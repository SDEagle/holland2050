require_relative 'field'

class Map
  def self.generate field_size, height, peaks = field_size[0], valleys = field_size[1]
    @field = Field.new field_size, Struct.new('FieldData', :height, :water)
    @field.each { |field, _| field.height = 0; field.water = false }

    randoms = []
    peaks.times do
      randoms << [rand(@field.height), rand(@field.width), rand(height)]
    end
    random_valleys = []
    valleys.times do
      randoms << [rand(@field.height), rand(@field.width), -rand(height/2)]
    end

    @field.width.times do |i|
      @field.height.times do |j|
        randoms.each do |peak|
          if peak[2] < 0
            @field[i,j].height = (height + peak[2] - dist([i, j], peak)).floor unless @field[i,j].height > height + peak[2] - dist([i, j], peak)
          else
            @field[i,j].height = (peak[2] - dist([i, j], peak)).floor unless @field[i,j].height > peak[2] - dist([i, j], peak)
          end
        end
        @field[i,j].height = 0 if @field[i,j].height < 0
        @field[i,j].height = height if @field[i,j].height > height
      end
    end

    min_height = height
    @field.each do |field|
      min_height = field.height if field.height < min_height
    end
    @field.each do |field|
      field.height -= min_height
    end

    @field
  end

  def self.dist a, b
    Math.sqrt ((b[0]-a[0])**2+(b[1]-a[1])**2)
  end
end