# import renderables.elements.*
# import renderables.settings.SettingsBase
class PtgSettings extends SettingsBase

    constructor: (@component_session_uid) ->
        super @component_session_uid

        # bypass
        @bypass = new Radio 'B'
        @bypass.buttonClick = @handleB
        @add @bypass

        # space
        @add new Spacer(AppData.ICON_SPACE2)

        # bpm
        @bmp = new Bpm @component_session_uid
        @add @bmp

        @add new Spacer(AppData.ICON_SPACE3)

        # pads
        @pads = new Pads @component_session_uid
        @add @pads

        @adjustPosition()
        @onResize()

    onResize: =>
        super()
        @pads.resize()
        null

    onSettingsChange: (event) =>
        if event.component is @component_session_uid
            @bypass.setActive Session.SETTINGS[@component_session_uid].settings.attack.bypass
        null

    handleB: =>
        Session.SETTINGS[@component_session_uid].settings.attack.bypass = !@bypass.active
        App.SETTINGS_CHANGE.dispatch { component: @component_session_uid }
        null
