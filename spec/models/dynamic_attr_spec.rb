require 'spec_helper'
require 'support/shared_examples'

describe DynamicAttr do
  let(:fields) {{string: :string, datetime: :datetime, boolean: :boolean, integer: :integer}}
  let(:owner)  {FactoryGirl.create(:owner)}

  context 'instance methods' do
    subject {FactoryGirl.create(:dynamic_attr, field: 'field')}

    describe '.owner' do
      its(:owner) {should be_a Owner}
    end
  end

  describe DynamicAttr::Owner do
    before do
      Owner.send(:include, DynamicAttr::Owner)
      Owner.has_dynamic_attrs :test_attrs, fields: fields
    end

    context 'dynamic attrs groups' do
      it_behaves_like 'a dynamic attrs group', :test_attrs
    end

    it_behaves_like 'a dynamic field accessor', :string,   'string',     String
    it_behaves_like 'a dynamic field accessor', :integer,  16,           Integer
    it_behaves_like 'a dynamic field accessor', :datetime, DateTime.now, DateTime
    it_behaves_like 'a dynamic field accessor', :boolean,  false,        FalseClass
  end

  describe DynamicAttr::Group do
    let(:owner)  {FactoryGirl.create :owner}
    subject      {owner.test_attrs}
    before       {Owner.has_dynamic_attrs :test_attrs, fields: fields}

    describe '#name' do
      its(:name) {should eq :test_attrs}
    end

    describe '#fields' do
      its(:fields) {should eq fields}
    end
  end
end
