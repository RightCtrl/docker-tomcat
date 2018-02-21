module.exports = function(grunt) {
 // Project configuration.
 grunt.initConfig({
pkg: grunt.file.readJSON('package.json'),
webshot: {
homepage: {
options: {
siteType: 'url',
  site: 'http://bqtech.co.in/',
savePath: './tmp/Pagename0.9072267241754811.png',
windowSize: {
 width: 1024,
 height: 768
}, shotSize: {
width: 1024,
height: 'all'
 },
//	 phantomPath: '/home/kishore/phantomjs-2.0.0/bin/phantomjs'
 }
}
 }
 });
 // Load the plugin that provides the "uglify" task.
 grunt.loadNpmTasks('grunt-webshot');
// Default task(s).
grunt.registerTask('default', ['webshot']);
};
