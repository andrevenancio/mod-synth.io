# import renderables.menu.Pannel
class LoginPannel extends Pannel

    constructor: (@initial_label) ->
        super @initial_label

        App.AUTH.add @build

        @build()

    clear: ->
        for i in [0...@children.length-1]
            @removeChild @children[1]
        @elements = []
        null

    build: =>
        @clear()

        if Services.REFERENCE.getAuth()
            data = Services.REFERENCE.getAuth()

            # picture
            img = new PIXI.Sprite.fromImage data[data.provider].profileImageURL
            img.anchor.x = 0.5
            img.anchor.y = 0.5
            img.width = AppData.ICON_SIZE_2
            img.height = AppData.ICON_SIZE_2
            img.x = AppData.PADDING + AppData.ICON_SIZE_2/2
            img.y = AppData.MENU_PANNEL / 2
            @addChild img

            # title (username/name)
            switch data.provider
                when 'twitter'
                    @label.text = '@' + data.twitter.username.toUpperCase()
                else
                    @label.text = data[data.provider].displayName.toUpperCase()
            @label.position.x = img.x + AppData.ICON_SIZE_2

            @title = new PIXI.Text 'LOGGED VIA ' + data.provider.toUpperCase(), AppData.TEXTFORMAT.MENU_SUBTITLE
            @title.tint = 0x646464
            @title.scale.x = @title.scale.y = 0.5
            @title.position.x = AppData.PADDING
            @title.position.y = AppData.MENU_PANNEL
            @addChild @title

            # logout
            logout = new SubmenuButton 'Logout'
            logout.buttonClick = @handleLogout
            @addChild logout
            @elements.push logout

        else
            @label.text = @initial_label.toUpperCase()
            @label.position.x = AppData.PADDING

            twitter = new SubmenuButton 'twitter', AppData.ASSETS.sprite.textures['ic-twitter.png']
            twitter.buttonClick = @handleTwitter
            @addChild twitter
            @elements.push twitter

            facebook = new SubmenuButton 'facebook', AppData.ASSETS.sprite.textures['ic-facebook.png']
            facebook.buttonClick = @handleFacebook
            @addChild facebook
            @elements.push facebook

            github = new SubmenuButton 'github', AppData.ASSETS.sprite.textures['ic-github.png']
            github.buttonClick = @handleGithub
            @addChild github
            @elements.push github

        @align()
        null

    align: ->
        data = Services.REFERENCE.getAuth()
        for i in [0...@elements.length]
            if i is 0
                @elements[i].y = if data then @title.y + @title.height + AppData.PADDING/2 else AppData.MENU_PANNEL
            else
                @elements[i].y = @elements[i-1].y + @elements[i-1].height
        null

    handleTwitter: =>
        Services.api.login.twitter @handleLogin
        null

    handleFacebook: =>
        Services.api.login.facebook @handleLogin
        null

    handleGithub: =>
        Services.api.login.github @handleLogin
        null

    handleLogout: =>
        App.PROMPT.dispatch {
            question: 'Are you sure you want to logout?'
            onConfirm: =>
                Services.api.login.logout @handleLogin
                null
        }
        null

    handleLogin: (data) =>
        App.AUTH.dispatch()
        null
