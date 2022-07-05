class Ball
  def initialize id
    @id = id
    @color_id = 0
    @rect = []
  end

  def self.setup i, j, c = 0
    {
      id: i * Game::BALLS_PER_TUBE + j,
      color_id: c,
      rect: []
    }
  end

  def compute_rect
    tx = @w * i * 2 + @x
    ty = @w * j + @y
  end
end
