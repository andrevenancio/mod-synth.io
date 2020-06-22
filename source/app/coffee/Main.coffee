# import App
do me = ->

    args = [
        '\n\n%c MOD%cSYNTH \n\n',
        'background: #000000; color: #3a3a3a; font-size: x-large;'
        'background: #3a3a3a; color: #000000; font-size: x-large;'
        '\nhttps://github.com/andrevenancio/mod-synth.io\n\n'
    ]
    console.log.apply console, args

    window.app = new App()
    null
