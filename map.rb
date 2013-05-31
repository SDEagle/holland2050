class Map
  def initialize field_size, max_height
    @field = []
    field_size.times do |i|
      @field << []
      field_size.times do
        @field[i] << rand(max_height)
      end
    end
  end

  def noise frequency

  end
end