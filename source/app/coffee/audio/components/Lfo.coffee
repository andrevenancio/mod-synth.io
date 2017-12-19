# import audio.components.Component
class Lfo extends Component

    constructor: (data) ->
        super data

        @parameters.bypass = data.settings.bypass
        @parameters.type = Audio.WAVE_TYPE[data.settings.wave_type]
        @parameters.frequency = data.settings.frequency

        App.SETTINGS_CHANGE.add @onSettingsChange

        @component = Audio.CONTEXT.createOscillator()
        @component.type = @type
        @component.frequency.setValueAtTime @frequency, Audio.CONTEXT.currentTime
        @component.connect @aux
        @component.start()

    destroy: ->
        @component.stop()
        null

    onSettingsChange: (event) =>
        if event.component is @component_session_uid
            @type = Audio.WAVE_TYPE[Session.SETTINGS[@component_session_uid].settings.wave_type]
            @frequency = Session.SETTINGS[@component_session_uid].settings.frequency
            @depth = MathUtils.map Session.SETTINGS[@component_session_uid].settings.depth, 0, 100, 0, 1
        null

    @property 'type',
        get: ->
            return @parameters.type
        set: (value) ->
            return @parameters.type if @parameters.type is value
            @parameters.type = value
            @component.type = @parameters.type
            return @parameters.type

    @property 'frequency',
        get: ->
            return @parameters.frequency
        set: (value) ->
            return @parameters.frequency if @parameters.frequency is value
            @parameters.frequency = value
            @component.frequency.setValueAtTime @parameters.frequency, Audio.CONTEXT.currentTime
            return @parameters.frequency

    @property 'depth',
        get: ->
            return @parameters.depth
        set: (value) ->
            return @parameters.depth if @parameters.depth is value
            @parameters.depth = value
            @aux.gain.setValueAtTime @parameters.depth, Audio.CONTEXT.currentTime
            return @parameters.depth
