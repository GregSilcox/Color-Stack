class TestScene < Scene
  def display
    @args.outputs.labels << [ 10, 700, "Game Scene: test" ]

    tubes = Tubes.new @args
    tube1 = tubes.read 11
    tube2 = tubes.read 5
    tube3 = tubes.read 0
    @args.outputs.solids << [tube1.output, tube2.output, tube3.output]

    data = @args.state.balls.map { |ball| ball[:position] }
    @args.outputs.labels << [ 10, 360, "pos: #{ data[0..11] }"]
    @args.outputs.labels << [ 10, 340, "pos: #{ data[12..23] }"]
    @args.outputs.labels << [ 10, 320, "pos: #{ data[24..35] }"]
    @args.outputs.labels << [ 10, 300, "pos: #{ data[36..48] }"]

    ball1 = @args.state.balls[0]
    @args.outputs.solids << (ball1[:rect].merge Colors::DATA[ball1[:color_id]])

    msg = @args.state.balls[0]
    @args.outputs.labels << [ 10, 270, "Ball 0 rect: #{ msg }"]

    msg = @args.state.tubes[1][:slots]
    @args.outputs.labels << [ 10, 240, "Tube 0 slots: #{ msg }" ]

    msg = @args.state.tubes[1][:rect]
    @args.outputs.labels << [ 10, 210, "Tube 0 rect: #{ msg }" ]

    msg = @args.state.tubes[1]

    msg = @args.state.scenes[:animation]
    @args.outputs.labels << [ 10, 180, "Animation Scene: #{ msg }" ]

    msg = @args.state.scenes[:game]
    @args.outputs.labels << [ 10, 150, "Game Scene: #{ msg }" ]

    msg = @args.state.scenes[:test]
    @args.outputs.labels << [ 10, 120, "Test Scene: #{ msg }" ]

    msg = @args.state.game
    @args.outputs.labels << [ 10, 90, "Game: #{ msg }" ]

    msg = @args.state.animations
    @args.outputs.labels << [ 10, 60, "Animations: #{ msg }" ]

    msg = @args.state.current
    @args.outputs.labels << [ 10, 30, "Game State: #{ msg }" ]
  end
end