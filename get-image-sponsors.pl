#!/usr/bin/env perl

use strict;
use warnings;
use LWP::UserAgent;
use HTML::PullParser;
use Data::Dumper;

my $ua = LWP::UserAgent->new;
my $host = 'https://www.perl.dance';
my $res = $ua->get("$host/sponsors");

if ($res->is_success) {
    my $content = $res->decoded_content;
    if ($content =~ m/(<div id="sponsors".*)<div class="footer">/) {
        my $stanza = $1;
        open (my $fh, '>:encoding(UTF-8)', 'sponsors.tex') or die;
        print $fh parse_sponsors($stanza);        
        close $fh;
    }
}

sub parse_sponsors {
    my $body = shift;
    my $tex = "\\begin{center}\n";
    my $parser = HTML::PullParser->new(doc => \$body,
                                       start => '"S", tagname, attr',
                                       text => '"T", dtext');
    my $current = '';
    while (my $token = $parser->get_token) {
        # print Dumper($token);
        my ($type, $text, $attrs) = @$token;
        if ($type eq 'T') {
            $current .= $text;
        }
        elsif ($type eq 'S') {
            if ($text eq 'img' and $attrs->{src}) {
                if ($current) {
                    $tex .= <<"EOF";
\\vfill

\\textbf{\\Large \\textsf{$current}}

\\vfill

EOF
                    $current = '';
                }
                my $target = $attrs->{src};
                $target =~ s/^\///;
                $tex .= "\\includegraphics[height=1.5cm]{$target}\n";
                $ua->mirror($host . $attrs->{src}, $target);
            }
        }
    }
    $tex .= "\\vfill\n\\end{center}";
    return $tex;
}
