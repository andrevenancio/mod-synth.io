# import renderables.menu.Pannel
class PresetsPannel extends Pannel

    constructor: (label) ->
        super label

        @elements = []

        App.PATCH_CHANGED.add @build
        App.PRESET_CHANGED.add @onPresetChanged
        @build()

    clear: ->
        for i in [0...@children.length-1]
            @removeChild @children[1]
        @elements = []
        null

    build: =>
        @clear()

        isLoggedIn = Services.REFERENCE.auth().currentUser || false
        if Session.patch.uid is 'default'
            isLoggedIn = false

        @button_NEW = new SubmenuButton 'Create new preset', AppData.ASSETS.sprite.textures['ic-add-32.png']
        @button_NEW.buttonClick = @createPreset
        @button_NEW.y = AppData.MENU_PANNEL
        @button_NEW.visible = isLoggedIn
        @addChild @button_NEW

        @description = new PIXI.Text 'You can\'t add presets to the default patch.', AppData.TEXTFORMAT.MENU_DESCRIPTION
        @description.scale.x = @description.scale.y = 0.5
        @description.position.x = AppData.PADDING
        @description.position.y = @button_NEW.y
        @description.visible = !isLoggedIn
        @addChild @description

        @saved = new PIXI.Text 'AVAILABLE PRESETS', AppData.TEXTFORMAT.MENU_SUBTITLE
        @saved.tint = 0x646464
        @saved.scale.x = @saved.scale.y = 0.5
        @saved.position.x = AppData.PADDING
        @saved.position.y = @button_NEW.y + @button_NEW.height + AppData.PADDING
        @addChild @saved

        # sorting by creation date.
        order = []
        for preset of Session.patch.presets
            obj = Session.patch.presets[preset]
            obj.key = preset
            order.push(obj);

        order.sort (a,b) ->
            return a.date-b.date

        for i in [0...order.length]
            # if the patch is the default, you can't edit anything.
            allowDelete = if Session.patch.uid is 'default' then false else true
            # if its not, you can delete everything but the default
            if allowDelete is true
                allowDelete = if order[i].key is 'default' then false else true

            bt = new SubmenuButtonPreset order[i].name, new Date(parseInt(order[i].date)).toLocaleDateString(), allowDelete
            bt.setCurrent Session.patch.preset is order[i].key
            @attachButtonClick bt, order[i].key
            @addChild bt
            @elements.push bt
        @align()
        null

    align: ->
        for i in [0...@elements.length]
            if i is 0
                @elements[i].y = @saved.y + @saved.height + AppData.PADDING/2
            else
                @elements[i].y = @elements[i-1].y + @elements[i-1].height
        null

    createPreset: =>
        App.PROMPT.dispatch {
            question: 'Choose a preset name:'
            input: true
            onConfirm: (data) =>

                preset_id = Services.GENERATE_UID(16)
                Services.api.presets.save Session.patch.uid, preset_id, data, (snapshot) =>
                    # patch_id, preset_id, preset_name
                    Session.patch.preset = preset_id
                    Session.patch.presets = snapshot.val()

                    App.PATCH_CHANGED.dispatch()
                    App.PRESET_CHANGED.dispatch()
                    App.AUTO_SAVE.dispatch {}

                    Services.api.presets.update preset_id
                    null
        }
        null

    attachButtonClick: (bt, uid) =>
        bt.buttonClick = =>
            return if uid is Session.patch.preset
            App.LOAD_PRESET.dispatch {
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
                        Services.api.presets.remove uid, (snapshot) =>
                            App.PATCH_CHANGED.dispatch()
                            App.PRESET_CHANGED.dispatch()
                            App.AUTO_SAVE.dispatch {}
                            null
                        null
                }
                null
        null

    onPresetChanged: =>
        # enable current preset only
        for i in [0...@elements.length]
            @elements[i].setCurrent Session.patch.presets[Session.patch.preset].name.toUpperCase() is @elements[i].label.text
        null
