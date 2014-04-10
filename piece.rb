class Piece
  attr_accessor :color, :pos

  def initialize(board, color, pos)
    @board, @color, @pos = board, color, pos
    @king = false
  end

  def king?
    @king
  end

  def valid_slide?(new_pos)
    i, j = pos

    pos_slides = slide_dirs.map do |coord|
      slide = [coord[0] + i, coord[1] + j]
      slide if on_board?(slide)
    end

    board.empty?(new_pos) && pos_slides.include?(new_pos)
  end

  def valid_jump?
    #board cannot be empty to the diagonal
  end

  def slide_dirs
    king? ? forward_diags + backward_diags : forward_diags
  end

  def forward_diags
    if color == :red
      [ [1, -1],
        [1,  1] ]
    else
      [ [-1,-1],
        [-1, 1]]
    end
  end

  def backward_diags
    if color == :red
      [ [-1,-1],
        [-1, 1]]
    else
      [ [1, -1],
        [1,  1] ]
    end
  end

  def on_board?(coord)
    coord.all? { |c| c.between?(0,7) }
  end
end


p = Piece.new('board', :red, [0,0])
p p.valid_slide?([1,1])
p p.valid_slide?([3,3])
