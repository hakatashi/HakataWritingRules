gulp = require 'gulp'
libs = require('gulp-load-plugins')()
pkg = require './package.json'

toMarkdown = require 'to-markdown'
through = require 'through2'

paths =
	src: 'HakataWritingRules.jade'
	html: 'HakataWritingRules.html'
	md: 'HakataWritingRules.md'
	dist: '..'

libs.toMarkdown = ->
	through.obj (file, enc, done) ->
		file.contents = new Buffer toMarkdown file.contents.toString()
		@push file
		done()

gulp.task 'build', ->
	gulp.src paths.src
	.pipe libs.jade()
	.pipe gulp.dest '.'
	.pipe libs.toMarkdown()
	.pipe libs.rename (file) -> file.extname = '.md'
	.pipe gulp.dest '.'

gulp.task 'test', ['build'], ->
	gulp.src paths.html
	.pipe libs.html5Lint()

gulp.task 'dist', ->
	gulp.src [paths.html, paths.md]
	.pipe gulp.dest paths.dist

gulp.task 'default', ['test']
