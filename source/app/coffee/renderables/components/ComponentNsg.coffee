# import renderables.components.ComponentBase
class ComponentNsg extends ComponentBase

    constructor: (component_session_uid) ->
        super component_session_uid

        # textures
        @bg.texture = AppData.ASSETS.sprite.textures['comp-3-fill.png']
        @over.texture = AppData.ASSETS.sprite.textures['comp-3-ol.png']
        @icon.texture = AppData.ASSETS.sprite.textures['ic-noise-white-48.png']

        # title
        pos = AppData.ASSETS.sprite.data.frames['comp-3-fill.png'].sourceSize
        @label.anchor.x = 0.5
        @label.y = pos.h/-2 + 60*AppData.RATIO

        @icon.y = 30*AppData.RATIO

        @vertices = [
            { x: 0 * AppData.RATIO, y: -1.85 * AppData.RATIO },
            { x: 2.15 * AppData.RATIO, y: 1.85 * AppData.RATIO },
            { x: -2.15 * AppData.RATIO, y: 1.85 * AppData.RATIO }
        ]
        @change()

    change: ->
        if Session.SETTINGS[@component_session_uid].settings.mute is true
            @__color = 0x3C3C3C
            @__alpha = 0.2
        else if Session.SETTINGS[@component_session_uid].settings.mute is false
            @__color = AppData.COLORS[AppData.COMPONENTS.NSG]
            @__alpha = 1

        @label.alpha = @__alpha
        @icon.alpha = @__alpha
        @bg.tint = @__color
        @over.tint = 0xffffff

        switch Session.SETTINGS[@component_session_uid].settings.noise_type
            when AppData.NOISE_TYPE.WHITE then @icon.texture = AppData.ASSETS.sprite.textures['ic-noise-white-48.png']
            when AppData.NOISE_TYPE.PINK then @icon.texture = AppData.ASSETS.sprite.textures['ic-noise-pink-48.png']
            when AppData.NOISE_TYPE.BROWN then @icon.texture = AppData.ASSETS.sprite.textures['ic-noise-brown-48.png']
        null
