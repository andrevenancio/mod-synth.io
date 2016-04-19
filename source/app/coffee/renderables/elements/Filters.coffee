# import renderables.buttons.Slider
class Filters extends Slider

    constructor: (@component_session_uid) ->
        super()

        App.SETTINGS_CHANGE.add @onSettingsChange

        @possibleValues = [AppData.FILTER_TYPE.LOWPASS, AppData.FILTER_TYPE.HIGHPASS, AppData.FILTER_TYPE.BANDPASS, AppData.FILTER_TYPE.LOWSHELF, AppData.FILTER_TYPE.HIGHSHELF, AppData.FILTER_TYPE.PEAKING, AppData.FILTER_TYPE.NOTCH, AppData.FILTER_TYPE.ALLPASS]

        @steps = @possibleValues.length
        @snap = true
        @elements = [
            '0',
            '1',
            '2',
            '3',
            '4',
            '5',
            '6',
            '7',
        ]

        for i in [0...@possibleValues.length]
            if Session.SETTINGS[@component_session_uid].settings.filter_type is @possibleValues[i]
                index = i
                continue
        @percentage = MathUtils.map(index, 0, @possibleValues.length, 0, 100, true)

        @title = new PIXI.Text 'FILTER', AppData.TEXTFORMAT.SETTINGS_LABEL
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
            next = Session.SETTINGS[@component_session_uid].settings.filter_type+1
            next %= @possibleValues.length
            @percentage = MathUtils.map next, 0, @possibleValues.length-1, 0, 100
            @onUpdate()
        null

    onSettingsChange: (event) =>
        if event.component is @component_session_uid
            @value.text = @elements[Session.SETTINGS[@component_session_uid].settings.filter_type]
        null

    onUpdate: ->
        Session.SETTINGS[@component_session_uid].settings.filter_type = MathUtils.map @percentage, 0, 100, 0, @possibleValues.length-1, true
        App.SETTINGS_CHANGE.dispatch { component: @component_session_uid }
        null
