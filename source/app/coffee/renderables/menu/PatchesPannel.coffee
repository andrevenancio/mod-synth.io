# import renderables.menu.Pannel
class PatchesPannel extends Pannel

    constructor: (label) ->
        super label

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

        isLoggedIn = Services.REFERENCE.getAuth() || false

        @button_NEW = new SubmenuButton 'save to new patch', AppData.ASSETS.sprite.textures['ic-add-32.png']
        @button_NEW.buttonClick = @createPatch
        @button_NEW.y = AppData.MENU_PANNEL
        @button_NEW.visible = isLoggedIn
        @addChild @button_NEW

        @description = new PIXI.Text 'You need to login in order to save or load patches.', AppData.TEXTFORMAT.MENU_DESCRIPTION
        @description.scale.x = @description.scale.y = 0.5
        @description.position.x = AppData.PADDING
        @description.position.y = @button_NEW.y
        @description.visible = !isLoggedIn
        @addChild @description

        @saved = new PIXI.Text 'AVAILABLE PATCHES', AppData.TEXTFORMAT.MENU_SUBTITLE
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

        if isLoggedIn
            # data is null, check is current session is same as default
            if data is null
                if Session.patch.uid
                    if Session.default.uid isnt Session.patch.uid
                        @resetToDefault()
                        @align()
                        return
            else
                # sorting by creation date.
                order = []
                for component of data
                    obj = data[component]
                    obj.key = component
                    order.push(obj);

                order.sort (a,b) ->
                    return a.date-b.date

                for i in [0...order.length]
                    bt = new SubmenuButtonPatch order[i].name, new Date(parseInt(order[i].date)).toLocaleDateString(), true
                    bt.setCurrent Session.patch.uid is order[i].uid
                    @attachButtonClick bt, order[i].key
                    @addChild bt
                    @elements.push bt

        App.PATCH_CHANGED.dispatch()
        @align()
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

                # to remove all components uncomment this
                # and on Services.api.patches.save change to Session.patch.components = {}
                # for component of Session.SETTINGS
                #     App.REMOVE.dispatch Session.SETTINGS[component]

                # saves new patch
                Services.api.patches.save data, (snapshot) =>
                    # stores cookie
                    Cookies.setCookie 'patch', Session.patch.uid
                    # saves new default preset
                    Services.api.presets.save Session.patch.uid, 'default', 'default', (snapshot) =>
                        Session.patch.preset = 'default'
                        Session.patch.presets = snapshot.val()

                        App.PATCH_CHANGED.dispatch()
                        App.PRESET_CHANGED.dispatch()
                        App.AUTO_SAVE.dispatch {}

                        for id of Session.patch.presets
                            Services.api.presets.update id
                        @checkUserPatches()
                        null
                    null
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
            Session.patches = {}
            @build()
        null

    checkUserPatches: =>
        Services.api.patches.getAll @rebuildUserPatches
        null

    rebuildUserPatches: (snapshot) =>
        Session.patches = snapshot.val() || {}
        @build Session.patches
        null

    attachButtonClick: (bt, uid) =>
        bt.buttonClick = =>
            return if uid is Session.patch.uid
            App.LOAD_PATCH.dispatch {
                uid: uid,
                label: bt.label.text
            }
            @checkUserPatches()
            null

        if bt.extraButton
            # remove patch
            bt.remove.buttonClick = =>
                App.PROMPT.dispatch {
                    question: 'Are you sure you want to delete "' + bt.label.text + '"?'
                    onConfirm: =>
                        Services.api.patches.remove uid, (snapshot) =>
                            App.LOAD_PATCH.dispatch {
                                uid: 'default',
                                label: bt.label.text,
                                confirm: false
                            }
                            @checkUserPatches()
                        null
                }
                null
        null

    onPatchLoaded: =>
        for i in [0...@elements.length]
            return if not Session.patch.name
            @elements[i].setCurrent Session.patch.name.toUpperCase() is @elements[i].label.text
        null
