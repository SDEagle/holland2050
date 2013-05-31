class Map
  attr_accessor :field
  def initialize field_size, height
    @field = Array.new(field_size) { Array.new(field_size) { 0 } }
    random_field = Array.new(field_size) { Array.new(field_size) { rand height } }
    step_one = Array.new(field_size / 5) { Array.new(field_size / 5) }
    raster = (field_size / 5)
    raster.times do |i|
      raster.times do |j|
        step_one[i][j] = random_field[i][j]
      end
    end

    field_size.times do |i|
      field_size.times do |j|
        unless i % 5 == 0 || j % 5 == 0
          q11 = [i, j, step_one[i/5][j/5]]
          q12 = [i, j+5, step_one[i/5][(j+1)/5]]
          q21 = [i+5, j, step_one[(i+1)/5][j/5]]
          q22 = [i+5, j+5, step_one[(i+1)/5][(j+1)/5]]
          p = [i, j, 0]
          @field[i][j] = interpolate_bilinear q11, q12, q21, q22, p
        end
      end
    end

    print_field @field
  end

  def interpolate_bilinear q11, q12, q21, q22, p
    r1 = (q21[0] - p[0]) / (q21[0] - q11[0]) * q11[2] + (p[0] - q11[0]) / (q21[0] - q11[0]) * q21[2]
    r2 = (q21[0] - p[0]) / (q21[0] - q11[0]) * q12[2] + (p[0] - q11[0]) / (q21[0] - q11[0]) * q22[2]
    (q22[1] - p[1]) / (q22[1] - q21[1]) * r1[2] + (p[1] - q11[1]) / (q22[1] - q11[1]) * r2[2]
  end
  
  def print_field field
    puts (field.map { |inner| inner.join "\s" }).join "\n"
  end
end

map = Map.new 20, 99