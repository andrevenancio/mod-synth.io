class MenuButton extends PIXI.Container

    constructor: (texture, hint='') ->
        super()

        App.HELP.add @onHelp

        @selected = false

        @graphics = new PIXI.Graphics()
        @graphics.beginFill 0x00ffff, 0
        @graphics.drawRect 0, 0, AppData.MENU_PANNEL, AppData.MENU_PANNEL

        @graphics.beginFill 0, 0
        @graphics.lineStyle 1*AppData.RATIO, 0x111111
        @graphics.moveTo 0, AppData.MENU_PANNEL
        @graphics.lineTo AppData.MENU_PANNEL, AppData.MENU_PANNEL
        @graphics.endFill()
        @addChild @graphics

        @duration = 0.3
        @ease = Quad.easeInOut
        @enabled = false
        @overAlpha = 1.0
        @outAlpha = 0.65

        @img = new PIXI.Sprite texture
        @img.anchor.x = 0.5
        @img.anchor.y = 0.5
        @img.x = AppData.MENU_PANNEL/2
        @img.y = AppData.MENU_PANNEL/2
        @addChild @img

        @count = new PIXI.Text '0', AppData.TEXTFORMAT.MENU_DESCRIPTION
        @count.tint = 0x646464
        @count.scale.x = @count.scale.y = 0.5
        @count.anchor.x = 1
        @count.anchor.y = 0
        @count.position.x = AppData.MENU_PANNEL - 10 * AppData.RATIO
        @count.position.y = 10 * AppData.RATIO
        @count.visible = false
        @addChild @count

        @hint = new PIXI.Text hint.toUpperCase(), AppData.TEXTFORMAT.HINT
        @hint.anchor.x = 0.5
        @hint.anchor.y = 1
        @hint.scale.x = @hint.scale.y = 0.5
        @hint.position.x = AppData.MENU_PANNEL/2
        @hint.position.y = AppData.MENU_PANNEL - 10 * AppData.RATIO
        @hint.hitArea = new PIXI.Rectangle(0, 0, 0, 0);
        @hint.visible = AppData.SHOW_LABELS
        @addChild @hint

        @alpha = @outAlpha

        @hitArea = new PIXI.Rectangle(0, 0, AppData.MENU_PANNEL, AppData.MENU_PANNEL);
        @enable()

    onHelp: (value) =>
        @hint.visible = value
        null

    onDown: =>
        return if @selected is true
        @buttonClick()
        null

    onUp: =>
        return if not @enabled or @selected is true
        @onOut()
        null

    onOver: =>
        return if not @enabled or @selected is true
        TweenMax.to @, 0, { alpha: @overAlpha, ease: @ease }
        null

    onOut: =>
        return if not @enabled or @selected is true
        TweenMax.to @, @duration, { alpha: @outAlpha, ease: @ease }
        null

    select: (value) ->
        @selected = value
        TweenMax.to @, 0, { alpha: (if @selected is false then @outAlpha else @overAlpha), ease: @ease }
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
