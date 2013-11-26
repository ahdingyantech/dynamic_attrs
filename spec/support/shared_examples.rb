shared_examples 'a dynamic attrs group' do |name|
  describe "#{name}" do
    subject {owner.send("#{name}")}

    it {should be_a DynamicAttr::Group}
    its(:name) {should eq name}
  end
end

shared_examples 'a dynamic field accessor' do |name, field, value, type|
  describe '##{name}_#{field}' do
    subject {owner.send("#{name}_#{field}")}

    it {should be nil}
  end

  describe '##{name}_#{field}=' do
    subject {owner.send("#{name}_#{field}=", value)}

    specify {expect{subject;owner.save}.to change{owner.reload.send("#{name}_#{field}")}.from(nil).to(value)}
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
