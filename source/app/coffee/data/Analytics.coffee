class Analytics

    @event: (category, type, id) ->
        if window.ga
            if id
                ga 'send', 'event', category, type, id
            else
                ga 'send', 'event', category, type
        null
