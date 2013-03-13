require 'spec_helper'
require 'support/shared_examples'

describe DynamicAttr do
  let(:fields) {{string: DAString, datetime: DADateTime, boolean: DABoolean, integer: DAInteger}}
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
  end

  describe DynamicAttr::Group do
    let(:owner)  {FactoryGirl.create :owner}
    subject      {owner.test_attrs}
    before       {Owner.has_dynamic_attrs :test_attrs}

    describe '#name' do
      its(:name) {should eq :test_attrs}
    end

    describe '#fields' do
      before do
        fields.each do |field, data_type|
          DynamicAttr.create name: :test_attrs, owner: owner, field: field, data_type: data_type
        end
      end

      its(:fields) {should eq fields.keys}
    end

    describe '#add_fields' do
      subject {owner.test_attrs.add_fields(fields)}

      it {should eq fields.keys}
      specify {expect{subject}.to change{owner.test_attrs.fields}.from([]).to(fields.keys)}
    end

    it_behaves_like 'a dynamic group field accessor', :string,   'string',     String
    it_behaves_like 'a dynamic group field accessor', :integer,  16,           Integer
    it_behaves_like 'a dynamic group field accessor', :datetime, DateTime.now, DateTime
    it_behaves_like 'a dynamic group field accessor', :boolean,  false,        FalseClass
  end

  it_behaves_like 'a DA type', DAString,   'string',     String
  it_behaves_like 'a DA type', DAInteger,  '16',         Integer
  it_behaves_like 'a DA type', DADateTime, '2012/03/12', DateTime
  it_behaves_like 'a DA type', DABoolean,  'true',       TrueClass
end
