use v6;

use RPi-native;

my $pi = RPi-native.new;

say 'Pin  Name      Value  Mode';
for 1..40 -> $pin {
    my $gpio = $pi.pin-gpio($pin);
    next if $gpio < 0;
    say sprintf('%3i  %-8s  %5i  %4s',
                $pin, $pi.pin-name($pin), $pi.read($pin), $pi.function($pin)
               );
}

$pi.close;
