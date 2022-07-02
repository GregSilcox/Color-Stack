require 'mygame/app/ball.rb'
require 'mygame/app/balls.rb'
require 'mygame/app/setup.rb'
require 'mygame/app/state.rb'
require 'mygame/app/tube.rb'
require 'mygame/app/tubes.rb'

# Todo:
# - Undo
# - Win detection
# - Extra slot
# - Make more classes
# - Animation

def tick args
  setup args unless args.state.once

  tubes = Tubes.new args
  state = State.new args
  state.display

  # Game reset button
  args.outputs.solids << [1180, 0, 100, 50, 128, 200, 200, 255]
  args.outputs.labels << [1210, 35, "Reset"]

  if args.inputs.mouse.click && args.inputs.mouse.inside_rect?([1180, 0, 100, 50])
    setup args
    state.reset!
  end

  if tubes.clicked?
    case state.current
    when State::SOURCE
      state.next if tubes.source
    when State::DESTINATION
      tubes.destination ? state.next : state.error!
    when State::ERROR
      state.reset!
    else
      state.reset!
    end
  end

  tubes.display
end
