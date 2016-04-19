class Cookies

    @DURATION: 365

    @setCookie: (cname, cvalue) ->
        d = new Date
        d.setTime d.getTime() + Cookies.DURATION * 24 * 60 * 60 * 1000
        expires = 'expires=' + d.toUTCString()
        document.cookie = cname + '=' + cvalue + '; ' + expires
        return

    @getCookie: (cname) ->
        name = cname + '='
        ca = document.cookie.split(';')
        i = 0
        while i < ca.length
            c = ca[i]
            while c.charAt(0) == ' '
                c = c.substring(1)
            if c.indexOf(name) == 0
                return c.substring(name.length, c.length)
            i++
        return false
