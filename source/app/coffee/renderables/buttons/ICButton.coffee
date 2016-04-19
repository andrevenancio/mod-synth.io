class ICButton extends PIXI.Container

    constructor: (texture, hint='') ->
        super texture

        App.HELP.add @onHelp

        @hitArea = new PIXI.Rectangle 0, 0, AppData.ICON_SIZE_1, AppData.ICON_SIZE_1

        @duration = 0.3
        @ease = Quad.easeInOut
        @enabled = false
        @selected = false
        @overAlpha = 1.0
        @outAlpha = 0.65
        @alpha = @outAlpha

        @img = new PIXI.Sprite texture
        @img.anchor.x = 0.5
        @img.anchor.y = 0.5
        @img.x = AppData.ICON_SIZE_1/2
        @img.y = AppData.ICON_SIZE_1/2
        @addChild @img

        @hint = new PIXI.Text hint.toUpperCase(), AppData.TEXTFORMAT.HINT
        @hint.anchor.x = 0.5
        @hint.anchor.y = 0
        @hint.scale.x = @hint.scale.y = 0.5
        @hint.position.x = AppData.ICON_SIZE_1/2
        @hint.position.y = AppData.ICON_SIZE_1
        @hint.hitArea = new PIXI.Rectangle(0, 0, 0, 0);
        @hint.visible = AppData.SHOW_LABELS
        @addChild @hint

        @enable()

    onHelp: (value) =>
        @hint.visible = value
        null

    select: (value) ->
        @selected = value
        TweenMax.to @, 0, { alpha: (if @selected is false then @outAlpha else @overAlpha), ease: @ease }
        null

    onDown: =>
        @buttonClick()
        null

    onUp: =>
        @onOut()
        null

    onOver: =>
        return if not @enabled
        return if @selected
        TweenMax.to @, 0, { alpha: @overAlpha, ease: @ease }
        null

    onOut: =>
        return if not @enabled
        return if @selected
        TweenMax.to @, @duration, { alpha: @outAlpha, ease: @ease }
        null

    buttonClick: ->
        # to be override
        null

    hide: (duration, delay) ->
        TweenMax.to @, duration, { alpha: 0, delay: delay, onComplete: =>
            @visible = false
        }
        @onOut()
        null

    show: (duration, delay) ->
        @visible = true
        @alpha = 0
        TweenMax.to @, duration, { alpha: 1, delay: delay, onComplete: =>
            @onOut()
            null
        }
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
