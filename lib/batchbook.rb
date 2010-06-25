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
  VERSION = '1.0.3'

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
    def self.inherited(base)
      BatchBook.resources << base
      class << base
        attr_accessor :site_format
      end
      base.site_format = '%s'
      super
    end
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
        self.put("super_tags/#{name}", :super_tag => params)
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
  end

  class Tag < Base
  end

  class Location < Base
  end

  class SuperTag < Base
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




