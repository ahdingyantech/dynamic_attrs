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
class User
  include DynamicAttr::Owner

  # Supporting 4 data types
  # :string, :datetime, :boolean, :integer
 
  has_dynamic_attrs :student_attrs,
                    :fields => {
                      :sid          => :string,
                      :birthday     => :datetime,
                      :is_graduated => :boolean,
                      :age          => :integer
                    }
 
  has_dynamic_attrs :teacher_attrs,
                    :fields => {
                      :tid      => :string,
                      :birthday => :datetime,
                      :age      => :integer
                    }
end
```

Get and set values:
-------------------
```ruby
@user.teacher_attrs_tid = '0001'
@user.teacher_attrs_tid
# => '0001'
 
@user.student_attrs_is_graduated? = true
@user.student_attrs_is_graduated = true
@user.student_attrs_is_graduated?
@user.student_attrs_is_graduated
# => true
```

Query:
------
```ruby
@user.where_student_attrs(:is_graduated, true)
# => ActiveRecord::Relation [...]
 
@user.where_teacher_attrs(:age, 35)
# => ActiveRecord::Relation [...]
```
