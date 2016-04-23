class Tour

    constructor: ->
        @canClick = false
        @stepIndex = 0
        @cur = 0
        @old = undefined

        @steps = []

        # open menu
        @steps.push {
            align: 'tr'
            x: 10
            y: 10
            instructions: 'Click on the menu icon to access your tools and settings'
            action: @action3
        }

        # add component
        @steps.push {
            align: 'tr'
            x: 10,
            y: 110,
            instructions: 'Click to add a new component'
            action: @action2
        }

        # add OSC
        @steps.push {
            align: 'tr'
            x: 139,
            y: 136,
            instructions: 'Let\'s start with an Oscillator to generate sound'
            action: @action3
        }

        # click on settings
        @steps.push {
            align: 'tl'
            x: 160,
            y: 160,
            instructions: 'Now select the component to change its settings'
            action: @action4
        }

        # click on settings
        @steps.push {
            align: 'bl'
            x: '50%',
            y: '25%',
            instructions: 'Last, you can use your keyboard or mouse to make sound. Enjoy!'
            action: @action5
        }

        @outer = document.createElement 'div'
        @outer.className = 'tour--outer-holder'
        document.body.appendChild @outer

        @dark = document.createElement 'div'
        @dark.className = 'tour--dark-holder'
        @outer.appendChild @dark

        @instructionsHolder = document.createElement 'div'
        @instructionsHolder.className = 'tour--instructions-holder'
        @outer.appendChild @instructionsHolder

        @instructions = document.createElement 'div'
        @instructions.className = 'tour--instructions-inner'
        @instructionsHolder.appendChild @instructions

        # add circle
        @inner = document.createElement 'div'
        @inner.className = 'tour--inner-holder'
        @outer.appendChild @inner

        @circle = document.createElement 'div'
        @circle.className = 'tour--circle'
        @inner.appendChild @circle

        @started = document.createElement 'div'
        @started.innerHTML = 'Get Started'
        @started.className = 'tour--get-started'
        @outer.appendChild @started

        # add nav
        @nav = document.createElement 'nav'
        @nav.className = 'nav'
        @outer.appendChild @nav

        for i in [0...@steps.length]
            a = document.createElement 'div'
            @nav.appendChild a

    start: ->
        if Modernizr.touch
            @circle.addEventListener 'touchend', @handleClick, false
            @started.addEventListener 'touchend', @handleClick, false
        else
            @circle.addEventListener 'mouseup', @handleClick, false
            @started.addEventListener 'mouseup', @handleClick, false

        AppData.TOUR_MODE = true
        AppData.KEYPRESS_ALLOWED = false
        TweenLite.to @dark, 0, { opacity: 0.7 }
        TweenLite.to @outer, 0.5, { autoAlpha: 1, onComplete: @handleStep }
        null

    end: ->
        if Modernizr.touch
            @circle.removeEventListener 'touchend', @handleClick, false
            @started.removeEventListener 'touchend', @handleClick, false
        else
            @circle.removeEventListener 'mouseup', @handleClick, false
            @started.removeEventListener 'mouseup', @handleClick, false

        TweenLite.to(@outer, 0.5, { autoAlpha: 0, onComplete: =>
            # reset everything
            TweenLite.to @dark, 0, { opacity: 0 }

            AppData.TOUR_MODE = false
            AppData.KEYPRESS_ALLOWED = true

            TweenLite.to @nav, 0, { autoAlpha: 1 }
            TweenLite.to @started, 0, { autoAlpha: 0, bottom: 0 }

            Cookies.setCookie 'tour', 'hide'
            null
        })
        null

    handleClick: (e) =>
        e.preventDefault()
        return if @canClick is false
        @canClick = false

        @steps[@stepIndex].action()
        @hideIndicator()
        null

    handleStep: =>
        if @cur isnt undefined
            @old = @cur
        @cur = @stepIndex;

        if @old isnt undefined
            @nav.children[@old].className = '';
        @nav.children[@stepIndex].className = 'selected'

        @instructions.innerHTML = @steps[@stepIndex].instructions

        @moveTo @steps[@stepIndex].align, @steps[@stepIndex].x, @steps[@stepIndex].y
        if @stepIndex < @steps.length-1
            @showIndicator()
        else
            @canClick = true
            TweenLite.to @nav, 0.3, { autoAlpha: 0 }
            TweenLite.to @started, 0.5, { autoAlpha: 1, bottom: @steps[@stepIndex].y, ease: Power2.easeInOut }
        null

    moveTo: (align, x, y) ->
        switch align
            when 'tr' then TweenLite.to @inner, 0.0, { css: { top: y, left: 'initial',bottom: 'initial', right: x } }
            when 'tl' then TweenLite.to @inner, 0.0, { css: { top: y, left: x,bottom: 'initial', right: 'initial' } }
            when 'bl' then TweenLite.to @inner, 0.0, { css: { top: 'initial', left: x,bottom: y, right: 'initial' } }
        null

    showIndicator: ->
        TweenLite.to @inner, 0.8, { autoAlpha: 1, delay: 0.5, ease: Power2.easeOut, onComplete: =>
            @canClick = true
            null
        }
        null

    hideIndicator: ->
        TweenLite.to @inner, 0.0, { autoAlpha: 0 }
        null

    delayToNextStep: (duration) ->
        setTimeout =>
            @stepIndex++
            if @stepIndex < @steps.length
                @handleStep()
            else
                @end()
        , duration
        null

    # open menu
    action1: =>
        AppData.SHOW_MENU_PANNEL = true
        App.TOGGLE_MENU.dispatch({ width: AppData.MENU_PANNEL + AppData.MENU_PANNEL_BORDER });
        @delayToNextStep 0
        null

    # open component pannel
    action2: =>
        window.app.menu.openSubmenu 1
        @delayToNextStep 0
        null

    # add OSC
    action3: =>
        component = {
            'type_uid': 1,
            x: -(AppData.WIDTH/2+app.dashboard.x) + 200*AppData.RATIO,
            y: -(AppData.HEIGHT/2+app.dashboard.y) + 200*AppData.RATIO
        }
        data = Session.ADD component

        # App.ADD.dispatch data
        # App.SETTINGS_CHANGE.dispatch { component: data.component_session_uid }
        # @delayToNextStep 0
        null

    action4: =>
        for uid of Session.SETTINGS
            App.TOGGLE_SETTINGS_PANNEL_HEIGHT.dispatch {
                type: true
                component_session_uid: Session.SETTINGS[uid].component_session_uid
            }
        AppData.SHOW_MENU_PANNEL = false
        App.TOGGLE_MENU.dispatch { width: 0 }
        @delayToNextStep 0
        null

    action5: =>
        @delayToNextStep 0
