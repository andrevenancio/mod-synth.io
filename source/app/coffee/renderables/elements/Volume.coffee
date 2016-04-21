# import renderables.buttons.Slider
class Volume extends Slider

    constructor: (@component_session_uid) ->
        super()

        App.SETTINGS_CHANGE.add @onSettingsChange

        @range = {
            min: -60,
            max: 0
        }

        @percentage = MathUtils.map(Session.SETTINGS[@component_session_uid].settings.volume, @range.min, @range.max, 0, 100, true)

        @title = new PIXI.Text 'VOLUME', AppData.TEXTFORMAT.SETTINGS_LABEL
        @title.scale.x = @title.scale.y = 0.5
        @title.anchor.x = 0.5
        @title.x = AppData.ICON_SIZE_1 / 2
        @title.hitArea = new PIXI.Rectangle(0, 0, 0, 0);
        @title.tint = 0x646464
        @addChild @title

        @value = new PIXI.Text '', AppData.TEXTFORMAT.SETTINGS_NUMBER
        @value.scale.x = @value.scale.y = 0.5
        @value.anchor.x = 0.5
        @value.anchor.y = 1
        @value.x = AppData.ICON_SIZE_1 / 2
        @value.y = AppData.ICON_SIZE_1 + 6 * AppData.RATIO
        @addChild @value

        @unit = new PIXI.Text 'dB', AppData.TEXTFORMAT.SETTINGS_NUMBER_POSTSCRIPT
        @unit.scale.x = @unit.scale.y = 0.5
        @unit.y = 17 * AppData.RATIO
        @unit.hitArea = new PIXI.Rectangle(0, 0, 0, 0);
        @addChild @unit

        @icon = new PIXI.Sprite AppData.ASSETS.sprite.textures['ic-vol-inf-48.png']
        @icon.visible = false
        @icon.scale.x = @icon.scale.y = 0.5
        @icon.anchor.x = @icon.anchor.y = 0.5
        @icon.x = AppData.ICON_SIZE_1 / 2
        @icon.y = 34 * AppData.RATIO
        @addChild @icon

    onEnd: (e) =>
        super e
        if @lastValue is @percentage
            value = 100/(@range.max-@range.min)
            @percentage += value
            if @percentage >= value*(@range.max-@range.min)
                @percentage = 0
            @onUpdate()
        null

    onSettingsChange: (event) =>
        if event.component is @component_session_uid
            switch Session.SETTINGS[@component_session_uid].settings.volume
                when @range.min
                    @value.text = '-  '
                    @icon.visible = true
                    @unit.x = @icon.x + @icon.width
                else
                    @value.text = Session.SETTINGS[@component_session_uid].settings.volume
                    @icon.visible = false
                    @unit.x = @value.x + @value.width / 2
        null

    onUpdate: ->
        Session.SETTINGS[@component_session_uid].settings.volume = MathUtils.map(@percentage, 0, 100, @range.min, @range.max, true)
        App.SETTINGS_CHANGE.dispatch { component: @component_session_uid }
        null
