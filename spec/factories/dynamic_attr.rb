FactoryGirl.define do
  factory :dynamic_attr do
    owner
    owner_type 'Owner'
    name       'test_attrs'
  end
end
