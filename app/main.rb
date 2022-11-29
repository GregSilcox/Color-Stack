require 'Color-Stack/app/animation.rb'
require 'Color-Stack/app/animations.rb'
require 'Color-Stack/app/ball.rb'
require 'Color-Stack/app/balls.rb'
require 'Color-Stack/app/colors.rb'
require 'Color-Stack/app/game.rb'
require 'Color-Stack/app/scene.rb'
require 'Color-Stack/app/scenes.rb'
require 'Color-Stack/app/state.rb'
require 'Color-Stack/app/tube.rb'
require 'Color-Stack/app/tubes.rb'

require 'Color-Stack/app/animation_scene.rb'
require 'Color-Stack/app/game_scene.rb'
require 'Color-Stack/app/test_scene.rb'

# Todo:
# - Undo
# - Win detection
# - Extra slot
# - Make more classes
# - Animation
# - multiple animations
# - What if I click on a tube before the animation for a ball completes that is on its way?

def tick args
  game = Game.setup args
  game.reset_button args
  scene = Scenes.current args
  scene.tick
  scene.display
end
