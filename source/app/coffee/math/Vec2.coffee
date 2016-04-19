class Vec2

    @add: (v1, v2) ->
        return new Vec2 v1.x+v2.x, v1.y+v2.y

    @subtract: (v1, v2) ->
        return new Vec2 v1.x-v2.x, v1.y-v2.y

    constructor: (@x=0, @y=0) ->

    clone: ->
        return new Vec2 @x, @y

    add: (v2) ->
        @x += v2.x
        @y += v2.y
        return @

    subtract: (v2) ->
        @x -= v2.x
        @y -= v2.y
        return @

    scale: (value) ->
        @x *= value
        @y *= value
        return @

    divide: (value) ->
        @x /= value
        @y /= value
        return @

    copy: (v2) ->
        @x = v2.x
        @y = v2.y
        return @

    set: (@x, @y) ->
        return @

    invert: ->
        @x = -@x
        @y = -@y
        return @

    dot: (v) ->
        return @x * v.x + @y * v.y

    rotate: (theta) ->
        co = Math.cos(theta)
        si = Math.sin(theta)
        xx = co * @x - si * @y
        @y = si * @x + co * @y
        @x = xx
        return @

    angle: ->
        return Math.atan2( @y, @x )

    angleBetween: (v) ->
        vv = v.clone()
        aa = @clone()
        vv.normalize()
        aa.normalize()
        return Math.acos aa.dot(vv)

    length: ->
        return Math.sqrt @x*@x + @y*@y

    abs: ->
        @x = Math.abs @x
        @y = Math.abs @y
        return @

    clamp: (min, max) ->
        if @x > max
            @x = max
        else if @x < min
            @x = min
        if @y > max
            @y = max
        else if @y < min
            @y = min
        return @

    normalize: ->
        len = @length()
        if len isnt 0
            @x = @x/len
            @y = @y/len
        return @

    interpolateTo: (v2, easing) ->
        diff = Vec2.subtract v2, @
        diff.scale easing
        @add diff
        return @
