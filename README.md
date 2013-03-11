Dynamic Attrs
=============
-------------

Make dynamic ActiveRecord attribute columns.

In your rails gem file, add:
----------------------------
```ruby
gem 'dynamic_attrs'
```

Generate related migration:
------
```
$ rails g dynamic_attrs
$ rake db:migrate
```

Then invoke something like this in your model definition:
------------
```ruby
has_dynamic_attrs :some_attrs, field: {number: :integer, title: :string}
```

Get and set values:
-------------------
```ruby
model.some_attrs_number = 2
model.some_attrs_number #=> 2
```
