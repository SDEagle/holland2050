require_relative 'field'
require 'matrix'
class Map
  attr_accessor :field
  def initialize field_size, height
    @field = Field.new Vector[field_size, field_size], Struct.new('FieldData', :height)
    @field.each { |field| field.height = 0 }
  end

  def generate height
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

  def dist a, b
    Math.sqrt ((b[0]-a[0])**2+(b[1]-a[1])**2)
  end
  
  def print_field field
    puts (field.map { |inner| inner.join "\s" }).join "\n"
  end
end