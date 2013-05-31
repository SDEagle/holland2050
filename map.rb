class Map
  attr_accessor :field
  def initialize field_size, height
    @field = Array.new(field_size) { Array.new(field_size) { 0 } }
  end

  def generate height
    randoms = []
    @field.size.times do
      randoms << [rand(@field.size), rand(@field.size), rand(height)]
    end

    @field.size.times do |i|
      @field.size.times do |j|
        randoms.each do |peak|
          @field[i][j] = (peak[2] - dist([i, j], peak)).floor unless @field[i][j] > peak[2] - dist([i, j], peak)
          @field[i][j] = 0 if @field[i][j] < 0
          @field[i][j] = height if @field[i][j] > height
        end
      end
    end
    @field
  end

  def dist a, b
    Math.sqrt ((b[0]-a[0])**2+(b[1]-a[1])**2)
  end
  
  def print_field field
    puts (field.map { |inner| inner.join "\s" }).join "\n"
  end
end