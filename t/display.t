use v6;

use RasPI;

my $pi = RasPI.new;

say 'Pin  Name      Value  Mode';
for 1..40 -> $pin {
    my $gpio = $pi.pin-gpio($pin);
    next if $gpio < 0;
    say sprintf('%3i  %-8s  %5i  %4s',
                $pin, $pi.pin-name($pin), $pi.read($pin), $pi.function-name($pi.mode($pin))
               );
}

$pi.close;
