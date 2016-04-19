class Slider extends PIXI.Container

    constructor: ->
        super()

        # components override this variables. they are needed for the PICKER object
        @steps = 0
        @snap = 0
        @elements = []

        @lastValue = 0
        @percentage = 0

        @dwnPosition = new Vec2()
        @curPosition = new Vec2()
        @isDragging = false

        @graphics = new PIXI.Graphics()
        @graphics.beginFill 0xffffff, 0
        @graphics.drawRect 0, 0, AppData.ICON_SIZE_1, AppData.ICON_SIZE_1
        @addChild @graphics

        @interactive = @buttonMode = true
        if Modernizr.touch
            @on 'touchstart', @onDown
            @on 'touchmove', @onMove
            @on 'touchend', @onEnd
            @on 'touchendoutside', @onEnd
        else
            @on 'mousedown', @onDown
            @on 'mousemove', @onMove
            @on 'mouseup', @onEnd
            @on 'mouseupoutside', @onEnd

    onDown: (e) =>
        @lastValue = @percentage
        @isDragging = true

        @dwnPosition.set e.data.global.x, e.data.global.y
        @defaultCursor = "-webkit-grabbing"
        @identifier = e.data.identifier

        App.PICKER_SHOW.dispatch { x: @x + AppData.ICON_SIZE_1/2, y: @y + AppData.ICON_SIZE_1/2, steps: @steps, snap: @snap, elements: @elements }
        App.PICKER_VALUE.dispatch { percentage: @percentage }
        null

    onMove: (e) =>
        return if e.data.identifier isnt @identifier
        if @isDragging
            @curPosition = new Vec2(e.data.global.x, e.data.global.y)
            @curPosition.subtract @dwnPosition
            @curPosition.scale 0.5

            @percentage = Math.round(@lastValue + @curPosition.x)
            @constrain()
            App.PICKER_VALUE.dispatch { percentage: @percentage }
            @onUpdate()
        null

    onEnd: (e) =>
        return if e.data.identifier isnt @identifier

        @isDragging = false

        @defaultCursor = "-webkit-grab"
        @identifier = null
        App.PICKER_HIDE.dispatch()
        null

    constrain: ->
        if @percentage < 0
            @percentage = 0
        if @percentage > 100
            @percentage = 100
        return @percentage

    onUpdate: ->
        # to be overriden
