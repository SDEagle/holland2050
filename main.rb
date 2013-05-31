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
    @bots.each do |bot|
      @bots.delete bot unless height @positions[bot] > @water
    end
  end

  def raise_water
    @water += 1
  end

  # Returns an array containing only fields around the bot within sight.
  def filter_sight bot, field
    field[@positions[bot][0] - SIGHT_RADIUS, 2 * SIGHT_RADIUS][@positions[bot][1] - SIGHT_RADIUS, 2 * SIGHT_RADIUS]
  end

  def move_possible? bot, direction
    possible_height = height @positions[bot] + 1
    case direction
      when MOVE_UP
        possible_height >= @field[@positions[bot][0]][@positions[bot][1]+1]
      when MOVE_LEFT
        possible_height >= @field[@positions[bot][0]-1][@positions[bot][1]]
      when MOVE_DOWN
        possible_height >= @field[@positions[bot][0]][@positions[bot][1]-1]
      when MOVE_RIGHT
        possible_height >= @field[@positions[bot][0]+1][@positions[bot][1]]
      else
        false
    end
  end

  def move bot, direction
    case direction
      when MOVE_UP
        @positions[bot][1] += 1
      when MOVE_LEFT
        @positions[bot][0] -= 1
      when MOVE_DOWN
        @positions[bot][1] -= 1
      when MOVE_RIGHT
        @positions[bot][0] += 1
      else
        false
    end
  end

  def dig bot
    @field[@positions[bot][0]][@positions[bot][1]] -= 1
  end

  def raise_possible bot
    current_height = height @positions[bot]
    height(@positions[bot] + Vector[1, 0]) >= current_height ||
    height(@positions[bot] + Vector[1, -1]) >= current_height ||
    height(@positions[bot] + Vector[0, -1]) >= current_height ||
    height(@positions[bot] + Vector[-1, -1]) >= current_height ||
    height(@positions[bot] + Vector[-1, 0]) >= current_height ||
    height(@positions[bot] + Vector[-1, 1]) >= current_height ||
    height(@positions[bot] + Vector[0, 1]) >= current_height ||
    height(@positions[bot] + Vector[1, 1]) >= current_height
  end

  def raise bot
    @field[@positions[bot][0]][@positions[bot][1]] += 1
  end

  def height position
    @field[position[0]][@field[1]]
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

  def raise_possible?
    game.raise_possible? self
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

