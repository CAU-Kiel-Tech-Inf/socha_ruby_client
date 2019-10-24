# encoding: utf-8
# frozen_string_literal: true

require_relative './util/constants'
require_relative 'player'
require_relative 'board'
require_relative 'move'
require_relative 'condition'

# Ein Spielzustand. Wird vom Server an die Computerspieler übermittelt und
# enthält alles, was der Computerspieler wissen muss, um einen Zug zu machen.
#
# Um eine Liste der gerade möglichen Züge zu bekommen, gibt es die Methode
# {GameState#possible_moves}.
class GameState
  # @!attribute [rw] turn
  # @return [Integer] Aktuelle Zugnummer (von 0 beginnend)
  attr_accessor :turn
  # @!attribute [rw] start_player_color
  # @return [PlayerColor] Die Farbe des Spielers, der den ersten Zug im Spiel
  #                       machen darf.
  attr_accessor :start_player_color
  # @!attribute [rw] current_player_color
  # @return [PlayerColor] Die Farbe des Spielers, der den nächsten Zug machen
  #                       darf, der also gerade an der Reihe ist.
  attr_accessor :current_player_color
  # @!attribute [r] red
  # @return [Player] Der rote Spieler
  attr_reader :red
  # @!attribute [r] blue
  # @return [Player] Der blaue Spieler
  attr_reader :blue
  # @!attribute [rw] board
  # @return [Board] Das aktuelle Spielbrett
  attr_accessor :board
  # @!attribute [rw] last_move
  # @return [Move] Der zuletzt gemachte Zug (ist nil vor dem ersten Zug, also
  #                bei turn == 0)
  attr_accessor :last_move
  # @!attribute [rw] condition
  # @return [Condition] Gewinner und Gewinngrund, falls das Spiel bereits
  #                     entschieden ist, sonst nil.
  attr_accessor :condition

  # Zugriff auf ein Feld des Spielbrettes. Siehe {Board#field}.
  def field(x, y)
    board.field(x, y)
  end

  # Erstellt einen neuen Spielzustand.
  def initialize
    @current_player_color = PlayerColor::RED
    @start_player_color = PlayerColor::RED
    @board = Board.new
    @turn = 0
  end

  # Fügt einen Spieler zum Spielzustand hinzu.
  #
  # @param player [Player] Der hinzuzufügende Spieler.
  def add_player(player)
    if player.color == PlayerColor::RED
      @red = player
    elsif player.color == PlayerColor::BLUE
      @blue = player
    end
  end

  # @return [Player] Spieler, der gerade an der Reihe ist.
  def current_player
    return red if current_player_color == PlayerColor::RED
    return blue if current_player_color == PlayerColor::BLUE
  end

  # @return [Player] Spieler, der gerade nicht an der Reihe ist.
  def other_player
    return blue if current_player_color == PlayerColor::RED
    return red if current_player_color == PlayerColor::BLUE
  end

  # @return [PlayerColor] Farbe des Spielers, der gerade nicht an der Reihe ist.
  def other_player_color
    PlayerColor.opponent_color(current_player_color)
  end

  # @return [Integer] Aktuelle Runde (von 0 beginnend).
  def round
    turn / 2
  end

  # Führt einen Zug auf dem Spielzustand aus. Das Spielbrett wird entsprechend
  # modifiziert.
  #
  # @param move [Move] Der auszuführende Zug.
  def perform!(move)
    move.perform!(self)
  end

  # @return [Boolean] true, falls das Spiel bereits geendet hat, false bei noch
  #                   laufenden Spielen.
  def game_ended?
    !condition.nil?
  end

  # @return [Player] Der Spieler, der das Spiel gewonnen hat, falls dies schon
  #                  entschieden ist. Sonst false.
  def winner
    condition.nil? ? nil : condition.winner
  end

  # @return [String] Der Grund, warum das Spiel beendet wurde, nil falls das
  #                  Spiel noch läuft.
  def winning_reason
    condition.nil? ? nil : condition.reason
  end

  # Ermittelt die Punkte eines Spielers. Wenn das Spiel durch Erreichen des
  # Rundenlimits beendet wird, hat der Spieler mit den meisten Punkten gewonnen.
  #
  # @param player [Player] Der Spieler, dessen Punkte berechnet werden sollen.
  # @return [Integer] Die Punkte des Spielers, entspricht der Anzahl der Fische
  #                   im größten Schwarm des Spielers.
  def points_for_player(player)
    GameRuleLogic.swarm_size(board, player)
  end

  def ==(other)
    turn == other.turn &&
        start_player_color == other.start_player_color &&
        current_player_color == other.current_player_color &&
        red == other.red &&
        blue == other.blue &&
        board == other.board &&
        lastMove == other.lastMove &&
        condition == other.condition
  end

  # Erzeugt eine Kopie des Spielzustandes. Änderungen an dieser Kopie
  # beeinflussen den originalen Spielzustand nicht. Die Kopie kann also zum
  # testen von Spielzügen genutzt werden.
  def deep_clone
    Marshal.load(Marshal.dump(self))
  end

  # Wechselt den Spieler, der aktuell an der Reihe ist.
  def switch_current_player
    @current_player_color = other_player_color
  end

  # @return [Array<Field>] Alle Felder mit Fischen des Spielers, der gerade an der Reihe ist.
  def own_fields
    board.fields_of_type(
      PlayerColor.field_type(current_player_color)
    )
  end

  # @return [Array<Move>] Alle regelkonformen Züge, die der aktuelle Spieler gerade machen könnte.
  def possible_moves
    own_fields.map do |f|
      GameRuleLogic.possible_moves(board, f, current_player_color)
    end.flatten
  end

end
