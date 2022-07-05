class Balls
  def self.setup args
    args.state.balls = []
    balls = []

    (0..Game::TUBES_PER_TRAY - 3).each do |i|
      (0..Game::BALLS_PER_TUBE - 1).each do |j|
        balls << Ball.setup(i, j, i + 1)
      end
    end

    # Shuffle the order of the balls
    while balls.any?
      i = rand(balls.length) - 1
      ball = balls.delete_at i
      args.state.balls.push ball
    end

    # Inital randomized order of colors, plus two empty tubes
    (Game::TUBES_PER_TRAY - 2..Game::TUBES_PER_TRAY - 1).each do |i|
      (0..Game::BALLS_PER_TUBE - 1).each do |j|
        args.state.balls << Ball.setup(i, j, 0)
      end
    end
  end

  def self.label args
    "Balls count: #{ args.state.balls.size }"
  end
end
