use v6;

use RasPI;

my $pi = RasPI.new;

say 'Pin  Name      Value';
for False, True, False, True, False -> $x {
    $pi.write(11, $x);
    say sprintf('%3i  %-8s  %5i',
                11, $pi.pin-name(11), $pi.read(11));
}

$pi.close;
