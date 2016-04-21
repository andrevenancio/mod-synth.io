# import core.View
# import renderables.Background
# import renderables.components.*
# import utils.*
class Dashboard extends View

    constructor: ->
        super()

        App.ADD.add @onAdd
        App.REMOVE.add @onRemove

        @canvasSizeW = window.screen.availWidth * 2 * AppData.RATIO
        @canvasSizeH = window.screen.availHeight * 2 * AppData.RATIO

        @background = new Background()
        @addChild @background

        @lineGraphics = new PIXI.Graphics()
        @lineGraphics.alpha = AppData.LINE_ALPHA
        @addChild @lineGraphics

        @graphics = new PIXI.Graphics()
        @addChild @graphics

        @holder = new PIXI.Container()
        @addChild @holder

        @draggable = new DraggableElement @background
        @draggable.position.x = (@canvasSizeW-AppData.WIDTH)/-2
        @draggable.position.y = (@canvasSizeH-AppData.HEIGHT)/-2

        @physics = new PhysicsEngine @canvasSizeW, @canvasSizeH, false
        @physics.init()

        @center = new Vec2()

        # is mouse down? used on move
        @mouseDown = false
        # used in down and move to identify if its a click or a up event
        @isClick = false
        # stored session_uid on mouse down if clicked on a body
        @downBody = null

        if Modernizr.touch
            @background.on 'touchstart', @onBackgroundDown
            @background.on 'touchmove', @onBackgroundMove
            @background.on 'touchend', @onBackgroundUp
            @background.on 'touchendoutside', @onBackgroundUp
        else
            @background.on 'mousedown', @onBackgroundDown
            @background.on 'mousemove', @onBackgroundMove
            @background.on 'mouseup', @onBackgroundUp
            @background.on 'mouseupoutside', @onBackgroundUp

        @components = []
        @positions = []

        if AppData.SHOW_KEYBOARD_PANNEL
            @draggable.position.y -= AppData.KEYBOARD_PANNEL_HEIGHT/2

    onBackgroundDown: (e) =>
        @mouseDown = true
        @isClick = true
        @draggable.lock = true

        x = e.data.global.x - @draggable.position.x - @x
        y = e.data.global.y - @draggable.position.y - @y
        @downBody = @physics.down x, y

        if @downBody is null
            App.TOGGLE_SETTINGS_PANNEL_HEIGHT.dispatch { type: false }
            @draggable.lock = false

        AppData.SHOW_MENU_PANNEL = false
        App.TOGGLE_MENU.dispatch { width: 0 }
        null

    onBackgroundMove: (e) =>
        if @mouseDown
            @isClick = false

            x = e.data.global.x - @draggable.position.x - @x
            y = e.data.global.y - @draggable.position.y - @y
            @physics.move x, y
        null

    onBackgroundUp: (e) =>
        @mouseDown = false
        @draggable.lock = false

        x = e.data.global.x - @draggable.position.x - @x
        y = e.data.global.y - @draggable.position.y - @y
        @physics.up x, y

        if @downBody isnt null
            xxx = Math.round ((@downBody.GetPosition().x * @physics.worldScale) + @draggable.position.x) - (AppData.WIDTH/2)
            yyy = Math.round ((@downBody.GetPosition().y * @physics.worldScale) + @draggable.position.y) - (AppData.HEIGHT/2)

            App.AUTO_SAVE.dispatch {
                component_session_uid: @downBody.GetUserData().uid,
                x: xxx
                y: yyy
            }

        if @downBody isnt null and @isClick
            App.TOGGLE_SETTINGS_PANNEL_HEIGHT.dispatch {
                type: true
                component_session_uid: @downBody.GetUserData().uid
            }
            @downBody = null
        null

    onResize: =>
        @background.width = AppData.WIDTH
        @background.height = AppData.HEIGHT
        @draggable.resize AppData.WIDTH, AppData.HEIGHT, @canvasSizeW, @canvasSizeH
        null

    onAdd: (data) =>
        @center.x = AppData.WIDTH/2 - @draggable.position.x
        @center.y = AppData.HEIGHT/2 - @draggable.position.y
        # if AppData.SHOW_KEYBOARD_PANNEL
            # @center.y = (AppData.HEIGHT - AppData.KEYBOARD_PANNEL_HEIGHT) / 2  - @draggable.position.y
        @add data
        null

    onRemove: (data) =>
        @remove data
        null

    add: (data) ->
        switch data.type_uid
            when AppData.COMPONENTS.NSG then shape = new ComponentNsg data.component_session_uid
            when AppData.COMPONENTS.OSC then shape = new ComponentOsc data.component_session_uid
            when AppData.COMPONENTS.ENV then shape = new ComponentEnv data.component_session_uid
            when AppData.COMPONENTS.FLT then shape = new ComponentFlt data.component_session_uid
            when AppData.COMPONENTS.PTG then shape = new ComponentPtg data.component_session_uid
            when AppData.COMPONENTS.LFO then shape = new ComponentLfo data.component_session_uid

        shape.onAdd()

        # attach box2d object to shape (for positioning)
        shape.box2d = @physics.createCustom( shape.vertices, @center.x + data.x, @center.y + data.y, Box2D.Dynamics.b2Body.b2_dynamicBody );
        # attached component session id, for clicks logic
        shape.box2d.SetUserData {
            uid: shape.component_session_uid
        }
        @components.push shape
        @holder.addChild shape
        null

    remove: (data) ->
        App.TOGGLE_SETTINGS_PANNEL_HEIGHT.dispatch { type: false }
        for i in [0...@components.length]
            component = @components[i]

            if component.component_session_uid is data.component_session_uid
                @components.splice i, 1

                component.onRemove =>
                    @holder.removeChild component

                    @physics.destroy component.box2d

                    delete Session.SETTINGS[data.component_session_uid]
                break
        null

    update: ->
        @graphics.clear()

        @draggable.update()
        @draggable.constrainToBounds()

        @background.update @draggable.position, @draggable.zoom
        @physics.update()

        @positions = []

        # gets data from box2D and position shapes
        for i in [0...@components.length]
            shape = @components[i]

            pos = shape.box2d.GetPosition()
            rot = shape.box2d.GetAngle()

            shape.x = @draggable.position.x + (pos.x * @physics.worldScale)
            shape.y = @draggable.position.y + (pos.y * @physics.worldScale)
            shape.rotation = rot

            # position
            x = shape.x
            y = shape.y

            # limits
            lw = AppData.WIDTH
            lh = AppData.HEIGHT

            # color
            color = AppData.COLORS[Session.GET(shape.component_session_uid).type_uid]

            # constrains
            if x < 0
                x = 0
            if x > lw
                x = AppData.WIDTH
            if y < 0
                y = 0
            if y > lh
                y = AppData.HEIGHT

            if x <= 0 or x >= lw or y <= 0 or y >= lh
                @graphics.lineStyle(0);
                @graphics.beginFill(color);
                @graphics.drawCircle(x, y, AppData.MINIMAP);
                @graphics.endFill();

            # adds position per component_session_uid to be used to draw lines
            @positions[shape.component_session_uid] = {
                x: x,
                y: y
            }

        @renderLines()
        null

    renderLines: ->
        @lineGraphics.clear()

        for i in [0...@components.length]
            shape = @components[i]

            if Session.SETTINGS[shape.component_session_uid].audioCapable is true
                env = Session.SETTINGS[shape.component_session_uid].connections.ENV
                ptg = Session.SETTINGS[shape.component_session_uid].connections.PTG
                lfo = Session.SETTINGS[shape.component_session_uid].connections.LFO
                flt = Session.SETTINGS[shape.component_session_uid].connections.FLT

                if env
                    # colour = AppData.COLORS[Session.GET(shape.component_session_uid).type_uid]
                    @lineGraphics.beginFill(0, 0);
                    @lineGraphics.lineStyle(1*AppData.RATIO, 0xffffff);
                    @lineGraphics.moveTo(@positions[shape.component_session_uid].x, @positions[shape.component_session_uid].y);
                    @lineGraphics.lineTo(@positions[env].x, @positions[env].y);
                    @lineGraphics.endFill();

                if ptg
                    # colour = AppData.COLORS[Session.GET(shape.component_session_uid).type_uid]
                    @lineGraphics.beginFill(0, 0);
                    @lineGraphics.lineStyle(1*AppData.RATIO, 0xffffff);
                    @lineGraphics.moveTo(@positions[shape.component_session_uid].x, @positions[shape.component_session_uid].y);
                    @lineGraphics.lineTo(@positions[ptg].x, @positions[ptg].y);
                    @lineGraphics.endFill();

                if lfo
                    # colour = AppData.COLORS[Session.GET(shape.component_session_uid).type_uid]
                    @lineGraphics.beginFill(0, 0);
                    @lineGraphics.lineStyle(1*AppData.RATIO, 0xffffff);
                    @lineGraphics.moveTo(@positions[shape.component_session_uid].x, @positions[shape.component_session_uid].y);
                    @lineGraphics.lineTo(@positions[lfo].x, @positions[lfo].y);
                    @lineGraphics.endFill();

                if flt
                    # colour = AppData.COLORS[Session.GET(shape.component_session_uid).type_uid]
                    @lineGraphics.beginFill(0, 0);
                    @lineGraphics.lineStyle(1*AppData.RATIO, 0xffffff);
                    @lineGraphics.moveTo(@positions[shape.component_session_uid].x, @positions[shape.component_session_uid].y);
                    @lineGraphics.lineTo(@positions[flt].x, @positions[flt].y);
                    @lineGraphics.endFill();
        null
