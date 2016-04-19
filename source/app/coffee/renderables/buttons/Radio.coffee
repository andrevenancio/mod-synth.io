class Radio extends PIXI.Container

    constructor: (label) ->
        super()

        @img = new PIXI.Sprite AppData.ASSETS.sprite.textures['48-circle-nofill.png']
        @addChild @img

        @title = new PIXI.Text label.toUpperCase(), AppData.TEXTFORMAT.SETTINGS_SMB
        @title.scale.x = @title.scale.y = 0.5
        @title.anchor.x = 0.5
        @title.anchor.y = 0.5
        @title.x = @img.width / 2
        @title.y = @img.height / 2
        @title.tint = 0x5A5A5A
        @addChild @title

        @active = false
        @interactive = @buttonMode = true

        if Modernizr.touch
            @on 'touchstart', @onDown
        else
            @on 'mousedown', @onDown

    onDown: =>
        @buttonClick()
        null

    select: ->
        @img.texture = AppData.ASSETS.sprite.textures['48-circle-fill.png']
        @img.tint = 0xffffff

        TweenMax.to @img, 0, { alpha: 1.0, ease: Quad.easeInOut }
        null

    unselect: ->
        TweenMax.to @img, 0, { alpha: 0.2, ease: Quad.easeInOut }
        @img.texture = AppData.ASSETS.sprite.textures['48-circle-nofill.png']
        @img.tint = 0x5A5A5A
        null

    buttonClick: ->
        null

    setActive: (value) ->
        @active = value
        if @active
            @select()
        else
            @unselect()
        null
