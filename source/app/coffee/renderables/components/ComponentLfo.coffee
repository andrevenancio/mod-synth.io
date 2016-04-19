# import renderables.components.ComponentBase
class ComponentLfo extends ComponentBase

    constructor: (component_session_uid) ->
        super component_session_uid

        # textures
        @bg.texture = AppData.ASSETS.sprite.textures['comp-10-fill.png']
        @over.texture = AppData.ASSETS.sprite.textures['comp-10-ol.png']
        @icon.texture = AppData.ASSETS.sprite.textures['ic-wave-sine-48.png']

        # title
        pos = AppData.ASSETS.sprite.data.frames['comp-10-fill.png'].sourceSize
        @label.anchor.x = 0.5
        @label.y = pos.h/-2 + 24*AppData.RATIO

        @vertices = [
            { x: -0.65 * AppData.RATIO, y: -1.9 * AppData.RATIO },
            { x: 0.65 * AppData.RATIO, y: -1.9 * AppData.RATIO },
            { x: 1.63 * AppData.RATIO, y: -1.2 * AppData.RATIO },
            { x: 1.99 * AppData.RATIO, y: 0 * AppData.RATIO },
            { x: 1.63 * AppData.RATIO, y: 1.2 * AppData.RATIO },
            { x: 0.65 * AppData.RATIO, y: 1.91 * AppData.RATIO },
            { x: -0.65 * AppData.RATIO, y: 1.91 * AppData.RATIO },
            { x: -1.63 * AppData.RATIO, y: 1.2 * AppData.RATIO },
            { x: -1.99 * AppData.RATIO, y: 0 * AppData.RATIO },
            { x: -1.63 * AppData.RATIO, y: -1.2 * AppData.RATIO }
        ]

    onSettingsChange: (event) =>
        if event.component is @component_session_uid
            if Session.SETTINGS[@component_session_uid].settings.bypass is true
                @__color = 0x3C3C3C
                @__alpha = 0.2
            else if Session.SETTINGS[@component_session_uid].settings.bypass is false
                @__color = AppData.COLORS[AppData.COMPONENTS.LFO]
                @__alpha = 1

        @label.alpha = @__alpha

        @bg.tint = @__color

        switch Session.SETTINGS[@component_session_uid].settings.wave_type
            when AppData.WAVE_TYPE.SINE then @icon.texture = AppData.ASSETS.sprite.textures['ic-wave-sine-48.png']
            when AppData.WAVE_TYPE.TRIANGLE then @icon.texture = AppData.ASSETS.sprite.textures['ic-wave-tri-48.png']
            when AppData.WAVE_TYPE.SQUARE then @icon.texture = AppData.ASSETS.sprite.textures['ic-wave-sq-48.png']
            when AppData.WAVE_TYPE.SAWTOOTH then @icon.texture = AppData.ASSETS.sprite.textures['ic-wave-saw-48.png']
        null
