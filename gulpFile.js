var gulp = require('gulp');
var vulcanize = require('gulp-vulcanize');
var crisper = require('gulp-crisper');

gulp.task('vulcanize', function() {
  return gulp.src('index.html')
    .pipe(vulcanize({
      stripComments: true,
      inlineScripts: true,
      inlineCss: true
    }))
    .pipe(crisper())
    .pipe(gulp.dest('index.html'));
});

gulp.task('default', ['vulcanize']);