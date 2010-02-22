use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Dancer::Template::Tenjin',
    AUTHOR              => q{Ido Perlmuter <ido@ido50.net>},
    VERSION_FROM        => 'lib/Dancer/Template/Tenjin.pm',
    ABSTRACT_FROM       => 'lib/Dancer/Template/Tenjin.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM		=> {
        'Test::More'		=> 0,
        'Dancer'		=> 1.15,
        'Tenjin'		=> 0.051,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Dancer-Template-Tenjin-*' },
);
