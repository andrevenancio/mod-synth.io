class Audio

    # stats
    @STATS:
        ChannelStrip: 0
        Oscillator: 0
        NoiseGenerator: 0

    # audio context
    @CONTEXT: new (window.AudioContext || window.webkitAudioContext)()

    # wave type
    @WAVE_TYPE = []
    @WAVE_TYPE[AppData.WAVE_TYPE.SINE] = 'sine'
    @WAVE_TYPE[AppData.WAVE_TYPE.TRIANGLE] = 'triangle'
    @WAVE_TYPE[AppData.WAVE_TYPE.SQUARE] = 'square'
    @WAVE_TYPE[AppData.WAVE_TYPE.SAWTOOTH] = 'sawtooth'

    # octave
    @OCTAVE = []
    @OCTAVE[AppData.OCTAVE_TYPE.THIRTY_TWO] = 0.5
    @OCTAVE[AppData.OCTAVE_TYPE.SIXTEEN] = 1
    @OCTAVE[AppData.OCTAVE_TYPE.EIGHT] = 2
    @OCTAVE[AppData.OCTAVE_TYPE.FOUR] = 3

    # noise
    @NOISE_TYPE = []
    @NOISE_TYPE[AppData.NOISE_TYPE.WHITE] = 0
    @NOISE_TYPE[AppData.NOISE_TYPE.PINK] = 1
    @NOISE_TYPE[AppData.NOISE_TYPE.BROWN] = 2

    # filter
    @FILTER_TYPE = []
    @FILTER_TYPE[AppData.FILTER_TYPE.LOWPASS] = 'lowpass'
    @FILTER_TYPE[AppData.FILTER_TYPE.HIGHPASS] = 'highpass'
    @FILTER_TYPE[AppData.FILTER_TYPE.BANDPASS] = 'bandpass'
    @FILTER_TYPE[AppData.FILTER_TYPE.LOWSHELF] = 'lowshelf'
    @FILTER_TYPE[AppData.FILTER_TYPE.HIGHSHELF] = 'highshelf'
    @FILTER_TYPE[AppData.FILTER_TYPE.PEAKING] = 'peaking'
    @FILTER_TYPE[AppData.FILTER_TYPE.NOTCH] = 'notch'
    @FILTER_TYPE[AppData.FILTER_TYPE.ALLPASS] = 'allpass'

    @OCTAVE_STEP: 3
    @CUR_OCTAVE: [0.125, 0.25, 0.5, 1, 2, 4, 8]

    # note to frequency
    @noteToFrequency: (note)  ->
        #global keyboard octave!
        frequency = 440.0 * Math.pow( 2, ( note - 69 ) / 12 )
        return frequency
