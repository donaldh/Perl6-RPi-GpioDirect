use v6;
use mmap;
use NativeCall;

my $size = 4096;

my $mem = mmap(Pointer, $size, PROT_READ +| PROT_WRITE, MAP_PRIVATE +| MAP_ANON, -1, 0);
say +$mem;
munmap($mem, $size);
