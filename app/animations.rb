class Animations
  def initialize args
    @args = args
    @args.state.animations ||= []
  end

  def self.create args
    id = args.state.animations.size
    args.state.animations << Animation.setup(args, id)
  end

  def self.reset! args
    args.state.animations = []
  end

  def tick
    @args.state.animations.each { |animation| animation.tick }
  end
end