class BotWrapper
  attr_reader :bot

  def initialize game, bot
    @bot = bot
    @game = game
    @game.add_bot self
    new_round nil, nil
  end

  def move direction
    if !@used_action && move_possible?(direction)
      @game.move self, direction
      @used_action = true
    end
  end

  def move_possible? direction
    @game.move_possible? self, direction
  end

  def dig
    unless @used_action
      @game.dig self
      @used_action = true
    end
  end

  def raise_possible?
    @game.raise_possible? self
  end

  def raise
    unless @used_action
      @game.raise self
      @used_action = true
    end
  end

  def height_to_water
    @game.map[@position].height - @water_level
  end

  def water_level
    @water_level
  end

  def get_position relative_position
    if (@position - relative_position).r < sight_radius # TODO
      @game.map[@position + relative_position].to_hash
      # TODO bot??
    end
  end

  def act water_level, position
    new_round water_level, position
    @bot.act
  end

  def == other
    if other.is_a? Bot
      @bot == other
    elsif other.is_a? BotWrapper
      @bot == other.bot
    else
      false
    end
  end

  private

  def new_round water_level, position
    @used_action = false
    @position = position
    @water_level = water_level
  end
end

class Bot
  attr_reader :id

  def initialize game
    @id = get_id
    @wrapper = BotWrapper.new game, self
  end

  [:move, :move_possible?, :dig, :raise, :raise_possible?].each do |method|
    define_method method do |*args|
      @wrapper.send method, *args
    end
  end

  def == other
    return false unless other.is_a? Bot
    @id == other.id
  end

  def hash
    @id.hash
  end

  def act
    puts 'implement that shit'
  end
end