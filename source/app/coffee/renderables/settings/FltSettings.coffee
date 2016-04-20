# import renderables.elements.*
# import renderables.settings.SettingsBase
class FltSettings extends SettingsBase

    constructor: (@component_session_uid) ->
        super @component_session_uid

        # bypass
        @bypass = new Radio 'B'
        @bypass.buttonClick = @handleB
        @add @bypass

        # space
        @add new Spacer(AppData.ICON_SPACE2)

        # detune
        @detune = new Detune @component_session_uid
        @add @detune

        @add new Spacer(AppData.ICON_SPACE3)

        # Q
        @q = new Q @component_session_uid
        @add @q

        @add new Spacer(AppData.ICON_SPACE3)

        @filterTypes = new Filters @component_session_uid
        @add @filterTypes

        @add new Spacer(AppData.ICON_SPACE3)

        # frequency
        @frequency = new Frequency @component_session_uid
        @frequency.range.min = 0
        @frequency.range.max = 20000
        @add @frequency

        @adjustPosition()

    onSettingsChange: (event) =>
        if event.component is @component_session_uid
            @bypass.setActive Session.patch.presets[Session.patch.preset][@component_session_uid].bypass
        null

    handleB: =>
        Session.patch.presets[Session.patch.preset][@component_session_uid].bypass = !@bypass.active
        App.SETTINGS_CHANGE.dispatch { component: @component_session_uid }
        null
