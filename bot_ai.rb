require_relative 'bot'

class BotAI
  @@id = 1
  def self.get_id
    @@id += 1
  end

  attr_reader :id

  def initialize game
    @id = BotAI.get_id
    @wrapper = Bot.new game, self
  end

  [:move, :move_possible?, :dig, :raise, :raise_possible?, :get_position, :current_position].each do |method|
    define_method method do |*args|
      @wrapper.send method, *args
    end
  end

  def == other
    return false unless other.is_a? BotAI
    @id == other.id
  end

  def hash
    @id.hash
  end

  def act
    #puts 'implement that shit'
  end
end