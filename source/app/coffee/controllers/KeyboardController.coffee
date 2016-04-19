class KeyboardController

    @map = []
    @map[0] = { label: 'A', keyCode: 65, note: 'C2', midi: 48 }
    @map[1] = { label: 'W', keyCode: 87, note: 'C2#', midi: 49 }
    @map[2] = { label: 'S', keyCode: 83, note: 'D2', midi: 50 }
    @map[3] = { label: 'E', keyCode: 69, note: 'D2#', midi: 51 }
    @map[4] = { label: 'D', keyCode: 68, note: 'E2', midi: 52 }
    @map[5] = { label: 'F', keyCode: 70, note: 'F2', midi: 53 }
    @map[6] = { label: 'T', keyCode: 84, note: 'F2#', midi: 54 }
    @map[7] = { label: 'G', keyCode: 71, note: 'G2', midi: 55 }
    @map[8] = { label: 'Y', keyCode: 89, note: 'G2#', midi: 56 }
    @map[9] = { label: 'H', keyCode: 72, note: 'A2', midi: 57 }
    @map[10] = { label: 'U', keyCode: 85, note: 'A2#', midi: 58 }
    @map[11] = { label: 'J', keyCode: 74, note: 'B2', midi: 59 }
    @map[12] = { label: 'K', keyCode: 75, note: 'C3', midi: 60 }
    @map[13] = { label: 'O', keyCode: 79, note: 'D3#', midi: 61 }
    @map[14] = { label: 'L', keyCode: 76, note: 'D3', midi: 62 }
    @map[15] = { label: 'P', keyCode: 80, note: 'D3#', midi: 63 }

    constructor: ->
        @currentKeys = []

        if 'onkeyup' of document.documentElement
            window.addEventListener 'keydown', @onKeyDown, false
            window.addEventListener 'keyup', @onKeyUp, false

    onKeyDown: (e) =>
        return if not AppData.KEYPRESS_ALLOWED
        value = false
        for i in [0...KeyboardController.map.length]
            if e.keyCode is KeyboardController.map[i].keyCode
                value = KeyboardController.map[i].midi
                break
        if value
            if @currentKeys[value] is undefined
                @currentKeys[value] = 1
                App.NOTE_ON.dispatch { note: value, velocity: 127.0 }
        null

    onKeyUp: (e) =>
        return if not AppData.KEYPRESS_ALLOWED
        value = false
        for i in [0...KeyboardController.map.length]
            if e.keyCode is KeyboardController.map[i].keyCode
                value = KeyboardController.map[i].midi
                break
        if value
            if @currentKeys[value]
                delete @currentKeys[value]
                App.NOTE_OFF.dispatch { note: value }
        null
