root = exports ? this

class Shape
  constructor: ->
    @el = null

class EditableCurve extends Shape
  constructor: (@start, @end) ->
    super()
    @el = new SVG.Line().plot(@start.x, @start.y, @end.x, @end.y).stroke(color: '#e6e6e6', width: 4)

class Label extends Shape
  constructor: (@location, @text) ->
    super()
    @el = new SVG.G()
    @el.circle(100).fill("#fe7941")

class Line extends Shape
  constructor: (@start, @end) ->
    super()
    @el = new SVG.Line().plot(@start.x, @start.y, @end.x, @end.y).stroke(color: '#fe7941', width: 7)

class root.Editor
  constructor: (@svg) ->
    @svg.size('100%', '100%')
    @canvas = @svg.rect(@svg.viewbox().width, @svg.viewbox().height).move(0, 0).fill('white').stroke('none').draggy hold:true
    # @svg.use("icon-appleinc", "pack.svg").addClass("icon-appleinc").size(100, 100).center(100, 100).fill("#656565").filter (add) -> add.gaussianBlur(5)
    @svg.use("icon-appleinc", "pack.svg").addClass("icon-appleinc").size(100, 100).center(100, 100).fill("#656565")
    @svg.use("icon-github", "pack.svg").addClass("icon-github").size(90, 90).center(230, 100).fill("#000000")
    @svg.use("icon-twitter", "pack.svg").addClass("icon-twitter").size(100, 100).center(360, 100).fill("#309fe6")
    @svg.use("icon-pinterest", "pack.svg").addClass("icon-pinterest").size(100, 100).center(490, 100).fill("#ae1622")
    @svg.use("icon-evil2", "pack.svg").addClass("icon-evil").size(90, 90).center(@svg.viewbox().width-100, @svg.viewbox().height-100).fill("#31d3cf")


    base = null
    @canvas.on 'dragstart', (e) => base = @svg.viewbox()
    @canvas.on 'dragmove', (e) =>
      bound = @svg.node.getBoundingClientRect()
      return unless bound.width > base.width

      delta = e.detail.delta

      x = Math.max 0, base.x - delta.x
      x = Math.min x, bound.width - base.width

      y = Math.max 0, base.y - delta.y
      y = Math.min y, bound.height - base.height

      @svg.viewbox x, y, base.width, base.height

  add: (shape) ->
    @svg.add shape.el

