# import math.Vec2
class DraggableElement

    constructor: (@element) ->

        # settings
        @VELOCITY_DAMPING = 0.9
        @TWEEN_EASE = 0.07
        @PRECISION = 0.1

        # vectors
        @position = new Vec2()
        @velocity = new Vec2()

        @draggingOld = new Vec2()
        @draggingCur = new Vec2()
        @tweenTarget = new Vec2()

        # more settings
        @lock = false
        @dragging = false
        @moving = false
        @onTween = false
        @speed = 0
        @currentTouches = 0

        if Modernizr.touch
            @element
                .on 'touchstart', @onTouchStart
                .on 'touchmove', @onTouchMove
                .on 'touchend', @onTouchEnd
                .on 'touchendoutside', @onTouchEnd
        else
            @element
                .on 'mousedown', @onMouseDown
                .on 'mousemove', @onMouseMove
                .on 'mouseup', @onMouseUp
                .on 'mouseupoutside', @onMouseUp
        # window.addEventListener 'mousewheel', @onMouseWheel, false

    onMouseDown: (e) =>
        e.data.originalEvent.preventDefault()
        @startDrag e.data.originalEvent.clientX, e.data.originalEvent.clientY
        null

    onMouseMove: (e) =>
        e.data.originalEvent.preventDefault()
        @moving = true
        @updateDrag e.data.originalEvent.clientX, e.data.originalEvent.clientY
        null

    onMouseUp: =>
        @endDrag()
        null

    onTouchStart: (e) =>
        @currentTouches++
        return if @currentTouches > 1
        @identifier = e.data.identifier

        e.data.originalEvent.preventDefault()
        @startDrag e.data.global.x, e.data.global.y
        null

    onTouchMove: (e) =>
        return if @identifier isnt e.data.identifier

        e.data.originalEvent.preventDefault()
        @updateDrag e.data.global.x, e.data.global.y
        null

    onTouchEnd: (e) =>
        @currentTouches--
        return if @identifier isnt e.data.identifier

        @endDrag()
        @identifier = null
        null

    onMouseWheel: (event) =>
        return if @lock is true
        return if AppData.SHOW_MENU_PANNEL is true

        @tweenPositionTo = null
        @velocity.set event.wheelDeltaX * 0.2, event.wheelDeltaY * 0.2
        null

    startDrag: (posX, posY) ->
        return if @dragging
        return if @lock
        @dragging = true
        @draggingCur.set posX, posY
        @draggingOld.copy @draggingCur
        null

    updateDrag: (posX, posY) ->
        return if not @dragging
        return if @lock
        @draggingCur.set posX, posY
        x = @draggingCur.x-@draggingOld.x
        y = @draggingCur.y-@draggingOld.y
        @velocity.set x, y
        @draggingOld.copy @draggingCur
        null

    endDrag: ->
        return if not @dragging
        @dragging = false
        null

    update: ->

        # if there is a tween, interpolate value
        if @onTween
            @position.interpolateTo @tweenTarget, @TWEEN_EASE
            if Math.abs( Vec2.subtract( @position, @tweenTarget ).length() ) < @PRECISION
                @onTween = false

        return if @lock

        if @moving is true
            @moving = false
        if not @moving
            @velocity.scale @VELOCITY_DAMPING
        @speed = @velocity.length()

        # round to precision
        if Math.abs(@speed) < @PRECISION
            @velocity.x = 0
            @velocity.y = 0

        @position.x += @velocity.x * AppData.RATIO
        @position.y += @velocity.y * AppData.RATIO
        null

    resize: (viewportWidth, viewportHeight, globalWidth, globalHeight) ->
        @vpw = viewportWidth
        @vph = viewportHeight
        @gw = globalWidth
        @gh = globalHeight
        null

    constrainToBounds: ->
        if @position.x < -(@gw - @vpw)
            @position.x = -(@gw - @vpw)
        if @position.x > 0
            @position.x = 0
        if @position.y < -(@gh - @vph)
            @position.y = -(@gh - @vph)
        if @position.y > 0
            @position.y = 0
        null

    # sets the dragger to a specific x/y position
    setPosition: (x, y) ->
        temp = new Vec2 x, y
        temp.invert()

        @onTween = true
        @tweenTarget.copy temp
        null
