require 'rubygems'
require 'net/ldap'

CONFIG_PATH = "#{Rails.root}/config/ldap.yml"

vals = YAML.load(File.read(CONFIG_PATH))

USERNAME = vals['username']
PASSWORD = vals['password']

class LDAPGroupFetcher
  attr_accessor :treebase
  attr_reader :groups
  def initialize
    @attributes = ["member"]
    @ldap = Net::LDAP.new :host => 'kiewit.dartmouth.edu',
         :port => 636,
         :encryption => :simple_tls,
         :auth => {
               :method => :simple,
               :username => 'kiewit\\' + USERNAME,
               :password => PASSWORD
         }
    @groups = []
  end
  def add_filter(filter)
    if @filter.nil?
      @filter = filter
    else
      @filter = @filter & filter
    end
  end
  def clear_filters!
    @filters = nil
  end
  def search
    puts "Searching..."
    @ldap.search(:base => @treebase, :filter => @filter, :attributes => @attributes) do |entry|
      # puts "DN: #{entry.dn}"
      entry.each do |attribute, values|
        values.each do |value|
          member = LDAPMember.new(value)
          @groups.push member if member.security_group?
        end
      end
    end
    @groups = @groups.uniq { |group| group.cn }
    puts "Finished searching... total: #{@groups.count}"
  end
end

class LDAPMember
  attr_accessor :cn, :dn, :ou
  def initialize(member_string)
    #member_string something like:
    #CN=BSR Events Mgmt User,OU=Security Groups,DC=kiewit,DC=dartmouth,DC=edu
    #or
    #CN=John Smith,OU=Development,OU=People,DC=kiewit,DC=dartmouth,DC=edu
    @dn = []
    @ou = []
    member_string.split(",").each do |unit|
      type, value = unit.split("=")
      if type == "CN"
        @cn = value
      elsif type == "OU"
        @ou.push value
      elsif type == "DN"
        @dn.push value
      end
    end
  end
  def security_group?
    @ou.include? "Security Groups"
  end
end

class LdapGroupWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  def perform(task)
    return unless task == 'fetch_groups'

    searcher = LDAPGroupFetcher.new

    searcher.clear_filters!
    filter = Net::LDAP::Filter.eq("objectClass", "Group")

    searcher.add_filter filter
    searcher.treebase = "dc=kiewit, dc=dartmouth, dc=edu"
    searcher.search
    puts "Called search. SHould be finished now."
    p searcher.groups
    groups = searcher.groups.collect { |group| group.cn }
    LdapGroup.delete_all
    groups.each do |group|
      LdapGroup.create!(name: group)
    end
  end
end
