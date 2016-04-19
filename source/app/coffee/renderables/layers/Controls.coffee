# import renderables.elements.Logo
# import renderables.buttons.ICButton
# import core.View
class Controls extends View

    constructor: ->
        super()

        App.TOGGLE_MENU.add @onToggleMenu

        @logo = new Logo()
        @addChild @logo

        @keyboard = new ICButton AppData.ASSETS.sprite.textures['ic-keyboard-48.png'], 'KEYBOARD'
        @keyboard.buttonClick = @toggleKeyboard
        @keyboard.select AppData.SHOW_KEYBOARD_PANNEL
        @addChild @keyboard

        @toggle = new ICButton AppData.ASSETS.sprite.textures['ic-menu.png'], 'MENU'
        @toggle.buttonClick = @toggleMenu
        @toggle.select AppData.SHOW_MENU_PANNEL
        @addChild @toggle

    onResize: =>
        @logo.x = AppData.PADDING
        @logo.y = AppData.PADDING

        @keyboard.x = AppData.PADDING
        @keyboard.y = AppData.HEIGHT - AppData.ICON_SIZE_1 - AppData.PADDING

        @toggle.x = AppData.WIDTH - AppData.ICON_SIZE_1 - AppData.PADDING
        @toggle.y = AppData.PADDING
        null

    onToggleMenu: =>
        @toggle.select AppData.SHOW_MENU_PANNEL
        null

    toggleKeyboard: =>
        AppData.SHOW_KEYBOARD_PANNEL = !AppData.SHOW_KEYBOARD_PANNEL
        @keyboard.select AppData.SHOW_KEYBOARD_PANNEL
        App.TOGGLE_KEYBOARD.dispatch AppData.SHOW_KEYBOARD_PANNEL
        null

    toggleMenu: =>
        AppData.SHOW_MENU_PANNEL = !AppData.SHOW_MENU_PANNEL
        w = AppData.MENU_PANNEL + AppData.MENU_PANNEL_BORDER
        if AppData.SHOW_MENU_PANNEL is false
            w = 0
        App.TOGGLE_MENU.dispatch({ width: w });
        null
