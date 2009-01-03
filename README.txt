= batchbook

http://github.com/batchblue/batchbook

== DESCRIPTION:

Wrapper for BatchBook XML API

== FEATURES/PROBLEMS:

Basic CRUD features for the data in your account: People, Companies, Communications, To-Dos.  Also custom methods for adding/removing Tags & SuperTags from a record, as well as updating SuperTag data for a particular record.

== SYNOPSIS:

>> require 'batchbook'
=> true
>> BatchBook.account = 'batchblue'
=> "batchblue"
>> BatchBook.token = 'xyz'
=> "xyz"
>> person = BatchBook::Person.find(5)
=> #<BatchBook::Person:0x18256e4 @attributes={"company"=>"BatchBlue Software", "title"=>"SDE", "id"=>5, "notes"=>nil, "first_name"=>"Will", "last_name"=>"Larson"}, @prefix_options={}>
>> person.tags
=> [#<BatchBook::Tag:0x1816f18 @attributes={"name"=>"batchblue", "id"=>2}, @prefix_options={}>]
>> person.locations
=> [#<BatchBook::Location:0x17cb7e8 @attributes={"city"=>"Seattle", "postal_code"=>"98101", "cell"=>"123-456-7890", "street_1"=>"123 Main Street", "street_2"=>nil, "country"=>"United States", "id"=>5, "website"=>"www.batchblue.com", "fax"=>nil, "phone"=>nil, "label"=>"work", "state"=>"WA", "email"=>"wlarson@batchblue.com"}, @prefix_options={}>]
>> person.last_name = 'Larsen'
=> "Larsen"
>> person.save
=> true
>> person.reload.last_name
=> "Larsen"


== REQUIREMENTS:

activeresource

== INSTALL:

sudo gem install batchblue-batchbook

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
