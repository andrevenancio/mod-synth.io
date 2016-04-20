# import renderables.components.ComponentBase
class ComponentOsc extends ComponentBase

    constructor: (component_session_uid) ->
        super component_session_uid

        # textures
        @bg.texture = AppData.ASSETS.sprite.textures['comp-4-fill.png']
        @over.texture = AppData.ASSETS.sprite.textures['comp-4-ol.png']
        @icon.texture = AppData.ASSETS.sprite.textures['ic-wave-sine-48.png']

        # title
        pos = AppData.ASSETS.sprite.data.frames['comp-4-fill.png'].sourceSize
        @label.x = pos.w/-2 + 24*AppData.RATIO
        @label.y = pos.h/-2 + 24*AppData.RATIO

        @vertices = [
            { x: -1.8 * AppData.RATIO, y: -1.8 * AppData.RATIO },
            { x: 1.8 * AppData.RATIO, y: -1.8 * AppData.RATIO },
            { x: 1.8 * AppData.RATIO, y: 1.8 * AppData.RATIO },
            { x: -1.8 * AppData.RATIO, y: 1.8 * AppData.RATIO }
        ]

    onSettingsChange: (event) =>
        if event.component is @component_session_uid
            if Session.patch.presets[Session.patch.preset][@component_session_uid].mute is true
                @__color = 0x3C3C3C
                @__alpha = 0.2
            else if Session.patch.presets[Session.patch.preset][@component_session_uid].mute is false
                @__color = AppData.COLORS[AppData.COMPONENTS.OSC]
                @__alpha = 1

        @label.alpha = @__alpha
        @icon.alpha = @__alpha
        @bg.tint = @__color
        @over.tint = 0xffffff

        switch Session.patch.presets[Session.patch.preset][@component_session_uid].wave_type
            when AppData.WAVE_TYPE.SINE then @icon.texture = AppData.ASSETS.sprite.textures['ic-wave-sine-48.png']
            when AppData.WAVE_TYPE.TRIANGLE then @icon.texture = AppData.ASSETS.sprite.textures['ic-wave-tri-48.png']
            when AppData.WAVE_TYPE.SQUARE then @icon.texture = AppData.ASSETS.sprite.textures['ic-wave-sq-48.png']
            when AppData.WAVE_TYPE.SAWTOOTH then @icon.texture = AppData.ASSETS.sprite.textures['ic-wave-saw-48.png']
        null
