class DAString
  include DAType

  def to_ruby
    self.value.to_s
  end
end
