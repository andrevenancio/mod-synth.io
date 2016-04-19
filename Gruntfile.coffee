module.exports = (grunt) ->
    grunt.initConfig

        pkg: grunt.file.readJSON 'package.json'

        # grunt-contrib-watch
        watch:
            app:
                files: ['Gruntfile.coffee', 'source/app/coffee/**/*coffee', 'source/app/sass/*.sass']
                tasks: ['percolator:app', 'sass:app']

        # grunt-coffee-percolator-v2
        percolator:
            app:
                source: 'source/app/coffee'
                output: 'deploy/js/app.js'
                main: 'Main.coffee'
                compile: true
                opts: "--bare"

        # grunt-contrib-sass
        sass:
            dist:
                options:
                    noCache: false
                    sourcemap: 'none'
            app:
                files:
                    'deploy/css/app.css': 'source/app/sass/style.sass'

            iframe:
                files:
                    'deploy/css/iframe.css': 'source/app/sass/iframe.sass'

            ipad:
                files:
                    'deploy/css/ipad.css': 'source/ipad/sass/Main.sass'

        # grunt-contrib-copy
        copy:
            main:
                expand: true
                cwd: 'source/_static/'
                src: '**'
                dest: 'deploy/'
                filter: 'isFile'

        # grunt-contrib-connect
        connect:
            server:
                options:
                    port: 8081,
                    base: 'deploy/'

        # grunt-contrib-uglify
        uglify:
            options:
                compress:
                    dead_code: true
                    drop_debugger: true
                    unused: true
                    drop_console: false
                screwIE8: true
            app:
                src: 'deploy/js/app.js',
                dest: 'deploy/js/app.min.js'
            vendors:
                files:
                    'deploy/js/vendors.min.js': ['deploy/vendors/*.js']

        # grunt-contrib-cssmin
        cssmin:
            app:
                files:
                    'deploy/css/app.min.css': ['deploy/css/app.css']

        # grunt-contrib-clean
        clean:
            options:
                force: true
            all: ['deploy/']
            deploy: [
                'deploy/css/app.css'
                'deploy/css/app.css.map'
                'deploy/js/app.js'
                'deploy/vendors/'
                'deploy/css/index.html'
            ]
        # grunt-contrib-rename
        rename:
            index:
                files: [
                    { src: ['deploy/PRODUCTION.html'], dest: 'deploy/index.html'},
                ]

    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-contrib-sass'
    grunt.loadNpmTasks 'grunt-coffee-percolator-v2'
    grunt.loadNpmTasks 'grunt-contrib-connect'
    grunt.loadNpmTasks 'grunt-contrib-uglify'
    grunt.loadNpmTasks 'grunt-contrib-copy'
    grunt.loadNpmTasks 'grunt-contrib-cssmin'
    grunt.loadNpmTasks 'grunt-contrib-clean'
    grunt.loadNpmTasks 'grunt-contrib-rename'

    grunt.registerTask 'default', ['clean:all', 'copy', 'percolator:app', 'sass:app', 'cssmin:app', 'uglify:app', 'uglify:vendors', 'clean:deploy', 'rename:index']
    grunt.registerTask 'dev', ['clean:all', 'copy', 'percolator:app', 'sass:app', 'connect', 'watch:app']
