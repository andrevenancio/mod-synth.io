class Picker extends PIXI.Container

    constructor: ->
        super()

        App.PICKER_SHOW.add @onPickerShow
        App.PICKER_HIDE.add @onPickerHide
        App.PICKER_VALUE.add @onPickerValue

        @visible = false

        @initialAngle = 20;
        @finalAngle = 160;
        @innerCircle = 120 * AppData.RATIO
        @outterCIrcle = 260 * AppData.RATIO
        @borderRadius = 8 * AppData.RATIO

        @steps = 0
        @snap = false

        @value = 0

        # if snap is true snap to X steps

        @canvas = document.createElement 'canvas'
        @canvas.width = @outterCIrcle * 2
        @canvas.height = @outterCIrcle * 2
        @canvas.style.width = (@outterCIrcle / 2) + 'px'
        @canvas.style.height = (@outterCIrcle / 2) + 'px'

        @context = @canvas.getContext '2d'
        @context.imageSmoothingEnabled = true

        @bg = new PIXI.Sprite(PIXI.Texture.fromCanvas(@canvas))
        @bg.scale.x = @bg.scale.y = 0.5
        @bg.anchor.x = 0.5
        @bg.anchor.y = 0
        @bg.y = - @bg.height / 2
        @addChild @bg

        @background = @getSlide @initialAngle, @finalAngle, @innerCircle, @outterCIrcle
        @slide = []
        @border = []

        @elements = new PIXI.Container()
        @addChild @elements

    getSlide: (initial, final, sizeA, sizeB) ->
        p = []
        i = initial
        while i <= final
            p.push
                x: sizeA * Math.cos((180 + i) * Math.PI / 180)
                y: sizeA * Math.sin((180 + i) * Math.PI / 180)
            i++
        i = final
        while i >= initial
            p.push
                x: sizeB * Math.cos((180 + i) * Math.PI / 180)
                y: sizeB * Math.sin((180 + i) * Math.PI / 180)
            i--
        return p

    getCenter: (i, f, sizeA, sizeB) ->
        angle = i + (f - i) / 2;
        size = (sizeB / 2) - ((sizeB / 2) - (sizeA / 2)) / 2 #(sizeB/2 + (sizeB/2 - sizeA/2) / 2)

        return {
            x: (size * Math.cos((180 + angle) * Math.PI / 180)),
            y: (size * Math.sin((180 + angle) * Math.PI / 180))
        }

    onPickerShow: (e) =>
        @steps = e.steps
        @snap = e.snap

        @x = e.x
        @y = e.y

        @removeElements()
        if e.elements
            angleStep = (@finalAngle - @initialAngle) / @steps;
            for i in [0...e.elements.length]
                pos = @getCenter(Math.floor(@initialAngle + (angleStep * i)), Math.ceil(@initialAngle + (angleStep * (i + 1))), @innerCircle, @outterCIrcle);
                @addElement e.elements[i], pos

        @visible = true
        null

    onPickerHide: (e) =>
        @visible = false
        null

    onPickerValue: (e) =>
        @value = e.percentage

        # clear all
        @context.clearRect 0, 0, @outterCIrcle*2, @outterCIrcle*2

        # draw base
        @context.beginPath();
        @context.fillStyle = 'rgba(0, 0, 0, 0.3)';
        for i in [0...@background.length]
            if i is 0
                @context.moveTo(@outterCIrcle + @background[i].x, @outterCIrcle + @background[i].y)
            else if i is @background.length-1
                @context.lineTo(@outterCIrcle + @background[0].x, @outterCIrcle + @background[0].y)
            else
                @context.lineTo(@outterCIrcle + @background[i].x, @outterCIrcle + @background[i].y)
        @context.fill()

        @draw()

        @bg.texture.update()
        null

    addElement: (element, pos) ->
        if element instanceof PIXI.Texture
            s = new PIXI.Sprite element
        else if typeof element is 'string'
            s = new PIXI.Text element.toUpperCase(), AppData.TEXTFORMAT.PICKER
            s.scale.x = s.scale.y = 0.5

        s.anchor.x = s.anchor.y = 0.5
        s.position.x = pos.x
        s.position.y = pos.y
        @elements.addChild s
        null

    removeElements: ->
        for i in [0...@elements.children.length]
            child = @elements.children[0]
            @elements.removeChild child
        null

    draw: ->
        if not @snap
            curAngle = MathUtils.map @value, 0, 100, @initialAngle, @finalAngle, true
            @slide = @getSlide @initialAngle, curAngle, @innerCircle, @outterCIrcle
            @border = @getSlide @initialAngle, curAngle, @innerCircle, @innerCircle + @borderRadius
        else
            step = MathUtils.map @value, 0, 100, 0, @steps-1, true
            angleStep = (@finalAngle - @initialAngle) / @steps;
            @slide = @getSlide(Math.floor(@initialAngle + (angleStep * step)), Math.ceil(@initialAngle + (angleStep * (step + 1))), @innerCircle, @outterCIrcle);
            @border = @getSlide(Math.floor(@initialAngle + (angleStep * step)), Math.ceil(@initialAngle + (angleStep * (step + 1))), @innerCircle, @innerCircle + @borderRadius);

        # draw selected
        @context.beginPath()
        @context.fillStyle = 'rgba(255, 255, 255, 0.2)'
        for i in [0...@slide.length]
            if i is 0
                @context.moveTo(@outterCIrcle + @slide[i].x, @outterCIrcle + @slide[i].y)
            else if i is @slide.length-1
                @context.lineTo(@outterCIrcle + @slide[0].x, @outterCIrcle + @slide[0].y)
            else
                @context.lineTo(@outterCIrcle + @slide[i].x, @outterCIrcle + @slide[i].y)
        @context.fill()

        # draw border
        @context.beginPath()
        @context.fillStyle = 'rgba(255, 255, 255, 1)'
        for i in [0...@border.length]
            if i is 0
                @context.moveTo(@outterCIrcle + @border[i].x, @outterCIrcle + @border[i].y)
            else if i is @border.length-1
                @context.lineTo(@outterCIrcle + @border[0].x, @outterCIrcle + @border[0].y)
            else
                @context.lineTo(@outterCIrcle + @border[i].x, @outterCIrcle + @border[i].y)
        @context.fill()
        null
