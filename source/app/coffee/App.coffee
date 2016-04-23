# import core.PixiBase
# import renderables.layers.*
# import renderables.Menu
# import renderables.LoadingScreen
# import controllers.Controllers
# import audio.Instrument
class App extends PixiBase

    # help
    @HELP: new signals.Signal()

    # prompt window
    @PROMPT: new signals.Signal()

    @LOAD_PATCH: new signals.Signal()
    @LOAD_PRESET: new signals.Signal()
    @PATCH_CHANGED: new signals.Signal()
    @PRESET_CHANGED: new signals.Signal()

    # add/remove components
    @ADD: new signals.Signal()
    @REMOVE: new signals.Signal()

    @TOGGLE_KEYBOARD: new signals.Signal()
    @TOGGLE_SETTINGS_PANNEL_HEIGHT: new signals.Signal()
    @TOGGLE_MENU: new signals.Signal()

    @NOTE_ON: new signals.Signal()
    @NOTE_OFF: new signals.Signal()

    @PATTERN_GATE: new signals.Signal()
    @SETTINGS_CHANGE: new signals.Signal()

    @PICKER_SHOW: new signals.Signal()
    @PICKER_HIDE: new signals.Signal()
    @PICKER_VALUE: new signals.Signal()

    # used for menu
    @AUTH: new signals.Signal()
    @MIDI: new signals.Signal()

    @AUTO_SAVE: new signals.Signal()

    constructor: ->
        super()

        @loading = new LoadingScreen @loadComplete
        AppData.PIXI.stage.addChild @loading

        App.RESIZE.add @onResize
        App.TOGGLE_MENU.add @onToggleMenu
        App.PROMPT.add @onPrompt
        App.LOAD_PATCH.add @onLoadPatch
        App.LOAD_PRESET.add @onLoadPreset
        App.AUTO_SAVE.add @onAutoSave

        App.AUTH.add @checkUserAuth

        App.TOGGLE_KEYBOARD.add @onToggle
        App.HELP.add @onHelp

    loadComplete: =>
        AppData.PIXI.stage.removeChild @loading

        # creates 2 pixi texts to force font rendering
        t1 = new PIXI.Text 'mod-synth', AppData.TEXTFORMAT.TEST_FONT_1
        t1.position.x = 0;
        t1.position.y = -100;
        AppData.PIXI.stage.addChild(t1);

        t2 = new PIXI.Text 'mod-synth', AppData.TEXTFORMAT.TEST_FONT_2
        t2.position.x = 400;
        t2.position.y = -100;
        AppData.PIXI.stage.addChild(t2);

        @prompt = new Prompt()
        @tour = new Tour()

        # audio engine
        @instrument = new Instrument()

        # all controls (keyboard, midi)
        @controllers = new Controllers()

        # dashboard where all the components are (draggable)
        @dashboard = new Dashboard()
        @dashboard.alpha = 0
        AppData.PIXI.stage.addChild @dashboard

        # background of menus
        @menuBg = new PIXI.Graphics()
        AppData.PIXI.stage.addChild @menuBg

        # menu
        @menu = new Menu()
        AppData.PIXI.stage.addChild @menu

        # midi keyboard + settings
        @bottom = new Bottom()
        @bottom.alpha = 0
        AppData.PIXI.stage.addChild @bottom

        # overlay of buttons
        @controls = new Controls()
        @controls.alpha = 0
        AppData.PIXI.stage.addChild @controls

        # if AppData.SHOW_TOUR
            # @tour.start()
        # else
        patch = Cookies.getCookie('patch') || 'default'
        @loadPatch patch

        if AppData.SHOW_MENU_PANNEL
            @onToggleMenu { width: AppData.MENU_PANNEL + AppData.MENU_PANNEL_BORDER }, 0

        # forces a resize
        App.RESIZE.dispatch()

        TweenMax.to [@controls, @bottom, @dashboard], 0.5, { alpha: 1 }
        null

    initialAdd: (delay, componentData) ->
        setTimeout =>
            data = Session.ADD componentData
            App.ADD.dispatch data
            App.SETTINGS_CHANGE.dispatch { component: data.component_session_uid }
        , delay * 1000.0
        null

    onResize: =>
        return if not @menu
        @menu.x = if AppData.SHOW_MENU_PANNEL is true then AppData.WIDTH-AppData.MENU_PANNEL-AppData.MENU_PANNEL_BORDER else AppData.WIDTH
        @menu.resize()

        @menuBg.x = if AppData.SHOW_MENU_PANNEL is true then AppData.WIDTH+@dashboard.x else AppData.WIDTH

        @menuBg.beginFill AppData.BG
        @menuBg.lineStyle 0, 0
        @menuBg.moveTo 0, 0
        @menuBg.lineTo AppData.SUBMENU_PANNEL, 0
        @menuBg.lineTo AppData.SUBMENU_PANNEL, AppData.HEIGHT
        @menuBg.lineTo 0, AppData.HEIGHT
        @menuBg.lineTo 0, 0
        @menuBg.endFill()
        null

    onToggleMenu: (data, duration=0.3) =>
        TweenMax.to [@dashboard, @bottom, @controls, @addLayer], duration, { x: (if AppData.SHOW_MENU_PANNEL is true then -data.width else 0), ease: Quad.easeInOut }
        TweenMax.to @menu, duration, { x: (if AppData.SHOW_MENU_PANNEL is true then AppData.WIDTH-AppData.MENU_PANNEL-AppData.MENU_PANNEL_BORDER else AppData.WIDTH), ease: Quad.easeInOut }
        TweenMax.to @menuBg, duration, { x: AppData.WIDTH-data.width, ease: Quad.easeInOut }
        if AppData.SHOW_MENU_PANNEL is true
            @menu.open data.width, duration
            Analytics.event 'menu', 'open'
        else
            @menu.close duration
            Analytics.event 'menu', 'close'

        Cookies.setCookie 'menu', if AppData.SHOW_MENU_PANNEL is true then 'show' else 'hide'
        null

    onPrompt: (data) =>
        if data
            @prompt.show data
            Analytics.event 'prompt', 'open'
        else
            @prompt.hide()
            Analytics.event 'prompt', 'open'
        null

    onLoadPatch: (data) =>
        if data.confirm is undefined
            data.confirm = true

        if data.confirm
            # confirmation
            App.PROMPT.dispatch {
                question: 'Load "' + data.label + '" patch?'
                onConfirm: =>
                    # remove all components,
                    @clearPatch =>
                        @loadPatch data.uid
                        null
                    null
            }
        else
            # no confirmation
            @clearPatch =>
                @loadPatch data.uid
                null
        null

    onLoadPreset: (data) =>

        # changes selected preset
        Session.patch.preset = data.uid

        # loops all components
        preset = Session.patch.presets[Session.patch.preset]
        # loops through all components in preset
        for component of preset.components
            settings = Session.DUPLICATE_OBJECT Session.SETTINGS[component].settings
            if settings
                for p of preset.components[component]
                    settings[p] = preset.components[component][p]
                Session.SETTINGS[component].settings = settings
                App.SETTINGS_CHANGE.dispatch { component: component }

        # let app know all is updated
        App.PRESET_CHANGED.dispatch()
        null

    clearPatch: (callback) =>
        for component of Session.SETTINGS
            App.REMOVE.dispatch Session.SETTINGS[component]

        setTimeout ->
            callback()
            null
        , 1000
        null

    loadPatch: (patch_uid) =>
        # Loads PATCH and all PRESETS
        Services.api.patches.load patch_uid, (snapshot) =>
            data = snapshot.val()

            # if user tries to load inexistent patch
            if data is null
                @loadPatch 'default'
                return

            Session.patch.uid = patch_uid
            Session.patch.author = data.author
            Session.patch.author_name = data.author_name
            Session.patch.components = data.components
            Session.patch.date = data.date
            Session.patch.name = data.name
            Session.patch.preset = data.preset

            # save cookie with latest patch
            Cookies.setCookie 'patch', patch_uid

            # loads all presets
            Services.api.presets.loadAll patch_uid, (snapshot) =>
                Session.patch.presets = snapshot.val()

                App.PATCH_CHANGED.dispatch()
                App.PRESET_CHANGED.dispatch()

                i = 0
                for component of Session.patch.components
                    @initialAdd 0.123 * (i++), Session.patch.components[component]
                null
            null
        null

    onAutoSave: Session.debounce (data) ->
        return if AppData.TOUR_MODE is true
        return if Session.patch.uid is 'default'

        if data.x
            Session.SETTINGS[data.component_session_uid].x = data.x
        if data.y
            Session.SETTINGS[data.component_session_uid].y = data.y
        Services.api.patches.update()

        return if not Services.REFERENCE.getAuth()
        Services.api.presets.update Session.patch.preset
    , 500

    onToggle: (value) =>
        Cookies.setCookie 'keyboard', if value is true then 'show' else 'hide'
        null

    onHelp: (value) =>
        Cookies.setCookie 'labels', if value is true then 'show' else 'hide'
        null

    checkUserAuth: =>
        if not Services.REFERENCE.getAuth()
            @clearPatch =>
                @loadPatch 'default'
        null
