class Tube
  def initialize tube # id, args
    @tube = tube
    @color = Colors::DATA[0].dup
  end

  def self.setup id
    {
      rect: {
        x: Game::W * id * 2 + Game::X - 2,
        y: Game::Y - 2,
        w: Game::W + 4,
        h: Game::BALLS_PER_TUBE * Game::W + 4
      },
      color_id: 3
    }
  end

  def output
    @tube[:rect].merge @color
  end
end
