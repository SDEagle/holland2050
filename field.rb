

class Field
  def initialize size, data_class
    @size = size
    @data = Array.new(@size[0]) { Array.new(@size[1], data_class.new) }
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

  # Returns an array containing only fields around the bot within sight.
  def filter_sight position, radius
    @data[position[0] - radius, 2 * radius].map { |column| column[position[1] - radius, 2 * radius] }
  end

  def each
    @data.each do |column|
      column.each do |date|
        yield date
      end
    end
  end
end