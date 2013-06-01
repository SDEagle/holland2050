require 'curses'
include Curses
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

  def run
    init_screen
    start_color
    init_pair(COLOR_BLUE,COLOR_BLUE,COLOR_BLACK)
    init_pair(COLOR_GREEN,COLOR_GREEN,COLOR_BLACK)
    init_pair(COLOR_RED,COLOR_RED,COLOR_BLACK)
    begin
      crmode
      addstr "
 _   _ _____ _      _       ___   _   _______   _____  _____ _____  _____
| | | |  _  | |    | |     / _ \\ | \\ | |  _  \\ / __  \\|  _  |  ___||  _  |
| |_| | | | | |    | |    / /_\\ \\|  \\| | | | | `' / /'| |/' |___ \\ | |/' |
|  _  | | | | |    | |    |  _  || . ` | | | |   / /  |  /| |   \\ \\|  /| |
| | | \\ \\_/ / |____| |____| | | || |\\  | |/ /  ./ /___\\ |_/ /\\__/ /\\ |_/ /
\\_| |_/\\___/\\_____/\\_____/\\_| |_/\\_| \\_/___/   \\_____/ \\___/\\____/  \\___/

                  Darfs ein bisschen Meer sein?"
      getch
      clear
      while any_bot_alive? do
        perform_round
        bot_positions = @bots.map { |bot| bot.position }
        @field.each do |field, position|
          setpos(@field.height - 1 - position[1], position[0] * 3)
          if field.water
            attron(color_pair(COLOR_BLUE)|A_NORMAL) {
              addstr("#{@water}")
            }
          elsif bot_positions.include? position
            attron(color_pair(COLOR_RED)|A_NORMAL) {
              addstr("#{field.height}")
            }
          else
            attron(color_pair(COLOR_GREEN)|A_NORMAL) {
              addstr("#{field.height}")
            }
          end
        end
        refresh
        sleep 0.5
      end
      addstr "

 ___________ _       ___   _____ _   _ _
/  ___| ___ \\ |     / _ \\ /  ___| | | | |
\\ `--.| |_/ / |    / /_\\ \\ `--.| |_| | |
 `--. \\  __/| |    |  _  | `--. \\  _  | |
/\\__/ / |   | |____| | | |/\\__/ / | | |_|
\\____/\\_|   \\_____/\\_| |_/\\____/\\_| |_(_)
"
      getch
      close_screen
      refresh
    ensure
      close_screen
    end
  end

  def any_bot_alive?
    !@bots.empty?
  end
end