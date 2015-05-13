use v6;
use RasPI;
use NativeCall;

sub perror(Str $prefix) is native { * }

my Int $BLOCK_SIZE = 4 * 1024;
my Int $BCM2708_PERI_BASE = 0x3F000000;
my Int $GPIO_BASE = $BCM2708_PERI_BASE + 0x00200000;

my int $fd = my-open('/dev/mem', O_RDWR +| O_SYNC) or die "$!";
say $fd;

my Pointer $null;
my $mem = mmap($null, $BLOCK_SIZE, PROT_READ +| PROT_WRITE, MAP_SHARED, $fd, $GPIO_BASE);
if +$mem == -1 {
    perror('Sorry, mmap failed');
}
say +$mem;
munmap($mem, $BLOCK_SIZE);
