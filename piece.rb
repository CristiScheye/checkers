class Piece
  attr_accessor :color, :pos
  attr_reader :board

  def initialize(board, color, pos, king = false)
    @board, @color, @pos, @king = board, color, pos, king
  end

  def king?
    @king
  end

  def valid_moves
    possible_moves = (jumps + slides).compact
    possible_moves.select { |coord| board.on_board?(coord) && board.empty?(coord)}
  end

  def jumps
    move_dirs(:jump).map do |coord|
      immediate_diag = [coord[0]/2 + pos[0], coord[1]/2 + pos[1]]
      next if board.empty?(immediate_diag)

      [coord[0] + pos[0], coord[1] + pos[1]]
    end
  end

  def slides
    slide_moves = move_dirs(:slide).map do |coord|
      [coord[0] + pos[0], coord[1] + pos[1]]
    end
  end

  def move_dirs(move_type)
    if king?
      forward_diags(move_type) + backward_diags(move_type)
    else
      forward_diags(move_type)
    end
  end

  def forward_diags(move_type)
    dist = (move_type == :slide ? 1 : 2)
    if color == :red
      [ [dist, -dist],
        [dist,  dist] ]
    else
      [ [-dist,-dist],
        [-dist, dist]]
    end
  end

  def backward_diags(move_type)
    dist = (move_type == :slide ? 1 : 2)
    if color == :red
      [ [-dist,-dist],
        [-dist, dist]]
    else
      [ [dist, -dist],
        [dist,  dist] ]
    end
  end

  def inspect
    status = (king? ? 'king' : 'pawn')
    "#{color} #{status} at #{pos}"
  end

  def king_me!
    @king = true
  end

  def reaches_end
    color == :red ? pos[0] == 7 : pos[0] == 0
  end

  def render
    king? ? "K" : "\u25CF"
  end
end
