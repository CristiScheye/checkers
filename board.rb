require './piece'

class Board

  def initialize
    @rows = Array.new(8) { Array.new(8) }
    set_pieces
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
    @rows[i][j]
  end

  def []=(pos, piece)
    i, j = pos
    @rows[i][j] = piece
  end

  def perform_slide(old_pos, new_pos)
    piece = self[old_pos]

    if valid_move?(old_pos, new_pos)
      self[new_pos] = piece
      self[old_pos] = nil
    end
  end

  def perform_jump(old_pos, new_pos)
    piece = self[old_pos]
    if valid_move?(old_pos, new_pos)
      self[new_pos] = piece
      self[old_pos] = nil

      if piece_between(old_pos, new_pos).color != piece.color
        capture(piece_between)
      end
    end
  end

  def empty?(pos)
    self[pos].nil?
  end

  def valid_move?(old_pos, new_pos)
    piece = self[old_pos]
    piece.valid_moves.include?(new_pos)
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

  private

  def set_pieces
    squares = diag_squares.reject { |coord| [3,4].include?(coord[0]) }
    squares.each do |square|
      color = (square[0] < 3 ? :red : :black)
      piece = Piece.new(self, color, square)
      self[square] = piece
    end
  end

  # def move_type(old_pos, new_pos)
  #   diff = new_pos[0] - old_pos[0]
  #   diff.even? ? :jump : :slide
  # end
end
