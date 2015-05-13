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
  MAP_ANONYMOUS => do given $*DISTRO.name {
    when 'macosx' { 0x1000 }
    when 'raspbian' { 0x20 }
    default { die "Unknown distro {$*DISTRO.name}" }
  }
);

sub my-open(Str $name, int $flags) returns int is native is symbol('open') is export {*}

sub mmap(OpaquePointer $addr, int $length, int $prot, int $flags, int $fd, int $offset)
  returns OpaquePointer is native is export { * } 

sub munmap(OpaquePointer, Int) returns int is native is export { * }
