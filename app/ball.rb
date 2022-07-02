class Ball
  def initialize id, args
    @args = args

    @id = id
    @color_id = 0
    @rect = []
  end

  def self.setup i, j, args
    i + 1 # args.state.balls << i + 1
  end

  def compute_rect
    tx = @w * i * 2 + @x
    ty = @w * j + @y
  end
end