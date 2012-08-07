require 'rubygems'
require 'net/ldap'

CONFIG_PATH = "#{Rails.root}/config/ldap.yml" 

vals = YAML.load(File.read(CONFIG_PATH))

USERNAME = vals['username']
PASSWORD = vals['password']

class LDAPGroupSearcher
  attr_accessor :treebase
  attr_reader :parent_groups, :sub_groups, :members
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
    @parent_groups = []
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
    @parent_groups = []
    @members = []
    @ldap.search(:base => @treebase, :filter => @filter, :attributes => @attributes) do |entry|
      puts "DN: #{entry.dn}"
      entry.each do |attribute, values|
        values.each do |value|
          # puts "Attr: #{attribute} value: #{value}"
          if attribute == :givenname
            given_name = value
          elsif attribute == :sn
            sur_name = value
          elsif attribute == :memberof || attribute == :member
            member = LDAPPersonMember.new(value)
            if member.group?
              puts "Attribute #{attribute} value #{value} IS A GROUP"
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
  def perform(group_id)
    group_to_lookup = Group.find(group_id)
    return if group_to_lookup.nil?
    group = group_to_lookup.name
    results = []
    puts "Trying to search for #{group}, got search_id #{group_id}"
    searcher = LDAPGroupSearcher.new

    puts "Searching for group #{group}"

    searcher.clear_filters!
    filter = Net::LDAP::Filter.eq("CN",  group)

    searcher.add_filter filter
    searcher.treebase = "dc=kiewit, dc=dartmouth, dc=edu"
    searcher.search

    sub_groups = searcher.sub_groups.collect { |sub_group| sub_group.cn }
    parent_groups = searcher.parent_groups.collect { |parent_group| parent_group.cn }
    group_members = searcher.members.collect { |member| member.cn }

    puts "Search finished."

    puts "Sub_groups:"
    sub_groups.each do |sub_group|
      puts sub_group
    end
    puts "Parent_groups:"
    parent_groups.each do |parent_group|
      puts parent_group
    end
    puts "Group_members:"
    group_members.each do |group_member|
      puts group_member
      results.push group_member unless results.include? group_member
    end
    group_to_lookup.clear_results!
    
    group_to_lookup.search_result.update_attributes(value: group_members.join(',')) if group_members.count > 0
    group_to_lookup.sub_groups.update_attributes(value: sub_groups.join(',')) if sub_groups.count > 0
    group_to_lookup.parent_groups.update_attributes(value: parent_groups.join(',')) if parent_groups.count > 0
    group_to_lookup.search_error.update_attributes(value: "No results found.") if sub_groups.count == 0 && parent_groups.count == 0 && group_members.count == 0
  end
end
