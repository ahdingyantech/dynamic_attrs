shared_examples 'a dynamic attrs group' do |name|
  before {Owner.has_dynamic_attrs :test_attrs, fields: fields}

  describe "#{name}" do
    subject {owner.send("#{name}")}

    it {should be_a DynamicAttr::Group}
    its(:name) {should eq name}
  end
end

shared_examples 'a dynamic field accessor' do |field, value, type|
  describe '#test_attrs_#{field}' do
    subject {owner.send("test_attrs_#{field}")}

    it {should be nil}
  end

  describe '#test_attrs_#{field}=' do
    subject {owner.send("test_attrs_#{field}=", value)}

    specify {expect{subject;owner.save}.to change{owner.send("test_attrs_#{field}")}.from(nil).to(value)}
    specify {expect{subject;owner.save}.to change{owner.dynamic_attrs.count}.by(1)}
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
