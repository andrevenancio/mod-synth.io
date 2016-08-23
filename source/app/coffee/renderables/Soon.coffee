class Soon extends PIXI.Sprite

    constructor: ->
        super()

        @anchor.x = 0.5
        @anchor.y = 0.5

        @hint = new PIXI.Text 'Your device resolution is too small.', AppData.TEXTFORMAT.SOON
        @hint.anchor.x = 0.5
        @hint.anchor.y = 1
        @hint.scale.x = @hint.scale.y = 0.5
        @hint.tint = 0xffffff
        @hint.y = 50 * AppData.RATIO
        @hint.hitArea = new PIXI.Rectangle(0, 0, 0, 0);
        @addChild @hint

        @hint2 = new PIXI.Text 'Please visit on your Desktop or Tablet.', AppData.TEXTFORMAT.SOON
        @hint2.anchor.x = 0.5
        @hint2.anchor.y = 1
        @hint2.scale.x = @hint2.scale.y = 0.5
        @hint2.tint = 0xffffff
        @hint2.y = 70 * AppData.RATIO
        @hint2.hitArea = new PIXI.Rectangle(0, 0, 0, 0);
        @addChild @hint2
