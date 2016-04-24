class Prompt

    constructor: ->
        # builds the HTML
        # <div class="prompt--holder">
        #     <div class="prompt--holder-window">
        #         <div class="prompt--holder-message">Please choose patch name:</div>
        #         <input class="prompt--holder-input" type="text" name="fname">
        #         <div class="prompt--holder-buttons">
        #             <button>CANCEL</button>
        #             <button>OK</button>
        #         </div>
        #     </div>
        # </div>

        # Example:
        # App.PROMPT.dispatch {
        #     question: 'Patch name:'
        #     input: true
        #     onConfirm: (data) =>
        #         null
        # }

        # regular expression for input field
        @defaultREGEXP = /^.{4,}/
        @defaultValidationMessage = 'Must have 4 or more characters'

        @validateInput = false
        @validationMessage = @defaultValidationMessage
        @validationREGEXP = @defaultREGEXP

        # confirm function (set by event prop)
        @confirmFN = null

        @holder = document.createElement 'div'
        @holder.className = 'prompt--holder'
        document.body.appendChild @holder

        @holderWindow = document.createElement 'div'
        @holderWindow.className = 'prompt--holder-window'
        @holder.appendChild @holderWindow

        @holderMessage = document.createElement 'div'
        @holderMessage.innerHTML = 'QUESTION?'
        @holderMessage.className = 'prompt--holder-message'
        @holderWindow.appendChild @holderMessage

        @holderInput = document.createElement 'input'
        @holderInput.type = 'text'
        @holderInput.className = 'prompt--holder-input'
        @holderInput.style.display = 'none'
        @holderWindow.appendChild @holderInput

        @holderInputValidation = document.createElement 'p'
        @holderInputValidation.className = 'prompt--holder-input-validation'
        @holderInputValidation.style.display = 'none'
        @holderWindow.appendChild @holderInputValidation

        @holderButtons = document.createElement 'div'
        @holderButtons.className = 'prompt--holder-buttons'
        @holderWindow.appendChild @holderButtons

        @cancel = document.createElement 'button'
        @cancel.innerHTML = 'cancel'
        @holderButtons.appendChild @cancel

        @confirm = document.createElement 'button'
        @confirm.innerHTML = 'confirm'
        @holderButtons.appendChild @confirm

    handleCancel: (e) =>
        @hide()
        null

    handleConfirm: (e) =>
        # if using validation the confirmFN will be called by validation method
        if @handleValidation()

            if @confirmFN
                @confirmFN @holderInput.value
            @hide()
        null

    handleValidation: (regexp) =>
        if @validateInput is false
            return true

        # implement regexp validation and toggle warning if is not valid
        if @defaultREGEXP.test(@holderInput.value) is false
            @holderInputValidation.style.display = 'block'
            @holderInputValidation.innerHTML = @validationMessage
            return false
        else
            return true
        null

    show: (data) ->
        if data.onConfirm
            @confirmFN = data.onConfirm

        if data.question
            @holderMessage.innerHTML = data.question

        if data.input
            @holderInput.style.display = 'block'
            @validateInput = true
            if data.regexp
                @validationREGEXP = data.regexp

        AppData.KEYPRESS_ALLOWED = false
        TweenLite.to(@holder, 0.5, { autoAlpha: 1 })

        @cancel.addEventListener 'click', @handleCancel, false
        @confirm.addEventListener 'click', @handleConfirm, false
        null

    hide: ->
        @cancel.removeEventListener 'click', @handleCancel, false
        @confirm.removeEventListener 'click', @handleConfirm, false
        TweenLite.to(@holder, 0.5, { autoAlpha: 0, onComplete: =>

            AppData.KEYPRESS_ALLOWED = true

            # reset everything
            @holderInput.value = ''
            @holderInput.style.display = 'none'
            @holderInputValidation.style.display = 'none'

            @validateInput = false
            @validationMessage = @defaultValidationMessage
            @validationREGEXP = @defaultREGEXP

            @confirmFN = null

            null
        })
        null
