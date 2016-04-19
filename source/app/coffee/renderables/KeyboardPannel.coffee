# import renderables.buttons.BlackKey
# import renderables.buttons.WhiteKey
# import renderables.buttons.OctaveUp
# import renderables.buttons.OctaveDown
class KeyboardPannel extends PIXI.Sprite

    constructor: ->
        super()

        App.NOTE_ON.add @onNoteOn
        App.NOTE_OFF.add @onNoteOff

        @firstKeyCode = 48
        @keycode = @firstKeyCode

        @graphics = new PIXI.Graphics()
        @addChild @graphics

        # keys
        @keys = new PIXI.Container()
        @keys.y = AppData.SETTINGS_PANNEL_HEIGHT
        @addChild @keys

        @hitArea = new PIXI.Rectangle 0, 100*AppData.RATIO, AppData.WIDTH, AppData.KEYBOARD_PANNEL_HEIGHT

    resize: ->
        @graphics.clear()
        @graphics.beginFill 0x232323, 0.97
        @graphics.moveTo 0, AppData.SETTINGS_PANNEL_HEIGHT
        @graphics.lineTo AppData.WIDTH, AppData.SETTINGS_PANNEL_HEIGHT
        @graphics.lineTo AppData.WIDTH, AppData.SETTINGS_PANNEL_HEIGHT + AppData.KEYBOARD_PANNEL_HEIGHT
        @graphics.lineTo 0, AppData.SETTINGS_PANNEL_HEIGHT + AppData.KEYBOARD_PANNEL_HEIGHT
        @graphics.lineTo 0, 0
        @graphics.endFill()

        @removeKeys()
        @addKeys()
        null

    removeKeys: ->
        for i in [0...@keys.children.length]
            child = @keys.children[0]
            child.disable()
            @keys.removeChild child
        null

    addKeys: ->
        @kw = 72 * AppData.RATIO
        @kh = 170 * AppData.RATIO
        @kr = 72 * AppData.RATIO
        @p = 100 * AppData.RATIO

        availableWidth = AppData.WIDTH - (110*AppData.RATIO) - AppData.PADDING
        initialX = (110*AppData.RATIO)
        # random number added
        total = Math.floor( availableWidth / (@kw+8*AppData.RATIO) )

        availableFluid = availableWidth - (@kw*total)

        @keycode = @firstKeyCode
        fluid = availableFluid/total
        for i in [0...total]

            if i%7 is 0 or ((i+4)%7) is 0
                if i isnt 0
                    @keycode--

            w = new WhiteKey()
            w.code = @keycode
            w.enable()
            w.x = initialX + (@kw+fluid) * i
            w.y = AppData.KEYBOARD_PANNEL_HEIGHT - @kh - AppData.PADDING
            @keys.addChild w

            @keycode += 2

            if i%7 is 0 or ((i+4)%7) is 0
                continue

            b = new BlackKey()
            b.code = @keycode-3
            b.enable()
            b.x = w.x - @kr/2
            b.y = w.y - @p
            @keys.addChild b

        # octaves
        @octaveUp = new OctaveUp();
        @octaveUp.x = AppData.PADDING - (@octaveUp.width-AppData.ICON_SIZE_1)/2
        @octaveUp.y = AppData.KEYBOARD_PANNEL_HEIGHT - @kh - AppData.PADDING - @p
        @keys.addChild @octaveUp

        @octaveDown = new OctaveDown();
        @octaveDown.x = AppData.PADDING - (@octaveUp.width-AppData.ICON_SIZE_1)/2
        @octaveDown.y = AppData.KEYBOARD_PANNEL_HEIGHT - @kh - AppData.PADDING
        @keys.addChild @octaveDown
        null

    onNoteOn: (data) =>
        key = @findKey data.note
        if key
            key.select()
        null

    onNoteOff: (data) =>
        key = @findKey data.note
        if key
            key.unselect()
        null

    findKey: (code) ->
        for i in [0...@keys.children.length]
            key = @keys.children[i]
            if key.code is code
                return key
        null
