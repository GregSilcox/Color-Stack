class Balls

  def initialize args
    @args = args
    @me = args.state.balls
  
    # an array of Ball
    @balls = (0..@me.size - 1).map { |id| Ball.new @me[id] }
  end

  def self.setup args
    args.state.balls = []
    balls = []
    shuffled = []

    (0..Game::TUBES_PER_TRAY - 3).each do |i|
      (0..Game::BALLS_PER_TUBE - 1).each do |j|
        # An array of hashes
        balls << Ball.setup(i, j, i + 1)
      end
    end

    # Shuffle the order of the balls
    while balls.any?
      i = rand(balls.length) - 1
      ball = balls.delete_at i
      id = shuffled.size - 0
      x = (id / Game::BALLS_PER_TUBE).to_i
      y = (id % Game::BALLS_PER_TUBE).to_i
      b = Ball.new ball
      b.move_to x, y
      shuffled << b.state
    end

    # Inital randomized order of colors, plus two empty tubes
    (Game::TUBES_PER_TRAY - 2..Game::TUBES_PER_TRAY - 1).each do |i|
      (0..Game::BALLS_PER_TUBE - 1).each do |j|
        ball = Ball.setup i, j, 11
        shuffled.push ball
      end
    end

    args.state.balls = shuffled # .map { |ball| ball.state }
  end

  def read id
    @balls[id]
  end

  def display
    @args.outputs.solids << @balls.map { |ball| ball.output }
  end
end
