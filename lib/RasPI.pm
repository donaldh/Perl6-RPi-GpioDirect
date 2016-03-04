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

  my int32 $fd = open('/dev/mem', O_RDWR +| O_SYNC);
  die('open failed: ' ~ strerror($errno)) if $fd == -1;
  say "Opened /dev/mem with fd {$fd}";

  my Pointer $null;
  my $mem = mmap($null, $BLOCK_SIZE, PROT_READ +| PROT_WRITE, MAP_SHARED, $fd, $GPIO_BASE);
  die('mmap failed: ' ~ strerror($errno)) if nativecast(int32, $mem) == -1;
  close $fd;

  $!gpio := $mem;
}

method close {
  my int $status = munmap($!gpio, $BLOCK_SIZE);
  die('munmap failed: ' ~ strerror($errno)) if $status == -1;
}
