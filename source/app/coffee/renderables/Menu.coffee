# import renderables.elements.User
# import renderables.menu.*
class Menu extends PIXI.Container

    constructor: ->
        super()

        @buttons = []
        @tabs = []
        @selectIndex = null

        @sidepannel = new PIXI.Container()
        @addChild @sidepannel

        @graphics = new PIXI.Graphics()
        @addChild @graphics

        @graphics2 = new PIXI.Graphics()
        @sidepannel.addChild @graphics2

        @select = new PIXI.Graphics()
        @select.beginFill 0x4E4E4E
        @select.lineStyle 0, 0
        @select.moveTo 0, 0
        @select.lineTo 4 * AppData.RATIO, 0
        @select.lineTo 4 * AppData.RATIO, AppData.SETTINGS_PANNEL_HEIGHT
        @select.lineTo 0, AppData.SETTINGS_PANNEL_HEIGHT
        @select.lineTo 0, 0
        @select.endFill()
        @select.y = AppData.SETTINGS_PANNEL_HEIGHT * -1
        @select.alpha = 0
        @addChild @select

        @build()

    build: ->
        @login = new MenuButton AppData.ASSETS.sprite.textures['ic-login-48.png'], 'login'
        @login.buttonClick = =>
            @openSubmenu 0
            null
        @buttons.push @login
        @addChild @login

        @add = new MenuButton AppData.ASSETS.sprite.textures['ic-add-48.png'], 'add'
        @add.buttonClick = =>
            @openSubmenu 1
            null
        @buttons.push @add
        @addChild @add

        @presets = new MenuButton AppData.ASSETS.sprite.textures['ic-presets-48.png'], 'patches'
        @presets.buttonClick = =>
            @openSubmenu 2
            null
        @buttons.push @presets
        @addChild @presets

        @midi = new MenuButton AppData.ASSETS.sprite.textures['ic-midi.png'], 'midi'
        @midi.buttonClick = =>
            @openSubmenu 3
            null
        @buttons.push @midi
        @addChild @midi

        @help = new LabelsToggle()
        @help.buttonClick = =>
            AppData.SHOW_LABELS = !AppData.SHOW_LABELS
            App.HELP.dispatch AppData.SHOW_LABELS
            null
        @addChild @help

        @tabs.push new LoginPannel('login')
        @tabs.push new AddPannel('add component')
        @tabs.push new PatchesPannel('patches')
        @tabs.push new MidiPannel('midi devices')

        for i in [0...@tabs.length]
            @tabs[i].visible = false
            @sidepannel.addChild @tabs[i]

        @adjustPosition()
        null

    resize: ->
        @graphics.clear()
        @graphics2.clear()

        @graphics.beginFill AppData.BG
        @graphics.lineStyle 0, 0
        @graphics.moveTo 0, 0
        @graphics.lineTo AppData.SUBMENU_PANNEL, 0
        @graphics.lineTo AppData.SUBMENU_PANNEL, AppData.HEIGHT
        @graphics.lineTo 0, AppData.HEIGHT
        @graphics.lineTo 0, 0
        @graphics.endFill()

        @graphics.beginFill 0x0D0D0D
        @graphics.lineStyle 0, 0
        @graphics.moveTo 0, 0
        @graphics.lineTo AppData.MENU_PANNEL_BORDER, 0
        @graphics.lineTo AppData.MENU_PANNEL_BORDER, AppData.HEIGHT
        @graphics.lineTo 0, AppData.HEIGHT
        @graphics.lineTo 0, 0
        @graphics.endFill()

        @graphics2.beginFill 0x0D0D0D
        @graphics2.lineStyle 0, 0
        @graphics2.moveTo 0, 0
        @graphics2.lineTo AppData.MENU_PANNEL_BORDER, 0
        @graphics2.lineTo AppData.MENU_PANNEL_BORDER, AppData.HEIGHT
        @graphics2.lineTo 0, AppData.HEIGHT
        @graphics2.lineTo 0, 0
        @graphics2.endFill()

        @help.x = 4 * AppData.RATIO
        @help.y = AppData.HEIGHT - @help.height - AppData.PADDING

        @adjustPosition()
        null

    adjustPosition: ->
        for i in [0...@buttons.length]
            @buttons[i].x = 4 * AppData.RATIO
            if i is 0
                @buttons[i].y = 0
            else
                @buttons[i].y = @buttons[i-1].y + @buttons[i-1].height
        null

    open: (width, duration) ->
        # change select icon and remove highlight
        if width <= AppData.MENU_PANNEL+AppData.MENU_PANNEL_BORDER
            @selectIndex = null
            TweenMax.to @select, duration, { y: AppData.MENU_PANNEL * -1, alpha: 0, ease: Quad.easeInOut }
        else
            TweenMax.to @select, duration, { alpha: 1, ease: Quad.easeInOut }

        # slide all pannels
        xx = if width is AppData.MENU_PANNEL+AppData.MENU_PANNEL_BORDER then 0 else -AppData.SUBMENU_PANNEL
        TweenMax.to @sidepannel, duration, { x: xx, ease: Quad.easeInOut }
        if @selectIndex is null
            @highlightMenu()
        null

    close: (duration)->
        @selectIndex = null
        TweenMax.to @sidepannel, duration, { x: 0, ease: Quad.easeInOut, onComplete: @highlightMenu }
        TweenMax.to @select, duration, { y: AppData.MENU_PANNEL * -1, alpha: 0, ease: Quad.easeInOut }
        null

    highlightMenu: =>
        # unselect
        for i in [0...@buttons.length]
            @buttons[i].select(false)

        # select if anything
        if @selectIndex isnt null
            @buttons[@selectIndex].select(true);
        null

    openSubmenu: (index) =>
        @selectIndex = index

        @highlightMenu()

        # hide all tabs and show only the current
        for i in [0...@tabs.length]
            @tabs[i].visible = false
        @tabs[@selectIndex].visible = true

        # select current
        TweenMax.to @select, 0.3, { y: @buttons[index].y, height: @buttons[index].height, ease: Quad.easeInOut }

        # change to new size
        App.TOGGLE_MENU.dispatch { width: AppData.SUBMENU_PANNEL + AppData.MENU_PANNEL + AppData.MENU_PANNEL_BORDER }
        null
