# TODO: http://stackoverflow.com/questions/20287890/audiocontext-panning-audio-of-playing-media
class ChannelStrip

    constructor: ->

        # channel strip output
        @output = Audio.CONTEXT.createGain()
        @output.gain.value = 0.4

        # channel strip input
        @input = Audio.CONTEXT.createGain()
        @input.connect @output
        # @setVolume 0.8

    setVolume: (value, linear=false) ->
        volume = value

        if not linear
            volume = Math.pow(volume/1, 2)

        if @input
            @input.gain.value = volume
        null

    connect: (otherDeviceInput) ->
        @output.connect otherDeviceInput
        null

    disconnect: ->
        @output.disconnect()
        null
