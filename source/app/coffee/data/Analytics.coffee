class Analytics

    @event: (category, type, id) ->
        if window.ga and location.hostname is not 'localhost'
            if id
                ga 'send', 'event', category, type, id
            else
                ga 'send', 'event', category, type
        null
