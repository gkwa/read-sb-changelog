# -*- perl -*-

use Getopt::Long;
use XML::Twig;

my $verbose;
my $inputfile = "";
my $outputfile = "";
GetOptions (
    "inputfile=s"   => \$inputfile,
    "outputfile=s"   => \$outputfile
    );

my $twig=XML::Twig->new(
    twig_handlers =>
    {
        a => sub {
	$_->delete if('' eq $_->text('no_recurse'));
	$_->del_att('href');
        },

        span => sub {
	$_->att_exists('class') and
	    ($_->att('class') eq "mw-headline") and
	    $_->del_att('class');
        },

        li => sub {
	my $t=$_->text('no_recurse');
	if($t =~ /\(private\)/i){
	    $t =~ s{\(private\).*}{}i;
	    $t =~ s,^\s+,,;
	    $t =~ s,\s+$,,;
	    $_->set_text($t);
	}
        },
    },
    pretty_print => 'indented',	# output will be nicely formatted
    empty_tags   => 'html',	# outputs <empty_tag />
    );

$twig->parsefile($inputfile)  || die "XML::Twig::parsefile($inputfile) failed: $!\n";
my $span=($twig->findnodes(qq{//span[\@id='changelog_entries_begin']}))[0]->parent;
my $start_ignore=($twig->find_by_tag_name('span[@id="changelog_entries_end"]'))[0]->parent;
foreach my $sib ($start_ignore->next_siblings){
    $sib->delete;
}

my @s = $span->next_siblings;

foreach my $cle (@s)
{
    if('p' eq $cle->tag){
        my $t=$cle->text;

        $t =~ s{\(private\).*}{}ig;
        $t =~ s,^\s+,,;
        $t =~ s,\s+$,,;

        $cle->set_text($t);
    }
}

open(OUTPUT, ">$outputfile") || die "Can't open $outputfile, qutting: $!\n";
my $oh = select(OUTPUT);
foreach my $cle (@s){
    $cle->print;
}
select($oh);
close(OUTPUT);
