require 'matrix'
require_relative 'game'
require_relative 'bot_ai'

g = Game.new Vector[50, 40], 23
5.times do
  BotAI.new g
end

g.status
23.times do
  readline
  g.perform_round
  g.status
end
