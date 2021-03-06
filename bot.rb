class Bot
  attr_reader :bot_ai, :position

  def initialize game, bot
    @bot_ai = bot
    @game = game
    @position = @game.add_bot self
    new_round nil
    @sight_radius = 5
  end

  def move_possible? direction
    target = @position + DIRECTIONS[direction]
    @game.field.in_field?(target) && @game.field[target].height <= @game.field[@position].height + 1
    # TODO other bots in way
  end

  def move direction
    if !@used_action
      push direction
      @used_action = true
    end
  end

  def push direction
    if move_possible? direction
      @position += DIRECTIONS[direction]
      @game.push self, direction
    end
  end

  def dig
    unless @used_action
      @game.field[@position].height -= 1
      @used_action = true
    end
  end

  def raise_possible?
    @game.field.neighbourhood(@position).any? { |neighbour| neighbour.height >= @game.field[@position].height }
  end

  def raise
    unless @used_action
      @game.field[@position].height += 1
      @used_action = true
    end
  end

  def height_to_water
    @game.field[@position].height - @water_level
  end

  def water_level
    @water_level
  end

  def get_position relative_position
    target = @position + relative_position
    if relative_position.r < @sight_radius && @game.field.in_field?(target)
      @game.field[@position + relative_position].to_h
      # TODO other bots??
    end
  end

  def current_position
    get_position Vector[0, 0]
  end

  def act water_level
    new_round water_level
    @bot_ai.act
  end

  def == other
    if other.is_a? BotAI
      @bot_ai == other
    elsif other.is_a? Bot
      @bot_ai == other.bot_ai
    else
      false
    end
  end

  private

  def new_round water_level
    @used_action = false
    @water_level = water_level
  end
end