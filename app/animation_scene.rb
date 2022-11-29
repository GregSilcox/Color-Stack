class AnimationScene < Scene
  def tick
    @scene = @args.state.scenes[:animation]

    @animation = if @args.state.animations.any?
      @args.state.animations.last
    else
      Animations.create @args
    end

    @animation[:source] = @scene[:source].dup
    @animation[:destination] = @scene[:destination].dup
    @animation[:position] = @scene[:source].dup
  end

  def display
    # raise "display animation: #{ @args.state.g ame }"
    @args.outputs.labels << [10, 700, "Animation Scene"]
    @args.outputs.labels << [10, 675, "Scene: " + @scene.to_s]

    # a = @args.state.animations.first
    a = @animation
    @args.outputs.labels << [10, 650, "source: #{ a[:source] }"]
    @args.outputs.labels << [10, 625, "destination: #{ a[:destination] }"]
    @args.outputs.labels << [10, 600, "position: #{ a[:position] }"]
    @args.outputs.labels << [10, 575, "ball id: #{ a[:ball_id] }"]
    @args.outputs.labels << [10, 550, "state: #{ a[:state] }"]
    @args.outputs.labels << [10, 525, "bpt: #{ Game::BALLS_PER_TUBE }"]
    @args.outputs.labels << [10, 500, "tpt: #{ Game::TUBES_PER_TRAY }"]
    @args.outputs.labels << [10, 475, "scene: #{ @scene }"]
    @args.outputs.labels << [10, 450, "animation: #{ @animation }"]
  end
end