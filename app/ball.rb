class Ball
  def initialize ball
    @ball = ball
    @color = Colors::DATA[ball[:color_id]]
  end

  def self.setup i, j, c = 0
    {
      id: i * Game::BALLS_PER_TUBE + j,
      color_id: c,
      rect: compute_rect(i, j),
      position: [i, j]
    }
  end

  def self.compute_rect i, j
    {
      x: Game::W * i * 2 + Game::X,
      y: Game::W * j + Game::Y,
      w: Game::W, 
      h: Game::W
    }
  end

  def move_to x, y
    @ball[:position] = [x, y]
    @ball[:rect] =     {
      x: Game::W * x * 2 + Game::X,
      y: Game::W * y + Game::Y,
      w: Game::W, 
      h: Game::W
    }
  end

  def state
    @ball
  end

  def output
    @ball[:rect].merge @color
  end
end
