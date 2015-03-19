use v6;
use JSON::Tiny;

my @list = 'spelllist.txt'.IO.lines;

my @buf;
my %spells;

my @descs = 'spelldescs.txt'.IO.lines;

sub parse-type($line) {
    my @words = $line.words;
    if @words[0] ~~ /^(\d)/ {
        return [+~$0, @words[1].tc]
    } else {
        return [0, @words[0].tc]
    }
}

sub parse(@buf) {
    my %props;
    my $type = parse-type(@buf.shift);
    %props<level> = $type[0];
    %props<school> = $type[1];
    %props<casting_time> = @buf.shift.subst(/^'Casting Time: '/, '');
    %props<range> = @buf.shift.subst(/^'Range: '/, '');
    %props<components> = @buf.shift.subst(/^'Components: '/, '');
    %props<duration> = @buf.shift.subst(/^'Duration: '/, '');
    %props<description> = @buf.join(" ");
    return %props;
}

my $current = @list.shift;
for @descs -> $descline {
    if $descline eq (@list[0] // '') {
        if not %spells {
            @buf.shift; # fix for Acid Splash
        }
        %spells{$current} = parse(@buf);
        $current = @list.shift;
        @buf = ();
    } else {
        @buf.push: $descline
    }
}
%spells{$current} = parse(@buf);

say to-json(%spells);
