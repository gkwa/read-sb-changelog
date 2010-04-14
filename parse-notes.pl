# Last modified $Id$
# $HeadURL$
# -*- perl -*-

# usage: perl parse-notes.pl > allinone.org

# fixme: if you run perl -w parse-notes.pl, then youll get a lot of
# warnings about sort { $b<=>$a } not comparing numerics.  This is
# harmless, but you should fix it since its bad design.

use Data::Dumper;

my @list;
my %elist;
my %dlist;
my $f = "/Users/$ENV{USER}/notes.txt";
open F, "<$f";
while(<F>)
{
    if(m/^\* SB Changelogs/.../^\* /){
	if(m/^ *\|/){
	    chomp;
	    next if(m/----------/);
	    s,^[\t ]+,,;
	    s,[\t ]+, ,;
	    s, *\| *,|,g;
	    s,^ *\| *,,;
	    my %h;
	    ($h{'binary'},$h{'pf'},$h{'SD win32/64'},$h{'HD win32/64'},$h{'SD osx'},$h{'HD osx'},$h{'version'},$h{'date'},$h{'comment'}) 
		= split/\|/;

	    # kludge: if we don't know exact date, then say its on day 1 (eg 2006-12-??)
	    $h{'date'} =~ s,-\?\?,-01,;


	    foreach my $k (keys %h){
		$h{$k} =~ s,^ +,,;
		$h{$k} =~ s, +$,,;
		

		if($k eq 'SD win32/64' and (($h{$k} eq 'yes') or ($h{$k} eq '?'))){
		    $h{'type'} = 'SD win32/64';
		    push @list, { type => $h{'type'},
				  binary => $h{'binary'}, 
				  date => $h{'date'},
				  version => $h{'version'},
				  comment => $h{'comment'} };
		}elsif($k eq 'HD win32/64' and (($h{$k} eq 'yes') or ($h{$k} eq '?'))){
		    $h{'type'} = 'HD win32/64';
		    push @list, { type => $h{'type'},
				  binary => $h{'binary'}, 
				  date => $h{'date'},
				  version => $h{'version'},
				  comment => $h{'comment'} };
		}elsif($k eq 'SD osx' and (($h{$k} eq 'yes') or ($h{$k} eq '?'))){
		    $h{'type'} = 'SD osx';
		    push @list, { type => $h{'type'},
				  binary => $h{'binary'}, 
				  date => $h{'date'},
				  version => $h{'version'},
				  comment => $h{'comment'} };
		}elsif($k eq 'HD osx' and (($h{$k} eq 'yes') or ($h{$k} eq '?'))){
		    $h{'type'} = 'HD osx';
		    push @list, { type => $h{'type'},
				  binary => $h{'binary'}, 
				  date => $h{'date'},
				  version => $h{'version'},
				  comment => $h{'comment'} };
		}

	    }
	    #print Dumper(\%h);
	}
    }
}

close F;

my %l2;
foreach my $h (@list)
{
    my $binary = $h->{binary};
    my $type = $h->{type};    
    my $index = "$binary,$type";
    my $comment = $h->{comment};    
    my $version = $h->{version};    
    my $date = $h->{date};    
    my $index2 = "$version,$date";

    $l2{ $index } = { } if(not defined $l2{ $index });
    $l2{ $index }->{$index2} = [] if(not defined $l2{ $index }->{$index2});
    push @{$l2{ $index }->{$index2}},  $comment;
}

# print Dumper(\%l2);

foreach my $k (sort keys %l2)
{
    my ($binary,$type) = $k =~ m{(.*),(.*)};
    print "* Streambox $type";
    print " ";
    print $binary;
    print "\n";

    foreach my $bintype (sort { $b<=>$a} keys %{$l2{$k}})
    {

	my ($version,$date) = $bintype =~ m{(.*),(.*)};
	print "** ";
	print "$version";
	print " ";
	print "$date";
	print "\n";
	
	foreach my $comment (@{$l2{$k}->{$bintype}})
	{
	    print "- $comment";
	    print "\n";
	}
    }
    print "\n";
}
