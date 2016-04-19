# import renderables.menu.Pannel
class PatchesPannel extends Pannel

    constructor: (label) ->
        super label

        @DEFAULT_MESSAGE = 'NOT LOGGED IN'

        @elements = []

        App.AUTH.add @checkUserAuth
        App.PATCH_CHANGED.add @onPatchLoaded

        @checkUserAuth()

    clear: ->
        for i in [0...@children.length-1]
            @removeChild @children[1]
        @elements = []
        null

    build: (data) =>
        @clear()
        if Services.REFERENCE.getAuth()

            # ADD new PATCH
            @button_NEW = new SubmenuButton 'create new patch', AppData.ASSETS.sprite.textures['ic-add-32.png']
            @button_NEW.buttonClick = @createPatch
            @button_NEW.y = AppData.MENU_PANNEL
            @addChild @button_NEW

            @saved = new PIXI.Text 'YOUR PATCHES', AppData.TEXTFORMAT.MENU_SUBTITLE
            @saved.tint = 0x646464
            @saved.scale.x = @saved.scale.y = 0.5
            @saved.position.x = AppData.PADDING
            @saved.position.y = @button_NEW.y + @button_NEW.height + AppData.PADDING
            @addChild @saved

            bt = new SubmenuButtonPatch Session.default.uid, new Date(parseInt(Session.default.date)).toLocaleDateString(), false
            bt.setCurrent Session.default.uid is Session.patch.uid
            @attachButtonClick bt, Session.default.uid
            @addChild bt
            @elements.push bt

            # data is null, check is current session is same as default
            if data is null
                if Session.default.uid isnt Session.patch.uid
                    @resetToDefault()
                    @align()
                    return

            @onPatchLoaded()

            if data
                for component of data
                    bt = new SubmenuButtonPatch data[component].name, new Date(parseInt(data[component].date)).toLocaleDateString(), true
                    bt.setCurrent Session.patch.uid is data[component].uid
                    @attachButtonClick bt, component
                    @addChild bt
                    @elements.push bt

            @align()
        else
            # nothing
            @title = new PIXI.Text @DEFAULT_MESSAGE, AppData.TEXTFORMAT.MENU_SUBTITLE
            @title.tint = 0x646464
            @title.scale.x = @title.scale.y = 0.5
            @title.position.x = AppData.PADDING
            @title.position.y = AppData.MENU_PANNEL
            @addChild @title

            @description = new PIXI.Text 'You need to login in order to save or load patches.', AppData.TEXTFORMAT.MENU_DESCRIPTION
            @description.scale.x = @description.scale.y = 0.5
            @description.position.x = AppData.PADDING
            @description.position.y = @title.y + @title.height + AppData.PADDING
            @addChild @description
        null

    align: ->
        for i in [0...@elements.length]
            if i is 0
                @elements[i].y = @saved.y + @saved.height + AppData.PADDING/2
            else
                @elements[i].y = @elements[i-1].y + @elements[i-1].height
        null

    createPatch: =>
        App.PROMPT.dispatch {
            question: 'Choose a patch name:'
            input: true
            onConfirm: (data) =>

                # clear all
                for component of Session.SETTINGS
                    App.REMOVE.dispatch Session.SETTINGS[component]

                setTimeout =>
                    # saves new patch
                    Services.api.patches.set_patch data, (d) ->
                        Cookies.setCookie 'patch', d.val().uid
                        null

                    # checks for all user patches
                    @checkUserPatches()
                , 1000
                null
        }
        null

    resetToDefault: =>
        App.LOAD_PATCH.dispatch {
            label: Session.default.uid,
            uid: Session.default.uid,
            confirm: false
        }
        null

    checkUserAuth: =>
        if Services.REFERENCE.getAuth()
            @checkUserPatches()
        else
            @build()
        null

    checkUserPatches: =>
        Services.api.patches.getAll @rebuildUserPatches
        null

    rebuildUserPatches: (snapshot) =>
        @build snapshot.val()
        null

    attachButtonClick: (bt, uid) =>

        bt.buttonClick = =>
            App.LOAD_PATCH.dispatch {
                uid: uid,
                label: bt.label.text
            }
            null

        if bt.extraButton
            # remove patch
            bt.remove.buttonClick = =>
                App.PROMPT.dispatch {
                    question: 'Are you sure you want to delete "' + bt.label.text + '"?'
                    onConfirm: =>
                        Services.api.patches.delete_patch uid, @checkUserPatches
                        null
                }
                null
        null

    onPatchLoaded: =>
        # return if AppData.TOUR_MODE
        # Session.patch.name.toUpperCase()
        # Session.patch.author.toUpperCase()
        # new Date(parseInt(Session.patch.date)).toLocaleDateString()

        for i in [0...@elements.length]
            @elements[i].setCurrent Session.patch.name.toUpperCase() is @elements[i].label.text
        null
