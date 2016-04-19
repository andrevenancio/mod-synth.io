# import renderables.buttons.Button
class WhiteKey extends Button

    constructor: ->
        super AppData.ASSETS.sprite.textures['white-note.png']

        @hint = new PIXI.Text 'W', AppData.TEXTFORMAT.HINT
        @hint.anchor.x = 0.5
        @hint.anchor.y = 1
        @hint.scale.x = @hint.scale.y = 0.5
        @hint.position.x = @texture.width/2
        @hint.position.y = @texture.height - 10 * AppData.RATIO
        @hint.tint = 0x232323
        @hint.hitArea = new PIXI.Rectangle(0, 0, 0, 0);
        @hint.visible = AppData.SHOW_LABELS
        @addChild @hint

    onHelp: =>
        @hint.visible = AppData.SHOW_LABELS
        null

    onDown: =>
        App.NOTE_ON.dispatch { note: @code, velocity: 127.0 }
        null

    onUp: =>
        App.NOTE_OFF.dispatch { note: @code }
        null

    onOutside: =>
        App.NOTE_OFF.dispatch { note: @code }
        null

    enable: ->
        super()

        label = ''
        for i in [0...KeyboardController.map.length]
            if @code is KeyboardController.map[i].midi
                label = KeyboardController.map[i].label
                break
        @hint.text = label
        null
