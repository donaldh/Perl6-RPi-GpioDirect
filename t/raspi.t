use v6;

use RasPI;

my $raspi = RasPI.new;

say 'Pin  Name      Value  Mode';
for 1..40 -> $x {
    #    my $b = $raspi.gpio()[$x].base(2);
    #    say '0' x (32 - $b.chars) ~ $b;
    my $gpio = $raspi.pin-gpio($x);
    next if $gpio < 0;
    say sprintf('%3i  %-8s  %5i   %03s',
                $x, $raspi.pin-name($x), read($gpio, 13), mode($gpio).base(2)
               );
}

sub read(Int $pin, Int $word) {
    $raspi.read-word($word) +& (1 +< ($pin +& 31)) > 0 ?? 1 !! 0;
}

sub mode(Int $pin) {
    $raspi.read-word($pin div 10) +> (($pin % 10) * 3) +& 7;
}

$raspi.close;
