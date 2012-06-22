use common::sense;
use IO::All;

my $DIR_IN  = 'video';
my $DIR_OUT = 'video/out';
my $CODECS  = '-vcodec libx264 -acodec libmp3lame -ab 192k -x264opts crf=21';

# the config below is not complete, as I stopped converting
# when found Mithaldu's work

my %CFG = (
	'0613-lowell-p2' => {
		out => '13-lowell',
		files => [{
			fname => 'metacpan_api_and_androidi_CUT',
			start => 0,
			end   => 1292,
		}, {
			fname => 'perl_medical_maple',
			start => 1292,
			end   => 3106,
		}, {
			fname => 'drupal_modern_perl_CUT',
			start => 3360,
		}]
	},
	'0615-lowell' => {},
	'0613-325' => {
		out => '13-325',
		files => [{
			fname => '29_ways_to_get_started',
			start => 0,
			end   => 3580,
		}, {
			fname => 'intro_to_dancer',
			start => 3835,
			end   => 6950,
		}, {
			fname => 'fundamental_unicode',
			start => 7670,
		}]
	},
	'0614-325-p1' => {},
	'0614-325-p2' => {
		out => '14-325',
		files => [{
			fname => 'exceptional_exceptions',
			start => 0,
			end   => 2620,
		}, {
			fname => 'intro_to_mojolicious',
			start => 3600,
			end   => 6470,
		}, {
			fname => 'essential_perl_toolkit',
			start => 7140,
		}]

	},
	'0614-325' => {},
	'0615-325-p1' => {
		out => '15-325',
		files => [{
			fname => 'our_friends_utils',
			start => 120,
			end   => 3280,
		}, {
			fname => 'introduction_to_performance_tuning',
			start => 3284,
			end   => 6260,
		}, {
			fname => 'refactoring_perl',
			start => 6700,
			end   => 8005,
		}]
	},
	'0615-325-p2' => {},
	'0613-313' => {
		out => '13-313',
		files => [{
			fname => 'tweakers_anonymous',
			start => 0,
			end   => 1786,
		}, {
			fname => 'embrace_your_community',
			start => 1784,
			end   => 3428,
		}, {
			fname => 'code_fast_die_young',
			start => 3950,
			end   => 5300,
		}]
	},
	'0613-313-p2' => {
		out => '13-313',
		files => [{
			fname => 'perl_sdl_games_CUT',
			start => 0,
		}]
	},
	'0615-313' => {},
	'0613-vandenburg' => {
		out => '13-vandenburg',
		files => [{
			fname => 'chi_universal_caching',
			start => 160,
			end   => 1850,
		}, {
			fname => 'perl_from_ipanema',
			start => 2330,
		}]
	},
	'0615-vandenburg-p2' => {
		out => '15-vandenburg',
		files => [{
			fname => 'noisegen',
			start => 160,
		}]
	},
	'0615-vandenburg-p3' => {},
	'0615-vandenburg-p4' => {},
);

my $fin = shift;
die "Usage: $0 <file-prefix>|all" unless defined $fin;

if ($fin eq 'all') {
	my $io = io($DIR_IN);
	for my $a (@$io) {
		next unless $a =~ s/\.wmv$//;
		$a =~ s|^$DIR_IN/||;
		convert($a, $CFG{$a}) if exists $CFG{$a};
	}
} else {
	if (exists $CFG{$a}) {
		convert($fin, $CFG{$fin});
	} else {
		die "Unknown video: $fin"
	}
}

sub convert {
	my ($fin, $cfg) = @_;
	say "*** Incomplete configuration for $fin ***" and return
			unless exists $cfg->{out} && exists $cfg->{files};
	$fin = "$DIR_IN/$fin.wmv";
	for my $fcfg (@{$cfg->{files}}) {
		my $fout = "$DIR_OUT/$cfg->{out}/$fcfg->{fname}.mp4";
		say "Skipping $fout, already exists" and next if -e $fout;
		
		say "Converting $fout";
		my $time = $fcfg->{end} ? "-t " . ($fcfg->{end}-$fcfg->{start}) : "";
		my $cmd = qq[ffmpeg -i "$fin" -ss $fcfg->{start} $time $CODECS "$fout"];

		say $cmd;
		system $cmd;
	}
}

