require 'matrix'

$id = 0
def get_id
  $id += 1
end

MOVE_UP = 0
MOVE_LEFT = 1
MOVE_DOWN = 2
MOVE_RIGHT = 3
SIGHT_RADIUS = 5

class Game
  def initialize field_size
    @field = []
    @water = 0
    @bots = []
    @positions = {}
    field_size.times do [i]
      @field << []
      field_size.times do
        @field[i] << 3
      end
    end
  end

  def add_bot bot
    @bots << bot
    @positions[bot] = Vector[0,0]
  end

  def next_round
    raise_water
    @bots.each do |bot|
      bot.act @water, @positions[bot], filter_sight bot, @field
    end
  end

  def raise_water
    @water += 1
  end

  def filter_sight bot, field
    field[@positions[bot][0] - SIGHT_RADIUS .. @positions[bot][0] + SIGHT_RADIUS][@positions[bot][1] - SIGHT_RADIUS .. @positions[bot][1] + SIGHT_RADIUS]
  end

  def move_possible? bot, direction
    case direction
      when MOVE_UP
        @field[@positions[bot].x][@positions[bot].y+1]
    end
  end
end

class Bot
  attr_reader :id

  def initialize game
    @game = game
    @id = get_id
  end

  def move direction
    game.move self, direction if move_possible? direction
  end

  def move_possible? direction
    game.move_possible? self, direction
  end

  def dig
    game.dig self
  end

  def raise
    game.dig self
  end

  def == other
    return false unless other.is_a? Bot
    @id == other.id
  end

  def hash
    @id.hash
  end
end

