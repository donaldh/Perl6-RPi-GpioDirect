use v6;

use RPi-native;

my $pi = RPi-native.new;

say 'Pin  Name      Value';

for 11, 12 -> $pin {
    $pi.set-function($pin, out);
    for Off, On, Off, On, Off -> $x {
        $pi.write($pin, $x);
        say sprintf('%2i   %-8s  %5s',
                    $pin, $pi.pin-name($pin), $pi.read($pin));
    }
}

$pi.close;
