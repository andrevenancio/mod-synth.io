# import audio.components.Component
class Oscillator extends Component

    constructor: (data) ->
        super data

        @parameters.type = Audio.WAVE_TYPE[data.settings.wave_type]
        @parameters.detune =  0.0
        @parameters.octave =  1.0
        @parameters.portamento = 0.0
        @parameters.poly = false

        @activeOscillators = []

        App.SETTINGS_CHANGE.add @onSettingsChange

    destroy: ->
        for i in [0...@activeOscillators.length]
            @activeOscillators[0].stop 0
            @activeOscillators.splice 0, 1
        @active = []
        null

    create: (frequency) ->
        now = Audio.CONTEXT.currentTime
        envAttackEnd = now + @attack/1000.0

        # create note on off gain
        nofg = Audio.CONTEXT.createGain()
        nofg.connect @pre
        nofg.gain.value = 0.0

        oscillator = Audio.CONTEXT.createOscillator()
        oscillator.type = @parameters.type
        oscillator.originalFrequency = frequency
        oscillator.nofg = nofg
        oscillator.frequency.cancelScheduledValues now
        oscillator.frequency.setTargetAtTime frequency * @parameters.octave * Audio.CUR_OCTAVE[Audio.OCTAVE_STEP], 0, @parameters.portamento / 1000.0
        oscillator.detune.setValueAtTime @parameters.detune, 0
        oscillator.connect nofg
        oscillator.start now

        nofg.attackStart = now
        nofg.attackEnd = envAttackEnd
        nofg.gain.cancelScheduledValues now
        nofg.gain.setValueAtTime 0.0, now
        if Session.SETTINGS[@component_session_uid].settings.mute is false
            nofg.gain.linearRampToValueAtTime 1.0, envAttackEnd
            nofg.gain.setTargetAtTime (@sustain*1.0)/100.0, envAttackEnd, (@decay/1000.0)+0.001

        return oscillator

    onSettingsChange: (event) =>
        if event.component is @component_session_uid
            @poly = Session.SETTINGS[@component_session_uid].settings.poly
            @type = Audio.WAVE_TYPE[Session.SETTINGS[@component_session_uid].settings.wave_type]
            @detune = Session.SETTINGS[@component_session_uid].settings.detune
            @octave = Audio.OCTAVE[Session.SETTINGS[@component_session_uid].settings.octave]
            @portamento = Session.SETTINGS[@component_session_uid].settings.portamento
            @setVolume MathUtils.map(Session.SETTINGS[@component_session_uid].settings.volume,  -60, 0, 0, 1)

        # if there is a settings change of a component in AUX
        if @ENV or @FLT or @PTG or @LFO
            if @LFO and event.component is @LFO.component_session_uid
                @checkAUX()
        null

    start: (frequency) ->
        # return if Session.SETTINGS[@component_session_uid].settings.mute is true
        @checkAUX()

        now = Audio.CONTEXT.currentTime

        @active.push frequency
        if @parameters.poly or @activeOscillators.length is 0
            @activeOscillators.push @create(frequency)
        else
            # frequency
            @activeOscillators[0].frequency.cancelScheduledValues now
            @activeOscillators[0].frequency.setTargetAtTime frequency * @parameters.octave * Audio.CUR_OCTAVE[Audio.OCTAVE_STEP], 0, @parameters.portamento / 1000.0
        null

    stop: (frequency) ->
        index = @active.indexOf frequency
        if index isnt -1
            @checkAUX()

            now = Audio.CONTEXT.currentTime
            release = now + (@release/1000.0)

            @active.splice index, 1

            if @parameters.poly is true or @active.length is 0
                rampValue = @getRampValue(0, 1, @activeOscillators[index].nofg.attackStart, @activeOscillators[index].nofg.attackEnd, now)
                if Session.SETTINGS[@component_session_uid].settings.mute is true
                    rampValue = 0
                @activeOscillators[index].nofg.gain.cancelScheduledValues now
                @activeOscillators[index].nofg.gain.setValueAtTime rampValue, now
                @activeOscillators[index].nofg.gain.linearRampToValueAtTime 0, release

                @activeOscillators[index].stop release
                @activeOscillators.splice index, 1
                null
            else
                @activeOscillators[0].frequency.cancelScheduledValues now
                @activeOscillators[0].frequency.setTargetAtTime @active[@active.length-1] * @parameters.octave, 0, @parameters.portamento / 1000
        null

    @property 'type',
        get: ->
            return @parameters.type
        set: (value) ->
            return @parameters.type if @parameters.type is value
            @parameters.type = value
            for i in [0...@activeOscillators.length]
                @activeOscillators[i].type = @parameters.type
            return @parameters.type

    @property 'detune',
        get: ->
            return @parameters.detune
        set: (value) ->
            return @parameters.detune if @parameters.detune is value
            @parameters.detune = value
            for i in [0...@activeOscillators.length]
                @activeOscillators[i].detune.setValueAtTime @parameters.detune, 0
            return @parameters.detune

    @property 'octave',
        get: ->
            return @parameters.octave
        set: (value) ->
            return @parameters.octave if @parameters.octave is value
            @parameters.octave = value

            # loop through all oscillators and update value
            for i in [0...@activeOscillators.length]
                osc = @activeOscillators[i]
                osc.frequency.setValueAtTime osc.originalFrequency*@parameters.octave, 0

            return @parameters.octave

    @property 'portamento',
        get: ->
            return @parameters.portamento
        set: (value) ->
            return @parameters.portamento if @parameters.portamento is value
            @parameters.portamento = value
            return @parameters.portamento

    @property 'poly',
        get: ->
            return @parameters.poly
        set: (value) ->
            return @parameters.poly if @parameters.poly is value
            @parameters.poly = value
            @destroy()
            return @parameters.poly
