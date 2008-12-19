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
  
  # people = Person.find(:all)
  #
  # person = BatchBook::Person.find(id)
  #
  # person = BatchBook::Person.new :first_name => 'will', :last_name => 'larson', :title => 'dev'
  # person.save
  #
  # person.last_name = 'new last name'
  # person.save
  #
  #
  class Person < Base
    def tags
      Tag.find(:all, :params => {:contact_id => id})
    end

    def locations
      Location.find(:all, :params => {:record_id => id})
    end
    
    def supertags
      SuperTag.find(:all, :params => {:contact_id => id})
    end
    
    def communications
      Communication.find(:all, :params => {:contact_id => id})
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
  end

  class Communication < Base
  end

  class Tag < Base
  end

  class Location < Base
    site_format << '/records/:record_id'
  end

  class SuperTag < Base
  end

end

__END__

require 'batchbook'
BatchBook.account = 'devo'
BatchBook.token = 'GMXdRvTXAD'

person = BatchBook::Person.find 1937



