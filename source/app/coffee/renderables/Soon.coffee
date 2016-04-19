class Soon extends PIXI.Sprite

    constructor: ->
        super()

        @anchor.x = 0.5
        @anchor.y = 0.5

        @hint = new PIXI.Text 'We\'re working on the mobile version. Please come back later.', AppData.TEXTFORMAT.SOON
        @hint.anchor.x = 0.5
        @hint.anchor.y = 1
        @hint.scale.x = @hint.scale.y = 0.5
        @hint.tint = 0xffffff
        @hint.y = 50 * AppData.RATIO
        @hint.hitArea = new PIXI.Rectangle(0, 0, 0, 0);
        @addChild @hint
