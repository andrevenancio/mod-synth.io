# import App
do me = ->

    args = [
        '\n %cMOD%cSYNTH\n',
        'background: #000000; color: #3a3a3a; font-size: x-large;'
        'background: #3a3a3a; color: #000000; font-size: x-large;'
        '\nDEVELOPMENT\nhttp://twitter.com/andrevenancio'
        '\n\nDESIGN\nhttp://twitter.com/janoskoos'
        '\n\nFollow us on twitter for new updates!\nhttp://twitter.com/modsynth_io'
        '\n\nSOURCE:\nhttps://github.com/LowwwLtd/mod-synth.io'
    ]
    console.log.apply console, args
    window.app = new App()
    null
