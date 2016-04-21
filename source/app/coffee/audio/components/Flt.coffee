# import audio.components.Component
class Flt extends Component

    constructor: (data) ->
        super data

        @parameters.bypass = data.settings.bypass
        @parameters.type = Audio.FILTER_TYPE[data.settings.filter_type]
        @parameters.frequency = data.settings.frequency
        @parameters.detune = data.settings.detune
        @parameters.q = data.settings.q

        App.SETTINGS_CHANGE.add @onSettingsChange

        @component = Audio.CONTEXT.createBiquadFilter()
        @component.type = @type
        @component.frequency.value = @frequency
        @component.detune.value = @detune
        @component.Q.value = @q

    #     @update()
    #
    # update: =>
    #     requestAnimationFrame @update
    #     @frequency = (0.5 + 0.5 * Math.sin(Date.now() / 500)) * 1000;
    #     @q = (0.5 + 0.5 * Math.sin(Date.now() / 500)) * 20;
    #     null

    destroy: ->
        @component.disconnect()
        null

    onSettingsChange: (event) =>
        if event.component is @component_session_uid
            @type = Audio.FILTER_TYPE[Session.patch.presets[Session.patch.preset][@component_session_uid].filter_type]
            @frequency = Session.patch.presets[Session.patch.preset][@component_session_uid].frequency
            @detune = Session.patch.presets[Session.patch.preset][@component_session_uid].detune
            @q = Session.patch.presets[Session.patch.preset][@component_session_uid].q
        null

    @property 'type',
        get: ->
            return @parameters.type
        set: (value) ->
            return @parameters.type if @parameters.type is value
            @parameters.type = value
            @component.type.value = @parameters.type
            return @parameters.type

    @property 'frequency',
        get: ->
            return @parameters.frequency
        set: (value) ->
            return @parameters.frequency if @parameters.frequency is value
            @parameters.frequency = value
            @component.frequency.value = @parameters.frequency
            return @parameters.frequency

    @property 'detune',
        get: ->
            return @parameters.detune
        set: (value) ->
            return @parameters.detune if @parameters.detune is value
            @parameters.detune = value
            @component.detune.value = @parameters.detune
            return @parameters.detune

    @property 'q',
        get: ->
            return @parameters.q
        set: (value) ->
            return @parameters.q if @parameters.q is value
            @parameters.q = value
            @component.Q.value = @parameters.q
            return @parameters.q
