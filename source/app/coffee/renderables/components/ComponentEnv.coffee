# import renderables.components.ComponentBase
class ComponentEnv extends ComponentBase

    constructor: (component_session_uid) ->
        super component_session_uid

        # textures
        @bg.texture = AppData.ASSETS.sprite.textures['comp-5-fill.png']
        @over.texture = AppData.ASSETS.sprite.textures['comp-5-ol.png']

        # title
        pos = AppData.ASSETS.sprite.data.frames['comp-5-fill.png'].sourceSize

        # label
        @label.anchor.x = 0.5
        @label.y = pos.h/-2 + 24*AppData.RATIO

        c = document.createElement 'canvas'
        c.width = AppData.ICON_SIZE_2*2
        c.height = AppData.ICON_SIZE_2*2
        @context = c.getContext '2d'

        @vertices = [
            { x: -0.0 * AppData.RATIO, y: -1.9 * AppData.RATIO },
            { x: 2.04 * AppData.RATIO, y: -0.35 * AppData.RATIO },
            { x: 1.25 * AppData.RATIO, y: 1.95 * AppData.RATIO },
            { x: -1.25 * AppData.RATIO, y: 1.95 * AppData.RATIO },
            { x: -2.04 * AppData.RATIO, y: -0.35 * AppData.RATIO }
        ]

    onSettingsChange: (event) =>
        if event.component is @component_session_uid
            if Session.patch.presets[Session.patch.preset][@component_session_uid].bypass is true
                @__color = 0x3C3C3C
                @__alpha = 0.2
                fillColor = 0x636363
            else if Session.patch.presets[Session.patch.preset][@component_session_uid].bypass is false
                @__color = AppData.COLORS[AppData.COMPONENTS.ENV]
                @__alpha = 1
                fillColor = 0xffffff

        @icon.alpha = @__alpha
        @label.alpha = @__alpha

        availableSustain = AppData.ICON_SIZE_2
        step = AppData.ICON_SIZE_2/4

        # ADSR graphic
        x0 = 0
        y0 = AppData.ICON_SIZE_2
        x1 = MathUtils.map(Session.patch.presets[Session.patch.preset][@component_session_uid].attack, 0, 1000, 0, step)
        y1 = 0
        availableSustain -= x1
        x2 = MathUtils.map(Session.patch.presets[Session.patch.preset][@component_session_uid].decay, 0, 1000, x1, x1 + step)
        y2 = MathUtils.map(Session.patch.presets[Session.patch.preset][@component_session_uid].sustain, 0, 100, AppData.ICON_SIZE_2, 0)
        availableSustain -= (x2-x1 + MathUtils.map(Session.patch.presets[Session.patch.preset][@component_session_uid].release, 0, 1000, 0, step))
        x3 = x2 + availableSustain
        y3 = y2
        x4 = MathUtils.map(Session.patch.presets[Session.patch.preset][@component_session_uid].release, 0, 1000, x3, x3 + step)
        y4 = AppData.ICON_SIZE_2

        # draw it to offscreen canvas
        ix = AppData.ICON_SIZE_2/2
        iy = AppData.ICON_SIZE_2/2

        @context.clearRect 0, 0, AppData.ICON_SIZE_2*2, AppData.ICON_SIZE_2*2
        @context.strokeStyle = '#ffffff';
        @context.lineWidth = 1.5 * AppData.RATIO
        @context.beginPath()
        @context.moveTo ix + x0, iy + y0
        @context.lineTo ix + x1, iy + y1
        @context.lineTo ix + x2, iy + y2
        @context.lineTo ix + x3, iy + y3
        @context.lineTo ix + x4, iy + y4
        @context.stroke()

        @icon.texture = PIXI.Texture.fromCanvas @context.canvas
        @icon.texture.update()
        @bg.tint = @__color
        null
