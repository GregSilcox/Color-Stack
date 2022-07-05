class Tube
  def initialize id, args
    @args = args

    @id = id # needs to be unique
    @color_id = [128, 128, 128, 64]
    @rect = args.state.tubes[id][:rect]
    @slots = args.state.tubes[id][:slots]
  end

  def self.setup id, args
    tx = Game::W * id * 2 + Game::X
    args.state.tubes[id] = {slots: []}

    (0..Game::BALLS_PER_TUBE - 1).each do |j|
      ty = Game::W * j + Game::Y
      ball_id = Game::BALLS_PER_TUBE * id + j
      args.state.tubes[id][:slots][j] = [tx, ty, Game::W, Game::W, ball_id ]
    end

    args.state.tubes[id][:rect] = [
      tx,
      Game::Y,
      Game::W,
      Game::BALLS_PER_TUBE * Game::W
    ]
  end

  def output
    {
      x: @rect[0] - 2,
      y: @rect[1] - 2,
      w: @rect[2] + 4,
      h: @rect[3] + 4,
      r: @color_id[0],
      g: @color_id[1],
      b: @color_id[2],
      a: @color_id[3]
    }
  end

  def self.label id, args
    "tube: "
  end
end
