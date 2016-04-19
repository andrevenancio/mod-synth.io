class SubmenuButtonMidi extends PIXI.Container

    constructor: (label, opt_texture) ->
        super()

        @graphics = new PIXI.Graphics()
        @graphics.beginFill 0x00ffff, 0
        @graphics.drawRect 0, 0, AppData.SUBMENU_PANNEL, AppData.ICON_SIZE_1
        @addChild @graphics

        @duration = 0.3
        @ease = Quad.easeInOut
        @enabled = false
        @overAlpha = 1.0
        @outAlpha = 0.65

        @img = new PIXI.Sprite opt_texture
        @img.anchor.x = 0.5
        @img.anchor.y = 0.5
        @img.x = AppData.PADDING + AppData.ICON_SIZE_2/2
        @img.y = AppData.ICON_SIZE_1 / 2
        if opt_texture
            @addChild @img
            @graphics.beginFill 0x00ffff, 0
            @graphics.drawRect AppData.PADDING, 0, AppData.ICON_SIZE_2, AppData.ICON_SIZE_1

        @label = new PIXI.Text label.toUpperCase(), AppData.TEXTFORMAT.MENU
        @label.anchor.y = 0.5
        @label.scale.x = @label.scale.y = 0.5
        @label.position.x = if opt_texture then AppData.ICON_SIZE_2 + 40 * AppData.RATIO else AppData.PADDING
        @label.position.y = AppData.ICON_SIZE_1 / 2
        @label.alpha = @outAlpha
        @addChild @label

        @hitArea = new PIXI.Rectangle(0, 0, AppData.SUBMENU_PANNEL, AppData.ICON_SIZE_1);

        @enable()

    onDown: =>
        @buttonClick()
        null

    onUp: =>
        @onOut()
        null

    onOver: =>
        return if not @enabled
        TweenMax.to @label, 0, { alpha: @overAlpha, ease: @ease }
        null

    onOut: =>
        return if not @enabled
        TweenMax.to @label, @duration, { alpha: @outAlpha, ease: @ease }
        null

    buttonClick: ->
        # to be override
        null

    enable: ->
        @interactive = @buttonMode = @enabled = true
        if Modernizr.touch
            @on 'touchstart', @onDown
            @on 'touchend', @onUp
            @on 'touchendoutside', @onOut
        else
            @on 'mousedown', @onDown
            @on 'mouseup', @onUp
            @on 'mouseout', @onOut
            @on 'mouseover', @onOver
            @on 'mouseupoutside', @onOut
        null

    disable: ->
        @interactive = @buttonMode = @enabled = false
        if Modernizr.touch
            @off 'touchstart', @onDown
            @off 'touchend', @onUp
            @off 'touchendoutside', @onOut
        else
            @off 'mousedown', @onDown
            @off 'mouseup', @onUp
            @off 'mouseout', @onOut
            @off 'mouseover', @onOver
            @off 'mouseupoutside', @onOut
        null
