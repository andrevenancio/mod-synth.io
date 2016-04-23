# import renderables.elements.*
class SettingsBase extends PIXI.Container

    component_session_uid: undefined

    constructor: (@component_session_uid) ->
        super()

        App.TOGGLE_KEYBOARD.add @onToggle
        App.RESIZE.add @onResize
        App.SETTINGS_CHANGE.add @onSettingsChange
        App.SETTINGS_CHANGE.add @handleAutoSave

        @elements = []
        @initialX = 112 * AppData.RATIO

        # component color
        @graphics = new PIXI.Graphics()
        @graphics.beginFill AppData.COLORS[Session.SETTINGS[@component_session_uid].type_uid]
        @graphics.moveTo 0, 0
        @graphics.lineTo 4 * AppData.RATIO, 0
        @graphics.lineTo 4 * AppData.RATIO, AppData.SETTINGS_PANNEL_HEIGHT
        @graphics.lineTo 0, AppData.SETTINGS_PANNEL_HEIGHT
        @graphics.lineTo 0, 0
        @graphics.endFill()
        @addChild @graphics

        # label
        @label = new PIXI.Text AppData.TITLE[Session.SETTINGS[@component_session_uid].type_uid], AppData.TEXTFORMAT.SETTINGS_TITLE
        @label.scale.x = @label.scale.y = 0.5
        @label.anchor.y = 0.5
        @label.position.x = AppData.PADDING
        @label.position.y = AppData.SETTINGS_PANNEL_HEIGHT/2
        @label.hitArea = new PIXI.Rectangle(0, 0, 0, 0);
        @label.visible = AppData.SHOW_KEYBOARD_PANNEL
        @addChild @label

        # remove
        @remove = new ICButton AppData.ASSETS.sprite.textures['ic-remove-32.png'], ''
        @remove.x = AppData.WIDTH - AppData.ICON_SIZE_1 - AppData.PADDING
        @remove.y = AppData.PADDING
        @remove.buttonClick = @removeComponent
        @addChild @remove

    onToggle: (value) =>
        @label.visible = value
        null

    onResize: =>
        @remove.x = AppData.WIDTH - AppData.ICON_SIZE_1 - AppData.PADDING
        null

    removeComponent: =>
        App.REMOVE.dispatch { component_session_uid: @component_session_uid }
        setTimeout =>

            App.AUTO_SAVE.dispatch {
                component_session_uid: @component_session_uid
            }
            for id of Session.patch.presets
                Services.api.presets.updateRemove id, @component_session_uid

        , 500
        null

    handleAutoSave: =>
        App.AUTO_SAVE.dispatch {
            component_session_uid: @component_session_uid
        }
        null

    onSettingsChange: => null

    add: (element) ->
        @elements.push element
        @addChild element

    adjustPosition: ->
        for i in [0...@elements.length]
            if i is 0
                @elements[i].x = @initialX
            else
                @elements[i].x = @elements[i-1].x + @elements[i-1].width
            @elements[i].y = Math.floor(AppData.SETTINGS_PANNEL_HEIGHT - AppData.ICON_SIZE_1) /2
        null
