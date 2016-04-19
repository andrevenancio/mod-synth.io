class Utils

    # loads json file
    @loadJSON: (url) ->
        return new Promise (resolve, reject) ->
            xhr = new XMLHttpRequest()
            xhr.open 'get', url, true
            xhr.responseType = 'json'
            xhr.onload = ->
                status = xhr.status
                if status is 200
                    resolve xhr.response
                else
                    reject status
                null
            xhr.onerror = ->
                reject Error('Network Error')
                null
            xhr.send()
            null

    # gets query string params
    @getQueryParam: (name) ->
        name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]")
        regex = new RegExp "[\\?&]" + name + "=([^&#]*)"
        results = regex.exec location.search.toLowerCase()
        return if results is null then false else decodeURIComponent results[1].replace(/\+/g, " ")

    # confirm window with callback
    @confirm: (action, onConfirm) ->
        # bypassing warning
        onConfirm()

        # w = confirm action
        # if w
        #     onConfirm()
        null
