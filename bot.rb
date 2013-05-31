class Bot
  attr_reader :id

  def initialize game
    @id = get_id
    @game = game
    @game.add_bot self
  end

  def move direction
    @game.move self, direction if move_possible? direction
  end

  def move_possible? direction
    @game.move_possible? self, direction
  end

  def dig
    @game.dig self
  end

  def raise_possible?
    @game.raise_possible? self
  end

  def raise
    @game.raise self
  end

  def == other
    return false unless other.is_a? Bot
    @id == other.id
  end

  def hash
    @id.hash
  end
end