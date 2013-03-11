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
has_dynamic_attrs :some_attrs, field: {number: :integer, title: :string}
```

读取和写入：
-------------------
```ruby
model.some_attrs_number = 2
model.some_attrs_number #=> 2
```

查询:
------
```ruby
Model.where_some_attrs(:number, 2) #=> 对应的Model实例集合(ActiveRecord::Relation类型)
```