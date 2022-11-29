class Game
  W = 25
  X = 300
  Y = 200
  TUBES_PER_TRAY = 12
  BALLS_PER_TUBE = 4

  def initialize args
    @args = args
    @me = args.state.game
  end

  def self.setup args
    game = new args
    return game if args.state.game[:once]

    Balls.setup args
    Tubes.setup args

    State.reset! args
    Animations.reset! args
    Scenes.reset! args

    args.state.game = {
      current: :game,
      once: :true
    }
    
    return game
  end

  def reset_button args
    args.outputs.solids << [1180, 0, 100, 50, 128, 200, 200, 255]
    args.outputs.labels << [1210, 35, "Reset"]
  
    if args.inputs.mouse.click && 
        args.inputs.mouse.inside_rect?([1180, 0, 100, 50])
      args.state.game[:once] = false
      Game.setup args
    end
  end
end
