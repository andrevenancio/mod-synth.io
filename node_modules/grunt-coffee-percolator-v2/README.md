# grunt-coffee-percolator

> Soulwire's CakeFile Percolator ported to grunt task
> For usage and documentation, see Soulwire's repo at https://github.com/soulwire/Coffee-Percolator


## Release History

Original authors not replying any Pull Request, so this project was taken over and pushed to a new NPM 

`grunt-coffee-percolator-v2`


## Getting Started
This plugin requires Grunt `~0.4.1`

If you haven't used [Grunt](http://gruntjs.com/) before, be sure to check out the [Getting Started](http://gruntjs.com/getting-started) guide, as it explains how to create a [Gruntfile](http://gruntjs.com/sample-gruntfile) as well as install and use Grunt plugins. Once you're familiar with that process, you may install this plugin with this command:

```shell
npm install grunt-coffee-percolator-v2 --save-dev
```

One the plugin has been installed, it may be enabled inside your Gruntfile with this line of JavaScript:

```js
grunt.loadNpmTasks('grunt-coffee-percolator-v2');
```

## The "coffee_percolator" task

### Overview
In your project's Gruntfile, add a section named `coffee_percolator` to the data object passed into `grunt.initConfig()`.

```js
grunt.initConfig({
  percolator: {
    source: 'path/to/js/folder',
    output: 'path/to/js/folder/main.js',
    main: 'main.coffee',
    compile: true,
    opts: '--bare'
  },
})
```

### Multitask

```js
grunt.initConfig({
  percolator: {
    main:{
        source: 'path/to/js/folder',
        output: 'path/to/js/folder/main.js',
        main: 'main.coffee',
        compile: true,
        opts: '--bare'
    },
    helpers:{
        source: 'path/to/js/helper/folder',
        output: 'path/to/js/helper/folder/main.js',
        main: 'helper.coffee',
        compile: true,
        opts: '--bare'
    }
  },
})
```

### Options

#### source
Type: `String`
Default value: `'.'`

A string value that specifies the base folder of your js/coffee.

#### output
Type: `String`
Default value: `'scripts.min.js'`

A string value that is the compiled js file.

#### main
Type: `String`
Default value: `'main.coffee'`

A string value that is the main coffee-file to compile.

#### compile
Type: `Boolean`
Default value: `true`

A boolean for if the files should be compiled or not.

#### opts
Type: `String`
Default value: `''`

A string value that of one or more coffee options.

