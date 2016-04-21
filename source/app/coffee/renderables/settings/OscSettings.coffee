# import renderables.elements.*
# import renderables.buttons.*
# import renderables.settings.SettingsBase
class OscSettings extends SettingsBase

    constructor: (@component_session_uid) ->
        super @component_session_uid

        # solo
        @solo = new Radio 'S'
        @solo.buttonClick = @handleS
        @add @solo

        @add new Spacer(AppData.ICON_SPACE1)

        # mute
        @mute = new Radio 'M'
        @mute.buttonClick = @handleM
        @add @mute

        @add new Spacer(AppData.ICON_SPACE1)

        # polyphonic
        @poly = new Poly()
        @poly.buttonClick = @handleP
        @add @poly

        # space
        @add new Spacer(AppData.ICON_SPACE2)

        # wave type
        @type = new Waves @component_session_uid
        @add @type

        @add new Spacer(AppData.ICON_SPACE3)

        # octave
        @octave = new Octave @component_session_uid
        @add @octave

        @add new Spacer(AppData.ICON_SPACE3)

        # portamento
        @portamento = new Portamento @component_session_uid
        @add @portamento

        @add new Spacer(AppData.ICON_SPACE3)

        # detune
        @detune = new Detune @component_session_uid
        @add @detune

        @add new Spacer(AppData.ICON_SPACE3)

        # volume
        @volume = new Volume @component_session_uid
        @add @volume

        @adjustPosition()

    onSettingsChange: (event) =>
        if event.component is @component_session_uid
            @solo.setActive Session.SETTINGS[@component_session_uid].settings.solo
            @mute.setActive Session.SETTINGS[@component_session_uid].settings.mute
            @poly.setActive Session.SETTINGS[@component_session_uid].settings.poly
        null

    handleS: =>
        Session.HANDLE_SOLO @component_session_uid
        null

    handleM: =>
        return if Session.SETTINGS[@component_session_uid].settings.solo is true
        Session.SETTINGS[@component_session_uid].settings.mute = !@mute.active
        App.SETTINGS_CHANGE.dispatch { component: @component_session_uid }
        null

    handleP: =>
        Session.SETTINGS[@component_session_uid].settings.poly = !@poly.active
        App.SETTINGS_CHANGE.dispatch { component: @component_session_uid }
        null
