require 'rubygems'
require 'net/ldap'

CONFIG_PATH = "#{Rails.root}/config/ldap.yml" 

vals = YAML.load(File.read(CONFIG_PATH))

USERNAME = vals['username']
PASSWORD = vals['password']

class LDAPGroupSearcher
  attr_accessor :treebase
  attr_reader :sub_groups, :members
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
    @sub_groups = []
    @members = []
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
    @sub_groups = []
    @members = []
    @ldap.search(:base => @treebase, :filter => @filter, :attributes => @attributes) do |entry|
      puts "DN: #{entry.dn}"
      entry.each do |attribute, values|
        values.each do |value|
          puts "Attr: #{attribute} value: #{value}"
          if attribute == :givenname
            given_name = value
          elsif attribute == :sn
            sur_name = value
          elsif attribute == :memberof || attribute == :member
            member = LDAPPersonMember.new(value)
            if member.group?
              @sub_groups.push member
            elsif member.person?
              @members.push member
            end
          end
        end
      end
    end
  end
end

class LDAPPersonMember
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
  def person?
    @ou.include? "People"
  end
  def group?
    @ou.include? "Security Groups"
  end
end

class GroupWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  def perform(group_id)
    group_to_lookup = Group.find(group_id)
    return if group_to_lookup.nil?
    original_group = group_to_lookup.name
    groups_to_search = [original_group]
    groups_searched = []
    results = []
    puts "Trying to search for #{groups_to_search}, got search_id #{group_id}"
    searcher = LDAPGroupSearcher.new

    groups_to_search.each do |group|
      puts "Searching for group #{group}"

      searcher.clear_filters!
      filter = Net::LDAP::Filter.eq("CN",  group)

      searcher.add_filter filter
      searcher.treebase = "dc=kiewit, dc=dartmouth, dc=edu"
      searcher.search

      sub_groups = searcher.sub_groups.collect { |sub_group| sub_group.cn }

      puts "Search finished."
      p searcher.members
      group_members = searcher.members.collect { |member| member.cn }
      puts "Got members: #{group_members.to_s}" unless group_members.nil?

      sub_groups.each do |sub_group|
        unless (groups_to_search & groups_searched).include?(sub_group)
          groups_to_search.push sub_group
        end
      end
      group_members.each do |group_member|
        results.push group_member unless results.include? group_member
      end
      groups_searched.push group
    end
    group_to_lookup.clear_results!
    if results.count > 0
      group_to_lookup.search_result.update_attributes(value: results.join(','))
    else
      group_to_lookup.search_error.update_attributes(value: "No results found.")
    end
  end
end
