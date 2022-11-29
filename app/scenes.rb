class Scenes
  def self.reset! args
    args.state.scenes = {
      current: :game,
      test: {},
      game: {
        state: nil,
        source: [nil, nil],
        destination: [nil, nil]
      },
      animation: {
        state: Animation::INIT,
        source: [1, 1],
        destination: [10, 2]
      }
    }
  end

  def self.current args
    if args.inputs.keyboard.key_down.t
      args.state.game[:current] = :test
    elsif args.inputs.keyboard.key_down.g
      args.state.game[:current] = :game
    elsif args.inputs.keyboard.key_down.s
      args.state.game[:current] = :scene
    elsif args.inputs.keyboard.key_down.a
      args.state.game[:current] = :animation
    end

    args.state.game[:current] = :game unless args.state.game[:current]
    
    scene = case args.state.game[:current]
    when :game
      GameScene
    when :test
      TestScene
    when :animation
      AnimationScene
    else
      GameScene
    end

    scene.new args
  end
end