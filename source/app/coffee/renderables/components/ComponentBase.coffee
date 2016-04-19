class ComponentBase extends PIXI.Container

    constructor: (component_session_uid) ->
        super()

        App.TOGGLE_SETTINGS_PANNEL_HEIGHT.add @onToggle
        App.SETTINGS_CHANGE.add @onSettingsChange

        @component_session_uid = component_session_uid

        @__color = AppData.COLORS[Session.SETTINGS[@component_session_uid].type_uid]
        @__alpha = 1

        @highlight = false

        @bg = new PIXI.Sprite()
        @bg.anchor.x = 0.5
        @bg.anchor.y = 0.5
        @bg.scale.x = 0
        @bg.scale.y = 0
        @addChild @bg

        @over = new PIXI.Sprite()
        @over.anchor.x = 0.5
        @over.anchor.y = 0.5
        @over.alpha = 0
        @addChild @over

        @front = new PIXI.Container()
        @front.alpha = 0
        @addChild @front

        @label = new PIXI.Text AppData.TITLE[Session.SETTINGS[@component_session_uid].type_uid], AppData.TEXTFORMAT.SETTINGS_TITLE
        @label.scale.x = @label.scale.y = 0.5
        @front.addChild @label

        @icon = new PIXI.Sprite()
        @icon.anchor.x = 0.5
        @icon.anchor.y = 0.5
        @front.addChild @icon

        @interactive = false
        @hitArea = new PIXI.Rectangle(0, 0, 0, 0);

    onToggle: (value) =>
        @highlight = false
        # highlight just the selected component
        if value.component_session_uid is @component_session_uid
            @highlight = value.type
        @over.alpha = if @highlight is true then 1 else 0
        null

    onAdd: (onComplete) ->
        @bg.rotation = 360*Math.PI/360

        TweenMax.to @bg,        0.5, { rotation: 0, ease: Power2.easeInOut }
        TweenMax.to @bg.scale,  0.5, { x: 1, y: 1, ease: Power4.easeInOut, onComplete: =>
            TweenMax.to @front, 0.6, { alpha: 1, onComplete: onComplete }
            null
        }
        null

    onRemove: (onComplete) ->
        App.TOGGLE_SETTINGS_PANNEL_HEIGHT.remove @onToggle
        App.SETTINGS_CHANGE.remove @onSettingsChange

        TweenMax.to @front,         0.3, { alpha: 0, onComplete: =>
            TweenMax.to @bg,        0.3, { rotation: 360*Math.PI/360, ease: Power2.easeInOut }
            TweenMax.to @bg.scale,  0.3, { x: 0, y: 0, ease: Power4.easeInOut, onComplete: onComplete }
            null
        }
        null
