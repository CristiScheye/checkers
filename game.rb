require './board'
require './player'

class Checkers
  attr_reader :player1, :player2

  LETTER_COORDS = {
    'a' => 0,
    'b' => 1,
    'c' => 2,
    'd' => 3,
    'e' => 4,
    'f' => 5,
    'g' => 6,
    'h' => 7
  }

  def initialize
    @player1 = HumanPlayer.new('player 1', :red)
    @player2 = HumanPlayer.new('player 2', :black)
    @board = Board.new
  end

  def play

    puts "Chess!\n\n"
    puts "To move a piece, enter the coordinates of the starting
    square and the ending square. If you want to make multiple
    jumping moves, enter coordinates of each square in sequence."

    current_player = player1

    until board.over?
      board.render
      puts "#{current_player.name}'s turn"
      begin
        move_seq = current_player.get_move
        moves = format_moves_arr(move_seq)
        board.perform_move(move_seq)
      rescue
        retry
      end

      toggle_player(current_player)
    end

    if board.draw?
      puts "It's a draw"
    else
      winning_player = (board.winning_color == :red ? player1 : player2)
      puts "#{winning_player.name} wins!"
    end

    puts "Game Over"
  end

  def toggle_player(current_player)
    current_player == player1 ? player2 : player1
  end


  def format_moves_arr(move_str)
    move_str = move_str.gsub(' ', '')
    moves = move_str.split(',') # => [a3, b4]
    moves.map do |move|
      char, num = move.split('') # => ['a', '3']

      if move.size != 2
        raise 'a coordinate must be two characters long (e.g. A3)'
      elsif !num.between(0,7)
        raise 'number end with a number be between 1 and 8 (e.g. A3)'
      elsif !(char =~ /^[A-Ha-h]/)
        raise 'must start with a letter A-H (e.g. A3)'
      end

      row = num.to_i - 1
      col = LETTER_COORDS[char.downcase]
      [row, col]
    end
  end
end
