class Session

    @BPM: 104

    @OCTAVE: 0

    # default patch data
    @default: {
        uid: null
        name: null
        author: null
        author_name: null
        date: null
        preset: null
        presets: []
    }

    # current patch data
    @patch: {
        uid: null
        name: null
        author: null
        author_name: null
        date: null
        preset: null
        presets: []
    }

    @SETTINGS = {}

    # active midi inputs
    @MIDI: {}

    @ADD: (component) ->
        # component unique id
        id = component.component_session_uid || Services.GENERATE_UID(16)

        # assigns component to session settings
        Session.SETTINGS[id] = component

        # adds unique component session id
        Session.SETTINGS[id].component_session_uid = id

        # adds connections object (which only has objects on audioCapable devices)
        Session.SETTINGS[id].connections = {}

        # imports component settings if available
        Session.SETTINGS[id].settings = component.settings || {}

        # default X & Y
        Session.SETTINGS[id].x = if component.x isnt undefined then component.x else 0
        Session.SETTINGS[id].y = if component.y isnt undefined then component.y else 0

        if component.type_uid is AppData.COMPONENTS.NSG
            Session.SETTINGS[id].audioCapable          = true
            Session.SETTINGS[id].connections.ENV       = null
            Session.SETTINGS[id].connections.PTG       = null
            Session.SETTINGS[id].settings.solo         = if component.settings.solo isnt undefined then component.settings.solo else false
            Session.SETTINGS[id].settings.mute         = if component.settings.mute isnt undefined then component.settings.mute else false
            Session.SETTINGS[id].settings.volume       = if component.settings.volume isnt undefined then component.settings.volume else 0
            Session.SETTINGS[id].settings.noise_type   = if component.settings.noise_type isnt undefined then component.settings.noise_type else AppData.NOISE_TYPE.WHITE

        if component.type_uid is AppData.COMPONENTS.OSC
            Session.SETTINGS[id].audioCapable          = true
            Session.SETTINGS[id].connections.ENV       = null
            Session.SETTINGS[id].connections.PTG       = null
            Session.SETTINGS[id].settings.solo         = if component.settings.solo isnt undefined then component.settings.solo else false
            Session.SETTINGS[id].settings.mute         = if component.settings.mute isnt undefined then component.settings.mute else false
            Session.SETTINGS[id].settings.poly         = if component.settings.poly isnt undefined then component.settings.poly else true
            Session.SETTINGS[id].settings.volume       = if component.settings.volume isnt undefined then component.settings.volume else 0
            Session.SETTINGS[id].settings.wave_type    = if component.settings.wave_type isnt undefined then component.settings.wave_type else AppData.WAVE_TYPE.SINE
            Session.SETTINGS[id].settings.octave       = if component.settings.octave isnt undefined then component.settings.octave else AppData.OCTAVE_TYPE.EIGHT
            Session.SETTINGS[id].settings.detune       = if component.settings.detune isnt undefined then component.settings.detune else 0
            Session.SETTINGS[id].settings.portamento   = if component.settings.portamento isnt undefined then component.settings.portamento else 0

        if component.type_uid is AppData.COMPONENTS.ENV
            Session.SETTINGS[id].settings.bypass       = if component.settings.bypass isnt undefined then component.settings.bypass else false
            Session.SETTINGS[id].settings.attack       = if component.settings.attack isnt undefined then component.settings.attack else 0
            Session.SETTINGS[id].settings.decay        = if component.settings.decay isnt undefined then component.settings.decay else 0
            Session.SETTINGS[id].settings.sustain      = if component.settings.sustain isnt undefined then component.settings.sustain else 100
            Session.SETTINGS[id].settings.release      = if component.settings.release isnt undefined then component.settings.release else 500

        if component.type_uid is AppData.COMPONENTS.FLT
            Session.SETTINGS[id].settings.bypass       = if component.settings.bypass isnt undefined then component.settings.bypass else false
            Session.SETTINGS[id].settings.frequency    = if component.settings.frequency isnt undefined then component.settings.frequency else 350
            Session.SETTINGS[id].settings.detune       = if component.settings.detune isnt undefined then component.settings.detune else 0
            Session.SETTINGS[id].settings.q            = if component.settings.q isnt undefined then component.settings.q else 20
            Session.SETTINGS[id].settings.filter_type  = if component.settings.filter_type isnt undefined then component.settings.filter_type else AppData.FILTER_TYPE.LOWPASS

        if component.type_uid is AppData.COMPONENTS.PTG
            Session.SETTINGS[id].settings.bypass       = if component.settings.bypass isnt undefined then component.settings.bypass else false
            Session.SETTINGS[id].settings.pattern      = if component.settings.pattern isnt undefined then component.settings.pattern else [true, false, true, false, true, false, true, false, true, false, true, false, true, false, true, true]

        if component.type_uid is AppData.COMPONENTS.LFO
            Session.SETTINGS[id].settings.bypass       = if component.settings.bypass isnt undefined then component.settings.bypass else false
            Session.SETTINGS[id].settings.wave_type    = if component.settings.wave_type isnt undefined then component.settings.wave_type else AppData.WAVE_TYPE.SINE
            Session.SETTINGS[id].settings.frequency    = if component.settings.frequency isnt undefined then component.settings.frequency else 8
            Session.SETTINGS[id].settings.depth        = if component.settings.depth isnt undefined then component.settings.depth else 60

        return Session.SETTINGS[id]

    @GET: (component_session_uid) ->
        return Session.SETTINGS[component_session_uid]

    @HANDLE_SOLO: (component_session_uid) ->
        isSolo = !Session.SETTINGS[component_session_uid].settings.solo

        for component of Session.SETTINGS
            c = Session.SETTINGS[component]
            if c.type_uid is AppData.COMPONENTS.OSC or c.type_uid is AppData.COMPONENTS.NSG
                if c.component_session_uid is component_session_uid
                    c.settings.solo = !c.settings.solo
                    c.settings.mute = false
                else
                    c.settings.solo = false
                    c.settings.mute = if isSolo is true then true else false
                App.SETTINGS_CHANGE.dispatch { component: c.component_session_uid }
        null

    @DUPLICATE_OBJECT: (obj) ->
        return JSON.parse(JSON.stringify(obj))
