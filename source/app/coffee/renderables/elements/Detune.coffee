# import renderables.buttons.Slider
class Detune extends Slider

    constructor: (@component_session_uid) ->
        super()

        App.SETTINGS_CHANGE.add @onSettingsChange

        @range = {
            min: -100,
            max: 100
        }

        @percentage = MathUtils.map(Session.SETTINGS[@component_session_uid].settings.attack.detune, @range.min, @range.max, 0, 100, true)

        @title = new PIXI.Text 'DETUNE', AppData.TEXTFORMAT.SETTINGS_LABEL
        @title.scale.x = @title.scale.y = 0.5
        @title.anchor.x = 0.5
        @title.x = AppData.ICON_SIZE_1 / 2
        @title.hitArea = new PIXI.Rectangle(0, 0, 0, 0);
        @title.tint = 0x646464
        @addChild @title

        @value = new PIXI.Text '', AppData.TEXTFORMAT.SETTINGS_NUMBER
        @value.scale.x = @value.scale.y = 0.5
        @value.anchor.x = 0.5
        @value.anchor.y = 1
        @value.x = AppData.ICON_SIZE_1 / 2
        @value.y = AppData.ICON_SIZE_1 + 6 * AppData.RATIO
        @addChild @value

    onEnd: (e) =>
        super e
        if @lastValue is @percentage
            value = 100/(@range.max-@range.min)
            @percentage += value
            if @percentage >= value*(@range.max-@range.min)
                @percentage = 0
            @onUpdate()
        null

    onSettingsChange: (event) =>
        if event.component is @component_session_uid
            @value.text = Session.SETTINGS[@component_session_uid].settings.attack.detune
        null

    onUpdate: ->
        Session.SETTINGS[@component_session_uid].settings.attack.detune = MathUtils.map(@percentage, 0, 100, @range.min, @range.max, true)
        App.SETTINGS_CHANGE.dispatch { component: @component_session_uid }
        null
