require 'active_support/inflector'

module DAType
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def to_ruby
    self.value
  end
end

