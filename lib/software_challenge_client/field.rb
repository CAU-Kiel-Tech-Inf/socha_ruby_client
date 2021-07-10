# encoding: utf-8
# frozen_string_literal: true

# Ein Feld des Spielfelds. Ein Spielfeld ist durch die Koordinaten eindeutig
# identifiziert.
class Field
  # @!attribute [r] coordinates
  # @return [Coordinates] die X-Y-Koordinaten des Feldes
  attr_reader :coordinates
  # @!attribute [r] piece
  # @return [Piece] das Piece auf diesem Feld, falls vorhanden, sonst nil
  attr_reader :piece

  # Erstellt ein neues leeres Feld.
  #
  # @param x [Integer] X-Koordinate
  # @param y [Integer] Y-Koordinate
  # @param color [Color] Farbe des Spielsteins, der das Feld überdeckt, nil falls kein Spielstein es überdeckt
  def initialize(x, y, piece = nil)
    @piece = piece
    @coordinates = Coordinates.new(x, y)
  end

  # Vergleicht zwei Felder. Felder sind gleich, wenn sie gleiche Koordinaten und
  # den gleichen Spielstein haben.
  # @return [Boolean] true bei Gleichheit, sonst false.
  def ==(other)
    !other.nil? && coordinates == other.coordinates && piece == other.piece
  end

  def x
    coordinates.x
  end

  def y
    coordinates.y
  end

  def team
    if piece.nil?
      nil
    else
      piece.team
    end
  end

  def color
    if piece.nil?
      nil
    else
      piece.team.to_c
    end
  end

  # @return [Boolean] true, wenn das Feld nicht durch einen Spielstein überdeckt ist, sonst false
  def empty?
    piece.nil?
  end

  # @return [String] Textuelle Darstellung des Feldes.
  def to_s
    empty? ? '_' : piece.to_s
  end
end
