# -*- perl -*-

use Data::Dumper;

my $changelog_orig = $ARGV[0];
my $log = $ARGV[1];
my $debug=$ENV{debug};

my $v = qr/(\d+\.)?(\d+\.)?(\*|\d+)\.?/;
my $on_header=0;
my $entry="";
my %le=(); #le is Log Entries
my $entry_title="";
my $header_count=0;
my $entries=();
my $modified_entries=();
my $first_rec_found=0;



if($debug){
    open DEBUG, ">$log" or die "Can't open $log for write\n";

}

open CL, "<$changelog_orig" or die "Can't open $changelog_orig for read\n";

while(<CL>)
{
    if(/^(Encoder|Decoder) v/i){
	$first_rec_found=1;
    }
    last if(/---private from here down---/);


    if($first_rec_found)
    {
	if(/^\s*((\(private\)\s+)?(Encoder|Decoder) v($v))/i){
	    push @entries, $entry;
	    $entry=$_;
	    $on_header=1;
	}else{
	    $on_header=0;
	    $entry.=$_;
	}

	# debug
#	last if 3<scalar(@entries);
    }
}
close(CL);







foreach my $entry (@entries)
{
    $entry =~ /^\s*((\(private\)\s+)?(Encoder|Decoder) v($v))/i;
    my $version = $4;
    my $entry_title = $1;
    next unless defined($entry_title);

    $entry = "\n" . $entry;

    print DEBUG "$entry_title\n" if($debug);

    #skip header lines that have '(private)' in the section header
    if(($entry_title =~ m/private/i)){
	print DEBUG "throwing out entry $entry_title\n"
	    if($debug);
    }else{

	my @elines;
	@elines = split /\n/, $entry;
	@elines = remove_private_section(\@elines);
#	@elines = remove_experimental_section(\@elines);

	for(@elines){
	    if($debug){
		print DEBUG "-"x30,"\n";
		print DEBUG "before private modification\n";
		print DEBUG;
		print DEBUG "\n";
	    }

	    s,\*\s+\(private\).*,,xs;
	    s,\(private\).*,,xs;
	    s,^[\s\t]*$,,;
	    if($debug){
		print DEBUG "after private modification\n";
		print DEBUG;
		print DEBUG "\n";
	    }
	}
	##############################

	$entry = join("\n", @elines) . "\n";

	##############################

	# reduce number of newlines
	$entry =~ s{\n\n\n\n}{\n}sx;
	$entry =~ s{\n\n\n}{\n}sx;

	##############################

	# remove lynx links

	# for example change "([61]Encoder v3.140)" to "(Encoder v3.140)"
	# creates these numbered links
	$entry =~ s/\[\d{1,4}\](\w)/$1/g;

	# for example change "([106]bug 1252)" to "(bug 1252)".  lynx
	# creates these numbered links
	$entry =~ s,\[\d+\]bug (\d+),bug $1,gi;
	##############################

	push @modified_entries,
	{
	    title => $entry_title,
	    version => $version,
	    entry => $entry
	};

	if($debug){
	    print DEBUG "modified_entries: " . Dumper(\@modified_entries);
	}

    }
}

foreach my $entry (@modified_entries)
{
    print $entry->{'entry'};
}

if($debug){
    print DEBUG "I found ".scalar(@modified_entries)." private entries\n";
}

if($debug){
    print DEBUG Dumper(\@entries);
    print DEBUG Dumper(\@modified_entries);
}



if($debug)
{
    close DEBUG;
}



sub remove_private_section
{
    my $lines = shift;		# ref to array
    my $found_private_section = 0;
    for(my $i=0; $i<@{$lines};$i++){
	$found_private_section = 1
	    if($lines->[$i] =~ /^\s*\(private\)\s*$/);
	splice(@{$lines}, $i, scalar(@{$lines})-$i+1)
	    if($found_private_section);
    }
    return @{$lines};
}

sub remove_experimental_section
{
    my $lines = shift;		# ref to array
    my $found_experimental_section = 0;
    for(my $i=0; $i<@{$lines};$i++){
	if($lines->[$i] =~ /^\s*\(experimental\)\s*$/)
	{
	    $found_experimental_section = 1;
	}

	if($found_experimental_section)
	{
	    splice(@{$lines}, $i, scalar(@{$lines})-$i+1);
	}

    }
    return @{$lines};
}
