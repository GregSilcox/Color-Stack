class Tubes
  attr_reader :color, :source

  def initialize args
    @args = args

    @x = Game::X
    @y = Game::Y
    @w = Game::W
    @h = Game::TUBES_PER_TRAY * @w

    @source = []
    @destination = []
    @args.state.color ||= 0
    @clicked = nil
  end

  def self.setup args
    args.state.tubes = []

    (0..Game::TUBES_PER_TRAY - 1).each do |i|
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

  def xanimate
    # @args.state.tubes[i][:slots][j] = [tx, ty, @w, @w]
    # tx = @w * i * 2 + @x
    # ty = @w * j + @y

    if @args.state.current == :source
      i = @args.state.source[0]
      j = @args.state.source[1]
      rect = @args.state.tubes[i][:rect]
      rect[1] = Game::W * (Game::BALLS_PER_TUBE + 2) + Game::Y
      c = @args.state.tubes[i][:colors][j]
      @args.outputs.solids << rect + @args.state.colors[c].values
    elsif @args.state.animation == :over
    elsif @args.state.animation == :down
    end
  end

  def animate
    top = 0
    @args.state.show = @args.state.tubes[@args.state.source[0]]

    case @args.state.animate
    when "setup"
      # Of all the slots in the source tube ...
      (Game::BALLS_PER_TUBE - 1).downto(0).each do |j|
        # which is the top non-empty slot?
        if is_color(source[0], j)
          source[1] = j
          break
        end
      end

      # Of all the slots in the destination tube
      (0..Game::BALLS_PER_TUBE - 1).each do |j|
        # which is the lowest empty slot?
        if !is_colored(destination[0], j)
          destination[1] = j
          break
        end
      end

      @args.state.animate = "move"
    when "move"
      # Swap the balls
      si = @args.state.source[0]
      sj = @args.state.source[1]
      temp = @args.state.tubes[si][:slots][sj][4]

      di = @args.state.destination[0]
      dj = @args.state.destination[1]
      @args.state.tubes[si][:slots][sj][4] = @args.state.tubes[di][:slots][dj][4]

      @args.state.tubes[di][:slots][dj][4] = temp
      
      @args.state.animate = "none"
    else
    end

    return false
  end

  def is_colored i, j
    ball_id = @args.state.tubes[i][:slots][j][4]
    @args.state.balls[ball_id][:color_id] != 0
  end

    # ball_id = @args.state.tubes[@clicked][:slots][top][4]
    # @args.state.source = @args.state.balls[ball_id]
    # @args.state.show = @args.state.source
    # return true

    # # The rest of this is neede for the move or animation
    # (0..Game::BALLS_PER_TUBE - 1).each do |j|
    #   if @args.state.tubes[@clicked][:colors][j] == 0
    #     if j == 0 || @args.state.tubes[@clicked][:colors][j - 1] == @args.state.color
    #       @args.state.tubes[@clicked][:colors][j] = @args.state.color
    #       return true
    #     end
    #   end
    # end

    # # Otherwise reset the source
    # @args.state.tubes[@args.state.source[0]][:colors][@args.state.source[1]] = @args.state.color
    # return false

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
