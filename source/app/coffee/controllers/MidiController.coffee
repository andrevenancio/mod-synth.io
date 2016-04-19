class MidiController

    constructor: ->
        @midi = null

        if !!window.navigator.requestMIDIAccess
            navigator.requestMIDIAccess()
                .then @onSuccess
                .catch @onError
        # else
        #    'Your browser doesn\'t support the Web MIDI API

    onSuccess: (midi) =>
        # 'Web MIDI API connected. inputs', midi.inputs.size, 'outputs', midi.outputs.size
        @midi = midi
        @midi.onstatechange = @onStateChange

        inputs = @midi.inputs.values()

        input = inputs.next()
        while input and !input.done
            input.value.onmidimessage = @onMIDIMessage
            input = inputs.next()
        null

    onError: (error) =>
        console.error error
        null

    onStateChange: (device) =>
        # 'state change', device.port.name, device.port.connection, device.port.state
        App.MIDI.dispatch { originalEvent: device, name: device.port.name, connection: device.port.connection, state: device.port.state }
        null

    onMIDIMessage: (e) =>
        cmd = e.data[0] >> 4
        channel = e.data[0] & 0xf
        note = e.data[1]
        velocity = e.data[2]
        controller = Session.MIDI[e.target.name]

        if channel is 9
            return

        if cmd is 8 || cmd is 9 && velocity is 0
            @noteOff note
        else if cmd is 9
            return if controller is undefined
            @noteOn note, velocity/127.0
        else if cmd is 11
            # make a mapping controller where user can device what button controls what
            return if controller is undefined
            # 'controller', note, velocity/127.0
        else if cmd is 14
            return if controller is undefined
            # 'pitch wheel', ((velocity * 128.0 + note)-8192)/8192.0
        else if cmd is 10
            return if controller is undefined
            # 'poly aftertouch', note, velocity/127.0
        else
            return if controller is undefined
            # e.data[0], e.data[1], e.data[2]
        null

    noteOn: (value, velocity) ->
        App.NOTE_ON.dispatch { note: value, velocity: velocity }
        null

    noteOff: (value) ->
        App.NOTE_OFF.dispatch { note: value }
        null
