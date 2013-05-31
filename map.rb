require_relative 'field'
require 'matrix'
class Map
  def self.generate field_size, height
    @field = Field.new field_size, Struct.new('FieldData', :height, :water)
    @field.each { |field, _| field.height = 0; field.water = false }

    randoms = []
    @field.width.times do
      randoms << [rand(@field.height), rand(@field.width), rand(height)]
    end

    @field.width.times do |i|
      @field.height.times do |j|
        randoms.each do |peak|
          @field[i,j].height = (peak[2] - dist([i, j], peak)).floor unless @field[i,j].height > peak[2] - dist([i, j], peak)
          @field[i,j].height = 0 if @field[i,j].height < 0
          @field[i,j].height = height if @field[i,j].height > height
        end
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