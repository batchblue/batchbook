require 'rubygems'
require 'activeresource'

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
  VERSION = '1.0.1'
  
  class Error < StandardError; end
  class << self
    attr_accessor :token, :host_format, :site_format, :domain_format, :protocol, :path
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
    def tags
      Tag.find(:all, :params => {:contact_id => id})
    end

    def locations
      Location.find(:all, :params => {:contact_id => id})
    end
    
    def supertags
      SuperTag.find(:all, :params => {:contact_id => id})
    end
    
    def add_tag tag
      if tag.kind_of?(BatchBook::Tag)
        tag.put(:add_to, :contact_id => id)
      else
        raise Error, "#{tag} is not a BatchBook::Tag"
      end
    end
    
    def remove_tag tag
      if tag.kind_of?(BatchBook::Tag)
        tag.put(:remove_from, :contact_id => id)
      else
        raise Error, "#{tag} is not a BatchBook::Tag"
      end
    end
  end

  class Todo < Base
    def tags
      Tag.find(:all, :params => {:todo_id => id})
    end
  end

  class Communication < Base
    def tags
      Tag.find(:all, :params => {:communication_id => id})
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

person = BatchBook::Person.find 1937
person.last_name = 'new last name'
person.save

new_person = BatchBook::Person.new :first_name => 'will', :last_name => 'larson', :title => 'dev'
new_person.save




