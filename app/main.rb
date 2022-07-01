require 'mygame/app/tubes.rb'
require 'mygame/app/state.rb'

def setup args
  # Constants used in formulas
  args.state.w = 25
  args.state.x = 300
  args.state.y = 200
  args.state.tubes_per_tray = 12
  args.state.balls_per_tube = 4

  args.state.balls = []
  args.state.tubes = Array.new(args.state.tubes_per_tray, {})
  tubes = []

  # Create `balls_per_tube` of each color, but leave last 2 tubes empty.
  (0..args.state.tubes_per_tray - 3).each do |i|
    tubes += Array.new(args.state.balls_per_tube, i + 1)
  end

  unshuffled = tubes.flatten

  # Shuffle the order of the balls
  while unshuffled.any? 
    i = rand(unshuffled.length) - 1
    e = unshuffled.delete_at i
    args.state.balls.push e
  end

  # Inital randomized order of colors, plus two empty tubes
  args.state.balls += Array.new(args.state.balls_per_tube * 2, 0)

  # Values for the game colors
  args.state.colors = [
    { r:   0, g:   0, b:   0, a:   0 }, # 0: no color
    { r: 184, g:   3, b:  19, a: 255 }, # 11: red rhododendron
    { r:  28, g: 169, b: 201, a: 255 }, # 0: pacific blue
    { r:  28, g: 172, b: 120, a: 255 }, # 1: green
    { r: 159, g: 226, b: 191, a: 255 }, # 2: sea green
    { r: 255, g: 163, b:  67, a: 255 }, # 3: carrot
    { r: 252, g: 180, b: 213, a: 255 }, # 4: blue
    { r: 142, g:  69, b: 133, a: 255 }, # 5: plum
    { r: 255, g: 255, b: 159, a: 255 }, # 6: canary
    { r:  43, g: 108, b: 196, a: 255 }, # 7: denim
    { r:  26, g:  72, b: 118, a: 255 }, # 8: midnight blue
    { r: 159, g: 129, b: 112, a: 255 }, # 9: beaver
    { r: 242, g:  40, b:  71, a: 255 } # 10: scarlet
  ]

  args.state.once = true
end

def tick args
  setup args unless args.state.once

  tubes = Tubes.new args
  tubes.fill unless args.state.once

  state = State.new args
  state.display

  # Game reset button
  args.outputs.solids << [1180, 0, 100, 50, 128, 200, 200, 255]
  args.outputs.labels << [1210, 35, "Reset"]

  if args.inputs.mouse.click && args.inputs.mouse.inside_rect?([1180, 0, 100, 50])
    setup args
    state.reset!
    tubes.fill
  end

  if tubes.clicked?
    case state.current
    when State::SOURCE
      tubes.source
      state.next
    when State::DESTINATION
      tubes.destination
      state.next
    else
      state.reset!
    end
  end

  # Game state machine
  if args.state.current == :xinitial
    if args.inputs.mouse.click
      (0..args.state.tubes_per_tray - 1).each do |i|
        if args.inputs.mouse.inside_rect?(args.state.tubes[i][:rect])
          (args.state.balls_per_tube - 1).downto(0).each do |j|
            if args.state.tubes[i][:colors][j] > 0
              args.state.current = :source
              args.state.source = [i, j]
              tubes.animate
              break
            end
          end
        end
      end
    end
  elsif args.state.current == :xsource
    if args.inputs.mouse.click
      (0..args.state.tubes_per_tray - 1).each do |i|
        if args.inputs.mouse.inside_rect?(args.state.tubes[i][:rect]) && args.state.tubes[i][:colors][3] == 0
          (0..args.state.balls_per_tube - 1).each do |j|
            if args.state.tubes[i][:colors][j] == 0
              if j == 0 || args.state.tubes[i][:colors][j - 1] == args.state.tubes[args.state.source[0]][:colors][args.state.source[1]]
                args.state.current = :destination
                args.state.destination = [i, j]
                break
              end
            end 
          end
        end
      end
    end
  elsif args.state.current == :xdestination
    args.state.current = :initial
    si = args.state.source[0]
    sj = args.state.source[1]
    di = args.state.destination[0]
    dj = args.state.destination[1]
    color = args.state.tubes[si][:colors][sj]
    args.state.tubes[di][:colors][dj] = color
    args.state.tubes[si][:colors][sj] = 0
    args.state.source = [0, 0]
    args.state.destination = [0, 0]
  end

  # Check for a win
  # Undo/Redo
  # Deselect source
  # Restart current game
  # Animation

  tubes.display
end
