# encoding: UTF-8
require_relative 'field_type'

# A field on the game board
class Field
  # @!attribute [rw] type
  # @return [PlayerColor] the field's type
  attr_accessor :type
  # @!attribute [r] x
  # @return [Integer] the field's x-coordinate
  attr_reader :x
  # @!attribute [r] y
  # @return [Integer] the field's y-coordinate
  attr_reader :y

  # Initializer
  #
  # @param type [FieldType] field type
  # @param x [Integer] x-coordinate
  # @param y [Integer] y-coordinate
  def initialize(type, x, y)
    self.ownerColor = PlayerColor::NONE
    self.type = type
    @x = x
    @y = y
  end

  def ==(another_field)
    return self.ownerColor == another_field.ownerColor &&
      self.type == another_field.type &&
      self.x == another_field.x &&
      self.y == another_field.y
  end

  def to_s
    return "Field: x = #{self.x}, y = #{self.y}, owner = #{self.ownerColor}, type = #{self.type}"
  end
end
