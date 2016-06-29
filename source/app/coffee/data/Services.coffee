# http://jsfiddle.net/firebase/a221m6pb/
# https://jsfiddle.net/andrevenancio/07j0p9ub/

config = {
    apiKey: "AIzaSyBcFB1TdT_ZLULA0PHSqKg4NHUZRFosJ4g",
    authDomain: "mod-synth.firebaseapp.com",
    databaseURL: "https://mod-synth.firebaseio.com",
    storageBucket: "",
}
firebase.initializeApp(config);

class Services

    @REFERENCE: firebase,

    @PATCHES: firebase.database().ref('patches')

    @PRESETS: firebase.database().ref('presets');

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
                provider = new firebase.auth.TwitterAuthProvider();

                firebase.auth()
                    .signInWithPopup(provider)
                    .then (result) ->
                        callback result
                    .catch (error) ->
                        console.error(error);
                null

            facebook: (callback) ->
                provider = new firebase.auth.FacebookAuthProvider();
                provider.addScope('email');

                firebase.auth()
                    .signInWithPopup(provider)
                    .then (result) ->
                        callback result
                    .catch (error) ->
                        console.error(error);
                null

            github: (callback) ->
                provider = new firebase.auth.GithubAuthProvider();

                firebase.auth()
                    .signInWithPopup(provider)
                    .then (result) ->
                        callback result
                    .catch (error) ->
                        console.error(error);
                null

            logout: (callback) ->
                firebase.auth().signOut()
                if callback
                    callback()
                null

        patches:

            getAll: (callback) ->
                if Services.REFERENCE.auth().currentUser
                    # console.log('%cpatches', 'background-color: black; color: green', 'getAll');
                    Services.PATCHES.orderByChild('author').equalTo(Services.REFERENCE.auth().currentUser.providerData[0].uid).once 'value', callback
                null

            load: (patch_id, callback) ->
                # console.log('%cpatches', 'background-color: black; color: green', 'load');
                patch = Services.PATCHES.child(patch_id)
                patch.once 'value', callback
                null

            save: (patch_name, callback) ->
                if Services.REFERENCE.auth().currentUser
                    # console.log('%cpatches', 'background-color: black; color: green', 'save');
                    providerData = Services.REFERENCE.auth().currentUser.providerData[0];

                    # adds data
                    Session.patch.uid = Services.GENERATE_UID(16)
                    Session.patch.author = providerData.uid
                    Session.patch.author_name = providerData.displayName
                    Session.patch.components = Session.SETTINGS
                    Session.patch.date = String(Date.now())
                    Session.patch.name = patch_name
                    Session.patch.preset = 'default'
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
                    patch.once 'value', callback
                null

            remove: (patch_id, callback) ->
                if Services.REFERENCE.auth().currentUser
                    # console.log('%cpatches', 'background-color: black; color: green', 'remove');
                    patch = Services.PATCHES.child(patch_id)
                    patch.remove (snapshot) =>
                        Services.api.presets.removeAll patch_id, callback
                        null
                null

            update: (callback) ->
                return if Session.patch.uid is 'default'

                if Services.REFERENCE.auth().currentUser
                    # console.log('%cpatches', 'background-color: black; color: green', 'update');

                    patch = Services.PATCHES.child(Session.patch.uid)
                    component = patch.child('components')
                    component.remove =>

                        components = Session.DUPLICATE_OBJECT Session.SETTINGS
                        for comp of components
                            delete components[comp].settings

                        component.update components
                        component.once 'value', callback
                        null
                null

        presets:

            loadAll: (patch_id, callback) ->
                # console.log('%cpreset', 'background-color: black; color: red', 'loadAll');
                presets = Services.PRESETS.child(patch_id)
                presets.once 'value', callback
                null

            save: (patch_id, preset_id, preset_name, callback) ->
                # console.log('%cpreset', 'background-color: black; color: red', 'save');

                patch = Services.PRESETS.child(patch_id)
                preset = patch.child(preset_id)
                preset.set({
                    date: String(Date.now())
                    name: preset_name
                    components: {}
                });
                preset.once 'value', (snapshot) =>
                    Services.api.presets.loadAll patch_id, callback
                    null
                null

            removeAll: (patch_id, callback) ->
                # console.log('%cpreset', 'background-color: black; color: red', 'removeAll');
                presets = Services.PRESETS.child(patch_id)
                presets.remove callback
                null

            remove: (patch_id, callback) ->
                # console.log('%cpreset', 'background-color: black; color: red', 'remove');
                presets = Services.PRESETS.child(Session.patch.uid)
                preset = presets.child(patch_id)
                preset.remove (error) =>
                    if not error
                        Services.api.presets.loadAll Session.patch.uid, (snapshot) =>
                            Session.patch.preset = 'default'
                            Session.patch.presets = snapshot.val()
                            if callback
                                callback snapshot
                            null
                null

            # updates settings of known components
            update: (id, callback) ->
                return if Session.patch.uid is 'default'
                # console.log('%cpreset', 'background-color: black; color: red', 'update');

                presets = Services.PRESETS.child(Session.patch.uid)
                preset = presets.child(id)
                component = preset.child('components')
                component.remove =>
                    components = Session.DUPLICATE_OBJECT Session.SETTINGS

                    # loops all components
                    for comp of components
                        # loops all properties in component
                        for prop of components[comp]
                            # deletes everything outsite settings
                            if prop isnt 'settings'
                                delete components[comp][prop]
                            else
                                # loops everything inside settings, and saves it
                                for p of components[comp][prop]
                                    components[comp][p] = components[comp][prop][p]
                                # safely remove settings
                                delete components[comp][prop]

                    component.update components
                    component.once 'value', (snapshot) =>
                        Session.patch.presets[id].components = snapshot.val()
                        if callback
                            callback snapshot
                    null
                null

            # updates settings of known components
            updateAdd: (id, data) ->
                return if Session.patch.uid is 'default'
                # console.log('%cpreset', 'background-color: black; color: red', 'updateAdd');

                settings = Session.DUPLICATE_OBJECT data.settings

                presets = Services.PRESETS.child(Session.patch.uid)
                preset = presets.child(id)
                components = preset.child('components')
                component = components.child(data.component_session_uid)
                component.set settings
                component.once 'value', (snapshot) =>
                    if Session.patch.presets[id].components is null
                        Session.patch.presets[id].components = {}
                    Session.patch.presets[id].components[data.component_session_uid] = snapshot.val()
                    null
                null

            # removes component
            updateRemove: (id, component_session_uid) ->
                return if Session.patch.uid is 'default'
                # console.log('%cpreset', 'background-color: black; color: red', 'updateRemove');

                presets = Services.PRESETS.child(Session.patch.uid)
                preset = presets.child(id)
                components = preset.child('components')
                component = components.child(component_session_uid)
                component.remove (error) =>
                    if not error
                        delete Session.patch.presets[id].components[component_session_uid]
                    null
                null
