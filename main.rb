require 'matrix'
require_relative 'game'
require_relative 'bot_ai'
require_relative 'bots/simple_ai'

g = Game.new Vector[50, 40], 23
5.times do
  SimpleAI.new g
end

g.status
while g.any_bot_alive? do
  readline
  g.perform_round
  g.status
end
