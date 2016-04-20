# import renderables.menu.Pannel
class PresetsPannel extends Pannel

    constructor: (label) ->
        super label

        @title = new PIXI.Text 'PRESETS', AppData.TEXTFORMAT.MENU_SUBTITLE
        @title.tint = 0x646464
        @title.scale.x = @title.scale.y = 0.5
        @title.position.x = AppData.PADDING
        @title.position.y = AppData.MENU_PANNEL
        @addChild @title

        @description = new PIXI.Text 'list of all presets.', AppData.TEXTFORMAT.MENU_DESCRIPTION
        @description.scale.x = @description.scale.y = 0.5
        @description.position.x = AppData.PADDING
        @description.position.y = @title.y + @title.height + AppData.PADDING
        @addChild @description
