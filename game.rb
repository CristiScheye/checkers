require './board'
require './player'

class Checkers
  attr_reader :player1, :player2, :board

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
    board.render
    puts "Press enter to play"
    gets

    current_player = player1

    until board.over?
      system "clear"
      puts "Chess! : #{current_player.name}'s turn (#{current_player.color})\n\n"
      board.render
      puts "\n\n"

      begin
        move_seq = current_player.get_move
        moves = format_moves_arr(move_seq)
        board.perform_moves(moves, current_player.color)
      rescue => e
        puts e.message.colorize(:red)
        puts 'Try another move'
        retry
      end

      current_player = toggle_player(current_player)
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

    if moves.size < 2
      raise 'must provide at least two coordinates'
    end

    moves.map do |move|

      if move.size != 2
        raise 'a coordinate must be two characters long (e.g. A3)'
      elsif !(move =~ /^[A-Ha-h][1-8]$/)
        raise 'must be formatted with a letter (A-H) and number (1-8) (e.g. A3)'
      end

      char, num = move.split('') # => ['a', '3']
      row = num.to_i - 1
      col = LETTER_COORDS[char.downcase]
      [row, col]
    end
  end
end

if $PROGRAM_NAME == __FILE__
  Checkers.new.play
end
