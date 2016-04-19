# import renderables.elements.*
class Pannel extends PIXI.Container

    constructor: (label) ->
        super()

        @label = new PIXI.Text label.toUpperCase(), AppData.TEXTFORMAT.PANNEL_TITLE
        @label.scale.x = @label.scale.y = 0.5
        @label.anchor.x = 0
        @label.anchor.y = 0.5
        @label.position.x = AppData.PADDING
        @label.position.y = AppData.MENU_PANNEL / 2
        @addChild @label

        @elements = []

    align: ->
        for i in [0...@elements.length]
            if i is 0
                @elements[i].y = AppData.MENU_PANNEL
            else
                @elements[i].y = @elements[i-1].y + @elements[i-1].height
        null
