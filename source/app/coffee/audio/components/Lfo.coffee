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
        @component.frequency.value = @frequency
        @component.connect @aux
        @component.start()

    destroy: ->
        @component.stop()
        null

    onSettingsChange: (event) =>
        if event.component is @component_session_uid
            @type = Audio.WAVE_TYPE[Session.patch.presets[Session.patch.preset][@component_session_uid].wave_type]
            @frequency = Session.patch.presets[Session.patch.preset][@component_session_uid].frequency
            @depth = MathUtils.map Session.patch.presets[Session.patch.preset][@component_session_uid].depth, 0, 100, 0, 1
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
            @component.frequency.value = @parameters.frequency
            return @parameters.frequency

    @property 'depth',
        get: ->
            return @parameters.depth
        set: (value) ->
            return @parameters.depth if @parameters.depth is value
            @parameters.depth = value
            @aux.gain.value = @parameters.depth
            return @parameters.depth
