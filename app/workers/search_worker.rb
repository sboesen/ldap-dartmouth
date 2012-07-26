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
    @ldap.search(:base => @treebase, :filter => @filter, :attributes => @attributes) do |entry|
      # puts "DN: #{entry.dn}"
      @sub_groups = []
      @members = []
      entry.each do |attribute, values|
        values.each do |value|
          #puts "Attr: #{attribute} value: #{value}"
          if attribute == :givenname
            given_name = value
          elsif attribute == :sn
            sur_name = value
          elsif attribute == :memberof || attribute == :member
            member = LDAPMember.new(value)
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
  def person?
    @ou.include? "People"
  end
  def group?
    @ou.include? "Security Groups"
  end
end

def perform(search_id)
  # TODO: check that user/pass are getting loaded from yaml file
  # TODO: get search from search_id
  # TODO: grab CN from search
  members = []
  groups_to_search = [ARGV.shift]
  groups_searched = []

  searcher = LDAPGroupSearcher.new

  groups_to_search.each do |group|
    # group should be a CN
    puts "Searching for group #{group}"

    searcher.clear_filters!
    filter = Net::LDAP::Filter.eq("CN",  group)

    searcher.add_filter filter
    searcher.treebase = "dc=kiewit, dc=dartmouth, dc=edu"
    searcher.search

    # p searcher.sub_groups
    sub_groups = searcher.sub_groups.collect { |sub_group| sub_group.cn }
    # puts "Got sub groups: #{sub_groups.to_s}" unless sub_groups.nil?
    group_members = searcher.members.collect { |member| member.cn }
    # puts "Got members: #{group_members.to_s}" unless group_members.nil?

    groups_to_search.push sub_groups unless sub_groups.empty?
    members.push group_members unless group_members.empty?
    groups_searched.push group
  end
end



# groups_searched.each do |group|
# end

# members.each do |member|
# end



