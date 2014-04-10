require './board'
require './player'

class Checkers
  attr_reader :player1, :player2

  def initialize
    @player1 = HumanPlayer.new('player 1')
    @player2 = HumanPlayer.new('player 2')
    @board = Board.new
  end

  def play

    puts "Chess"
    current_player = player1

    until board.won?
      board.render

      begin
        move_seq = current_player.get_move
        moves = format_moves_arr(move_seq)
        board.perform_move(move_seq)
      rescue
        retry
      end

      toggle_player(current_player)
    end

    puts "Game Over"
  end

  def toggle_player(current_player)
    current_player == players1 ? player2 : player1
  end


  def format_moves_arr(move_str)
    move_str = move_str.gsub(' ', '')
    moves = move_str.split(',')
    moves.map do |move|
      char, num = move
      row = num.to_i
      col = LETTER_COORD[char]
      [row, col]
    end
  end
end
