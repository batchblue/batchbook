require 'rubygems'
require 'active_resource'

# Ruby lib for working with the BatchBook's API's XML interface. Set the account
# name and authentication token, using the BatchBook API Key found in your
# account settings, and you're ready to roll.
#
# http://demo.batchbook.com
# BatchBook.account = 'demo'
# BatchBook.token = 'XYZ'
#
#
module BatchBook
  VERSION = '1.0.4'

  class Error < StandardError; end
  class << self
    attr_accessor :host_format, :site_format, :domain_format, :protocol, :path
    attr_reader :account, :token

    # Sets the account name, and updates all the resources with the new domain.
    def account=(name)
      resources.each do |r|
        r.site = r.site_format % (host_format % [protocol, domain_format % name, path])
      end
      @account = name
    end

    # Sets the BatchBook API Key for all resources.
    def token=(value)
      resources.each do |r|
        r.user = value
      end
    end
    
    def site=(value)
      resources.each do |r|
        r.site = value
      end
    end

    def resources
      @resources ||= []
    end
  end

  self.host_format = '%s://%s/%s'
  self.domain_format = '%s.batchbook.com'
  self.path = 'service'
  self.protocol = 'https'

  class Base < ActiveResource::Base
    @proxy = ''
    @timeout = 15
  
    def self.inherited(base)
      BatchBook.resources << base
      class << base
        attr_accessor :site_format
      end
      base.site_format = '%s'
      super
    end
  end

  class Activities < Base
     
    def self.recent
      self.find(:all, :from => :recent)
    end
    
  end
  
  class Affiliation < Base    
    
  end
  
  class Person < Base
    #http://developer.batchblue.com/people.html
    def tags
      Tag.find(:all, :params => {:contact_id => id})
    end

    def locations
      self.get('locations')
    end

    def location label
      raise Error, "Location label not specified.  Usage:  person.location('label_name')" unless label
      self.get('locations', :label => label)
    end

    # Add a Location to a Person
    # POST https://test.batchbook.com/service/people/#{id}/locations.xml
    # Field Description
    # location[label]   Location Name ('work', 'home', etc.) - REQUIRED
    # location[email]   Email Address
    # location[website]   Website URL
    # location[phone]   Phone Number
    # location[cell]  Cell Phone Number
    # location[fax]   Fax Number
    # location[street_1]  Street Address
    # location[street_2]  Street Address 2
    # location[city]  City
    # location[state]   State
    # location[postal_code]   Postal Code
    # location[country]   Country
    def add_location(params = {})
      params.update(:label => 'home') unless params[:label].present?
      self.post(:locations, :location => params)
    end

    def supertags
      self.get('super_tags')
    end

    def supertag name
      raise Error, "SuperTag name not specified.  Usage:  person.supertag('tag_name')" unless name
      self.get('super_tags', :name => name)
    end

    #TODO : Fix supertags
    # Add a SuperTag to a Person
    #
    # Add a SuperTag to a Person the same way you add a regular tag to it, via PUT https://test.batchbook.com/service/people/#{id}/add_tag/#{super_tag_name}.xml.
    # Remove a SuperTag from a Person
    # DELETE https://test.batchbook.com/service/people/#{id}/super_tags/#{super_tag_name}.xml

    def add_supertag name, params = {}
      raise Error, "Tag name not specified.  Usage:  person.add_supertag('tag_name')" unless name

      self.put(:add_tag, :tag => name)
      unless params.empty?
        self.put("super_tags/#{name.gsub(/ /, '_')}", :super_tag => params)
      end
    end

    def add_tag name
      raise Error, "Tag name not specified.  Usage:  person.add_tag('tag_name')" unless name
      self.put(:add_tag, :tag => name)
    end

    def remove_tag name
      raise Error, "Tag name not specified.  Usage:  person.remove_tag('tag_name')" unless name
      self.delete(:remove_tag, :tag => name)
    end

    def comments(scope = :all)
      Comment.find(scope, :params => {:person_id => self.id})
    end
    
    def comment(id)
      comments(id)
    end
    
    def affiliations
      Affiliation.find(:all, :params => {:person_id => self.id})      
    end
    
    def communications
      Communication.find(:all, :params => {:person_id => self.id})
    end
    
    def todos
      Todo.find(:all, :params => {:person_id => self.id})
    end
  end

  class Company < Base
    def tags
      Tag.find(:all, :params => {:contact_id => id})
    end

    def locations
      self.get('locations')
    end

    def location label
      raise Error, "Location label not specified.  Usage:  person.location('label_name')" unless label
      self.get('locations', :label => label)
    end

    def supertags
      self.get('super_tags')
    end

    def supertag name
      raise Error, "SuperTag name not specified.  Usage:  person.supertag('tag_name')" unless name
      self.get('super_tags', :name => name)
    end

    def add_tag name
      raise Error, "Tag name not specified.  Usage:  person.add_tag('tag_name')" unless name
      self.put(:add_tag, :tag => name)
    end

    def remove_tag name
      raise Error, "Tag name not specified.  Usage:  person.remove_tag('tag_name')" unless name
      self.delete(:remove_tag, :tag => name)
    end
    
    def comments(scope = :all)
      Comment.find(scope, :params => {:company_id => self.id})
    end
    
    def comment(id)
      comments(id)
    end
    
    def people
      Person.find(:all, :params => {:company_id => self.id})
      # self.get(:people)      
    end
    
    def affiliations
      Affiliation.find(:all, :params => {:company_id => self.id})      
    end
    
    def communications
      Communication.find(:all, :params => {:company_id => self.id})
    end
    
    def todos
      Todo.find(:all, :params => {:company_id => self.id})
    end
  end

  class Todo < Base
    def tags
      Tag.find(:all, :params => {:todo_id => id})
    end
    
    def add_tag name
      raise Error, "Tag name not specified.  Usage:  todo.add_tag('tag_name')" unless name
      self.put(:add_tag, :tag => name)
    end

    def remove_tag name
      raise Error, "Tag name not specified.  Usage:  todo.remove_tag('tag_name')" unless name
      self.delete(:remove_tag, :tag => name)
    end
    
    def comments(scope = :all)
      Comment.find(scope, :params => {:todo_id => self.id})
    end
    
    def comment(id)
      comments(id)
    end
  end
  
  class Deal < Base
    def tags
      Tag.find(:all, :params => {:deal_id => id})
    end
    
    def add_tag name
      raise Error, "Tag name not specified.  Usage:  deal.add_tag('tag_name')" unless name
      self.put(:add_tag, :tag => name)
    end

    def remove_tag name
      raise Error, "Tag name not specified.  Usage:  deal.remove_tag('tag_name')" unless name
      self.delete(:remove_tag, :tag => name)
    end

    def comments(scope = :all)
      Comment.find(scope, :params => {:deal_id => self.id})
    end
    
    def comment(id)
      comments(id)
    end
    
    def contacts
      Person.find(:all, :params => {:deal_id => self.id})
    end
    
    def add_related_contact(contact_id)
      raise Error, "Contact not specified.  Usage: deal.add_contact(50)" unless contact_id
      self.put(:add_related_contact, :contact_id => contact_id)
    end
    
    def remove_related_contact(contact_id)
      raise Error, "Contact not specified.  Usage: deal.add_contact(50)" unless contact_id
      self.delete(:remove_related_contact, :contact_id => contact_id)
    end
  end

  class Communication < Base
    def tags
      Tag.find(:all, :params => {:communication_id => id})
    end
    
    def add_tag name
      raise Error, "Tag name not specified.  Usage:  communication.add_tag('tag_name')" unless name
      self.put(:add_tag, :tag => name)
    end

    def remove_tag name
      raise Error, "Tag name not specified.  Usage:  communication.remove_tag('tag_name')" unless name
      self.delete(:remove_tag, :tag => name)
    end
    
    def comments(scope = :all)
      Comment.find(scope, :params => {:communication_id => self.id})
    end
    
    def comment(id)
      comments(id)
    end
  end

  class Comment < Base

    def communication
      Communication.find(self.prefix_options[:communication_id])
    end

    def communication=(communication)
      self.prefix_options[:communication_id] = communication.id
    end
    
    def company
      Company.find(self.prefix_options[:company_id])
    end
    
    def company=(company)
      self.prefix_options[:company_id] = company.id
    end
    
    def deal
      Deal.find(self.prefix_options[:deal_id])
    end
    
    def deal=(deal)
      self.prefix_options[:deal_id] = deal.id
    end
        
    def list
      List.find(self.prefix_options[:list_id])
    end

    def list=(list)
      self.prefix_options[:list_id] = list.id
    end
    
    def person
      Person.find(self.prefix_options[:person_id])
    end

    def person=(person)
      self.prefix_options[:person_id] = person.id
    end

    def todo
      Todo.find(self.prefix_options[:todo_id])
    end

    def todo=(todo)
      self.prefix_options[:todo_id] = todo.id
    end
    
  end

  class List < Base
    def comments(scope = :all)
      Comment.find(scope, :params => {:list_id => self.id})
    end
    
    def comment(id)
      comments(id)
    end
  end

  class Tag < Base
  end

  class Location < Base
  end

  class SuperTag < Base
  end
  
  class Record < Base
  end

end

__END__

require 'batchbook'
BatchBook.account = 'devo'
BatchBook.token = 'xyZ'

search_by_name = BatchBook::Person.find(:all, :params => {:name => 'will'} )
search_by_email = BatchBook::Person.find(:all, :params => {:email => will@batchblue.com})

person = BatchBook::Person.find 1937
person.last_name = 'new last name'
person.save

new_person = BatchBook::Person.new :first_name => 'will', :last_name => 'larson', :title => 'dev'
new_person.save
new_person_comment = BatchBook.Comment.new :comment => 'Best comment ever'
new_person_comment.person = new_person
new_person_comment.save
assert new_person.comments.include? new_person_comment





