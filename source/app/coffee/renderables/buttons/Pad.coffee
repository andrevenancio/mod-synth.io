class Pad extends PIXI.Container

    constructor: (@index, @size) ->
        super()

        @__alpha = @last = 0.2

        @title = new PIXI.Text @index+1, AppData.TEXTFORMAT.SETTINGS_PAD
        @title.scale.x = @title.scale.y = 0.5
        @title.anchor.x = 0.5
        @title.anchor.y = 0
        @title.x = @size/2
        @title.y = 32 * AppData.RATIO
        @title.tint = 0xffffff
        @title.alpha = @__alpha
        @addChild @title

        @icon = new PIXI.Graphics()
        @addChild @icon

        @_selected = 1
        @_tick = 0.5
        @_unselected = 0.2

        @active = false
        @interactive = @buttonMode = true
        @draw()
        if Modernizr.touch
            @on 'touchstart', @onDown
        else
            @on 'mousedown', @onDown

    draw: ->
        @icon.clear()
        @icon.beginFill 0x00ffff, 0
        @icon.drawRect 0, 0, @size, AppData.ICON_SIZE_1
        @icon.endFill()

        @icon.drawRect 0, 0, @size, AppData.ICON_SIZE_1
        @icon.beginFill 0xffffff, @__alpha
        @icon.drawRect 4 * AppData.RATIO, 0, @size - 8 * AppData.RATIO, 4
        @icon.endFill()
        null

    onDown: =>
        @buttonClick @index
        null

    select: ->
        @__alpha = @_selected
        @draw()
        null

    unselect: ->
        @__alpha = @_unselected
        @draw()
        null

    tick: ->
        @__alpha = @_tick
        @draw()
        null

    untick: ->
        @__alpha = if @active is true then @_selected else @_unselected
        @draw()
        null

    buttonClick: (id) ->
        null

    setActive: (value) ->
        @active = value
        if @active
            @select()
        else
            @unselect()
        null
