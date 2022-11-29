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

  def self.reset! args
    args.state.current = SOURCE
  end

  def self.error! args
    args.state.current = ERROR
  end

  def tick tubes
    @args.state.current =
      case @args.state.current
      when SOURCE
        tubes.source ? DESTINATION : SOURCE
      when DESTINATION 
        if tubes.destination
          Animations.create @args
          SOURCE
        else
          DESTINATION
        end
      else
        ERROR
      end
  end

  def display
    @args.outputs.labels << [ 10, 30, "Current State: " + @args.state.current.to_s ]
  end
end
