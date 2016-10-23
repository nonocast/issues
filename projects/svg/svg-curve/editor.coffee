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

    @svg.size('100%', '100%').viewbox(0, 0, 1000, 1000/1.7)
    pattern = @svg.pattern 30, 30, (add) ->
      add.rect(30,30).fill('white')
      add.circle(3).fill('#ccc').center(15,15)
    @canvas = @svg.rect(1000,1000/1.7).move(0, 0).fill(pattern).stroke('none').draggy hold:true

    @polyline = @svg.polyline().fill('none').stroke width: 1

    base = null
    @canvas.on 'dragstart', (e) => @points = []
    @canvas.on 'dragmove', (e) =>
      pos = { x: e.detail.event.clientX, y: e.detail.event.clientY }
      pos = @svg.point pos.x, pos.y
      @points.push x: Math.round(pos.x), y: Math.round(pos.y)
      @update()
    @canvas.on 'dragend', =>
      console.log @points.length
      @points = simplify @points, 3
      console.log @points.length
      @polyline.plot ''
      @updateCurve()

  update: =>
    x = []
    for each in @points
      x.push [each.x, each.y]

    @polyline.plot x

  updateCurve: =>
    x = []
    y = []
    for each in @points
      x.push each.x
      y.push each.y

    px = $.computeControlPoints(x)
    py = $.computeControlPoints(y)

    for i in [0...@points.length-1]
      @svg.path("M #{@points[i].x},#{@points[i].y} C #{px.p1[i]},#{py.p1[i]} #{px.p2[i]},#{py.p2[i]} #{@points[i+1].x},#{@points[i+1].y}").fill('none').stroke width:3, color: 'orange'
      # @svg.circle(10).fill('black').center(px.p1[i], py.p1[i])
      # @svg.circle(10).fill('black').center(px.p2[i], py.p2[i])

  add: (shape) ->
    @svg.add shape.el
  ###
  computeControlPoints: (K) ->
    p1=new Array()
    p2=new Array()
    n = K.length-1

    a=new Array()
    b=new Array()
    c=new Array()
    r=new Array()

    a[0]=0
    b[0]=2
    c[0]=1
    r[0] = K[0]+2*K[1]

    # for (i = 1; i < n - 1; i++)
    for i in [1...n-1]
      a[i]=1
      b[i]=4
      c[i]=1
      r[i] = 4 * K[i] + 2 * K[i+1]
        
    a[n-1]=2
    b[n-1]=7
    c[n-1]=0
    r[n-1] = 8*K[n-1]+K[n]

    # for (i = 1; i < n; i++)
    for i in [1...n]
      m = a[i]/b[i-1]
      b[i] = b[i] - m * c[i - 1]
      r[i] = r[i] - m*r[i-1]

    p1[n-1] = r[n-1]/b[n-1]
    # for (i = n - 2; i >= 0; --i)
    for i in [n-2..i] by -1
      p1[i] = (r[i] - c[i] * p1[i+1]) / b[i]

    console.log p1
      
    # for (i=0;i<n-1;i++)
    for i in [0...n-1]
      p2[i]=2*K[i+1]-p1[i+1]

    p2[n-1]=0.5*(K[n]+p1[n-1])

    return {p1:p1, p2:p2}
  ###
