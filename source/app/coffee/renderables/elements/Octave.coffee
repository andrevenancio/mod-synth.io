# import renderables.buttons.Slider
class Octave extends Slider

    constructor: (@component_session_uid) ->
        super()

        App.SETTINGS_CHANGE.add @onSettingsChange

        @possibleValues = [AppData.OCTAVE_TYPE.THIRTY_TWO, AppData.OCTAVE_TYPE.SIXTEEN, AppData.OCTAVE_TYPE.EIGHT, AppData.OCTAVE_TYPE.FOUR]

        @steps = @possibleValues.length
        @snap = true
        @elements = [
            '32',
            '16',
            '8',
            '4',
        ]

        for i in [0...@possibleValues.length]
            if Session.SETTINGS[@component_session_uid].settings.attack.octave is @possibleValues[i]
                index = i
                continue
        @percentage = MathUtils.map(index, 0, @possibleValues.length-1, 0, 100, true)

        @title = new PIXI.Text 'OCTAVE', AppData.TEXTFORMAT.SETTINGS_LABEL
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

        @unit = new PIXI.Text "’", AppData.TEXTFORMAT.SETTINGS_NUMBER_POSTSCRIPT
        @unit.scale.x = @unit.scale.y = 0.5
        @unit.y = 17 * AppData.RATIO
        @unit.hitArea = new PIXI.Rectangle(0, 0, 0, 0);
        @addChild @unit

    onEnd: (e) =>
        super e
        if @lastValue is @percentage
            next = Session.SETTINGS[@component_session_uid].settings.attack.octave+1
            next %= @possibleValues.length
            @percentage = MathUtils.map next, 0, @possibleValues.length-1, 0, 100
            @onUpdate()
        null

    onSettingsChange: (event) =>
        if event.component is @component_session_uid
            @value.text = @elements[Session.SETTINGS[@component_session_uid].settings.attack.octave]
            @unit.x = @value.x + @value.width / 2
        null

    onUpdate: ->
        Session.SETTINGS[@component_session_uid].settings.attack.octave = MathUtils.map @percentage, 0, 100, 0, @possibleValues.length-1, true
        App.SETTINGS_CHANGE.dispatch { component: @component_session_uid }
        null
