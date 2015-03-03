use v6;
use mmap;

my Int $BLOCK_SIZE = 4 * 1024;
my Int $BCM2708_PERI_BASE = 0x3F000000;
my Int $GPIO_BASE = $BCM2708_PERI_BASE + 0x00200000;

my int $fd = my-open('/dev/mem', O_RDWR +| O_SYNC) or die "$!";
say $fd;

my Pointer $null;
my $mem = mmap($null, $BLOCK_SIZE, PROT_READ +| PROT_WRITE, MAP_SHARED, $fd, $GPIO_BASE);
say +$mem;
munmap($mem, $BLOCK_SIZE);
