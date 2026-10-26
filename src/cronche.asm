
include 'dzx0_standard.asm'

org #4000
ld hl,orko
ld de,#8000
call unzx0
jp #8000

defb 'strapZ!',0

unzx0 dzx0_standard (void)

orko
inczx0 'p4.bin'

save 'pouiss4.bin',#4000,$-#4000,DSK,'puissance4_v2.dsk'


