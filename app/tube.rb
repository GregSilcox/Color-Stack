class Tube
  def initialize id, args
    @args = args

    @id = id # needs to be unique
    @color_id = [128, 128, 128, 64]
    @rect = args.state.tubes[id][:rect]
    @slots = args.state.tubes[id][:slots]
  end

  def self.setup id, args
    tx = args.state.w * id * 2 + args.state.x

    args.state.tubes[id] = {}

    (0..@args.state.balls_per_tube - 1).each do |j|
      ty = args.state.w * j + args.state.y
      args.state.tubes[id][:slots] = [tx, ty, args.state.w, args.state.w ]
    end

    args.state.tubes[id][:rect] = [
      tx,
      args.state.y,
      args.state.w,
      args.state.balls_per_tube * args.state.w
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

  def labell
    "tube: "
  end
end