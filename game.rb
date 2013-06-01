require 'colorize'
require_relative 'map'

UP = 0
LEFT = 1
DOWN = 2
RIGHT = 3
DIRECTIONS = { UP => Vector[0, 1], LEFT => Vector[-1, 0], DOWN => Vector[0, -1], RIGHT => Vector[1, 0] }

class Game
  attr_reader :field

  def initialize field_size, height
    @field = Map.generate field_size, height
    @bots = []

    @water = 0
    @actions_per_round = 3
  end

  def add_bot bot
    @bots << bot
    Vector[rand(@field.width), rand(@field.height)]
  end

  def perform_round
    @actions_per_round.times do
      @bots.each do |bot|
        bot.act @water
      end
    end
    raise_water
    @bots.reject! { |bot| @field[bot.position].water }
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
        if !neighbour.water && (neighbour.height <= @water || neighbour.height <= @field[position].height)
          neighbour.water = true
          flow_to_neighbours neighbour_position
        end
      end
    end
  end

  def push bot, direction
    @bots.each do |other|
      other.push direction unless other.position != bot.position || other == bot
    end
  end

  def draw
    bot_positions = @bots.map { |bot| bot.position }
    @field.draw do |field, position|
      s = '%02d' % (field.water ? @water : field.height)
      if field.water
        s.blue
      elsif bot_positions.include? position
        s.red
      else
        s.green
      end
    end
  end

  def status
    puts '-----------------------------------------------------------'
    puts "bots left: #{@bots.size} - water level: #{@water}"
    draw
  end

  def any_bot_alive?
    !@bots.empty?
  end
end