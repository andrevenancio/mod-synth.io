# import renderables.menu.Pannel
class AddPannel extends Pannel

    constructor: (label) ->
        super label

        @nsg = new SubmenuButtonAdd 'Noise Generator',
            AppData.ASSETS.sprite.textures['comp-3-fill.png'],
            AppData.COLORS[AppData.COMPONENTS.NSG]
        @nsg.buttonClick = =>
            @addComponent 0
            null
        @addChild @nsg
        @elements.push @nsg

        @osc = new SubmenuButtonAdd 'Oscillator',
            AppData.ASSETS.sprite.textures['comp-4-fill.png'],
            AppData.COLORS[AppData.COMPONENTS.OSC]
        @osc.buttonClick = =>
            @addComponent 1
            null
        @addChild @osc
        @elements.push @osc

        @env = new SubmenuButtonAdd 'Envelope',
            AppData.ASSETS.sprite.textures['comp-5-fill.png'],
            AppData.COLORS[AppData.COMPONENTS.ENV]
        @env.buttonClick = =>
            @addComponent 2
            null
        @addChild @env
        @elements.push @env

        @flt = new SubmenuButtonAdd 'Filter',
            AppData.ASSETS.sprite.textures['comp-6-fill.png'],
            AppData.COLORS[AppData.COMPONENTS.FLT]
        @flt.buttonClick = =>
            @addComponent 3
            null
        @addChild @flt
        @elements.push @flt

        @ptg = new SubmenuButtonAdd 'Pattern Gate',
            AppData.ASSETS.sprite.textures['comp-7-fill.png'],
            AppData.COLORS[AppData.COMPONENTS.PTG]
        @ptg.buttonClick = =>
            @addComponent 4
            null
        @addChild @ptg
        @elements.push @ptg

        @lfo = new SubmenuButtonAdd 'Low Frequency Oscillator',
            AppData.ASSETS.sprite.textures['comp-10-fill.png'],
            AppData.COLORS[AppData.COMPONENTS.LFO]
        @lfo.buttonClick = =>
            @addComponent 5
            null
        @addChild @lfo
        @elements.push @lfo

        @align()

    align: ->
        c = 0
        for i in [0...@elements.length]
            if i%2 is 0
                @elements[i].x = 0
            else
                @elements[i].x = AppData.SUBMENU_PANNEL/2

            if i%2 is 0
                c++

            @elements[i].y = AppData.MENU_PANNEL + (AppData.SUBMENU_PANNEL/2 * c) - (AppData.SUBMENU_PANNEL/2)
        null

    addComponent: (type_uid) ->
        # adds new component
        component = {
            'type_uid': type_uid
        }
        data = Session.ADD component

        App.ADD.dispatch data
        App.SETTINGS_CHANGE.dispatch { component: data.component_session_uid }

        # uncomment to close menu
        # AppData.SHOW_MENU_PANNEL = false
        # App.TOGGLE_MENU.dispatch({ width: 0 });
        null
