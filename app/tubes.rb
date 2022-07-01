class Tubes
  def initialize args
    @args = args
    
    @x = args.state.x
    @y = args.state.y
    @w = args.state.w
    @h = args.state.balls_per_tube * @w

    @source = []
    @destination = []
    @color = 0
    @clicked = nil
  end

  def fill
    @args.state.tubes = []

    (0..@args.state.tubes_per_tray - 1).each do |i|
      tx = @w * i * 2 + @x
  
      @args.state.tubes[i] = {
        rect: [tx, @y, @w, @h],
        color: [128, 128, 128, 64], # fixed tube color
        slots: [],
        colors: []
      }
  
      (0..@args.state.balls_per_tube - 1).each do |j|
        ty = @w * j + @y
  
        @args.state.tubes[i][:slots][j] = [tx, ty, @w, @w]
        @args.state.tubes[i][:colors][j] = @args.state.balls[i * 4 + j]
      end
    end
  end

  def display
    @args.state.tubes.each_with_index do |tube, i|
      @args.outputs.solids << {
        x: tube[:rect][0] - 2,
        y: tube[:rect][1] - 2,
        w: tube[:rect][2] + 4,
        h: tube[:rect][3] + 4,
        r: tube[:color][0],
        g: tube[:color][1],
        b: tube[:color][2],
        a: tube[:color][3]
      }

      @args.state.tubes[i][:colors].each_with_index do |color, j|
        color_i = @args.state.tubes[i][:colors][j]
        color = @args.state.colors[color_i]
        slot = @args.state.tubes[i][:slots][j]
  
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
    (0..@args.state.tubes_per_tray - 1).each do |i|
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
    return unless @args.state.tubes[@clicked][:colors].sum > 0

    top = 0

    # Of all the slots in the clicked tube ...
    (@args.state.balls_per_tube - 1).downto(0).each do |j|
      # which was the top?
      if @args.state.tubes[@clicked][:colors][j] > 0
        top = j
        break
      end
    end

    # Make the color appear above the tube
    @color = @args.state.tubes[@clicked][:colors][top]

    # Blank the source color
    @args.state.tubes[@clicked][:colors][top] = 0
    @args.outputs.labels << [ 10, 60, "Source: " + @clicked.to_s + ', ' + top.to_s ]
  end

  def destination
  end
end
