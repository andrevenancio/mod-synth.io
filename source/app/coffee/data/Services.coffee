# http://jsfiddle.net/firebase/a221m6pb/
# https://jsfiddle.net/andrevenancio/07j0p9ub/
class Services

    # end point to firebase app
    @REFERENCE: new Firebase "https://mod-synth.firebaseio.com"

    @PATCHES: @REFERENCE.child('patches');

    @api: {
        login: {
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
        },

        patches: {

            generateUID: ->
                return ('000000' + (Math.random() * Math.pow(36, 6) << 0).toString(36)).slice(-6)

            load_patch: (patch_id, callback) ->
                patch = Services.PATCHES.child(patch_id)
                patch.once 'value', callback
                null

            getAll: (callback) ->
                if Services.REFERENCE.getAuth()
                    Services.PATCHES.orderByChild('author').equalTo(Services.REFERENCE.getAuth().uid).once 'value', callback
                else
                    # You need to be logged in to be able to do that
                null

            set_patch: (patch_name, callback) ->
                if Services.REFERENCE.getAuth()
                    # override current Settings data
                    Session.patch.uid = Services.api.patches.generateUID()
                    Session.patch.name = patch_name
                    Session.patch.author = Services.REFERENCE.getAuth().uid
                    Session.patch.author_name = Services.REFERENCE.getAuth()[Services.REFERENCE.getAuth().auth.provider].displayName
                    Session.patch.date = String(Date.now())

                    # clear any existing patch

                    # saves patch with current settings data
                    patch = Services.PATCHES.child(Session.patch.uid)
                    patch.set({
                        uid: Session.patch.uid
                        name: Session.patch.name
                        author: Session.patch.author
                        author_name: Session.patch.author_name
                        date: Session.patch.date
                        components: Session.SETTINGS
                    });
                    patch.once 'value', callback
                else
                    # You need to be logged in to be able to do that
                null

            update_patch: (component_session_uid, callback) ->
                return if Session.patch.uid is 'default'
                if Services.REFERENCE.getAuth()

                    patch = Services.PATCHES.child(Session.patch.uid)
                    component = patch.child('components')
                    component.remove =>
                        component.update(Session.SETTINGS);
                        # component.once 'value', callback
                        null
                else
                    # You need to be logged in to be able to do that
                    # or You are not the owner
                null

            delete_patch: (patch_id, callback) ->
                if Services.REFERENCE.getAuth()
                    patch = Services.PATCHES.child(patch_id)
                    patch.remove callback
                else
                    # You need to be logged in to be able to do that
                null
        }
    }
