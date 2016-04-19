class Spacer extends PIXI.Container

    constructor: (size) ->
        super()

        @graphics = new PIXI.Graphics()
        @graphics.beginFill 0xffffff, 0
        @graphics.drawRect 0, 0, size, AppData.ICON_SIZE_1
        @addChild @graphics
