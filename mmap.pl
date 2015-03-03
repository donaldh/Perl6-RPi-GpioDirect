#
# void *mmap(void *addr, size_t length, int prot, int flags, int fd, off_t offset);
# int munmap(void *addr, size_t length);

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
  MAP_ANON => 0x20
);

sub my-open(Str $name, int $flags) returns int is native is symbol('open') {*}
sub mmap(OpaquePointer $addr, Int $length, int $prot, int $flags, int $fd, Int $offset)
  returns OpaquePointer is native { * } 
sub munmap(OpaquePointer, int) returns int is native { * }

my Int $BLOCK_SIZE = 4 * 1024;
my Int $BCM2708_PERI_BASE = 0x3F000000;
my Int $GPIO_BASE = $BCM2708_PERI_BASE + 0x00200000;

my int $fd = my-open('/dev/mem', O_RDWR +| O_SYNC) or die "$!";
say $fd;
my OpaquePointer $null;
my $mem = mmap($null, $BLOCK_SIZE, PROT_READ +| PROT_WRITE, MAP_SHARED, $fd, $GPIO_BASE);
say +$mem;
