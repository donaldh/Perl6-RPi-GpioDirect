RPi-native
==========

Access the Raspberry Pi GPIO

Overview
--------

The RPi-native module provides access to the Raspberry Pi GPIO without any dependency on C libraries.
RPi-native makes use of /dev/gpiomem so that it can run without elevated privileges.

Installation
------------

    $ panda install RPi-native

Usage
-----

```
use RPi-native;

my $pi = RPi-native.new;

say 'Pin  Name      Value  Mode';
for $pi.gpio-pins -> $pin {
    say sprintf('%3i  %-8s  %5i  %4s',
                $pin, $pi.pin-name($pin), $pi.read($pin), $pi.function($pin)
               );
}

say 'Pin  Name      Value';
for 11, 12 -> $pin {
    $pi.set-function($pin, out);
    for False, True, False, True -> $value {
        $pi.write($pin, $value);
        say sprintf('%3i  %-8s  %5i',
                    $pin, $pi.pin-name($pin), $pi.read($pin));
    }
}
```

Author
------

Donald Hunter <donald.hunter@gmail.com>
