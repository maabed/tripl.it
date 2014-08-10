module.exports = (grunt) ->

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    app: 'app'
    dist: 'www'

    template:
      config:
        options:
          data:
            id: 'tripli.it.app'
            version: '<%= pkg.version %>'
            name: '<%= pkg.name %>'
            description: '<%= pkg.description %>'
            author:
              email: 'gabrielpoca@gmail.com'
              href: 'http://groupbuddies.com'
              text: 'Group Buddies'
        files:
          '<%= dist %>/config.xml': '_config.xml'

    connect:
      options:
        hostname: 'localhost'
        livereload: 35729
        port: 3001
      server:
        options:
          base: 'www'

    coffee:
      compile:
        files:
          '<%= dist %>/js/app.js': ['<%= app %>/js/{,*/}*.coffee', '<%= app %>/components/{,*/}*.coffee']
    sass:
      dist:
        options:
          includePaths: require('node-bourbon').includePaths
          outputStyle: 'extended'
        files:
          '<%= dist %>/css/index.css': '<%= app %>/components/styles.sass'

    htmlmin:
      dist:
        options:
          collapseWhitespace: true
        files: [
          expand: true
          cwd: '<%= dist %>/'
          dest: '<%= dist %>/'
          src: [ '*.html', 'partials/*/*.html', 'components/*/*.html' ]
        ]

    useminPrepare:
      html: '<%= app %>/index.html'
      options:
        dest: '<%= dist %>'
        flow:
          html:
            steps:
              js: ['concat']
            post: {}

    copy:
      dist:
        files: [{
          expand: true
          cwd: '<%= app %>/'
          src: ['index.html', 'partials/*.html', 'partials/*/*.html', 'components/*/*.html', 'img/*']
          dest: '<%= dist %>/'
        },{
          expand: true
          src: ['res/**']
          dest: '<%= dist %>/'
        }]

    usemin:
      html: '<%= dist %>/index.html'

    watch:
      options:
        livereload: '<%= connect.options.livereload %>'
      copy:
        files: [
          '<%= app %>/*.html',
          '<%= app %>/partials/{,*/}*.html',
          '<%= app %>/components/{,*/}*.html'
        ]
        tasks: ['copy', 'useminPrepare','concat', 'usemin', 'htmlmin']
      coffee:
        files: ['<%= app %>/js/{,*/}*.coffee', '<%= app %>/components/{,*/}*.coffee']
        tasks: 'coffee'
      sass:
        files: ['<%= app %>/components/{,*/}*.sass']
        tasks: 'sass'

  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-phonegap'
  grunt.loadNpmTasks 'grunt-sass'
  grunt.loadNpmTasks 'grunt-usemin'
  grunt.loadNpmTasks 'grunt-contrib-htmlmin'
  grunt.loadNpmTasks 'grunt-template'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-text-replace'


  grunt.registerTask 'build', [
    'template'
    'sass'
    'coffee'
    'copy'
    'useminPrepare'
    'concat'
    'usemin'
    'htmlmin'
  ]

  grunt.registerTask 'server', [
      'template'
      'sass'
      'coffee'
      'copy'
      'useminPrepare'
      'concat'
      'usemin'
      'connect:server'
      'htmlmin'
      'watch'
    ]
