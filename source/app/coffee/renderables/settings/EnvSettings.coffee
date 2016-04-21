# import renderables.elements.*
# import renderables.buttons.*
# import renderables.settings.SettingsBase
class EnvSettings extends SettingsBase

    constructor: (@component_session_uid) ->
        super @component_session_uid

        # bypass
        @bypass = new Radio 'B'
        @bypass.buttonClick = @handleB
        @add @bypass

        # space
        @add new Spacer(AppData.ICON_SPACE2)

        # attack
        @attack = new Attack @component_session_uid
        @attack.range.min = 0
        @attack.range.max = 2000
        @add @attack

        @add new Spacer(AppData.ICON_SPACE3)

        # decay
        @decay = new Decay @component_session_uid
        @decay.range.min = 0
        @decay.range.max = 2000
        @add @decay

        @add new Spacer(AppData.ICON_SPACE3)

        # sustain
        @sustain = new Sustain @component_session_uid
        @add @sustain

        @add new Spacer(AppData.ICON_SPACE3)

        # release
        @release = new Release @component_session_uid
        @release.range.min = 0
        @release.range.max = 2000
        @add @release

        @adjustPosition()

    onSettingsChange: (event) =>
        if event.component is @component_session_uid
            @bypass.setActive Session.SETTINGS[@component_session_uid].settings.attack.bypass
        null

    handleB: =>
        Session.SETTINGS[@component_session_uid].settings.attack.bypass = !@bypass.active
        App.SETTINGS_CHANGE.dispatch { component: @component_session_uid }
        null
