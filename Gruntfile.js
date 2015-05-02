module.exports = function(grunt) {

  var path = require('path'),
      fs = require('fs'),
      shell = require('shelljs');
  grunt.loadNpmTasks('grunt-docco');

  // Load grunt tasks automatically
  require('load-grunt-tasks')(grunt);

  var MODULE_NAME = 'tz-date';
  var SRC_DIR = 'src';
  var DIST_DIR = 'lib';
  var DOCS_DIR = 'docs';

  // Define the configuration for all the tasks.
  grunt.initConfig({
    coffee: {
      dist: {
        expand: true,
        flatten: false,
        cwd: SRC_DIR,
        src: ['**/*.coffee'],
        dest: DIST_DIR,
        ext: '.js'
      }
    },
    copy: {
      dist: {
        expand: true,
        cwd: SRC_DIR,
        src: ['fixtures/**/*'],
        dest: DIST_DIR
      }
    },
    clean: {
      dist: DIST_DIR,
      docs: DOCS_DIR
    },
    docco: {
      debug: {
        src: ['src/**/*.coffee'],
        options: {
          output: DOCS_DIR
        }
      }
    },
    mochaTest: {
      test: {
        options: {
          reporter: 'spec',
          require: 'coffee-script/register'
        },
        src: ['test/**/*Spec.coffee']
      }
    },
    'node-inspector': {
      dev: {
        options: {
          'hidden': ['node_modules']
        }
      }
    }
  });

  grunt.registerTask('build', 'Build a distributable package.', ['coffee:dist', 'copy:dist']);
  grunt.registerTask('test', 'Runs tests.', function (arg1) {
    if (arg1 === undefined) {
      grunt.task.run('mochaTest');
    } else {
      shell.exec('mocha --reporter spec --require coffee-script/register test/' + arg1);
    }
  });

  grunt.registerTask('docs', 'Compiles docs with Docco.', function() {
    grunt.task.run('docco');
  });

  grunt.registerTask('inspector', 'Runs node-inspector.', ['node-inspector:dev']);
  grunt.registerTask('test:ci', 'Runs tests.', ['mochaTest']);

  // FILES

  function readFile(file) {
    return fs.readFileSync(file, {encoding: 'utf-8'});
  }

  function writeFile(file, data) {
    if (typeof data === 'function') {
      data = data(readFile(file));
    }
    fs.writeFileSync(file, data);
  }

  function _prefixPath(dir, args) {
    var prefixedArgs = Array.prototype.slice.apply(args);
    prefixedArgs.unshift(dir);
    return path.join.apply(path, prefixedArgs);
  }

  function srcPath() {
    return _prefixPath(SRC_DIR, arguments);
  }

  function distPath() {
    return _prefixPath(DIST_DIR, arguments);
  }

};
