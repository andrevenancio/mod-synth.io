# import core.View
# import renderables.SettingsPannel
# import renderables.KeyboardPannel
# import renderables.Picker
class Bottom extends View

    constructor: ->
        super()

        App.TOGGLE_KEYBOARD.add @onToggle

        @bottom = new KeyboardPannel()
        @addChild @bottom

        @top = new SettingsPannel()
        @addChild @top

        @picker = new Picker()
        @addChild @picker

    onResize: =>
        @top.resize()
        @bottom.resize()

        if AppData.SHOW_KEYBOARD_PANNEL
            @y = AppData.HEIGHT - ( AppData.SETTINGS_PANNEL_HEIGHT + AppData.KEYBOARD_PANNEL_HEIGHT )
        else
            @y = AppData.HEIGHT - AppData.SETTINGS_PANNEL_HEIGHT
        null

    onToggle: (value) =>
        if value
            @open()
        else
            @close()
        null

    open: ->
        AppData.SHOW_KEYBOARD_PANNEL = true
        y = AppData.HEIGHT - ( AppData.SETTINGS_PANNEL_HEIGHT + AppData.KEYBOARD_PANNEL_HEIGHT )
        TweenMax.to @, 0.2, { y: y }
        null

    close: ->
        AppData.SHOW_KEYBOARD_PANNEL = false
        y = AppData.HEIGHT - AppData.SETTINGS_PANNEL_HEIGHT
        TweenMax.to @, 0.2, { y: y }
        null
