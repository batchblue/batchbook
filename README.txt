= batchbook

http://github.com/batchblue/batchbook

== DESCRIPTION:

Wrapper for BatchBook XML API

== API

API : http://developer.batchblue.com/

== FEATURES/PROBLEMS:

Basic CRUD features for the data in your account: People, Companies, Communications, To-Dos, Deals.  Also custom methods for adding/removing Tags & SuperTags from a record, as well as updating SuperTag data for a particular record.

== TODO:

* Fix supertag creation + deletion
* Delete location methods for 'Person' & 'Company'

== SYNOPSIS:

require 'batchbook'
BatchBook.account = 'devo'
BatchBook.token = 'xyZ'

#In development to test the urls being used:
ActiveResource::Base.logger = Logger.new(STDOUT)

#also work for company
search_by_name = BatchBook::Person.find(:all, :params => {:name => 'will larson'} )
search_by_email = BatchBook::Person.find(:all, :params => {:email => will@batchblue.com})

#Deal requests
deal_by_email = BatchBook::Deal.find(:all, :params => {:assigned_to => 'eekrause@batchblue.com'})
deal_by_status = BatchBook::Deal.find(:all, :params => {:status => 'lost'})

#To add/remove a tag
deal = BatchBook::Deal.find(1)
deal.add_tag 'some tag'
deal.remove_tag 'some tag'

#To add/remove a comment
comment = BatchBook::Comment.new :comment => "It's a lovely day"
comment.deal = deal
comment.save
deal.comments.first.destroy

person = BatchBook::Person.find(5)
=> #<BatchBook::Person:0x1822c3c @attributes={"company"=>"BatchBlue Software", "title"=>"Software Developer", "id"=>5, "notes"=>nil, "first_name"=>"Will", "last_name"=>"Larson"}, @prefix_options={}>

person.tags
=> [#<BatchBook::Tag:0x1816f18 @attributes={"name"=>"batchblue", "id"=>2}, @prefix_options={}>]

person.locations
=> [#<BatchBook::Location:0x17cb7e8 @attributes={"city"=>"Seattle", "postal_code"=>"98101", "cell"=>"123-456-7890", "street_1"=>"123 Main Street", "street_2"=>nil, "country"=>"United States", "id"=>5, "website"=>"www.batchblue.com", "fax"=>nil, "phone"=>nil, "label"=>"work", "state"=>"WA", "email"=>"wlarson@batchblue.com"}, @prefix_options={}>]

person.location 'work'
=> #<BatchBook::Location:0x17cb7e8 @attributes={"city"=>"Seattle", "postal_code"=>"98101", "cell"=>"123-456-7890", "street_1"=>"123 Main Street", "street_2"=>nil, "country"=>"United States", "id"=>5, "website"=>"www.batchblue.com", "fax"=>nil, "phone"=>nil, "label"=>"work", "state"=>"WA", "email"=>"wlarson@batchblue.com"}, @prefix_options={}>

person.supertags
=> [#<BatchBook::SuperTag:0x17e5170 @attributes={"name"=>"reference", "id"=>5149}, @prefix_options={}>, #<BatchBook::SuperTag:0x17e515c @attributes={"name"=>"work schedule", "tuesday"=>"8-4", "wednesday"=>"9-5 PST", "thursday"=>"9-5 PST", "id"=>1948, "monday"=>"9-5 PST", "friday"=>"9-5 PST"}, @prefix_options={}>]

person.supertag 'work schedule'
=> #<BatchBook::SuperTag:0x17c7ea4 @attributes={"name"=>"work schedule", "tuesday"=>"8-4", "wednesday"=>"9-5 PST", "thursday"=>"9-5 PST", "id"=>1948, "monday"=>"9-5 PST", "friday"=>"9-5 PST"}, @prefix_options={}>

company = BatchBook::Company.find(:all, :params =>{:name => 'BatchBlue'}).first
=> #<BatchBook::Company:0x1762fcc @attributes={"name"=>"BatchBlue Software", "id"=>2, "notes"=>nil}, @prefix_options={}>

company.tags
=> []

company.supertags
=> []

company.locations
=> [#<BatchBook::Location:0x1737cb4 @attributes={"city"=>"Barrington", "postal_code"=>"02806", "cell"=>nil, "street_1"=>"18 Maple Ave.", "street_2"=>"Suite #300", "country"=>"United States", "id"=>622, "website"=>"http://batchblue.com", "fax"=>"(401) 633-6526", "phone"=>"(888) 402-2824", "label"=>"main", "email"=>"info@batchblue.com", "state"=>"RI"}, @prefix_options={}>]

company.location 'main'
=> #<BatchBook::Location:0x17225bc @attributes={"city"=>"Barrington", "postal_code"=>"02806", "cell"=>nil, "street_1"=>"18 Maple Ave.", "street_2"=>"Suite #300", "country"=>"United States", "id"=>622, "website"=>"http://batchblue.com", "fax"=>"(401) 633-6526", "phone"=>"(888) 402-2824", "label"=>"main", "email"=>"info@batchblue.com", "state"=>"RI"}, @prefix_options={}>

== ADDITIONAL EXAMPLES

person = BatchBook::Person.new(:first_name => 'Test', :last_name => 'Name', :notes => "Created via batchbook API")
person.save

person.add_tag('some tag name')
person.remove_tag('some tag name')

person.add_supertag('some tag name', "some field" => "some value")

person.add_location(  :email => 'test@here.com.au', :phone => '1234 1234', :cell => '2345 2345', :fax => '5678 5678',
                      :street_1 => 'Test Street 1', :street_2 => 'Test Street 2', :city => 'Test City', :state => 'VIC',
                      :postal_code => '1234', :country => 'Australia')

== REQUIREMENTS:

activeresource

== INSTALL:

git clone git://github.com/batchblue/batchbook.git

== LICENSE:

(The MIT License)

Copyright (c) 2009 BatchBlue Software

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
