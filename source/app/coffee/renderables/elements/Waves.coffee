# import renderables.buttons.Slider
class Waves extends Slider

    constructor: (@component_session_uid) ->
        super()

        App.SETTINGS_CHANGE.add @onSettingsChange

        @possibleValues = [AppData.WAVE_TYPE.SINE, AppData.WAVE_TYPE.TRIANGLE, AppData.WAVE_TYPE.SQUARE, AppData.WAVE_TYPE.SAWTOOTH]

        @steps = @possibleValues.length
        @snap = true
        @elements = [
            AppData.ASSETS.sprite.textures['ic-wave-sine-32.png']
            AppData.ASSETS.sprite.textures['ic-wave-tri-32.png']
            AppData.ASSETS.sprite.textures['ic-wave-sq-32.png']
            AppData.ASSETS.sprite.textures['ic-wave-saw-32.png']
        ]

        for i in [0...@possibleValues.length]
            if Session.SETTINGS[@component_session_uid].settings.wave_type is @possibleValues[i]
                index = i
                continue
        @percentage = MathUtils.map(index, 0, @possibleValues.length, 0, 100, true)

        @title = new PIXI.Text 'WAVE', AppData.TEXTFORMAT.SETTINGS_LABEL
        @title.scale.x = @title.scale.y = 0.5
        @title.anchor.x = 0.5
        @title.x = AppData.ICON_SIZE_1 / 2
        @title.hitArea = new PIXI.Rectangle(0, 0, 0, 0);
        @title.tint = 0x646464
        @addChild @title

        @texture = new PIXI.Sprite()
        @texture.anchor.x = 0.5
        @texture.anchor.y = 1
        @texture.x = AppData.ICON_SIZE_1 / 2
        @texture.y = AppData.ICON_SIZE_1
        @texture.tint = 0xffffff
        @addChild @texture

    onEnd: (e) =>
        super e
        if @lastValue is @percentage
            next = Session.SETTINGS[@component_session_uid].settings.wave_type+1
            next %= @possibleValues.length
            @percentage = MathUtils.map next, 0, @possibleValues.length-1, 0, 100
            @onUpdate()
        null

    onSettingsChange: (event) =>
        if event.component is @component_session_uid
            @texture.texture = @elements[Session.SETTINGS[@component_session_uid].settings.wave_type]
        null

    onUpdate: ->
        Session.SETTINGS[@component_session_uid].settings.wave_type = MathUtils.map @percentage, 0, 100, 0, @possibleValues.length-1, true
        App.SETTINGS_CHANGE.dispatch { component: @component_session_uid }
        null
