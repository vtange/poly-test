var gulp = require('gulp');
var vulcanize = require('gulp-vulcanize');

gulp.task('vulcanize', function() {
  return gulp.src('index.html', {base: './'})
    .pipe(vulcanize({
      stripComments: true,
      inlineScripts: true,
      inlineCss: true
    }))
    .pipe(gulp.dest('./'));
});

gulp.task('default', ['vulcanize']);