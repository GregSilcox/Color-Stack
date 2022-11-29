class Tubes
  attr_reader :color, :source

  IDS = (0..Game::TUBES_PER_TRAY - 1)

  def initialize args
    @args = args
    @clicked = nil
    @me = args.state.tubes

    # an array of Tube
    @tubes = IDS.map { |id| Tube.new @me[id] }
  end

  def self.setup args
    args.state.tubes = IDS.map { |id| Tube.setup id }
  end

  def read id
    @tubes[id]
  end

  def display
    @args.outputs.solids << @tubes.map { |tube| tube.output }
    @args.outputs.labels << [ 10, 60, "Source: " + @args.state.source.to_s ]
    @args.outputs.labels << [ 10, 90, "Destination: " + @args.state.destination.to_s ]
  end

  def clicked?
    return false unless @args.inputs.mouse.click

    # Of all the tubes ...
    (0..Game::TUBES_PER_TRAY - 1).each do |i|
      # which was clicked in? ...
      if @args.inputs.mouse.inside_rect?(@args.state.tubes[i][:rect])
        @clicked = i
        return true
      end
    end

    return false
  end

  def source
    # A tube needs some colors to be a source
    slots = @args.state.tubes[@clicked][:slots]
    balls = slots.map { |slot| @args.state.balls[slot[4]] }
    colors = balls.map { |ball| ball[:color_id] }

    return false unless colors.select { |color| color != 0 }.any?

    @args.state.source = [@clicked, nil]
    return true
  end

  def destination
    # There has to be room in the tube for another ball
    ball_id = @args.state.tubes[@clicked][:slots][Game::BALLS_PER_TUBE - 1][4]
    color_id = @args.state.balls[ball_id][:color_id]
    return false unless color_id == 0

    # The destination must be different than the source
    return false if @clicked == @args.state.source

    @args.state.destination = [@clicked, nil]
    return true
  end
end
