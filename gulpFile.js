var gulp = require('gulp');
var vulcanize = require('gulp-vulcanize');
var crisper = require('gulp-crisper');

gulp.task('vulcanize', function() {
  return gulp.src('app/elements/elements.html')
    .pipe(vulcanize({
      stripComments: true,
      inlineScripts: true,
      inlineCss: true
    }))
    .pipe(crisper())
    .pipe(gulp.dest('dist/elements'));
});

gulp.task('default', ['vulcanize']);