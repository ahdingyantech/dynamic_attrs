require 'active_support/inflector'

module DAType
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def to_ruby
    self.value
  end

  def self.dispatch(sym)
    case sym
    when :string   then DAString
    when :integer  then DAInteger
    when :datetime then DADateTime
    when :boolean  then DABoolean
    end
  end
end
