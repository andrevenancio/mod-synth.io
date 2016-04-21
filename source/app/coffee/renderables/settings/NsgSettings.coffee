# import renderables.elements.*
# import renderables.settings.SettingsBase
class NsgSettings extends SettingsBase

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

        # space
        @add new Spacer(AppData.ICON_SPACE2)

        # type
        @type = new Noises @component_session_uid
        @add @type

        @add new Spacer(AppData.ICON_SPACE3)

        # volume
        @volume = new Volume @component_session_uid
        @add @volume

        @adjustPosition()

    onSettingsChange: (event) =>
        if event.component is @component_session_uid
            @solo.setActive Session.SETTINGS[@component_session_uid].settings.solo
            @mute.setActive Session.SETTINGS[@component_session_uid].settings.mute
        null

    handleS: =>
        Session.HANDLE_SOLO @component_session_uid
        null

    handleM: =>
        return if Session.SETTINGS[@component_session_uid].settings.solo is true
        Session.SETTINGS[@component_session_uid].settings.mute = !@mute.active
        App.SETTINGS_CHANGE.dispatch { component: @component_session_uid }
        null
