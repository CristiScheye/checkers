class Player
  attr_reader :name, :color
  def initialize(name, color)
    @name = name
    @color = color
  end
end

class HumanPlayer < Player
  def get_move
    print "Next move >> "
    move = gets.chomp
  end
end
