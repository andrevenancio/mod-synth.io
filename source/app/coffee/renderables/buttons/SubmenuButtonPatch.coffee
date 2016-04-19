class SubmenuButtonPatch extends PIXI.Container

    constructor: (label, date, @extraButton = false) ->
        super()

        @data = {
            label: label,
            date: date
        }

        limit = AppData.ICON_SIZE_1 * 2
        iconSize = 8 * AppData.RATIO

        @graphics = new PIXI.Graphics()
        @graphics.beginFill 0x00ffff, 0
        @graphics.drawRect 0, 0, AppData.SUBMENU_PANNEL-limit, AppData.ICON_SIZE_1
        @addChild @graphics

        @duration = 0.3
        @ease = Quad.easeInOut
        @enabled = false
        @overAlpha = 1.0
        @outAlpha = 0.65

        @label = new PIXI.Text label.toUpperCase(), AppData.TEXTFORMAT.MENU
        @label.anchor.y = 1
        @label.scale.x = @label.scale.y = 0.5
        @label.position.x = AppData.PADDING
        @label.position.y = AppData.ICON_SIZE_1 / 2
        @addChild @label

        @date = new PIXI.Text date, AppData.TEXTFORMAT.MENU
        @date.tint = 0x646464
        @date.anchor.y = 0
        @date.scale.x = @date.scale.y = 0.5
        @date.position.x = AppData.PADDING * 2
        @date.position.y = AppData.ICON_SIZE_1 / 2
        @addChild @date

        @img = new PIXI.Sprite AppData.ASSETS.sprite.textures['ic-selection-active.png']
        @img.tint = 0xff0000
        @img.anchor.x = 0
        @img.anchor.y = 0.5
        @img.scale.x = @img.scale.y = 0.5
        @img.x = AppData.PADDING
        @img.y = AppData.ICON_SIZE_1 / 2 + iconSize
        @addChild @img

        if @extraButton

            @remove = new ICButton AppData.ASSETS.sprite.textures['ic-remove-32.png'], ''
            @remove.x = AppData.SUBMENU_PANNEL-limit/2
            @remove.y = 0
            @addChild @remove

        @hitArea = new PIXI.Rectangle(0, 0, AppData.SUBMENU_PANNEL-limit, AppData.ICON_SIZE_1);

        @alpha = @outAlpha
        @enable()
        @setCurrent false

    onDown: =>
        @buttonClick()
        null

    onUp: =>
        @onOut()
        null

    onOver: =>
        return if not @enabled
        TweenMax.to @, 0, { alpha: @overAlpha, ease: @ease }
        null

    onOut: =>
        return if not @enabled
        TweenMax.to @, @duration, { alpha: @outAlpha, ease: @ease }
        null

    buttonClick: ->
        # to be override
        null

    setCurrent: (value) ->
        if value is true
            @img.visible = true
            @date.x = @img.x + @img.width + AppData.PADDING/4
            @date.text = 'Currently editing'
        else
            @img.visible = false
            @date.x = AppData.PADDING
            @date.text = @data.date
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
