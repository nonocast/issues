class Shape
  x: -> return @el.tbox().x
  y: -> return @el.tbox().y

class Label extends Shape
  constructor: (@parent, x = 0, y = 0)->
    @el = new SVG.G().draggy().move(x, y)
    @main = @el.rect(220, 40).radius(5).addClass('svg-label')
    fobj = @el.foreignObject(220, 40).appendChild("div", { id: "svg-label-title", contentEditable: true, innerText: "Class" })
    @top = new Joint(this, 110, 0, 110, -100)
    @bottom = new Joint(this, 110, 40, 110, 140)
    @left = new Joint(this, 0, 20, -100, 20)
    @right = new Joint(this, 220, 20, 320, 20)

    fobj.on 'mousedown', (e) -> e.preventDefault()
    fobj.on 'mouseup', (e) ->
      # edit when up in div
      p = $(fobj.node).children(0).get(0)
      p.focus()
      range = document.createRange()
      range.selectNodeContents(p)
      sel = window.getSelection()
      sel.removeAllRanges()
      sel.addRange(range)

class Joint extends Shape
  constructor: (@parent, x = 0, y = 0, cpX = 0, cpY = 0) ->
    @root = @parent.parent
    @r = 5

    @cpLocation = { x: cpX, y: cpY }

    # @cpline = @parent.el.line(x, y, @cpLocation.x, @cpLocation.y).stroke('#777')
    @cp = @parent.el.circle(@r*2).stroke('transparent').fill('transparent').move(@cpLocation.x-@r, @cpLocation.y-@r)
    @el = @parent.el.circle(@r*2).addClass('svg-joint').move(x-@r, y-@r).draggy hold:true

    if @cp?
      @cp.on "dragmove", (e) =>
        p = { x: @cp.bbox().x + @r, y: @cp.bbox().y + @r }
        @cpline.plot(x, y, p.x, p.y) if @cpline?
        each.update() for each in @root.connections

    tmpline = null
    @el.on "dragstart", (e) =>
      tmpline = @root.draw.path().addClass('svg-drag-connection')
      
    @el.on "dragmove", (e) =>
      tmpline.plot @curveTo { x: @x()+e.detail.delta.x, y: @y()+e.detail.delta.y }

      pos = { x: e.detail.event.pageX, y: e.detail.event.pageY }
      pos = @root.windowToCanvas pos.x, pos.y
      pos = new SVG.Point pos.x, pos.y

      for each in @root.labels
        q = pos.transform each.el.matrixify().inverse()
        for joint in [each.left, each.right, each.top, each.bottom]
          t = q.transform joint.el.matrixify().inverse()
          if joint.el.inside t.x, t.y
            joint.el.scale 2, 2
          else
            joint.el.scale 1, 1


    @el.on "dragend", (e) =>
      tmpline.remove()

      pos = { x: e.detail.event.pageX, y: e.detail.event.pageY }
      pos = @root.windowToCanvas pos.x, pos.y
      pos = new SVG.Point pos.x, pos.y

      result = null
      for each in @root.labels
        q = pos.transform each.el.matrixify().inverse()
        for joint in [each.left, each.right, each.top, each.bottom]
          t = q.transform joint.el.matrixify().inverse()
          joint.el.scale 1, 1
          if joint.el.inside t.x, t.y
            result = joint

      if result && result != this
        @root.addConnection new Connection(this, result)


  curveTo: (p) =>
    cp = { x: @cp.tbox().x + @r, y: @cp.tbox().y + @r }
    return "M #{@x()},#{@y()} C #{cp.x},#{cp.y} #{p.x},#{p.y}  #{p.x},#{p.y}"


  x: -> return @el.tbox().x + @r
  y: -> return @el.tbox().y + @r

class Connection extends Shape
  constructor: (@joint1, @joint2) ->
    @el = new SVG.Path().addClass("svg-connection").plot @curve()
    @joint1.parent.el.on 'dragmove', @update
    @joint2.parent.el.on 'dragmove', @update

  update: => @el.plot @curve()

  line: => "M #{@joint1.x()},#{@joint1.y()} L #{@joint2.x()},#{@joint2.y()}"
  # curve: => "M #{@joint1.x()},#{@joint1.y()} C #{@joint1.x()+100},#{@joint1.y()} #{@joint2.x()-100},#{@joint2.y()}  #{@joint2.x()},#{@joint2.y()}"
  curve: =>
    cp1 = { x: @joint1.cp.tbox().x + @joint1.r, y: @joint1.cp.tbox().y + @joint1.r }
    cp2 = { x: @joint2.cp.tbox().x + @joint2.r, y: @joint2.cp.tbox().y + @joint2.r }
    p = "M #{@joint1.x()},#{@joint1.y()} C #{cp1.x},#{cp1.y} #{cp2.x},#{cp2.y}  #{@joint2.x()},#{@joint2.y()}"
    return p

class Editor
  constructor: (name) ->
    @labels = []
    @connections = []

    @draw = SVG(name).size('100%', '100%')
    @sample()
    @init()

  init: ->

  addLabel: (label) ->
    @labels.push label
    @draw.add label.el

  addConnection: (connection) ->
    @connections.push connection
    # insert before label
    @draw.add connection.el, 1

  sample: ->
    label1 = new Label(this, 100, 300)
    label2 = new Label(this, 550, 140)
    label3 = new Label(this, 700, 400)

    @addLabel new Label(this, 10, 10)

    @addLabel label1
    @addLabel label2
    @addLabel label3

    @addConnection new Connection(label1.right, label3.left)
    @addConnection new Connection(label1.right, label2.left)

  windowToCanvas: (x, y) =>
    bounding = @draw.node.getBoundingClientRect()
    result = {
      x: Math.round((x - bounding.left) * (@draw.viewbox().width / bounding.width))
      y: Math.round((y - bounding.top) * (@draw.viewbox().height / bounding.height))
    }
    return result

$.app = {} or $.app
$.app.Editor = Editor
