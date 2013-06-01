class SimpleAI < BotAI
  def act
    best_direction = nil
    best_height = current_position[:height]
    DIRECTIONS.each do |direction, vector|
      if get_position(vector) && get_position(vector)[:height] > best_height && move_possible?(direction)
        best_direction = direction
        best_height = get_position(vector)[:height]
      end
    end

    if get_position(Vector[1, -1]) && get_position(Vector[1, -1])[:height] > best_height
      best_height = get_position(Vector[1, -1])[:height]
      if move_possible? RIGHT
        best_direction = RIGHT
      elsif move_possible? DOWN
        best_direction = DOWN
      end
    end
    if get_position(Vector[1, 1]) && get_position(Vector[1, 1])[:height] > best_height
      best_height = get_position(Vector[1, 1])[:height]
      if move_possible? RIGHT
        best_direction = RIGHT
      elsif move_possible? UP
        best_direction = UP
      end
    end
    if get_position(Vector[-1, 1]) && get_position(Vector[-1, 1])[:height] > best_height
      best_height = get_position(Vector[-1, 1])[:height]
      if move_possible? LEFT
        best_direction = LEFT
      elsif move_possible? UP
        best_direction = UP
      end
    end
    if get_position(Vector[-1, -1]) && get_position(Vector[-1, -1])[:height] > best_height
      best_height = get_position(Vector[-1, -1])[:height]
      if move_possible? LEFT
        best_direction = LEFT
      elsif move_possible? DOWN
        best_direction = DOWN
      end
    end


    move best_direction unless best_direction.nil?
  end
end