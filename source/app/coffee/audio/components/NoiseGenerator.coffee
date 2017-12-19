# import audio.components.Component
class NoiseGenerator extends Component

    constructor: (data) ->
        super data

        @parameters.type = Audio.NOISE_TYPE[data.settings.noise_type]

        @envelope = Audio.CONTEXT.createGain()
        @envelope.gain.setValueAtTime 0.0, Audio.CONTEXT.currentTime
        @envelope.connect @pre

        @buffer = @getWhite()
        @create()

        App.SETTINGS_CHANGE.add @onSettingsChange

    destroy: ->
        @generator.stop 0
        @output.gain.setValueAtTime 0.0, Audio.CONTEXT.currentTime
        @generator = null
        null

    create: ->
        @generator = Audio.CONTEXT.createBufferSource()
        @generator.buffer = @buffer
        @generator.loop = true
        @generator.start 0
        @generator.connect @envelope
        null

    onSettingsChange: (event) =>
        if event.component is @component_session_uid
            @type = Audio.NOISE_TYPE[Session.SETTINGS[@component_session_uid].settings.noise_type]
            @setVolume MathUtils.map(Session.SETTINGS[@component_session_uid].settings.volume,  -60, 0, 0, 1)
        null

    start: (frequency) ->
        @checkAUX()

        now = Audio.CONTEXT.currentTime
        envAttackEnd = now + @attack/1000.0

        @active.push frequency

        @envelope.attackStart = now
        @envelope.attackEnd = envAttackEnd
        @envelope.gain.cancelScheduledValues now
        @envelope.gain.setValueAtTime 0.0, now
        if Session.SETTINGS[@component_session_uid].settings.mute is false
            @envelope.gain.linearRampToValueAtTime 1.0, envAttackEnd
            @envelope.gain.setTargetAtTime (@sustain*1.0)/100.0, envAttackEnd, (@decay/1000.0)+0.001
        null

    stop: (frequency) ->
        index = @active.indexOf frequency

        if index isnt -1
            @checkAUX()
            @active.splice index, 1

            now = Audio.CONTEXT.currentTime
            release = now + (@release/1000.0)

            if @active.length is 0
                rampValue = @getRampValue(0, 1, @envelope.attackStart, @envelope.attackEnd, now)
                if Session.SETTINGS[@component_session_uid].settings.mute is true
                    rampValue = 0
                @envelope.gain.cancelScheduledValues now
                @envelope.gain.setValueAtTime rampValue, now
                @envelope.gain.linearRampToValueAtTime 0, release
        null

    getWhite: ->
        bufferSize = 2 * Audio.CONTEXT.sampleRate
        buffer = Audio.CONTEXT.createBuffer 1, bufferSize, Audio.CONTEXT.sampleRate
        output = buffer.getChannelData 0
        for i in [0...bufferSize]
            white = Math.random() * 2 - 1
            output[i] = white
        return buffer

    getPink: ->
        b0 = b1 = b2 = b3 = b4 = b5 = b6 = 0.0
        bufferSize = 2 * Audio.CONTEXT.sampleRate
        buffer = Audio.CONTEXT.createBuffer 1, bufferSize, Audio.CONTEXT.sampleRate
        output = buffer.getChannelData 0
        for i in [0...bufferSize]
            white = Math.random() * 1 - 0.5
            b0 = 0.99886 * b0 + white * 0.0555179
            b1 = 0.99332 * b1 + white * 0.0750759
            b2 = 0.96900 * b2 + white * 0.1538520
            b3 = 0.86650 * b3 + white * 0.3104856
            b4 = 0.55000 * b4 + white * 0.5329522
            b5 = -0.7616 * b5 - white * 0.0168980

            output[i] = b0 + b1 + b2 + b3 + b4 + b5 + b6 + white * 0.5362
            output[i] *= 0.11
            b6 = white * 0.115926
        return buffer

    getBrown: ->
        lastOut = 0.0
        bufferSize = 2 * Audio.CONTEXT.sampleRate
        buffer = Audio.CONTEXT.createBuffer 1, bufferSize, Audio.CONTEXT.sampleRate
        output = buffer.getChannelData 0
        for i in [0...bufferSize]
            white = Math.random() * 1 - 0.5
            output[i] = (lastOut + (0.02 * white)) / 1.02
            lastOut = output[i]
            output[i] *= 3.5
        return buffer

    @property 'type',
        get: ->
            return @parameters.type
        set: (value) ->
            return @parameters.type if @parameters.type is value

            @parameters.type = value

            switch @parameters.type
                when Audio.NOISE_TYPE[AppData.NOISE_TYPE.PINK] then @buffer = @getPink()
                when Audio.NOISE_TYPE[AppData.NOISE_TYPE.BROWN] then @buffer = @getBrown()
                else
                    @buffer = @getWhite()

            @destroy()
            @create()
            return @parameters.type
