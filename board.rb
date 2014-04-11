require 'debugger'
require 'colorize'

require './piece'

class Board
  attr_reader :rows

  def initialize(brand_new = true)
    @rows = Array.new(8) { Array.new(8) }
    set_pieces if brand_new
  end

  def diag_squares
    diags = []
    8.times do |i|
      8.times do |j|
        diags << [i,j] if (i + j).even?
      end
    end
    diags
  end

  def [](pos)
    i, j = pos
    rows[i][j]
  end

  def []=(pos, piece)
    i, j = pos
    rows[i][j] = piece
  end

  def all_pieces
    rows.flatten.compact
  end

  def dup
    dup_board = Board.new(false)
    all_pieces.each do |piece|
      new_piece = Piece.new(dup_board, piece.color, piece.pos)
      dup_board[piece.pos] = new_piece
    end
    dup_board
  end

  def perform_moves(move_seq, player_color)
    unless valid_move_seq?(move_seq, player_color)
      raise "Nope, can't make that move"
    end
    perform_moves!(move_seq)
  end

  def perform_move!(old_pos, new_pos)
    if (new_pos[0] - old_pos[0]).even?  #if the piece moves two spaces, it's a jump
      perform_jump(old_pos, new_pos)
    else
      perform_slide(old_pos, new_pos)
    end
  end

  def valid_move_seq?(move_seq, player_color)
    dup_board = self.dup

    (move_seq.size - 1).times do |index|
      old_pos, new_pos = move_seq[index], move_seq[index + 1]

      if dup_board.valid_move?(old_pos, new_pos, player_color)
        dup_board.perform_move!(old_pos, new_pos)
      else
        return false
      end
    end
    true
  end

  def empty?(pos)
    self[pos].nil?
  end

  def valid_move?(old_pos, new_pos, player_color)
    piece = self[old_pos]
    piece.color == player_color && piece.valid_moves.include?(new_pos)
  end

  def on_board?(coord)
    coord.all? { |c| c.between?(0,7) }
  end

  def piece_between(old_pos, new_pos)
    coord = [(new_pos[0] + old_pos[0]) / 2, (new_pos[1] + old_pos[1]) / 2]
    self[coord]
  end

  def capture(piece)
    self[piece.pos] = nil
  end

  def render
    puts "   A  B  C  D  E  F  G  H "
    rows.each_with_index do |row,row_index|
      row_squares = row.map.with_index do |piece, col_index|
        square_color = ((row_index + col_index).even? ? :light_white : :black)
        if piece.nil?
          square_char = '   '.colorize(background: square_color)
        else
          square_char = " #{piece.render} ".colorize(piece.color).bold.colorize(background: square_color)
        end
      end
      row_str = row_squares.join
      puts "#{row_index + 1} #{row_str} #{row_index + 1}"
    end
    puts "   A  B  C  D  E  F  G  H "
  end

  def over?
    winning_color || draw?
  end

  def winning_color
    winning_color = all_pieces.first.color
    all_pieces.each do |piece|
      if winning_color != piece.color
        winning_color = nil
        break
      end
    end
    winning_color
  end

  def draw?
    all_pieces.all? { |piece| piece.valid_moves.empty? }
  end

  private

  def set_pieces
    squares = diag_squares.reject { |coord| [3,4].include?(coord[0]) }
    squares.each do |square|
      color = (square[0] < 3 ? :red : :black)
      piece = Piece.new(self, color, square)
      self[square] = piece
    end
  end

  def move_type(old_pos, new_pos)
    diff = new_pos[0] - old_pos[0]
    diff.even? ? :jump : :slide
  end

  def place_piece(old_pos, new_pos)
    piece = self[old_pos]

    self[new_pos] = piece
    self[old_pos] = nil
    piece.pos = new_pos
    piece.king_me! if piece.reaches_end
  end

  def perform_slide(old_pos, new_pos)
    place_piece(old_pos, new_pos)
  end

  def perform_jump(old_pos, new_pos)
    piece = self[old_pos]

    place_piece(old_pos, new_pos)

    if piece_between(old_pos, new_pos).color != piece.color
      capture(piece_between(old_pos, new_pos))
    end
  end

  def perform_moves!(move_seq)
    (move_seq.size - 1).times do |index|
      old_pos, new_pos = move_seq[index], move_seq[index + 1]
      perform_move!(old_pos, new_pos)
    end
  end
end
