class Colors
  DATA = [
    { r:   0, g:   0, b:   0, a:  16 }, # 0: no color
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

  def self.values id
    DATA[id].values
  end

  def self.label id
    "Color #{ id } values: #{ self.values id }"
  end
end
