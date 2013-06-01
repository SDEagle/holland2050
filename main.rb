require 'matrix'
require_relative 'game'
require_relative 'bot_ai'
require_relative 'bots/simple_ai'

g = Game.new Vector[50, 30], 23
5.times do
  SimpleAI.new g
end

g.run
