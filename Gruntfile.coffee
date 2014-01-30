module.exports = (grunt) ->
    grunt.initConfig
        pkg: grunt.file.readJSON("package.json")

        stylus:
            compile:
                src: [
                    'src/public/css/fonts.styl'
                    'src/public/css/main.styl'
                ]
                dest: 'src/public/css/main.css'

        concat:
            scripts:
                src: [
                    'vendor/jquery/jquery.js'
                    'vendor/moment/moment.js'
                ]
                dest: 'src/public/js/vendor.js'
                options:
                    separator: ';'
            
            styles:
                src: [
                    'vendor/normalize-css/normalize.css'
                    'vendor/foundation/css/foundation.css'
                ]
                dest: 'src/public/css/vendor.css'

    grunt.loadNpmTasks('grunt-contrib-stylus')
    grunt.loadNpmTasks('grunt-contrib-concat')

    grunt.registerTask('default', [
        'stylus'
        'concat'
    ])