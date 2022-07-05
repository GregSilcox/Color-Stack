class Tubes
  attr_reader :color, :source

  def initialize args
    @args = args

    @x = args.state.x
    @y = args.state.y
    @w = args.state.w
    @h = args.state.balls_per_tube * @w

    @source = []
    @destination = []
    @args.state.color ||= 0
    @clicked = nil
  end

  def self.setup args
    args.state.tubes = []

    (0..args.state.tubes_per_tray - 1).each do |i|
      Tube.setup i, args
    end
  end

  def display
    @args.state.tubes.each_with_index do |tube, i|
      @args.outputs.solids << tube.output

      @args.state.tubes[i][:slots].each_with_index do |slot, j|
        ball_id = slot[4]
        color_id = @args.state.balls[ball_id][:color_id]
        color = Colors::DATA[color_id]

        @args.outputs.solids << {
          x: slot[0],
          y: slot[1],
          w: slot[2],
          h: slot[3],
          r: color[:r],
          g: color[:g],
          b: color[:b],
          a: color[:a]
        }
      end
    end

    @args.outputs.labels << [ 10, 60, "Source: " + @args.state.source.to_s ]
    @args.outputs.labels << [ 10, 90, "Destination: " + @args.state.destination.to_s ]
  end

  def self.label args
    "Tubes: #{ args.state.tubes }"
  end

  def self.inspect x, y, args
    args.state.tubes.each_with_index do |tube, j|
      args.outputs.labels << [ x, y + 40 * j, "Slots: #{ tube[:slots] }" ]
      args.outputs.labels << [ x, y + 40 * j + 20, "Rect: #{ tube[:rect] }"]
    end
  end

  def animate
    # @args.state.tubes[i][:slots][j] = [tx, ty, @w, @w]
    # tx = @w * i * 2 + @x
    # ty = @w * j + @y

    if @args.state.current == :source
      i = @args.state.source[0]
      j = @args.state.source[1]
      rect = @args.state.tubes[i][:rect]
      rect[1] = @args.state.w * (@args.state.balls_per_tube + 2) + @args.state.y
      c = @args.state.tubes[i][:colors][j]
      @args.outputs.solids << rect + @args.state.colors[c].values
    elsif @args.state.animation == :over
    elsif @args.state.animation == :down
    end
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

    @args.state.source = @args.state.tubes[@clicked]
    return true

    # The rest of this is needed for the move or animation
    top = 0
    # Of all the slots in the clicked tube ...
    (Game::BALLS_PER_TUBE - 1).downto(0).each do |j|
      # which was the top?
      if colors[j] > 0
        top = j
        break
      end
    end

    ball_id = @args.state.tubes[@clicked][:slots][top][4]
    @args.state.source = @args.state.balls[ball_id]
    @args.state.show = @args.state.source
    return true
  end

  def destination
    # There has to be room in the tube for another ball
    ball_id = @args.state.tubes[@clicked][:slots][Game::BALLS_PER_TUBE - 1][4]
    color_id = @args.state.balls[ball_id][:color_id]
    return false unless color_id == 0

    # The destination must be different than the source
    return false if @clicked == @args.state.source

    @args.state.destination = @args.state.tubes[@clicked]
    return true

    # The rest of this is neede for the move or animation
    (0..@args.state.balls_per_tube - 1).each do |j|
      if @args.state.tubes[@clicked][:colors][j] == 0
        if j == 0 || @args.state.tubes[@clicked][:colors][j - 1] == @args.state.color
          @args.state.tubes[@clicked][:colors][j] = @args.state.color
          return true
        end
      end
    end

    # Otherwise reset the source
    @args.state.tubes[@args.state.source[0]][:colors][@args.state.source[1]] = @args.state.color
    return false
  end
end
