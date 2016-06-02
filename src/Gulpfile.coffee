gulp = require 'gulp'
libs = require('gulp-load-plugins')()
pkg = require '../package.json'
transform = require 'vinyl-transform'
asianbreak = require 'asianbreak-html'

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
	.pipe libs.jade locals: version: 'beta'
	.pipe transform asianbreak
	.pipe gulp.dest '.'
	.pipe libs.toMarkdown()
	.pipe libs.rename (file) -> file.extname = '.md'
	.pipe gulp.dest '.'

gulp.task 'test', ['build'], ->
	gulp.src paths.html
	.pipe libs.html5Lint()

gulp.task 'dist', ->
	gulp.src paths.src
	.pipe libs.jade locals: version: pkg.version
	.pipe gulp.dest paths.dist
	.pipe libs.toMarkdown()
	.pipe libs.rename (file) -> file.extname = '.md'
	.pipe gulp.dest paths.dist

gulp.task 'watch', ->
	gulp.watch paths.src, ['build']

gulp.task 'default', ['test']
