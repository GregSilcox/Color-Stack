class GameScene < Scene
  def tick
    @tubes = Tubes.new @args
    @balls = Balls.new @args
    @state = State.new @args
    @animations = Animations.new @args
    @state.tick @tubes if @tubes.clicked?
    # @animations.tick()  # if tubes.clicked?
  end

  def display
    @tubes.display
    @balls.display
    @state.display
    @args.outputs.labels << [ 10, 700, "Game Scene: game" ]
  end
end