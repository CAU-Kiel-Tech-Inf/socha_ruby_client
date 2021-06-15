# frozen_string_literal: true

require 'typesafe_enum'

# Die Spielsteintypen. Herzmuschel, Möwe, Seestern und Robbe
class PieceType < TypesafeEnum::Base
  new :COCKLE, 'C'
  new :GULL, 'G'
  new :STARFISH, 'S'
  new :SEAL, 'R'

  # Gibt den color namen zurück
  def to_s
    self.key.to_s
  end
end
