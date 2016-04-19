class SubmenuButtonAdd extends PIXI.Container

    constructor: (label, texture, color) ->
        super()

        App.HELP.add @onHelp

        @duration = 0.3
        @ease = Quad.easeInOut
        @enabled = false
        @scaleFactor = 0.45

        width = Math.round texture.width*@scaleFactor
        height = Math.round texture.height*@scaleFactor

        @img = new PIXI.Sprite texture
        @img.anchor.x = 0.5
        @img.anchor.y = 1
        @img.scale.x = @img.scale.y = @scaleFactor
        @img.position.x = AppData.SUBMENU_PANNEL/4
        @img.position.y = AppData.SUBMENU_PANNEL/2 - AppData.PADDING
        @img.tint = color
        @addChild @img

        @graphics = new PIXI.Graphics()
        @graphics.beginFill 0x00ffff, 0
        @graphics.drawRect 0, 0, AppData.SUBMENU_PANNEL/2, AppData.SUBMENU_PANNEL/2
        @addChild @graphics

        textFormat = JSON.parse(JSON.stringify(AppData.TEXTFORMAT.MENU_SUBTITLE));
        textFormat.align = 'center'
        textFormat.wordWrap = true;
        textFormat.wordWrapWidth = 300 * AppData.RATIO

        @hint = new PIXI.Text label, textFormat
        @hint.anchor.x = 0.5
        @hint.anchor.y = 0
        @hint.tint = 0x646464
        @hint.scale.x = @hint.scale.y = 0.5
        @hint.position.x = AppData.SUBMENU_PANNEL/4
        @hint.position.y = AppData.SUBMENU_PANNEL/2 - AppData.PADDING/2
        # @hint.visible = AppData.SHOW_LABELS
        @addChild @hint

        @hitArea = new PIXI.Rectangle(0, 0, AppData.SUBMENU_PANNEL/2, AppData.SUBMENU_PANNEL/2);

        @enable()

    onHelp: (value) =>
        # @hint.visible = value
        null

    onDown: =>
        @buttonClick()
        null

    onUp: =>
        @onOut()
        null

    onOver: =>
        return if not @enabled
        TweenMax.to @hint, 0, { tint: 0xffffff, ease: @ease }
        null

    onOut: =>
        return if not @enabled
        TweenMax.to @hint, 0, { tint: 0x646464, ease: @ease }
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
