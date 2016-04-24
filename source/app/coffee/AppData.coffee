class AppData

    # cookies
    @SHOW_TOUR: undefined
    @SHOW_KEYBOARD_PANNEL: undefined
    @SHOW_MENU_PANNEL: undefined
    @SHOW_LABELS: undefined

    # TOUR_MODE (necessary to avoid defaulting to Default patch in PatchesPannel)
    @TOUR_MODE: false

    # pixi
    @PIXI:
        renderer: null
        stage: null

    # preloaded assets
    @ASSETS: null

    # device pixel ratio
    @RATIO: if window.devicePixelRatio >= 2 then 2 else 1

    # canvas dimentions
    @WIDTH: 320 * @RATIO
    @HEIGHT: 240 * @RATIO

    # icon sizes
    @ICON_SIZE_1 = 48 * @RATIO
    @ICON_SIZE_2 = 32 * @RATIO
    @ICON_SIZE_3 = 72 * @RATIO

    @ICON_SPACE1 = 15 * @RATIO
    @ICON_SPACE2 = 50 * @RATIO
    @ICON_SPACE3 = 40 * @RATIO

    # padding
    @PADDING: 26 * @RATIO

    # minimap itens
    @MINIMAP: 4 * @RATIO

    # pannel sizes
    @SETTINGS_PANNEL_HEIGHT: 100 * @RATIO
    @KEYBOARD_PANNEL_HEIGHT: 326 * @RATIO
    @MENU_PANNEL: @ICON_SIZE_1 + @PADDING*2
    @MENU_PANNEL_BORDER: 4 * @RATIO
    @SUBMENU_PANNEL: 300 * @RATIO

    @KEYPRESS_ALLOWED: true

    # background color
    @BG: 0x191919

    # line color
    @LINE_COLOR: 0xffffff
    @LINE_ALPHA: 0.3

    @COMPONENTS:
        NSG: 0 # noise generator
        OSC: 1 # oscillator
        ENV: 2 # ADSR envelope
        FLT: 3 # filter
        PTG: 4 # pattern gate
        LFO: 5 # low frequency oscillator

    @TITLE: []
    @TITLE[@COMPONENTS.NSG] = 'NSG'
    @TITLE[@COMPONENTS.OSC] = 'OSC'
    @TITLE[@COMPONENTS.ENV] = 'ENV'
    @TITLE[@COMPONENTS.FLT] = 'FLT'
    @TITLE[@COMPONENTS.PTG] = 'PTG'
    @TITLE[@COMPONENTS.LFO] = 'LFO'

    @COLORS: []
    @COLORS[@COMPONENTS.NSG] = 0x00D8C7
    @COLORS[@COMPONENTS.OSC] = 0x4A00FF
    @COLORS[@COMPONENTS.ENV] = 0xD43557
    @COLORS[@COMPONENTS.FLT] = 0x0BD7E3
    @COLORS[@COMPONENTS.PTG] = 0x26E2A7
    @COLORS[@COMPONENTS.LFO] = 0xF21141

    @WAVE_TYPE:
        SINE: 0
        TRIANGLE: 1
        SQUARE: 2
        SAWTOOTH: 3

    @NOISE_TYPE:
        WHITE: 0
        PINK: 1
        BROWN: 2

    @OCTAVE_TYPE:
        THIRTY_TWO: 0
        SIXTEEN: 1
        EIGHT: 2
        FOUR: 3

    @FILTER_TYPE:
        LOWPASS: 0
        HIGHPASS: 1
        BANDPASS: 2
        LOWSHELF: 3
        HIGHSHELF: 4
        PEAKING: 5
        NOTCH: 6
        ALLPASS: 7

    @TEXTFORMAT:

        TEST_FONT_1:
            font: '20px sofia_prolight',
            fill: 'white'
            align: 'left'

        TEST_FONT_2:
            font: '20px letter_gothic_fsregular',
            fill: 'white'
            align: 'left'

        # 2X
        HINT:
            font: ( 20 * @RATIO ) + 'px sofia_prolight',
            fill: 'white'
            align: 'left'

        # 2X
        MENU:
            font: ( 24 * @RATIO ) + 'px sofia_prolight',
            fill: 'white'
            align: 'left'

        # 2X
        MENU_SMALL:
            font: ( 24 * @RATIO ) + 'px sofia_prolight',
            fill: 'white'
            align: 'center'

        # 2X
        PANNEL_TITLE:
            font: ( 40 * @RATIO ) + 'px sofia_prolight',
            fill: 'white'
            align: 'left'

        # 2X
        MENU_SUBTITLE:
            font: ( 28 * @RATIO ) + 'px sofia_prolight',
            fill: 'white'
            align: 'left'

        # 2X
        MENU_DESCRIPTION:
            font: ( 32 * @RATIO ) + 'px sofia_prolight',
            fill: 'white'
            align: 'left'
            wordWrap: true
            wordWrapWidth: @SUBMENU_PANNEL + @MENU_PANNEL + @PADDING

        # 2X
        SETTINGS_TITLE:
            font: ( 40 * @RATIO ) + 'px sofia_prolight',
            fill: 'white'
            align: 'left'

        # 2X
        SETTINGS_SMB:
            font: ( 32 * @RATIO ) + 'px sofia_prolight',
            fill: 'white'
            align: 'left'

        # 2X
        SETTINGS_LABEL:
            font: ( 24 * @RATIO ) + 'px sofia_prolight',
            fill: 'white'
            align: 'left'

        # 2X
        SETTINGS_PAD:
            font: ( 28 * @RATIO ) + 'px sofia_prolight',
            fill: 'white'
            align: 'left'

        # 2X
        SETTINGS_NUMBER:
            font: ( 64 * @RATIO ) + 'px letter_gothic_fsregular',
            fill: 'white'
            align: 'left'

        # 2X
        SETTINGS_NUMBER_POSTSCRIPT:
            font: ( 24 * @RATIO ) + 'px letter_gothic_fsregular',
            fill: 'white'
            align: 'left'

        # 2X
        PICKER:
            font: ( 44 * @RATIO ) + 'px letter_gothic_fsregular',
            fill: 'white'
            align: 'left'

        # 2X
        SOON:
            font: ( 30 * @RATIO ) + 'px sofia_prolight',
            fill: 'white'
            align: 'left'
