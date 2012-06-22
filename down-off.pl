use common::sense;
use Thread::Pool;

my $DIR_OUT  = 'video';

my %streams = (
	'1dde05aea2624c69a12db461afb00a6b1d' => '0613-lowell-p2', # 10:30-11:50
	'f19a3c94a9404d21b889907d383c54f81d' => '0615-lowell',
	'6789bff938fa4eb1925fced2a6b378471d' => '0613-325',
	'8fcd2edd9b274d70bdd5fbab31ea6f3a1d' => '0614-325-p1',
	'640fa2a6d6ec488aad6228044e777b931d' => '0614-325-p2',
	'5f5f3fd0d1fa4eb9bda841209ee6d28c1d' => '0614-325',
	'ac8f4a0ad44545df8cf1e55c681a8fbe1d' => '0615-325-p1',
	'2a1d3ca6e9264a58929ea824e1ef806a1d' => '0615-325-p2',
	'37bf5af3cf0743efab4ba7c083a4565a1d' => '0613-313',
	'9707adc68c084313a5816b7ccd8f990c1d' => '0613-313-p2',
	'e24560126a1f4ce185d27f27145eab171d' => '0615-313',
	'b503ecb42c18452a9f4a95b7372648711d' => '0613-vandenburg',
	'fa50b60ea9b647a49bfbce7e79bc4a6e1d' => '0615-vandenburg-p2',
	'050b24fa72d647b78a4f891435c652251d' => '0615-vandenburg-p3',
	'91c66716c0374ac396776529536d794b1d' => '0615-vandenburg-p4',
);

my $pool = Thread::Pool->new({
	do => sub {
		my ($id, $fname) = @_;
		$fname =~ s/(\.wmv)?$/.wmv/;
		$fname = "$DIR_OUT/$fname";
		say "Skipping $fname, already exists" and return if -e $fname;
		my @parts = ($id =~ /^(\w{8})(\w{4})(\w{4})(\w{4})(\w{12})/);
		my $url = "http://video.ics.uwex.edu/Video/ICS/" . join('-', @parts) . ".wmv";

		say "Getting $fname from $url";
		# for live, see gist https://gist.github.com/2932293
		system "mplayer -quiet -user-agent 'NSPlayer/7.10.0.3059' $url -dumpstream -dumpfile $fname";
		say "Getting $fname: done";
	},
	workers => 2,
});

for my $k (keys %streams) {
	$pool->job($k, $streams{$k});
}

$pool->shutdown;

