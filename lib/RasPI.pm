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

my Int $BLOCK_SIZE = 4 * 1024;
my Int $BCM2708_PERI_BASE = 0x3F000000;
my Int $GPIO_BASE = $BCM2708_PERI_BASE + 0x00200000;

sub open(Str $name, int $flags) returns int is native {*}
sub close(int $fd) returns int is native {*}

sub mmap(OpaquePointer $addr, int $length, int $prot, int $flags, int $fd, int $offset)
  returns OpaquePointer is native { * } 

sub munmap(OpaquePointer, Int) returns int is native { * }

sub perror(Str $prefix) is native { * }

submethod BUILD {
  my int $fd = open('/dev/mem', O_RDWR +| O_SYNC) or die "$!";
  say "Opened /dev/mem with fd {$fd}";

  my Pointer $null;
  my $mem = mmap($null, $BLOCK_SIZE, PROT_READ +| PROT_WRITE, MAP_SHARED, $fd, $GPIO_BASE);
  perror('Sorry, mmap failed') if +$mem == -1;
  say "mmap region at {+$mem}";

  close $fd;
}

method close {
  my int $status = munmap($!gpio, $BLOCK_SIZE);
  perror('Sorry, munmap failed') if $status == -1;
}
