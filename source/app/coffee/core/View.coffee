class View extends PIXI.Container

    constructor: ->
        super()

        App.RESIZE.add @onResize

    onResize: =>
        null

    update: ->
        null
