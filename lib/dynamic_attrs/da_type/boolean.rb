class DABoolean
  include DAType

  def to_ruby
    {true: true, false: false}[self.value.to_s.to_sym]
  end
end
