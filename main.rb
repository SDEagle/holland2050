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
DIRECTIONS = { UP => Vector[0, 1], LEFT => Vector[-1, 0], DOWN => Vector[0, -1], RIGHT => Vector[1, 0] }

class Game
  def initialize field_size
    @field = Field.new Vector[field_size, field_size], Struct.new('FieldData', :height, :water)
    @field.each { |field, _| field.height = 3; field.water = false }

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
      @bots.delete bot if @field[@positions[bot]].water
    end
  end

  def raise_water
    @water += 1

    @field.each do |field, position|
      # spawn water on edge
      field.water = true if field.height <= @water && (position[0] == 0 || position[1] == 0 || position[0] == @field.width - 1 || position[1] == @field.height - 1)
      flow_to_neighbours position
    end
  end

  def flow_to_neighbours position
    if @field[position].water
      @field.position_neighbourhood(position).each do |neighbour_position|
        neighbour = @field[neighbour_position]
        if !neighbour.water && neighbour.height <= @field[position].height
          neighbour.water = true
          flow_to_neighbours neighbour_position
        end
      end
    end
  end

  def move_possible? bot, direction
    target = @positions[bot] + DIRECTIONS[direction]
    @field.in_field?(target) && @field[target].height <= @field[@positions[bot]].height + 1
  end

  def move bot, direction
    @positions[bot] += DIRECTIONS[direction]

    # Pushing bots around.
    @bots.each do |other|
      move other, direction unless @positions[other] != @positions[bot] || other == bot
    end
  end

  def dig bot
    @field[@positions[bot]].height -= 1
  end

  def raise_possible? bot
    @field.neighbourhood(@positions[bot]).any? { |neighbour| neighbour.height >= @field[@positions[bot]].height }
  end

  def raise bot
    @field[@positions[bot]].height += 1
  end

  def draw
    @field.draw do |field, position|
      s = field.height.to_s
      if field.water
        s.blue
      elsif @positions.has_value? position
        s.red
      else
        s.green
      end
    end
  end
end

g = Game.new 20
b = Bot.new g
b2 = Bot.new g
b.move RIGHT
b2.raise
g.draw