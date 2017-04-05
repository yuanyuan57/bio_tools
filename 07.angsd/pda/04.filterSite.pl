#! /usr/bin/env perl
use strict;
use warnings;

my %site;
open I,"zcat /home/share/user/user101/projects/yangshu/16.angsd.removeRelation.new/shared.pos.gz |";
while(<I>){
    chomp;
    my ($chr,$pos)=split(/\s+/);
    $site{$chr}{$pos}=1;   
}
close I;

open O,"| /home/share/user/user101/software/samtools/htslib/bgzip -c > pda_filter.thetas.gz";
open I,"zcat pda.thetas.gz |";
my $head=<I>;
print O "$head";
while(<I>){
    chomp;
    my @a=split(/\s+/);
    if(exists $site{$a[0]}{$a[1]}){
	print O "$_\n";
	delete $site{$a[0]}{$a[1]};
    }
}
close I;
close O;

my $count=0;
foreach my $chr(keys %site){
    $count+= keys %{$site{$chr}};
}
print "$count\n";
