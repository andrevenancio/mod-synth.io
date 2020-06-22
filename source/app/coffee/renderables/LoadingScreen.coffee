# import renderables.Soon
# import audio.core.Audio
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

    onUp: =>
        Audio.CONTEXT = new (window.AudioContext || window.webkitAudioContext)()

        TweenMax.to @click, 1, { alpha: 0, ease: Power4.easeInOut, onComplete: () =>
            @removeChild @click
        }


        # does end animation, and in the end call the callback
        TweenMax.to @holder, 1.0, { alpha: 0, delay: 0.5, ease: Power2.easeInOut, onComplete: @callback }
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
            AppData.SHOW_KEYBOARD_PANNEL = if keyboard is 'show' then true else false
            AppData.SHOW_LABELS = if labels is 'show' then true else false

        # saves default patch and presets so its public not locked to a user
        Services.api.patches.load 'default', (snapshot) =>
            data = snapshot.val()

            Session.default.uid = 'default'
            Session.default.author = data.author
            Session.default.author_name = data.author_name
            Session.default.components = data.components
            Session.default.date = data.date
            Session.default.name = data.name
            Session.default.preset = data.preset

            Services.api.presets.loadAll 'default', (snapshot) =>
                Session.default.preset = 'default'
                Session.default.presets = snapshot.val()
                
                if window.screen.availWidth < 800 || window.screen.availHeight < 600
                    @soon = new Soon()
                    @soon.x = AppData.WIDTH / 2
                    @soon.y = AppData.HEIGHT / 2
                    @soon.alpha = 0;
                    @addChild @soon

                    TweenMax.to @soon, 1, { alpha: 1, ease: Power4.easeInOut }

                else
                    # add CLICK TO START
                    @click = new PIXI.Text 'Click to Start', AppData.TEXTFORMAT.SOON
                    @click.anchor.x = 0.5
                    @click.anchor.y = 1
                    @click.scale.x = @click.scale.y = 0.5
                    @click.tint = 0xffffff
                    @click.x = AppData.WIDTH / 2
                    @click.y = AppData.HEIGHT / 2 + 100
                    @click.alpha = 0
                    @click.interactive = @click.buttonMode = true
                    @addChild @click

                    TweenMax.to @click, 1, { alpha: 1, delay: 0.3, ease: Power4.easeInOut }

                    if Modernizr.touch
                        @click.on 'touchend', @onUp
                    else
                        @click.on 'mouseup', @onUp
        null

    start: ->
        # fades in elements
        TweenMax.to @holder, 1.0, { alpha: 1, ease: Power2.easeInOut, onComplete: @preloadAssets }
        TweenMax.to @icon1, 1, { x: @pos1, alpha: 1, ease: Power4.easeInOut }
        TweenMax.to @icon3, 1, { x: @pos2, alpha: 1, ease: Power4.easeInOut, delay: 0.1 }
        null

    onResize: =>
        @holder.x = AppData.WIDTH / 2
        @holder.y = AppData.HEIGHT / 2

        if @click
            @click.x = AppData.WIDTH / 2
            @click.y = AppData.HEIGHT / 2 + 100


        return if not @soon
        @soon.x = AppData.WIDTH / 2
        @soon.y = AppData.HEIGHT / 2
        null
