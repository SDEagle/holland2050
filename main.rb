require 'matrix'
require 'colorize'
require_relative 'bot'

$id = 0
def get_id
  $id += 1
end

UP = 0
LEFT = 1
DOWN = 2
RIGHT = 3
SIGHT_RADIUS = 5

class Game
  def initialize field_size
    @field_size = Vector[field_size, field_size]
    @field = Array.new(@field_size[1]) { Array.new(@field_size[0], 3) }

    @water = 0

    @bots = []
    @positions = {}
  end

  def add_bot bot
    @bots << bot
    @positions[bot] = Vector[rand(@field_size[0]), rand(@field_size[0])]
  end

  def next_round
    raise_water
    @bots.each do |bot|
      bot.act @water, @positions[bot], filter_sight(bot, @field)
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
    field[@positions[bot][0] - SIGHT_RADIUS, 2 * SIGHT_RADIUS].map { |column| column[@positions[bot][1] - SIGHT_RADIUS, 2 * SIGHT_RADIUS] }
  end

  def move_possible? bot, direction
    possible_height = height(@positions[bot]) + 1
    case direction
      when UP
        possible_height >= @field[@positions[bot][0]][@positions[bot][1]+1] && @positions[bot][1] < @field_size[1] - 1
      when LEFT
        possible_height >= @field[@positions[bot][0]-1][@positions[bot][1]] && @positions[bot][0] > 0
      when DOWN
        possible_height >= @field[@positions[bot][0]][@positions[bot][1]-1] && @positions[bot][1] > 0
      when RIGHT
        possible_height >= @field[@positions[bot][0]+1][@positions[bot][1]] && @positions[bot][0] < @field_size[0] - 1
      else
        false
    end
  end

  def move bot, direction
    case direction
      when UP
        @positions[bot] += Vector[0,1]
      when LEFT
        @positions[bot] += Vector[-1,0]
      when DOWN
        @positions[bot] += Vector[0,-1]
      when RIGHT
        @positions[bot] += Vector[1,0]
      else
        false
    end

    # Pushing bots around.
    @bots.each do |other|
      move other, direction unless @positions[other] != @positions[bot] || other == bot
    end
  end

  def dig bot
    @field[@positions[bot][0]][@positions[bot][1]] -= 1
  end

  def raise_possible? bot
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
    @field[position[0]][position[1]]
  end

  def output
    # orientation foo
    # our field is
    #    +y
    # -x 0 +x
    #    -y
    puts 'the field'
    (@field[0].size - 1).downto(0) do |y|
      @field.size.times do |x|
        output = @field[x][y].to_s
        if @field[x][y] <= @water
          output = output.blue
        elsif @positions.has_value? Vector[x,y]
          output = output.red
        else
          output = output.green
        end
        print output
        print ' '
      end
      puts ''
    end
  end
end

#g = Game.new 20
#b = Bot.new g
#b2 = Bot.new g
#b.move RIGHT
#g.output
#b2.move RIGHT
#g.output