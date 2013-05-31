NEIGHBOUR_VECTORS = [Vector[1, 0], Vector[1, -1], Vector[0, -1], Vector[-1, -1], Vector[-1, 0], Vector[-1, 1], Vector[0, 1], Vector[1, 1]]

class Field
  def initialize size, data_class
    @size = size
    @data = Array.new(@size[0]) { Array.new(@size[1]) { data_class.new } }
  end

  def [] *args
    if args.size == 1
      @data[args[0][0]][args[0][1]]
    else
      @data[args[0]][args[1]]
    end
  end

  def width
    @size[0]
  end
  def height
    @size[1]
  end

  def neighbourhood *args
    position_neighbourhood(*args).map { |position| self[position] }
  end

  def position_neighbourhood *args
    if args.size == 1
      position = args[0]
    else
      position = Vector[*args]
    end
    NEIGHBOUR_VECTORS.map { |direction| position + direction }.reject { |neighbour_position| !in_field? neighbour_position }
  end

  def in_field? position
    position[0] >= 0 && position[0] < width && position[1] >= 0 && position[1] < height
  end

  # Returns an array containing only fields around the bot within sight.
  def filter_sight position, radius
    @data[position[0] - radius, 2 * radius].map { |column| column[position[1] - radius, 2 * radius] }
  end

  def each
    @data.each_with_index do |column, x|
      column.each_with_index do |data, y|
        yield data, Vector[x, y]
      end
    end
  end

  def draw
    # our field is
    #    +y
    # -x 0 +x
    #    -y
    (height - 1).downto(0) do |y|
      width.times do |x|
        print "#{yield self[x,y], Vector[x,y]} "
      end
      puts ''
    end
  end
end