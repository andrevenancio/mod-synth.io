class Background extends PIXI.extras.TilingSprite

    constructor: ->
        super AppData.ASSETS.sprite.textures['shadow.png']
        @alpha = 0.0
        @interactive = true
        @defaultCursor = "-webkit-grabbing"

    update: (position, zoom) ->
        @tileScale.x = zoom
        @tileScale.y = zoom
        @tilePosition.x = position.x - @x
        @tilePosition.y = position.y - @y
        null
