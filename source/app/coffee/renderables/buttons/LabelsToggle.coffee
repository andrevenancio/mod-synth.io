class LabelsToggle extends PIXI.Container

    constructor: ->
        super()

        @graphics = new PIXI.Graphics()
        @graphics.beginFill 0x00ffff, 0
        @graphics.drawRect 0, 0, AppData.MENU_PANNEL, AppData.ICON_SIZE_1
        @addChild @graphics

        img = new PIXI.Sprite AppData.ASSETS.sprite.textures['help-toggle-bg.png']
        img.anchor.x = 0.5
        img.anchor.y = 0
        img.x = AppData.MENU_PANNEL / 2
        @addChild img

        @selector = new PIXI.Sprite AppData.ASSETS.sprite.textures['help-toggle-selector.png']
        @selector.x = 29 * AppData.RATIO
        @selector.y = 4 * AppData.RATIO
        @selector.alpha = 0.5
        @addChild @selector

        labels = Cookies.getCookie('labels')

        @duration = 0.3
        @ease = Quad.easeInOut
        @enabled = false
        @selected = if labels is 'show' then true else false
        @overAlpha = 1.0
        @outAlpha = 0.65

        @label = new PIXI.Text 'HELP OFF', AppData.TEXTFORMAT.MENU_SMALL
        @label.anchor.x = 0.5
        @label.anchor.y = 1
        @label.scale.x = @label.scale.y = 0.5
        @label.position.x = AppData.MENU_PANNEL / 2
        @label.position.y = AppData.ICON_SIZE_1
        @addChild @label

        @hitArea = new PIXI.Rectangle(0, 0, AppData.MENU_PANNEL, AppData.ICON_SIZE_1);

        @alpha = @outAlpha

        @enable()

        if @selected is true
            @onOver()
        @swap()

    onDown: =>
        @selected = !@selected
        @swap()
        @onOver()
        @buttonClick()
        null

    swap: ->
        TweenMax.to @selector, 0.3, { x: (if @selected is true then 49 else 29) * AppData.RATIO, alpha: (if @selected is true then 1 else 0.5), ease: Power2.easeInOut }
        @label.text = 'LABELS ' + (if @selected is true then 'ON' else 'OFF')
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
        return if @selected
        TweenMax.to @, @duration, { alpha: @outAlpha, ease: @ease }
        null

    buttonClick: ->
        # to be override
        null

    select: (value) ->
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
