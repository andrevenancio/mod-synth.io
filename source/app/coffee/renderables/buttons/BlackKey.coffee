# import renderables.buttons.Button
class BlackKey extends Button

    constructor: ->
        super AppData.ASSETS.sprite.textures['black-note.png']

        @hint = new PIXI.Text 'B', AppData.TEXTFORMAT.HINT
        @hint.anchor.x = 0.5
        @hint.anchor.y = 0.5
        @hint.scale.x = @hint.scale.y = 0.5
        @hint.position.x = @texture.width/2
        @hint.position.y = @texture.height/2
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
