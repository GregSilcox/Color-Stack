class Game
  W = 25
  X = 300
  Y = 200
  TUBES_PER_TRAY = 12
  BALLS_PER_TUBE = 4

  def initialize args
    @args = args
  end

  def self.setup args
    Balls.setup args
    Tubes.setup args

    args.state.once = true
  end

  def self.label args
    [ X, Y, W, TUBES_PER_TRAY, BALLS_PER_TUBE ].to_s
  end
end
