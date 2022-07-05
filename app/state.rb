class State
  SOURCE = "source"
  DESTINATION = "destination"
  ANIMATE = "animate"
  ERROR = "error"

  def initialize args
    @args = args
    @args.state.current ||= SOURCE
  end

  def current
    @args.state.current
  end

  def reset!
    @args.state.current = SOURCE
  end

  def error!
    @args.state.current = ERROR
  end

  def next
    @args.state.current =
      case @args.state.current
      when SOURCE
        DESTINATION
      when DESTINATION
        ANIMATE
      when ANIMATE
        SOURCE
      else
        ERROR
      end
  end

  def display
    @args.outputs.labels << [ 10, 30, "Current State: " + @args.state.current.to_s ]
  end
end
