shared_examples 'a dynamic attr accessor' do |field|
  let(:owner)  {FactoryGirl.create(:owner)}
  let(:types)  {{string: String, datetime: DateTime, boolean: TrueClass, integer: Integer}}
  let(:values) {{string: 'test', datetime: DateTime.now, boolean: true, integer: 4}}

  describe "#test_attrs_#{field}=" do
    subject {owner.send("test_attrs_#{field}=", values[field])}

    it {should be_a types[field]}
  end

  describe "#test_attrs_#{field}" do
    subject {owner.send("test_attrs_#{field}")}

    it {should be nil}
    it 'returns value with corresponding type' do
      owner.send("test_attrs_#{field}=", values[field])
      subject.should be_a types[field]
    end
  end
end
