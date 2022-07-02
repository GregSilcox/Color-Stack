class Balls
  def self.setup args
    args.state.balls = []
    tubes = []

    (0..args.state.tubes_per_tray - 3).each do |i|
      (0..args.state.balls_per_tube).each do |j|
        tubes << Ball.setup(i, j, args) # Array.new args.state.balls_per_tube, i + 1
      end
    end
  
    unshuffled = tubes.flatten

    # Shuffle the order of the balls
    while unshuffled.any? 
      i = rand(unshuffled.length) - 1
      e = unshuffled.delete_at i
      args.state.balls.push e
    end
  
    # Inital randomized order of colors, plus two empty tubes
    args.state.balls += Array.new(args.state.balls_per_tube * 2, 0)
  end
end