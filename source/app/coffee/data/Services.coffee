# http://jsfiddle.net/firebase/a221m6pb/
# https://jsfiddle.net/andrevenancio/07j0p9ub/
class Services

    # end point to firebase app
    @REFERENCE: new Firebase "https://mod-synth.firebaseio.com"

    @PATCHES: @REFERENCE.child('patches');

    @PRESETS: @REFERENCE.child('presets');

    # http://www.broofa.com/Tools/Math.uuid.htm
    @GENERATE_UID: (len, radix) ->
        chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'.split('')
        uuid = []
        i = undefined
        radix = radix or chars.length
        if len
            i = 0
            while i < len
                uuid[i] = chars[0 | Math.random() * radix]
                i++
        else
            r = undefined
            uuid[8] = uuid[13] = uuid[18] = uuid[23] = '-'
            uuid[14] = '4'
            i = 0
            while i < 36
                if !uuid[i]
                    r = 0 | Math.random() * 16
                    uuid[i] = chars[if i == 19 then r & 0x3 | 0x8 else r]
                i++
        return uuid.join ''

    @api:

        login:
            twitter: (callback) ->
                Services.REFERENCE.authWithOAuthPopup "twitter", (error, authData) ->
                    if error
                        console.error 'Login Failed!', error
                    else
                        callback authData
                    null
                null

            facebook: (callback) ->
                Services.REFERENCE.authWithOAuthPopup "facebook", (error, authData) ->
                    if error
                        console.error 'Login Failed!', error
                    else
                        callback authData
                    null
                , { scope: "email," }
                null

            github: (callback) ->
                Services.REFERENCE.authWithOAuthPopup "github", (error, authData) ->
                    if error
                        console.error 'Login Failed!', error
                    else
                        callback authData
                    null
                null

            logout: (callback) ->
                Services.REFERENCE.unauth()
                if callback
                    callback()
                null

        patches:

            getAll: (callback) ->
                if Services.REFERENCE.getAuth()
                    Services.PATCHES.orderByChild('author').equalTo(Services.REFERENCE.getAuth().uid).once 'value', callback
                null

            load: (patch_id, callback) ->
                console.log 'firebase load', patch_id
                patch = Services.PATCHES.child(patch_id)
                patch.once 'value', callback
                Services.api.presets.loadAll patch_id
                null

            save: (patch_name, callback) ->
                if Services.REFERENCE.getAuth()
                    # adds data
                    Session.patch.uid = Services.GENERATE_UID(16)
                    Session.patch.author = Services.REFERENCE.getAuth().uid
                    Session.patch.author_name = Services.REFERENCE.getAuth()[Services.REFERENCE.getAuth().auth.provider].displayName
                    Session.patch.components = {}
                    Session.patch.date = String(Date.now())
                    Session.patch.name = patch_name
                    Session.patch.preset = Services.GENERATE_UID(16)
                    Session.patch.presets = {}

                    # saves patch with current settings data
                    patch = Services.PATCHES.child(Session.patch.uid)
                    patch.set({
                        uid: Session.patch.uid
                        author: Session.patch.author
                        author_name: Session.patch.author_name
                        components: Session.patch.components
                        date: Session.patch.date
                        name: Session.patch.name
                        preset: Session.patch.preset
                    });
                    patch.once 'value', (snapshot) ->
                        Cookies.setCookie 'patch', snapshot.val().uid
                        Services.api.presets.save Session.patch.uid, Session.patch.preset, 'default', callback
                        null
                null

            remove: (patch_id, callback) ->
                if Services.REFERENCE.getAuth()
                    patch = Services.PATCHES.child(patch_id)
                    patch.remove (snapshot) ->
                        Services.api.presets.remove patch_id, callback
                        null
                null

            update: (callback) ->
                return if Session.patch.uid is 'default'

                if Services.REFERENCE.getAuth()
                    patch = Services.PATCHES.child(Session.patch.uid)
                    component = patch.child('components')
                    component.remove =>

                        components = Session.DUPLICATE_OBJECT Session.SETTINGS
                        for comp of components
                            delete components[comp].settings

                        component.update components
                        component.once 'value', (snapshot) ->
                            Services.api.presets.update callback
                            null
                        null
                null

        presets:

            loadAll: (patch_id, callback) ->
                presets = Services.PRESETS.child(patch_id)
                presets.once 'value', (data) ->
                    d = data.val()
                    # loads default presets
                    if patch_id is Session.default.uid
                        Session.default.presets = d
                    Session.patch.presets = d
                    App.PRESET_CHANGED.dispatch()
                    null
                null

            save: (patch_id, preset_id, preset_name, callback) ->
                patch = Services.PRESETS.child(patch_id)
                preset = patch.child(preset_id)
                preset.set({
                    date: String(Date.now())
                    name: preset_name
                });
                preset.once 'value', callback
                null

            remove: (patch_id, callback) ->
                patch = Services.PRESETS.child(patch_id)
                patch.remove callback
                null

            update: (callback) ->
                patch = Services.PRESETS.child(Session.patch.uid)
                preset = patch.child(Session.patch.preset)

                components = {}
                for comp of Session.SETTINGS
                    components[comp] = Session.SETTINGS[comp].settings

                preset.update components
                preset.once 'value', (snapshot) ->
                    # console.log 'preset updated, change settings object in session'
                    preset = Session.patch.preset
                    # console.log 'PRESET:', preset
                    # console.log Session.patch.presets[preset]

                    # App.PRESET_CHANGED.dispatch()
                    if callback
                        callback()
                null
