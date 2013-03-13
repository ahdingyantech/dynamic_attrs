class DAInteger
  include DAType

  def to_ruby
    self.value.to_i
  end
end
