use v6;

use RPi-native;

my $pi = RPi-native.new;

say 'Pin  Name      Value';

for 11, 12 -> $pin {
    $pi.set-function($pin, out);
    for False, True, False, True, False -> $x {
        $pi.write($pin, $x);
        say sprintf('%3i  %-8s  %5i',
                    $pin, $pi.pin-name($pin), $pi.read($pin));
    }
}

$pi.close;
