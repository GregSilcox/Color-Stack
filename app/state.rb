class State
  SOURCE = "source"
  DESTINATION = "destination"
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
    @args.state.current = @args.state.current == SOURCE ? DESTINATION : SOURCE
  end

  def display
    @args.outputs.labels << [ 10, 30, "Current State: " + @args.state.current.to_s ]
  end
end
