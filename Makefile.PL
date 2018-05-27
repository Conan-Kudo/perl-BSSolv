use ExtUtils::MakeMaker;

my $solvprefix = '/usr';

my @inc_dirs = ("$solvprefix/include/solv");
my $lib;

if (grep {$_ eq '--bundled-libsolv'} @ARGV) {
  my $builddir = 'libsolv';
  @inc_dirs = ("$builddir/src", "$builddir/ext");
  $lib = "-L$builddir/src -L$builddir/ext -lsolvext -lsolv -lz -llzma";
} else {
  $lib = '-lsolvext -lsolv';
}

my $def = '';

if (grep {-e "$_/repo_deb.h"} @inc_dirs) {
    $def .= ' -DHAVE_DEBIAN';
}
if (grep {-e "$_/repo_arch.h"} @inc_dirs) {
    $def .= ' -DHAVE_ARCH';
}

my $inc = join ' ', map { '-I' . $_ } @inc_dirs;

WriteMakefile(
    NAME         => 'BSSolv',
    VERSION_FROM => 'BSSolv.pm',
    DEFINE       => $def,
    INC          => $inc,
    LIBS         => [ $lib ],
)
