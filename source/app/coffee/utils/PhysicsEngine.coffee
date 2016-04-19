class PhysicsEngine

    constructor: (@width, @height, @debug) ->

        @allowSleep         = true
        @worldScale         = 60
        @worldStep          = 1/20
        @velocityIterations = 5
        @positionIterations = 4
        @gravity            = new Box2D.Common.Math.b2Vec2 0, 0

        # virtual bounds
        @boundsSize = { x: 0, y: 0, width: @width, height: @height }

        @boundSize = 10
        @boundPadding = 0

        @debugCanvas = document.createElement( 'canvas' )

        @bounds = []

        # dragging
        @selectedBody = null
        @mousePVec = null
        @mouseJoint = null

    init: ->
        @world = new Box2D.Dynamics.b2World @gravity, @allowSleep
        if @debug
            @world.SetDebugDraw @debugDraw()

        @addBounds()
        null

    update: ->
        @world.Step( @worldStep, @velocityIterations, @positionIterations)
        @world.DrawDebugData()
        @world.ClearForces()
        null

    down: (mouseX, mouseY) ->
        body = @getBodyAtPosition( mouseX / @worldScale, mouseY / @worldScale )
        if body
            md = new Box2D.Dynamics.Joints.b2MouseJointDef()
            md.bodyA = @world.GetGroundBody()
            md.bodyB = body
            md.target.Set( mouseX / @worldScale, mouseY / @worldScale )
            md.collideConnected = true
            md.maxForce = 1000.0 * body.GetMass()
            @mouseJoint = @world.CreateJoint( md )
            body.SetAwake( true )
        return body

    move: (mouseX, mouseY) ->
        if @mouseJoint
            @mouseJoint.SetTarget(new Box2D.Common.Math.b2Vec2( mouseX / @worldScale, mouseY / @worldScale ))
        null

    up: (mouseX, mouseY) ->
        if @mouseJoint
            @world.DestroyJoint( @mouseJoint )
            @mouseJoint = null
            @selectedBody = null
        null

    getBodyAtPosition: (x, y) ->
        @mousePVec = new Box2D.Common.Math.b2Vec2( x, y )
        aabb = new Box2D.Collision.b2AABB()
        aabb.lowerBound.Set( x - 0.001, y - 0.001 )
        aabb.upperBound.Set( x + 0.001, y + 0.001 )
        @world.QueryAABB( @getBodyCB, aabb )

        return @selectedBody

    getBodyCB: (fixture) =>
        if fixture.GetBody().GetType() isnt Box2D.Dynamics.b2Body.b2_staticBody
            if fixture.GetShape().TestPoint( fixture.GetBody().GetTransform(), @mousePVec )
                @selectedBody = fixture.GetBody()
                return false
        return true

    createBox: (x, y, width, height, type) ->
        polygonShape = new Box2D.Collision.Shapes.b2PolygonShape()
        polygonShape.SetAsBox( width / 2 / @worldScale, height / 2 / @worldScale )

        fixtureDef = new Box2D.Dynamics.b2FixtureDef()
        fixtureDef.density = 1.0
        fixtureDef.friction = 0.5
        fixtureDef.restitution = 0.5
        fixtureDef.shape = polygonShape

        bodyDef = new Box2D.Dynamics.b2BodyDef()
        bodyDef.type = type
        # bodyDef.linearDamping = 4
        # bodyDef.angularDamping = 4
        # bodyDef.fixedRotation = true
        bodyDef.position.Set( x / @worldScale, y / @worldScale )

        body = @world.CreateBody( bodyDef )
        body.CreateFixture( fixtureDef )
        return body

    createCircle: ( radius, x, y, type ) ->
        polygonShape = new Box2D.Collision.Shapes.b2CircleShape( radius / @worldScale )

        fixtureDef = new Box2D.Dynamics.b2FixtureDef()
        fixtureDef.density = 1.0
        fixtureDef.friction = 0.5
        fixtureDef.restitution = 0.1
        fixtureDef.shape = polygonShape

        bodyDef = new Box2D.Dynamics.b2BodyDef()
        bodyDef.type = type
        # bodyDef.linearDamping = 2
        # bodyDef.angularDamping = 2
        # bodyDef.fixedRotation = true
        bodyDef.position.Set( x / @worldScale, y / @worldScale )

        body = @world.CreateBody( bodyDef )
        body.CreateFixture( fixtureDef )
        return body

    createCustom: ( vertices, x, y, type ) ->
        polygonShape = new Box2D.Collision.Shapes.b2PolygonShape()

        fixtureDef = new Box2D.Dynamics.b2FixtureDef()
        fixtureDef.density = 1.0
        fixtureDef.friction = 0.5
        fixtureDef.restitution = 0.1
        fixtureDef.shape = polygonShape
        fixtureDef.shape.SetAsArray( vertices )

        bodyDef = new Box2D.Dynamics.b2BodyDef()
        bodyDef.type = type
        bodyDef.linearDamping = 1.5
        bodyDef.angularDamping = 1.5
        bodyDef.fixedRotation = true
        bodyDef.position.Set( x / @worldScale, y / @worldScale )

        body = @world.CreateBody( bodyDef )
        body.CreateFixture( fixtureDef )
        return body

    addBounds: ->
        @bounds.push( @createBox(
            @boundsSize.x + @boundsSize.width / 2,
            @boundsSize.y + @boundPadding + @boundSize / 2 + 0,
            @boundsSize.width + @boundSize * 2,
            @boundSize,
            Box2D.Dynamics.b2Body.b2_staticBody ) )

        @bounds.push( @createBox(
            @boundsSize.x - @boundPadding - @boundSize / 2 + @boundsSize.width,
            @boundsSize.y + @boundsSize.height / 2,
            @boundSize,
            @boundsSize.height + @boundSize * 2,
            Box2D.Dynamics.b2Body.b2_staticBody ) )

        @bounds.push( @createBox(
            @boundsSize.x + @boundsSize.width / 2,
            @boundsSize.y - @boundPadding - @boundSize / 2 + @boundsSize.height,
            @boundsSize.width + @boundSize * 2,
            @boundSize,
            Box2D.Dynamics.b2Body.b2_staticBody ) )

        @bounds.push( @createBox(
            @boundsSize.x + @boundPadding + @boundSize / 2 + 0,
            @boundsSize.y + @boundsSize.height / 2,
            @boundSize,
            @boundsSize.height + @boundSize * 2,
            Box2D.Dynamics.b2Body.b2_staticBody ) )
        null

    removeBounds: ->
        for i in [0...@bounds.length]
            @world.DestroyBody @bounds[i]
        @bounds = []
        null

    destroy: (body) ->
        @world.DestroyBody body
        null

    debugDraw: ->
        @debugCanvas.style.position = 'absolute'
        @debugCanvas.style.top = 0
        @debugCanvas.style.left = 0
        @debugCanvas.style.pointerEvents = 'none'
        @debugCanvas.width = @width
        @debugCanvas.height = @height
        document.body.appendChild( @debugCanvas )

        debugDraw = new Box2D.Dynamics.b2DebugDraw()
        debugDraw.SetSprite( @debugCanvas.getContext( '2d' ) )
        debugDraw.SetDrawScale( @worldScale )
        debugDraw.SetFillAlpha( 0.5 )
        debugDraw.SetLineThickness( 1.0 )
        debugDraw.SetFlags( Box2D.Dynamics.b2DebugDraw.e_shapeBit | Box2D.Dynamics.b2DebugDraw.e_jointBit )
        return debugDraw
