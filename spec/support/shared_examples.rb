shared_examples 'a dynamic attrs group' do |name|
  describe "#{name}" do
    subject {owner.send("#{name}")}

    it {should be_a DynamicAttr::Group}
    its(:name) {should eq name}
  end
end

shared_examples 'a dynamic field accessor' do |name, field, value, value1, type, type2|
  describe '##{name}_#{field}' do
    subject {owner.send("#{name}_#{field}")}

    it {should be nil}
  end

  describe '##{name}_#{field}=' do
    let(:assign)   {owner.send("#{name}_#{field}=", value);owner.save}
    let(:reassign) {owner.send("#{name}_#{field}=", value1);owner.save}

    specify {expect{assign}.to change{owner.reload.send("#{name}_#{field}")}.from(nil).to(value)}
    specify {expect{assign}.to change{owner.dynamic_attrs.count}.by(1)}

    context "reassign" do
      before {assign}

      specify {expect{reassign}.to change{owner.reload.send("#{name}_#{field}")}.from(value).to(value1)}
      specify {expect{reassign}.not_to change{owner.dynamic_attrs.count}}
    end
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
