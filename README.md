RPi-native
==========

Access the Raspberry Pi GPIO

Overview
--------

The RPi-native module provides access to the Raspberry Pi GPIO without any dependency on C libraries.
RPi-native makes use of /dev/gpiomem so that it can run without elevated privileges.

RPi-native has only been tested with a Raspberry Pi 3 but is likely to work with a Pi 2. RPi-native is also
dependend on a kernel with /dev/gpiomem.

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
