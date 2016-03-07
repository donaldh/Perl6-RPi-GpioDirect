use v6;

use RPi-native;

my $pi = RPi-native.new;

say 'Pin  Name      Value  Mode';
for $pi.gpio-pins -> $pin {
    say sprintf('%3i  %-8s  %5i  %4s',
                $pin, $pi.pin-name($pin), $pi.read($pin), $pi.function($pin)
               );
}

$pi.close;
