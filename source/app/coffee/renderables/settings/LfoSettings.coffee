# import renderables.elements.*
# import renderables.settings.SettingsBase
class LfoSettings extends SettingsBase

    constructor: (@component_session_uid) ->
        super @component_session_uid

        # bypass
        @bypass = new Radio 'B'
        @bypass.buttonClick = @handleB
        @add @bypass

        @add new Spacer(AppData.ICON_SPACE2)

        # type
        @type = new Waves @component_session_uid
        @add @type

        @add new Spacer(AppData.ICON_SPACE3)

        # frequency
        @frequency = new Frequency @component_session_uid
        @add @frequency

        @add new Spacer(AppData.ICON_SPACE3)

        # depth
        @depth = new Depth @component_session_uid
        @add @depth

        @adjustPosition()

    onSettingsChange: (event) =>
        if event.component is @component_session_uid
            @bypass.setActive Session.SETTINGS[@component_session_uid].settings.attack.bypass
        null

    handleB: =>
        Session.SETTINGS[@component_session_uid].settings.attack.bypass = !@bypass.active
        App.SETTINGS_CHANGE.dispatch { component: @component_session_uid }
        null
