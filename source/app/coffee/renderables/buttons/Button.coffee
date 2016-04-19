class Button extends PIXI.Container

    constructor: (texture) ->
        super()

        App.HELP.add @onHelp

        @texture = new PIXI.Sprite texture
        @addChild @texture

        @duration = 0.1
        @ease = Quad.easeInOut

        @overAlpha = 0.22
        @outAlpha = 0.2
        @downAlpha = 1.0

        @selected = false

        @texture.alpha = @outAlpha
        @code = 0

    onHelp: (value) =>
        # to be overriden

    onDown: =>
        @buttonClick()
        @select()
        null

    onUp: =>
        @selected = false
        @onOut()
        null

    onOver: =>
        return if @selected
        TweenMax.to @texture, 0, { alpha: @overAlpha, ease: @ease }
        null

    onOut: =>
        return if @selected
        @unselect()
        null

    onOutside: =>
        return if @selected
        @unselect()
        null

    select: ->
        @selected = true
        TweenMax.to @texture, 0, { alpha: @downAlpha, ease: @ease }
        null

    unselect: ->
        @selected = false
        TweenMax.to @texture, @duration, { alpha: @outAlpha, ease: @ease }
        null

    buttonClick: ->
        null

    enable: ->
        @interactive = @buttonMode = true
        if Modernizr.touch
            @on 'touchstart', @onDown
            @on 'touchend', @onUp
            @on 'touchendoutside', @onUp
        else
            @on 'mousedown', @onDown
            @on 'mouseup', @onUp
            @on 'mouseover', @onOver
            @on 'mouseout', @onOut
            @on 'mouseupoutside', @onOutside
        null

    disable: ->
        @interactive = @buttonMode = false
        if Modernizr.touch
            @off 'touchstart', @onDown
            @off 'touchend', @onUp
            @off 'touchendoutside', @onOut
        else
            @off 'mousedown', @onDown
            @off 'mouseup', @onUp
            @off 'mouseover', @onOver
            @off 'mouseout', @onOut
            @off 'mouseupoutside', @onOutside
        null
