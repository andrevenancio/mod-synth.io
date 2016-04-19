# import renderables.Soon
class LoadingScreen extends PIXI.Sprite

    constructor: (@callback) ->
        super()

        @holder = new PIXI.Sprite()
        @holder.alpha = 0
        @holder.scale.x = @holder.scale.y = 0.5
        @holder.anchor.x = 0.5
        @holder.anchor.y = 0.5
        @addChild @holder

        @icon1 = new PIXI.Sprite()
        @icon1.anchor.x = 0.5
        @icon1.anchor.y = 0.5
        @icon1.alpha = 0
        @holder.addChild @icon1

        @icon2 = new PIXI.Sprite()
        @icon2.x = 6
        @icon2.anchor.x = 0.5
        @icon2.anchor.y = 0.5
        @holder.addChild @icon2

        @icon3 = new PIXI.Sprite()
        @icon3.anchor.x = 0.5
        @icon3.anchor.y = 0.5
        @icon3.alpha = 0
        @holder.addChild @icon3

        App.RESIZE.add @onResize
        App.RESIZE.dispatch()

        @pos1 = -81*AppData.RATIO
        @pos2 = 86*AppData.RATIO

        @preloadLoadingAssets()
        null

    preloadLoadingAssets: ->

        @isLoading = true
        if AppData.RATIO is 1
            PIXI.loader.add 'preloader', '/sprites/preload1x.json'
        else
            PIXI.loader.add 'preloader', '/sprites/preload2x.json'

        PIXI.loader.once 'complete', @preloadLoadingAssetsComplete
        PIXI.loader.load()
        null

    preloadLoadingAssetsComplete: (loader, resources) =>

        @icon1.texture = resources.preloader.textures['preload1.png']
        @icon2.texture = resources.preloader.textures['preload2.png']
        @icon3.texture = resources.preloader.textures['preload3.png']

        # create masks
        @mask1 = new PIXI.Graphics()
        @mask1.beginFill 0x00ffff, 0.5
        @mask1.drawRect @icon1.texture.width / -2, @icon1.texture.height / -2, @icon1.texture.width, @icon1.texture.height
        @mask1.x = @pos1
        @holder.addChild @mask1

        @mask2 = new PIXI.Graphics()
        @mask2.beginFill 0x00ffff, 0.5
        @mask2.drawRect @icon3.texture.width / -2, @icon3.texture.height / -2, @icon3.texture.width, @icon3.texture.height
        @mask2.x = @pos2
        @holder.addChild @mask2

        # set masks
        @icon1.mask = @mask1
        @icon3.mask = @mask2

        loader.reset()
        @start()
        null

    preloadAssets: =>

        if AppData.RATIO is 1
            PIXI.loader.add 'sprite', '/sprites/sprite1x.json'
        else
            PIXI.loader.add 'sprite', '/sprites/sprite2x.json'

        PIXI.loader.once 'complete', @preloadAssetsComplete
        PIXI.loader.load()
        null

    preloadAssetsComplete: (loader, resources) =>
        # all textures are loaded
        AppData.ASSETS = resources

        loader.reset()

        # reads cookies
        tour = Cookies.getCookie('tour') || 'show'
        menu = Cookies.getCookie('menu') || 'hide'
        keyboard = Cookies.getCookie('keyboard') || 'show'
        labels = Cookies.getCookie('labels') || 'hide'

        AppData.SHOW_TOUR = if tour is 'show' then true else false

        # if we're seeing the tour for the first time, we close all pannels
        if AppData.SHOW_TOUR is true
            AppData.SHOW_MENU_PANNEL = false
            AppData.SHOW_KEYBOARD_PANNEL = true
            AppData.SHOW_LABELS = false
        else
            # otherwise we read the cookie
            AppData.SHOW_MENU_PANNEL = if menu is 'show' then true else false
            AppData.SHOW_KEYBOARD_PANNEL = if keyboard is 'show' then true else true
            AppData.SHOW_LABELS = if labels is 'show' then true else false

        # stored default patch settings and loads the patch in cookie
        Services.api.patches.load_patch 'default', (snapshot) =>
            data = snapshot.val()

            Session.default.uid = 'default'
            Session.default.author = data.author
            Session.default.name = data.name
            Session.default.date = data.date
            Session.default.components = data.components

            Session.patch.uid = 'default'
            Session.patch.author = data.author
            Session.patch.name = data.name
            Session.patch.date = data.date
            Session.patch.components = data.components
            @end()
            null
        null

    start: ->
        # fades in elements
        TweenMax.to @holder, 1.0, { alpha: 1, ease: Power2.easeInOut, onComplete: @preloadAssets }
        TweenMax.to @icon1, 1, { x: @pos1, alpha: 1, ease: Power4.easeInOut }
        TweenMax.to @icon3, 1, { x: @pos2, alpha: 1, ease: Power4.easeInOut, delay: 0.1 }
        null

    end: ->
        # check if we're on iPad
        iOS = /iPad|iPhone|iPod/.test navigator.userAgent

        # min width: 800
        # min height: 600
        if iOS
            @soon = new Soon()
            @soon.x = AppData.WIDTH / 2
            @soon.y = AppData.HEIGHT / 2
            @addChild @soon
            return

        # does end animation, and in the end call the callback
        TweenMax.to @holder, 1.0, { alpha: 0, delay: 0.5, ease: Power2.easeInOut, onComplete: @callback }
        null

    onResize: =>
        @holder.x = AppData.WIDTH / 2
        @holder.y = AppData.HEIGHT / 2

        return if not @soon
        @soon.x = AppData.WIDTH / 2
        @soon.y = AppData.HEIGHT / 2
        null
