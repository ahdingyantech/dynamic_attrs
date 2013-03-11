Dynamic Attrs
=============
-------------

为ActiveRecord模型定义动态属性。

在rails工程Gemfile里添加：
----------------------------
```ruby
gem 'dynamic_attrs'
```

生成并运行migration：
------
```
$ rails g dynamic_attrs
$ rake db:migrate
```

然后在模型定义里调用：
------------
```ruby
class User
  include DynamicAttr::Owner

  # 支持四种数据类型
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

读取和写入：
-------------------
```ruby
@user.student_attrs_sid = '0001'
@user.student_attrs_sid
# => '0001'

@user.student_attrs_is_graduated? = true
@user.student_attrs_is_graduated = true
@user.student_attrs_is_graduated?
@user.student_attrs_is_graduated
# => true
```

查询:
------
```ruby
@user.where_student_attrs(:is_graduated, true)
# => ActiveRecord::Relation [...]

@user.where_teacher_attrs(:age, 35)
# => ActiveRecord::Relation [...]
```
