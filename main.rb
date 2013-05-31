require 'matrix'
require 'colorize'
require_relative 'bot'
require_relative 'field'

$id = 0
def get_id
  $id += 1
end

UP = 0
LEFT = 1
DOWN = 2
RIGHT = 3

class Game
  def initialize field_size
    @field = Field.new Vector[field_size, field_size], Struct.new('FieldData', :height)
    @field.each { |field| field.height = 3 }

    @water = 0

    @bots = []
    @positions = {}

    @sight_radius = 5
    @actions_per_round = 3
  end

  def add_bot bot
    @bots << bot
    @positions[bot] = Vector[rand(@field.width), rand(@field.height)]
  end

  def perform_round
    @actions_per_round.times do
      @bots.each do |bot|
        bot.act @water, @positions[bot], @field.filter_sight(@positions[bot], @sight_radius)
      end
    end
    raise_water
    @bots.each do |bot|
      @bots.delete bot unless  @field[@positions[bot]].height > @water
    end
  end

  def raise_water
    @water += 1
  end

  def move_possible? bot, direction
    possible_height = @field[@positions[bot]].height + 1
    case direction
      when UP
        possible_height >= @field[@positions[bot] + Vector[0,1]].height && @positions[bot][1] < @field.height - 1
      when LEFT
        possible_height >= @field[@positions[bot] + Vector[-1,0]].height && @positions[bot][0] > 0
      when DOWN
        possible_height >= @field[@positions[bot] + Vector[0,-1]].height && @positions[bot][1] > 0
      when RIGHT
        possible_height >= @field[@positions[bot] + Vector[1,0]].height && @positions[bot][0] < @field.width[0] - 1
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
    @field[@positions[bot]].height -= 1
  end

  def raise_possible? bot
    current_height = @field[@positions[bot]].height
    @field[@positions[bot] + Vector[1, 0]].height >= current_height ||
    @field[@positions[bot] + Vector[1, -1]].height >= current_height ||
    @field[@positions[bot] + Vector[0, -1]].height >= current_height ||
    @field[@positions[bot] + Vector[-1, -1]].height >= current_height ||
    @field[@positions[bot] + Vector[-1, 0]].height >= current_height ||
    @field[@positions[bot] + Vector[-1, 1]].height >= current_height ||
    @field[@positions[bot] + Vector[0, 1]].height >= current_height ||
    @field[@positions[bot] + Vector[1, 1]].height >= current_height
  end

  def raise bot
    @field[@positions[bot]].height += 1
  end

  def output
    # orientation foo
    # our field is
    #    +y
    # -x 0 +x
    #    -y
    puts 'the field'
    (@field.height - 1).downto(0) do |y|
      @field.width.times do |x|
        output = @field[x, y].height.to_s
        if @field[x, y].height <= @water
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

g = Game.new 20
b = Bot.new g
b2 = Bot.new g
b.move RIGHT
g.output
b2.move RIGHT
g.output