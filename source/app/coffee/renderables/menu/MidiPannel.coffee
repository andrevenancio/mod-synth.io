# import renderables.menu.Pannel
class MidiPannel extends Pannel

    constructor: (label) ->
        super label

        @DEFAULT_MESSAGE = 'NO MIDI DEVICES CONNECTED'

        @controllers = []

        App.MIDI.add @onMidiStateChange

        @title = new PIXI.Text @DEFAULT_MESSAGE, AppData.TEXTFORMAT.MENU_SUBTITLE
        @title.tint = 0x646464
        @title.scale.x = @title.scale.y = 0.5
        @title.position.x = AppData.PADDING
        @title.position.y = AppData.MENU_PANNEL
        @addChild @title

        @description = new PIXI.Text 'You need to connect your MIDI enabled device in order to control the synthesizer', AppData.TEXTFORMAT.MENU_DESCRIPTION
        @description.scale.x = @description.scale.y = 0.5
        @description.position.x = AppData.PADDING
        @description.position.y = @title.y + @title.height + AppData.PADDING
        @addChild @description

    onMidiStateChange: (e) =>
        # add/remove from controllers objects
        if e.state is 'disconnected' and e.connection is 'closed'
            delete @controllers[e.name]
        else if e.state is 'connected'
            @controllers[e.name] = e

        # remove all buttons
        for i in [0...@elements.length]
            @removeChild @elements[i]
        @elements = []

        # add based on controllers object
        for controller of @controllers
            bt = new SubmenuButtonMidi controller, AppData.ASSETS.sprite.textures['ic-selection-inactive.png']
            bt.active = false
            @addChild bt
            @elements.push bt
            @controllers[controller].button = bt

            @assign bt, controller
            @toggleMidiDevice controller

        if Object.keys(@controllers).length > 0
            @title.text = 'CHOOSE MIDI INPUT'
            @description.visible = false
        else
            @title.text = @DEFAULT_MESSAGE
            @description.visible = true
        @align()
        null

    align: ->
        for i in [0...@elements.length]
            if i is 0
                @elements[i].y = @title.y + @title.height + AppData.PADDING/2
            else
                @elements[i].y = @elements[i-1].y + @elements[i-1].height
        null

    assign: (bt, controller) ->
        bt.buttonClick = =>
            @toggleMidiDevice controller
        null

    toggleMidiDevice: (controller) =>
        button = @controllers[controller].button
        button.active = !button.active

        if button.active is false
            button.img.texture = AppData.ASSETS.sprite.textures['ic-selection-inactive.png']
            button.img.alpha = 0.15
            delete Session.MIDI[controller]
        else
            button.img.texture = AppData.ASSETS.sprite.textures['ic-selection-active.png']
            button.img.alpha = 1
            Session.MIDI[controller] = controller
        null
