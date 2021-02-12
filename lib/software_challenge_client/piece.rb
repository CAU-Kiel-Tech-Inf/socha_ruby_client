# frozen_string_literal: true

# Ein Spielstein mit Ausrichtung, Koordinaten und Farbe
class Piece
  # @!attribute [r] Farbe
  # @return [Color]
  attr_reader :color

  # @!attribute [r] Form
  # @return [PieceShape]
  attr_reader :kind

  # @!attribute [r] Drehung
  # @return [Rotation]
  attr_reader :rotation

  # @!attribute [r] Ob der Stein an der Y-Achse gespiegelt ist
  # @return [Boolean]
  attr_reader :is_flipped

  # @!attribute [r] Koordinaten
  # @return [Coordinates]
  attr_reader :position

  # @!attribute [r] Ein Array der Positionsdaten aller Bestandteile von dem Stein in Board Koordinaten, also schon ggf. gedreht und um position versetzt.
  # return [Array<Coordinates>]
  attr_reader :coords

  # Erstellt einen neuen leeren Spielstein.
  def initialize(color, kind, rotation = Rotation::NONE, is_flipped = false, position = Coordinates.origin)
    @color = color
    @kind = kind
    @rotation = rotation
    @is_flipped = is_flipped
    @position = position

    @coords = coords_priv
  end

  # Dreht den Stein
  def rotate!(rotation)
    @rotation = @rotation.rotate(rotation)
    @coords = coords_priv
  end

  # Dreht den Stein
  def rotate(rotation)
    Piece.new(@color,@kind,@rotation.rotate(rotation),@is_flipped,@position)
  end

  # Flipped den Stein
  def flip!(f = true)
    @is_flipped = @is_flipped ^ f
    @coords = coords_priv
  end

  # Flipped den Stein
  def flip(f = true)
    Piece.new(@color,@kind,@rotation,@is_flipped ^ f,@position)
  end

  # Setzt den Stein auf eine Position
  def locate!(position)
    @position = position
    @coords = coords_priv
    
  # Setzt den Stein auf eine Position
  def locate(position)
    Piece.new(@color,@kind,@rotation,@is_flipped,position)
  end

  # Verschiebt den Stein
  def move!(shift)
    @position = @position + shift
    @coords = coords_priv
  end

  # Verschiebt den Stein
  def move(shift) 
    Piece.new(@color,@kind,@rotation,@is_flipped,@position + shift)
  end

  # Gibt die Fläche der transformierten Steinform von diesem Stein zurück
  def area()
    CoordinateSet.new(coords).area
  end

  def ==(other)
    color == other.color &&
      coords == other.coords
  end

  def to_s
    "#{color.key} #{kind.key} at #{position} rotation #{rotation.key}#{is_flipped ? ' (flipped)' : ''}"
  end

  def inspect
    to_s
  end

  private

  def coords_priv
    kind.transform(@rotation, @is_flipped).transform do |it|
      Coordinates.new(it.x + @position.x, it.y + @position.y)
    end.coordinates
  end
end
