# import renderables.components.ComponentBase
class ComponentPtg extends ComponentBase

    constructor: (component_session_uid) ->
        super component_session_uid

        # textures
        @bg.texture = AppData.ASSETS.sprite.textures['comp-7-fill.png']
        @over.texture = AppData.ASSETS.sprite.textures['comp-7-ol.png']

        # title
        pos = AppData.ASSETS.sprite.data.frames['comp-7-fill.png'].sourceSize

        # label
        @label.anchor.x = 0.5
        @label.y = pos.h/-2 + 24*AppData.RATIO

        @graphics = new PIXI.Graphics()
        @graphics.x = AppData.ICON_SIZE_1/-2 + 4*AppData.RATIO
        @graphics.y = AppData.ICON_SIZE_1/-2 + 4*AppData.RATIO
        @graphics.hitArea = new PIXI.Rectangle 0, 0, 0, 0
        @front.addChild @graphics

        @vertices = [
            { x: 0 * AppData.RATIO, y: -2.0 * AppData.RATIO },
            { x: 1.63 * AppData.RATIO, y: -1.2 * AppData.RATIO },
            { x: 2.04 * AppData.RATIO, y: 0.6 * AppData.RATIO },
            { x: 0.9 * AppData.RATIO, y: 2.02 * AppData.RATIO },
            { x: -0.9 * AppData.RATIO, y: 2.02 * AppData.RATIO },
            { x: -2.04 * AppData.RATIO, y: 0.6 * AppData.RATIO },
            { x: -1.63 * AppData.RATIO, y: -1.2 * AppData.RATIO }
        ]

    onSettingsChange: (event) =>
        if event.component is @component_session_uid
            if Session.patch.presets[Session.patch.preset][@component_session_uid].bypass is true
                @__color = 0x3C3C3C
                @__alpha = 0.2
            else if Session.patch.presets[Session.patch.preset][@component_session_uid].bypass is false
                @__color = AppData.COLORS[AppData.COMPONENTS.PTG]
                @__alpha = 1

        @label.alpha = @__alpha
        @graphics.alpha = @__alpha

        @bg.tint = @__color

        @graphics.clear()
        index = 0
        for i in [0...4]
            for j in [0...4]
                @graphics.beginFill 0xffffff, if Session.patch.presets[Session.patch.preset][@component_session_uid].pattern[index] is true then 1 else 0.5
                @graphics.drawCircle (12 * j) * AppData.RATIO, (12 * i) * AppData.RATIO, 2 * AppData.RATIO
                @graphics.endFill()
                index++
        null
