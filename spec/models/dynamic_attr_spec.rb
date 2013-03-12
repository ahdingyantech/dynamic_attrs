require 'spec_helper'
require 'support/shared_examples'

describe DynamicAttr do

  context 'instance methods' do
    subject {FactoryGirl.create(:dynamic_attr, field: 'field')}

    describe '.owner' do
      its(:owner) {should be_a Owner}
    end
  end

  describe DynamicAttr::Owner do
    let(:fields) {{string: :string, datetime: :datetime, boolean: :boolean, integer: :integer}}

    before do
      Owner.send(:include, DynamicAttr::Owner)
      Owner.has_dynamic_attrs :test_attrs, fields: fields
    end

    context 'instance methods' do
      it_behaves_like 'a dynamic attr accessor', :string
      it_behaves_like 'a dynamic attr accessor', :datetime
      it_behaves_like 'a dynamic attr accessor', :boolean
      it_behaves_like 'a dynamic attr accessor', :integer
    end

  end
end
