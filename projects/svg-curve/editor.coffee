root = exports ? this

class Shape
  constructor: ->
    @el = null

class EditableCurve extends Shape
  constructor: (@start, @end) ->
    super()
    @el = new SVG.Line().plot(@start.x, @start.y, @end.x, @end.y).stroke('red')

class root.Editor
  constructor: (@svg) ->
    @svg.add new EditableCurve({x:100, y:100}, {x:400, y:200}).el

