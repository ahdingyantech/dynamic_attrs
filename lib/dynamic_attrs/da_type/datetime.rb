class DADateTime
  include DAType

  def to_ruby
    self.value.to_datetime
  end
end
