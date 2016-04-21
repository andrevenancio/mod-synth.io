# import renderables.components.ComponentBase
class ComponentFlt extends ComponentBase

    constructor: (component_session_uid) ->
        super component_session_uid

        # textures
        @bg.texture = AppData.ASSETS.sprite.textures['comp-6-fill.png']
        @over.texture = AppData.ASSETS.sprite.textures['comp-6-ol.png']
        @icon.texture = AppData.ASSETS.sprite.textures['ic-comp-lpf-48.png']

        # title
        pos = AppData.ASSETS.sprite.data.frames['comp-6-fill.png'].sourceSize
        @label.anchor.x = 0.5
        @label.y = pos.h/-2 + 24*AppData.RATIO

        @vertices = [
            { x: -1.05 * AppData.RATIO, y: -1.83 * AppData.RATIO },
            { x: 1.05 * AppData.RATIO, y: -1.83 * AppData.RATIO },
            { x: 2.12 * AppData.RATIO, y: 0.02 * AppData.RATIO },
            { x: 1.05 * AppData.RATIO, y: 1.83 * AppData.RATIO },
            { x: -1.05 * AppData.RATIO, y: 1.83 * AppData.RATIO },
            { x: -2.12 * AppData.RATIO, y: 0.02 * AppData.RATIO }
        ]
        @change()

    change: ->
        if Session.SETTINGS[@component_session_uid].settings.bypass is true
            @__color = 0x3C3C3C
            @__alpha = 0.2
        else if Session.SETTINGS[@component_session_uid].settings.bypass is false
            @__color = AppData.COLORS[AppData.COMPONENTS.FLT]
            @__alpha = 1

        @label.alpha = @__alpha
        @bg.tint = @__color
        null
