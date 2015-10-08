gulp = require 'gulp'
libs = require('gulp-load-plugins')()
pkg = require './package.json'

paths =
	src: 'HakataWritingRules.jade'
	html: 'HakataWritingRules.html'
	dist: '../HakataWritingRules.html'

gulp.task 'build', ->
	gulp.src paths.src
	.pipe libs.jade()
	.pipe gulp.dest '.'

gulp.task 'test', ['build'], ->
	gulp.src paths.html
	.pipe libs.html5Lint()

gulp.task 'dist', ->
	gulp.src paths.html
	.pipe gulp.dest paths.dist

gulp.task 'default', ['test']
