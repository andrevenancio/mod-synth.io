# import renderables.buttons.Radio
# import renderables.settings.*
class SettingsPannel extends PIXI.Sprite

    constructor: ->
        super()

        @pannelShow = false

        App.TOGGLE_SETTINGS_PANNEL_HEIGHT.add @onToggle

        @theMask = new PIXI.Graphics()
        @addChild @theMask

        @holder = new PIXI.Container()
        @holder.mask = @theMask
        @addChild @holder

        @graphics = new PIXI.Graphics()
        @holder.addChild @graphics

        @settingsHolder = new PIXI.Container()
        @holder.addChild @settingsHolder

    resize: ->
        @theMask.clear()
        @theMask.beginFill 0xff00ff
        @theMask.moveTo 0, 0
        @theMask.lineTo AppData.WIDTH, 0
        @theMask.lineTo AppData.WIDTH, AppData.SETTINGS_PANNEL_HEIGHT+1
        @theMask.lineTo 0, AppData.SETTINGS_PANNEL_HEIGHT+1
        @theMask.lineTo 0, 0
        @theMask.endFill()

        @graphics.clear()

        @graphics.beginFill 0x232323, 0.97
        @graphics.lineStyle 1, 0x000000, 0.2
        @graphics.moveTo 0, 0
        @graphics.lineTo AppData.WIDTH+1, 0
        @graphics.lineTo AppData.WIDTH+1, AppData.SETTINGS_PANNEL_HEIGHT
        @graphics.lineTo 0, AppData.SETTINGS_PANNEL_HEIGHT
        @graphics.lineTo 0, 0
        @graphics.endFill()

        if @pannelShow
            @theMask.y = 0
        else
            @theMask.y = AppData.SETTINGS_PANNEL_HEIGHT
        null

    onToggle: (value) =>
        if value.type
            @removeAllFromSettings()

            switch Session.GET(value.component_session_uid).type_uid
                when AppData.COMPONENTS.NSG then s = new NsgSettings value.component_session_uid
                when AppData.COMPONENTS.OSC then s = new OscSettings value.component_session_uid
                when AppData.COMPONENTS.ENV then s = new EnvSettings value.component_session_uid
                when AppData.COMPONENTS.FLT then s = new FltSettings value.component_session_uid
                when AppData.COMPONENTS.PTG then s = new PtgSettings value.component_session_uid
                when AppData.COMPONENTS.LFO then s = new LfoSettings value.component_session_uid
                else
                    return

            @settingsHolder.addChild s
            App.SETTINGS_CHANGE.dispatch { component: value.component_session_uid }
            @open()
        else
            @close()
        null

    removeAllFromSettings: ->
        for i in [0...@settingsHolder.children.length]
            child = @settingsHolder.children[0]
            @settingsHolder.removeChild child
        null

    open: ->
        @pannelShow = true
        @settingsHolder.visible = true
        TweenMax.to @theMask, 0.1, { y: 0 }
        @hitArea = new PIXI.Rectangle 0, 0, AppData.WIDTH, AppData.SETTINGS_PANNEL_HEIGHT
        null

    close: ->
        @pannelShow = false
        TweenMax.to @theMask, 0.1, { y: AppData.SETTINGS_PANNEL_HEIGHT, onComplete: =>
            @settingsHolder.visible = false
            null
        }
        @hitArea = new PIXI.Rectangle 0, 0, AppData.WIDTH, 0
        null
