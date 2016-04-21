# import audio.core.Audio
# import audio.core.*
# import audio.components.*
class Instrument

    constructor: ->

        # master channel
        @master = new ChannelStrip()
        @master.connect Audio.CONTEXT.destination

        # channels
        @channels = []

        # components
        @components = []

        # add / remove signal
        App.ADD.add @onAdd
        App.REMOVE.add @onRemove

        # note on / off signal
        App.NOTE_ON.add @onNoteOn
        App.NOTE_OFF.add @onNoteOff

    onAdd: (data) =>
        Analytics.event 'component', 'add', data.type_uid
        @add data
        null

    onRemove: (data) =>
        Analytics.event 'component', 'remove', Session.SETTINGS[data.component_session_uid].type_uid
        @remove data
        null

    createChannelStrip: ->
        fader = new ChannelStrip()
        fader.connect @master.input
        return fader

    getNextAvailableChannelStrip: ->
        # returns next available channel strip
        if @channels.length is 0
            # if its the first channel in the array, add it
            available = @channels[0] = @createChannelStrip()
        else
            # check if there is any empty channel strip in between 0 and length
            for i in [0...@channels.length]
                channel = @channels[i]
                if not channel
                    available = @channels[i] = @createChannelStrip()
                    break

            # if there is, adds a new one
            if not available
                available = @channels[@channels.length] = @createChannelStrip()

        return available

    onNoteOn: (data) =>
        frequency = Audio.noteToFrequency data.note
        for i in [0...@components.length]
            component = @components[i]
            switch component.type_uid
                when AppData.COMPONENTS.OSC, AppData.COMPONENTS.NSG
                    component.start frequency
        null

    onNoteOff: (data) =>
        frequency = Audio.noteToFrequency data.note
        for i in [0...@components.length]
            component = @components[i]
            switch component.type_uid
                when AppData.COMPONENTS.OSC, AppData.COMPONENTS.NSG
                    component.stop frequency
        null


    add: (data) ->

        switch data.type_uid
            when AppData.COMPONENTS.NSG then component = new NoiseGenerator data
            when AppData.COMPONENTS.OSC then component = new Oscillator data
            when AppData.COMPONENTS.ENV then component = new Envelope data
            when AppData.COMPONENTS.FLT then component = new Flt data
            when AppData.COMPONENTS.PTG then component = new PatternGate data
            when AppData.COMPONENTS.LFO then component = new Lfo data

        if component
            if data.audioCapable
                component.connect @getNextAvailableChannelStrip().input

            @attachToAUX component
            @components.push component
        null

    remove: (data) ->
        App.TOGGLE_SETTINGS_PANNEL_HEIGHT.dispatch { type: false }
        for i in [0...@components.length]
            component = @components[i]

            if component.component_session_uid is data.component_session_uid
                component.destroy()
                delete Session.SETTINGS[data.component_session_uid]

                @detachFromAUX component

                @components.splice i, 1
                @channels.splice i, 1
                break
        null

    detachFromAUX: (component) ->
        type = component.type_uid
        uid = component.component_session_uid

        for i in [0...@components.length]
            cur_type = @components[i].type_uid
            if type is AppData.COMPONENTS.ENV
                if cur_type is AppData.COMPONENTS.OSC or cur_type is AppData.COMPONENTS.NSG
                    @components[i].ENV = null
                    Session.SETTINGS[@components[i].component_session_uid].connections.ENV = null
            if type is AppData.COMPONENTS.PTG
                if cur_type is AppData.COMPONENTS.OSC or cur_type is AppData.COMPONENTS.NSG
                    @components[i].PTG = null
                    Session.SETTINGS[@components[i].component_session_uid].connections.PTG = null
            if type is AppData.COMPONENTS.LFO
                if cur_type is AppData.COMPONENTS.OSC or cur_type is AppData.COMPONENTS.NSG
                    @components[i].LFO = null
                    Session.SETTINGS[@components[i].component_session_uid].connections.LFO = null
            if type is AppData.COMPONENTS.FLT
                if cur_type is AppData.COMPONENTS.OSC or cur_type is AppData.COMPONENTS.NSG
                    @components[i].FLT = null
                    Session.SETTINGS[@components[i].component_session_uid].connections.FLT = null
        null

    attachToAUX: (component) ->
        type = component.type_uid
        uid = component.component_session_uid

        for i in [0...@components.length]
            cur_type = @components[i].type_uid
            # ENV is added, checks for OSC and NSG
            if type is AppData.COMPONENTS.ENV
                if cur_type is AppData.COMPONENTS.OSC or cur_type is AppData.COMPONENTS.NSG
                    # if there's already an envelope disconnect the old one
                    if @components[i].ENV
                        @components[i].ENV.disconnect()
                    # 'you are adding a ENV and there\'s already a OSC'
                    @components[i].ENV = component
                    # adds reference to Session
                    Session.SETTINGS[@components[i].component_session_uid].connections.ENV = component.component_session_uid

            # PTG is added, checks for OSC and NSG
            if type is AppData.COMPONENTS.PTG
                if cur_type is AppData.COMPONENTS.OSC or cur_type is AppData.COMPONENTS.NSG
                    if @components[i].PTG
                        @components[i].PTG.disconnect()
                    # 'you are adding a PTG and there\'s already a OSC'
                    @components[i].PTG = component
                    Session.SETTINGS[@components[i].component_session_uid].connections.PTG = component.component_session_uid

            # LFO is added, checks for OSC and NSG
            if type is AppData.COMPONENTS.LFO
                if cur_type is AppData.COMPONENTS.OSC or cur_type is AppData.COMPONENTS.NSG
                    if @components[i].LFO
                        @components[i].LFO.disconnect()
                    # 'you are adding a LFO and there\'s already a OSC'
                    @components[i].LFO = component
                    Session.SETTINGS[@components[i].component_session_uid].connections.LFO = component.component_session_uid

            # FLT is added, checks for OSC and NSG
            if type is AppData.COMPONENTS.FLT
                if cur_type is AppData.COMPONENTS.OSC or cur_type is AppData.COMPONENTS.NSG
                    if @components[i].FLT
                        @components[i].FLT.disconnect()
                    # 'you are adding a FLT and there\'s already a OSC'
                    @components[i].FLT = component
                    Session.SETTINGS[@components[i].component_session_uid].connections.FLT = component.component_session_uid

            # OSC or NSG is added, checks for ENV
            if type is AppData.COMPONENTS.OSC or type is AppData.COMPONENTS.NSG
                if cur_type is AppData.COMPONENTS.ENV
                    if component.ENV
                        component.ENV.disconnect()
                    # 'you are adding a OSC and there\'s already a ENV'
                    component.ENV = @components[i]
                    Session.SETTINGS[component.component_session_uid].connections.ENV = @components[i].component_session_uid

            # OSC or NSG is added, checks for PTG
            if type is AppData.COMPONENTS.OSC or type is AppData.COMPONENTS.NSG
                if cur_type is AppData.COMPONENTS.PTG
                    if component.PTG
                        component.PTG.disconnect()
                    # 'you are adding a OSC and there\'s already a PTG'
                    component.PTG = @components[i]
                    Session.SETTINGS[component.component_session_uid].connections.PTG = @components[i].component_session_uid

            # OSC or NSG is added, checks for LFO
            if type is AppData.COMPONENTS.OSC or type is AppData.COMPONENTS.NSG
                if cur_type is AppData.COMPONENTS.LFO
                    if component.LFO
                        component.LFO.disconnect()
                    # 'you are adding a OSC and there\'s already a LFO'
                    component.LFO = @components[i]
                    Session.SETTINGS[component.component_session_uid].connections.LFO = @components[i].component_session_uid

            # OSC or NSG is added, checks for FLT
            if type is AppData.COMPONENTS.OSC or type is AppData.COMPONENTS.NSG
                if cur_type is AppData.COMPONENTS.FLT
                    if component.FLT
                        component.FLT.disconnect()
                    # 'you are adding a OSC and there\'s already a FLT'
                    component.FLT = @components[i]
                    Session.SETTINGS[component.component_session_uid].connections.FLT = @components[i].component_session_uid
        null
