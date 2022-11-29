class Animation
  attr_reader :me

  INIT = "init"
  COMPUTE = "compute"
  UP = "up"
  ACCROSS = "accross"
  DOWN = "down"
  ERROR = "error"
  
  # new/read
  def initialize args, id
    @args = args
    @id = id
    @me = @args.state.animations[id]
  end

  # create
  def self.setup args, id, source=[nil, nil], destination=[nil, nil]
    args.state.animations[id] = { 
      state: INIT, 
      ball_id: nil,
      source: source, 
      position: source.dup,
      destination: destination
    }
  end
  
  def current
    @me[:state]
    @args.state.animation
  end

  # update
  def reset!
    @me = {
      state: INIT,
      ball_id: nil,
      source: [nil, nil],
      position: [nil, nil],
      destination: [nil, nil]
    }
  end

  def error!
    @me[:state] = ERROR
  end

  def tick
    @me[:state] = case @me[:state]
      when INIT
        ready ? COMPUTE : INIT
      when COMPUTE
        compute
        UP
      when UP
        up ? ACCROSS : UP
      when ACCROSS
        accross ? DOWN : ACCROSS
      when DOWN
        if down
          Animations.reset!
          INIT
        else
          DOWN
        end
      when ERROR
        ERROR
      else
        ERROR
      end

    display_animation
  end

  def ball
    return false unless @me[:ball_id]
    @args.state.balls[@me[:ball_id]]
  end

  def display_animation
    return false if @args.state.position.compact.empty?
    i = @me[:position][0]
    j = @me[:position][1]
    x = i * Game::W * 2 + Game::X
    y = j * Game::W + Game::Y
    rect = [x, y, Game::W, Game::W]
    # c = @args.state.tubes[i][:colors][1]
    @args.outputs.solids << rect + Colors.values(1)
  end

  def display
    @args.outputs.labels << [ 10, 150, "Current Animation: " + @me.to_s ]
    @args.outputs.labels << [ 10, 210, "Tick Count: " + (@args.state.tick_count % 60).to_s ]
  end

  def ready
    raise "ready"
    @me[:source][0] && @me[:destination][0]
  end

  # update
  def compute
    # Of all the slots in the source tube ...
    (Game::BALLS_PER_TUBE - 1).downto(0).each do |j|
      # which is the top non-empty slot?
      if is_colored(@me[:source][0], j)
        @me[:source][1] = j
        @me[:position] = @me[:source].dup
        break
      end
    end

    # Of all the slots in the destination tube
    (0..Game::BALLS_PER_TUBE - 1).each do |j|
      # which is the lowest empty slot?
      if !is_colored(@me[:destination][0], j)
        @me[:destination][1] = j
        break
      end
    end
  end

  def is_colored i, j
    ball_id = @args.state.tubes[i][:slots][j][4]
    @args.state.balls[ball_id][:color_id] != 0
  end

  # update
  def up
    @me[:position][1] += 1
    return @me[:position][1] == Game::BALLS_PER_TUBE + 2
  end

  # update
  def accross
    direction = @me[:destination][0] > @me[:source][0] ? 1 : -1
    @me[:position][0] += direction
    return @me[:position][0] == @me[:destination][0]
  end

  # update
  def down
    @me[:position][1] -= 1
    @args.state.current = State::SOURCE if
      @me[:position][1] == @me[:destination][1]
      
    return @me[:position][1] == @me[:destination][1]
  end

  # read
  def to_h
    {}
  end
end