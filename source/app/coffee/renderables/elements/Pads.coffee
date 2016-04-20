# import renderables.buttons.Pad
class Pads extends PIXI.Container

    constructor: (@component_session_uid) ->
        super()

        App.SETTINGS_CHANGE.add @onSettingsChange
        App.PATTERN_GATE.add @onPadChange
        @total = 16

    resize: =>
        @availableArea = AppData.WIDTH - AppData.PADDING - AppData.ICON_SIZE_1 - AppData.PADDING - @x
        @itemArea = @availableArea / @total

        @removePads()
        @addPads()
        null

    removePads: ->
        for i in [0...@children.length]
            child = @children[0]
            @removeChild child
        null

    addPads: ->
        for i in [0...@total]
            pad = new Pad i, @itemArea
            pad.x = (@itemArea * i)
            pad.setActive Session.patch.presets[Session.patch.preset][@component_session_uid].pattern[i]
            pad.buttonClick = @handlePad
            @addChild pad
        null

    handlePad: (index) =>
        Session.patch.presets[Session.patch.preset][@component_session_uid].pattern[index] = !@children[index].active
        App.SETTINGS_CHANGE.dispatch { component: @component_session_uid }
        null

    onSettingsChange: (event) =>
        if event.component is @component_session_uid
            for i in [0...Session.patch.presets[Session.patch.preset][@component_session_uid].pattern.length]
                @children[i].setActive Session.patch.presets[Session.patch.preset][@component_session_uid].pattern[i]
        null

    onPadChange: (pad) =>
        tick = pad
        untick = pad-1
        if pad is 0
            untick = 15

        @children[tick].tick()
        @children[untick].untick()
        null
