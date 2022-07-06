require 'Color-Stack/app/ball.rb'
require 'Color-Stack/app/balls.rb'
require 'Color-Stack/app/colors.rb'
require 'Color-Stack/app/game.rb'
require 'Color-Stack/app/state.rb'
require 'Color-Stack/app/tube.rb'
require 'Color-Stack/app/tubes.rb'

# Todo:
# - Undo
# - Win detection
# - Extra slot
# - Make more classes
# - Animation

# Colors and Game contain constant data.
# Tubes and Balls contain data that doesn't change after setup
# The only thing that changes is where each ball is <= State
# Separate what changes from what doesn't

def tick args
  Game.setup args unless args.state.once

  # Tubes.inspect 10, 220, args
  # args.outputs.labels << [ 12, 150, Balls.label(args)]
  # args.outputs.labels << [ 12, 130, Tubes.label(args) ]
  # args.outputs.labels << [ 12, 110, Colors.label(4) ]
  args.outputs.labels << [ 10, 120, "Show: #{args.state.show}" ]

  tubes = Tubes.new args
  state = State.new args
  state.display

  # Game reset button
  args.outputs.solids << [1180, 0, 100, 50, 128, 200, 200, 255]
  args.outputs.labels << [1210, 35, "Reset"]

  if args.inputs.mouse.click && args.inputs.mouse.inside_rect?([1180, 0, 100, 50])
    Game.setup args
    state.reset!
  end

  if tubes.clicked?
    case state.current
    when State::SOURCE
      state.next if tubes.source
    when State::DESTINATION
      if tubes.destination
        state.next
        args.state.animate = "setup"
      else 
        state.error!
      end
    when State::ANIMATE
      state.next if tubes.animate
    when State::ERROR
      state.reset!
    else
      state.reset!
    end
  end

  tubes.display
end
