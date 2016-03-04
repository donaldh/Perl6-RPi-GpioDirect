use v6;

# void *mmap(void *addr, size_t length, int prot, int flags, int fd, off_t offset);
# int munmap(void *addr, size_t length);

unit class RasPI;

has $!gpio;

use NativeCall;

enum FILE_MODE (
  O_RDWR => 0x2,
  O_SYNC => 0o4010000
);

enum MAP_PROT (
  PROT_READ => 0x1,
  PROT_WRITE => 0x2,
  PROT_EXEC => 0x4
);

enum MAP_FLAGS (
  MAP_SHARED => 0x1,
  MAP_PRIVATE => 0x2,
  MAP_ANONYMOUS => do given $*DISTRO.name {
    when 'macosx' { 0x1000 }
    when 'raspbian' { 0x20 }
    default { die "Unknown distro {$*DISTRO.name}" }
  }
);

my @physToGPIO = <
  -1  -1
   2  -1
   3  -1
   4  14
  -1  15
  17  18
  27  -1
  22  23
  -1  24
  10  -1
   9  25
  11   8
  -1   7
   0   1
   5  -1
   6  12
  13  -1
  19  16
  26  20
  -1  21
>;

my @physNames = <
   3.3v     5v
   SDA.1    5v
   SCL.1    GND
   GPIO.4   TxD
   GND      RxD
   GPIO.17  GPIO.18
   GPIO.27  GND
   GPIO.22  GPIO.23
   3.3v     GPIO.24
   MOSI     GND
   MISO     GPIO.25
   SCLK     CE0
   GND      CE1
   SDA.0    SCL.0
   GPIO.5   GND
   GPIO.6   GPIO.12
   GPIO.13  GND
   GPIO.19  GPIO.16
   GPIO.26  GPIO.20
   GND      GPIO.21
>;

my int32 $BLOCK_SIZE = 4 * 1024;
my int32 $BCM2708_PERI_BASE = 0x3F000000;
my int32 $GPIO_BASE = $BCM2708_PERI_BASE + 0x00200000;

sub open(Str $name, int32 $flags) returns int32 is native {*}
sub close(int32 $fd) returns int32 is native {*}

sub mmap(Pointer $addr, int32 $length, int32 $prot, int32 $flags, int32 $fd, int32 $offset)
  returns CArray[int32] is native {*}
sub munmap(CArray[int32], int32) returns int32 is native {*}

sub strerror(int32) returns Str is native {*}
my $errno := cglobal('libc.so.6', 'errno', int32);

submethod BUILD {

  my int32 $fd = open('/dev/gpiomem', O_RDWR +| O_SYNC);
  die('open failed: ' ~ strerror($errno)) if $fd == -1;
  say "Opened /dev/gpiomem with fd {$fd}";

  my Pointer $null;
  my $mem = mmap($null, $BLOCK_SIZE, PROT_READ +| PROT_WRITE, MAP_SHARED, $fd, 0);
  die('mmap failed: ' ~ strerror($errno)) if nativecast(int32, $mem) == -1;
  close $fd;

  $!gpio := $mem;
}

method gpio() {
    $!gpio;
}

method read-word(int $word) {
    $!gpio[$word];
}

method pin-name($pin) {
    @physNames[$pin - 1];
}

method pin-gpio($pin) {
    @physToGPIO[$pin - 1];
}

method close {
  my int $status = munmap($!gpio, $BLOCK_SIZE);
  die('munmap failed: ' ~ strerror($errno)) if $status == -1;
}
