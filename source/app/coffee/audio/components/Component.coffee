class Component

    constructor: (data) ->

        @component_session_uid = data.component_session_uid
        @type_uid = data.type_uid

        @output = Audio.CONTEXT.createGain()

        # check if is audioCapable
        @aux = Audio.CONTEXT.createGain()
        @aux.gain.setValueAtTime 1.0, Audio.CONTEXT.currentTime
        @aux.connect @output

        # used to change stuff
        @pre = Audio.CONTEXT.createGain()
        @pre.gain.setValueAtTime 1.0, Audio.CONTEXT.currentTime
        @pre.connect @aux

        if data.audioCapable
            @attack = 0.0
            @decay = 0.0
            @sustain = 100.0
            @release = 0.0

            @ENV = null
            @PTG = null
            @LFO = null
            @FLT = null

        # specific device params
        @parameters = {}

        # active notes on components who can create audio
        @active = []

    connect: (input) ->
        if input instanceof GainNode or input instanceof AudioDestinationNode
            @output.connect input
        else
            @disconnect()
            console.log 'You can only connect to GainNode or AudioDestinationNode.'
        null

    disconnect: ->
        @output.disconnect()
        null

    destroy: ->
        @disconnect()
        null

    setVolume: (value, linear=false) ->
        volume = value

        if not linear
            volume = Math.pow(value/1, 2)

        if @output
            @output.gain.setValueAtTime volume, Audio.CONTEXT.currentTime
        null

    # returns current ramp value
    # useful when you call cancelScheduledValues() which destroys any ramp.
    getRampValue: (start, end, fromTime, toTime, at) ->
        difference = end - start
        time = toTime - fromTime
        truncateTime = at - fromTime
        phase = truncateTime / time
        v = start + phase * difference

        if v <= start
            v = start
        if v >= end
            v = end

        return v

    checkAUX: ->
        # check for ENV
        if @ENV isnt null and Session.SETTINGS[@ENV.component_session_uid].settings.bypass isnt true
            @attack = @ENV.parameters.attack
            @decay = @ENV.parameters.decay
            @sustain = @ENV.parameters.sustain
            @release = @ENV.parameters.release
        else
            @attack = 0
            @decay = 0
            @sustain = 100
            @release = 0

        # check for LFO
        if @LFO isnt null and Session.SETTINGS[@LFO.component_session_uid].settings.bypass isnt true
            @LFO.aux.connect @aux.gain
        else
            if @LFO
                @LFO.aux.disconnect()

        # check for LFO
        if @FLT isnt null and Session.SETTINGS[@FLT.component_session_uid].settings.bypass isnt true
            @pre.disconnect()

            @FLT.component.connect @aux
            @pre.connect @FLT.component
        else
            if @FLT
                @FLT.disconnect()
            @pre.disconnect()
            @pre.connect @aux

        # check for PTG
        if @PTG isnt null and Session.SETTINGS[@PTG.component_session_uid].settings.bypass isnt true
            @PTG.aux = @aux
        else
            if @PTG
                @PTG.disconnect()
        null
