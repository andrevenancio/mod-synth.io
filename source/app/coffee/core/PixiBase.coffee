# import core.Base
class PixiBase extends Base

    @RESIZE: new signals.Signal()

    constructor: ->

        super()

        # setup pixi
        PIXI.utils._saidHello = true
        AppData.PIXI.renderer = new PIXI.autoDetectRenderer 1, 1, { antialias: false, backgroundColor: 0x1A1A1A, resolution: 1 }
        document.body.appendChild AppData.PIXI.renderer.view

        AppData.PIXI.stage = new PIXI.Container()
        AppData.PIXI.stage.interactive = true

        # add events
        window.addEventListener 'resize', @handleResize, false
        AppData.PIXI.renderer.view.addEventListener 'contextmenu', @handleContext, false

        @handleResize()
        @update()

    handleContext: (e) =>
        # e.preventDefault()
        null

    handleResize: =>
        AppData.WIDTH = window.innerWidth * AppData.RATIO
        AppData.HEIGHT = window.innerHeight * AppData.RATIO
        AppData.PIXI.renderer.resize AppData.WIDTH, AppData.HEIGHT
        AppData.PIXI.renderer.view.style.width = (AppData.WIDTH/AppData.RATIO) + 'px'
        AppData.PIXI.renderer.view.style.height = (AppData.HEIGHT/AppData.RATIO) + 'px'
        App.RESIZE.dispatch()
        null

    update: =>
        requestAnimationFrame @update
        AppData.PIXI.renderer.render AppData.PIXI.stage

        for renderable of AppData.PIXI.stage.children
            if AppData.PIXI.stage.children[renderable].update
                AppData.PIXI.stage.children[renderable].update()
        null
