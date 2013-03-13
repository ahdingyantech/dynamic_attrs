shared_examples 'a dynamic attrs group' do |name|
  before {Owner.has_dynamic_attrs :test_attrs}

  describe "#{name}" do
    subject {owner.send("#{name}")}

    it {should be_a DynamicAttr::Group}
    its(:name) {should eq name}
  end
end

shared_examples 'a dynamic group field accessor' do |field, value, type|
  let(:group)  {owner.test_attrs}
  before       {group.add_fields(fields)}

  describe '##{field}' do
    subject {group.send("#{field}")}

    it {should be nil}
  end

  describe '##{field}=' do
    subject {group.send("#{field}=", value)}

    specify {expect{subject}.to change{group.send("#{field}")}.from(nil).to(value)}
    it {should be_a type}
  end

end

shared_examples 'a DA type' do |klass, str, type|
  describe klass do
    describe '#to_ruby' do
      subject {klass.new(str).to_ruby}
      it {should be_a type}
    end
  end
end
