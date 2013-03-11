FactoryGirl.define do
  factory :dynamic_attr do
    owner
    owner_type 'User'
    name       'test_attrs'
  end
end
