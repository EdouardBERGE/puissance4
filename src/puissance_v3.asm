


org #8000 ; program origin / load address

; code: game logic and routines
lab8000 xor a ; entry point: init inks/mode, draw board, main loop
    ld (lab88F3),a
    ld (lab88F2),a
    ld a,#0
    call #bc0e ; vector SCR_SET_MODE
    ld a,#0
    ld b,#0
    ld c,#0
    call #bc32 ; vector SCR_SET_INK
    ld a,#1
    ld b,#2
    ld c,#2
    call #bc32 ; vector SCR_SET_INK
    ld a,#2
    ld b,#18
    ld c,#18
    call #bc32 ; vector SCR_SET_INK
    ld a,#3
    ld b,#6
    ld c,#6
    call #bc32 ; vector SCR_SET_INK
    ld a,#4
    ld b,#1a
    ld c,#1a
    call #bc32 ; vector SCR_SET_INK
    ld a,#5
    ld b,#10
    ld c,#10
    call #bc32 ; vector SCR_SET_INK
    ld a,#6
    ld b,#19
    ld c,#19
    call #bc32 ; vector SCR_SET_INK
    ld a,#7
    ld b,#e
    ld c,#e
    call #bc32 ; vector SCR_SET_INK
    ld a,#8
    ld b,#1
    ld c,#1
    call #bc32 ; vector SCR_SET_INK
    ld a,#9
    ld b,#3
    ld c,#3
    call #bc32 ; vector SCR_SET_INK
    ld a,#a
    ld b,#f
    ld c,#f
    call #bc32 ; vector SCR_SET_INK
    ld a,#b
    ld b,#4
    ld c,#4
    call #bc32 ; vector SCR_SET_INK
    ld b,#0
    ld c,#0
    call #bc38 ; vector SCR_SET_BORDER
    call lab8305
    ld hl,#c05c
    ld c,#38
    ld b,#c0
    ld a,#c0
    call lab8899
    call lab866B
    call lab86CC
    ld hl,#e05d
    ld a,#6
    ld (lab88D6),a
lab809C push hl ; draw board rows loop
    ld a,#7
    ld (lab88D7),a
lab80A2 push hl ; draw board columns loop
    call lab8753
    call lab863F
    pop hl
    ld de,#8
    add hl,de
    ld a,(lab88D7)
    dec a
    ld (lab88D7),a
    jr nz,lab80A2
    pop hl
    ld de,#140
    add hl,de
    ld a,(lab88D6)
    dec a
    ld (lab88D6),a
    jr nz,lab809C
    call lab8722
    ld hl,lab890C
    ld de,lab890D
    ld bc,#29
    ld (hl),#0
    ldir
    xor a
    ld (lab88D8),a
    ld a,#1
    ld (lab88D9),a
lab80DE ld a,(nbPlayer) ; main game loop
    cp #1
    jr nz,lab80F8
    ld a,(lab88D9)
    cp #2
    jr nz,lab80F8
    call lab8408
    call lab8408
    call lab84B4
    jp lab8134
lab80F8 call lab81BB ; handle keyboard input
    call lab81D4
    call #bb06 ; vector KM_WAIT_CHAR
    push af
    ld a,#0
    call lab81D4
    pop af
    cp #f2
    jr z,lab811A
    cp #f3
    jr z,lab8126
    cp #20
    jr z,lab8134
    cp #fc
    jr z,lab8133
    jr lab80DE
lab811A ld a,(lab88D8) ; cursor left
    or a
    jr z,lab80DE
    dec a
    ld (lab88D8),a
    jr lab80DE
lab8126 ld a,(lab88D8) ; cursor right
    cp #6
    jr z,lab80DE
    inc a
    ld (lab88D8),a
    jr lab80DE
lab8133 ret  ; quit game
lab8134 ld a,(lab88D8) ; drop disc into selected column
    ld e,a
    ld d,#0
    ld hl,lab890C
    add hl,de
    ld a,(hl)
    or a
    jr nz,lab80DE
    ld b,#0
lab8144 ld a,b ; find first empty row in column
    cp #5
    jr z,lab815A
    push hl
    ld de,#7
    add hl,de
    ld a,(hl)
    pop hl
    or a
    jr nz,lab815A
    ld de,#7
    add hl,de
    inc b
    jr lab8144
lab815A ld a,(lab88D9) ; place disc, animate drop, check win
    ld (hl),a
    ld a,b
    ld (lab88D9+2),a
    xor a
    ld (lab88D9+1),a
lab8166 ld a,(lab88D9+1) ; animate falling disc
    ld b,a
    call lab81E1
    call lab81BB
    ld c,a
    ld ix,lab8936
    call lab8622
    ld a,(lab88D9+1)
    ld hl,lab88D9+2
    cp (hl)
    jr z,lab8194
    call lab81F7
    ld a,(lab88D9+1)
    ld b,a
    call lab81E1
    call lab863F
    ld hl,lab88D9+1
    inc (hl)
    jr lab8166
lab8194 ld hl,#1de ; after move: sound, win check, turn switch
    call lab82FB
    call lab825A
    ld a,(lab88F2)
    or a
    jp nz,lab8201
    ld a,(lab88F3)
    inc a
    ld (lab88F3),a
    cp #2a
    jp z,lab821F
    ld a,(lab88D9)
    xor #3
    ld (lab88D9),a
    jp lab80DE
lab81BB ld a,(lab88D9) ; current player color mask
    cp #1
    ld a,#cc
    ret z
    ld a,#c
    ret 
lab81C6 ld a,(lab88D8) ; screen address for cursor column
    add a,a
    add a,a
    add a,a
    ld e,a
    ld d,#0
    ld hl,#c00d
    add hl,de
    ret 
lab81D4 push af ; draw cursor
    call lab81C6
    pop af
    ld c,#6
    ld b,#6
    call lab8899
    ret 
lab81E1 ld hl,#e05d ; screen address for board cell
    ld a,(lab88D8)
    add a,a
    add a,a
    add a,a
    ld e,a
    ld d,#0
    add hl,de
    ld de,#140
    inc b
lab81F2 dec b
    ret z
    add hl,de
    jr lab81F2
lab81F7 ld b,#4 ; frame delay
lab81F9 push bc
    call #bd19 ; vector MC_WAIT_FLYBACK
    pop bc
    djnz lab81F9
    ret 
lab8201 ld hl,#1de ; game over sequence
    call lab82FB
    ld hl,#17c
    call lab82FB
    ld hl,#13f
    call lab82FB
    ld hl,#ef
    call lab82FB
    call lab83D4
    jp lab8000
lab821F ld hl,#384 ; win flash sequence
    call lab82FB
    ld a,#1
    call lab822D
    jp lab8000
lab822D ld d,a ; flash winning discs
    ld e,#6
lab8230 ld a,d ; code
    ld b,#0
    ld c,#0
    push de
    call #bc32 ; vector SCR_SET_INK
    pop de
    ld b,#a
lab823C push bc
    call #bd19 ; vector MC_WAIT_FLYBACK
    pop bc
    djnz lab823C
    ld a,d
    ld b,#2
    ld c,#2
    push de
    call #bc32 ; vector SCR_SET_INK
    pop de
    ld b,#a
lab824F push bc
    call #bd19 ; vector MC_WAIT_FLYBACK
    pop bc
lab8254 djnz lab824F ; code
    dec e
    jr nz,lab8230
    ret 
lab825A xor a ; check four-in-a-row
    ld (lab88F2),a
    ld a,(lab88D8)
    ld (lab88F5),a
    ld a,(lab88D9+2)
    ld (lab88F6),a
    ld ix,lab88FB
    ld b,#4
lab8270 push bc ; code
    ld a,#1
    ld (lab88F4),a
    ld a,(ix+0)
    ld (lab88F7),a
    ld a,(ix+1)
    ld (lab88F8),a
    call lab82B8
    ld a,(lab88F7)
    neg
    ld (lab88F7),a
    ld a,(lab88F8)
    neg
    ld (lab88F8),a
    call lab82B8
    ld a,(lab88F4)
    cp #4
    jr c,lab82B0
    ld a,#1
    ld (lab88F2),a
    ld a,(ix+0)
    ld (lab88DC),a
    ld a,(ix+1)
    ld (lab88DD),a
lab82B0 inc ix
    inc ix
    pop bc
    djnz lab8270
    ret 
lab82B8 ld a,(lab88F5) ; step direction while checking
    ld (lab88F9),a
    ld a,(lab88F6)
    ld (lab88FA),a
lab82C4 ld a,(lab88F9) ; walk board cells in direction
    ld hl,lab88F7
    add a,(hl)
    ld (lab88F9),a
    cp #7
    ret nc
    ld a,(lab88FA)
    ld hl,lab88F8
    add a,(hl)
    ld (lab88FA),a
    cp #6
    ret nc
    ld b,a
    ld a,(lab88F9)
    ld c,a
    ld a,b
    add a,a
    add a,a
    add a,a
    sub b
    add a,c
    ld e,a
    ld d,#0
    ld hl,lab890C
    add hl,de
    ld a,(lab88D9)
    cp (hl)
    ret nz
    ld hl,lab88F4
    inc (hl)
    jr lab82C4
lab82FB ld (lab8906),hl ; play sound effect
    ld hl,lab8901+2
    call #bcaa ; vector SOUND_QUEUE
    ret 
lab8305 ld hl,#c000 ; init screen and menu
    ld c,#50
    ld b,#c8
    call lab86E1
    ld hl,#d057
    ld de,lab8F5A
    call lab8784
    ld hl,#f19b
    ld de,lab8F64
    call lab8784
    ld hl,#c9e4
    ld c,#cc
    call lab8622
    ld hl,#ca26
    ld c,#c
    call lab8622
    ld hl,#dc15
    ld c,#46
    ld b,#32
    ld a,#fc
    call lab8899
    ld hl,#e416
    ld c,#44
    ld b,#30
    ld a,#0
    call lab8899

    ld a,#4 : call #bb90 ; vector TXT_SET_PEN
    ld h,#3 :  ld l,#f : call #bb75 ; vector TXT_SET_CURSOR
    ld hl,niveau_debutant : call lab83C9

    ld h,#3 :  ld l,#10 : call #bb75 ; vector TXT_SET_CURSOR
    ld hl,niveau_intermediaire : call lab83C9

    ld a,#a : call #bb90 ; vector TXT_SET_PEN
    ld h,#3 :  ld l,#11 : call #bb75 ; vector TXT_SET_CURSOR
    ld hl,niveau_avance : call lab83C9

    ld h,#3 :  ld l,#12 : call #bb75 ; vector TXT_SET_CURSOR
    ld hl,niveau_difficile : call lab83C9

    ld a,#3 : call #bb90 ; vector TXT_SET_PEN
    ld h,#3 : ld l,#13 : call #bb75 ; vector TXT_SET_CURSOR
    ld hl,niveau_deux_joueurs :  call lab83C9

    ld a,#4 : call #bb90 ; vector TXT_SET_PEN
    ld h,#1 : ld l,#17 : call #bb75 ; vector TXT_SET_CURSOR
    ld hl,copyright :  call lab83C9

    ld a,#4 : call #bb90 ; vector TXT_SET_PEN
    ld h,#1 : ld l,#18 : call #bb75 ; vector TXT_SET_CURSOR
    ld hl,copy2 :  call lab83C9

    ld a,#4 : call #bb90 ; vector TXT_SET_PEN
    ld h,#1 : ld l,#19 : call #bb75 ; vector TXT_SET_CURSOR
    ld hl,oldcopyright :  call lab83C9

lab8394 call #bb09 ; vector KM_READ_CHAR ; wait key release
    jr c,lab8394
lab8399 call #bb06 ; vector KM_WAIT_CHAR ; read menu selection
    cp #31
    jr z,choix_debutant
    cp #32
    jr z,choix_intermediaire
    cp #33
    jr z,choix_avance
    cp #34
    jr z,choix_difficile
    cp #35
    jr z,choix_deux_joueurs
    jr lab8399

difficulte_fine defb 0

choix_debutant ld a,#1 ; mode 1 debutant
    ld (nbPlayer),a
    ld (legacyDifficulty),a
    ld a,0 : ld (newDifficulty),a
    jr clear_before_play

choix_intermediaire
    ld a,1 : ld (nbPlayer),a
    ld a,1 : ld (newDifficulty),a
    jr clear_before_play

choix_avance
    ld a,1 : ld (nbPlayer),a
    ld a,2 : ld (newDifficulty),a
    jr clear_before_play

choix_difficile ld a,#1 ; mode 1 difficile
    ld (nbPlayer),a
    ld a,#2
    ld (legacyDifficulty),a
    ld a,3 : ld (newDifficulty),a
    jr clear_before_play

choix_deux_joueurs ld a,#2 ; mode 2 two players
    ld (nbPlayer),a
clear_before_play call #bc14 ; vector SCR_CLEAR ; clear screen and return
    ret


lab83C9 ld a,(hl) ; print zero-terminated string
    or a
    ret z
    push hl
    call #bb5a ; vector TXT_OUTPUT
    pop hl
    inc hl
    jr lab83C9
lab83D4 ld a,#8 ; game over animation
    ld (lab88DF),a
lab83D9 ld a,#30 ; game over draw loop
    ld (lab88DE),a
    call lab8412
    call lab8408
    call lab81BB
    ld (lab88DE),a
    call lab8412
    call lab8408
    ld hl,lab88DF
    dec (hl)
    jr nz,lab83D9
    ld a,#30
    ld (lab88DE),a
    call lab8412
    ld b,#4
lab8400 push bc ; code
    call lab8408
    pop bc
    djnz lab8400
    ret 
lab8408 ld b,#c ; short delay
lab840A push bc
    call #bd19 ; vector MC_WAIT_FLYBACK
    pop bc
    djnz lab840A
    ret 
lab8412 ld a,(lab88F5) ; animate winning disc removal
    ld (lab88F9),a
    ld a,(lab88F6)
    ld (lab88FA),a
    call lab848B
    ld a,(lab88DC)
    ld (lab88F7),a
    ld a,(lab88DD)
    ld (lab88F8),a
    call lab8444
    ld a,(lab88DC)
    neg
    ld (lab88F7),a
    ld a,(lab88DD)
    neg
    ld (lab88F8),a
    call lab8444
    ret 
lab8444 ld a,(lab88F5) ; step cell in direction
    ld (lab88F9),a
    ld a,(lab88F6)
    ld (lab88FA),a
lab8450 ld a,(lab88F9) ; code
    ld hl,lab88F7
    add a,(hl)
    ld (lab88F9),a
    cp #7
    ret nc
    ld a,(lab88FA)
    ld hl,lab88F8
    add a,(hl)
    ld (lab88FA),a
    cp #6
    ret nc
    ld b,a
    ld a,(lab88F9)
    ld c,a
    call lab847C
    ld hl,lab88D9
    cp (hl)
    ret nz
    call lab848B
    jr lab8450
lab847C ld a,b ; board cell lookup
    add a,a
    add a,a
    add a,a
    sub b
    add a,c
    ld e,a
    ld d,#0
    ld hl,lab890C
    add hl,de
    ld a,(hl)
    ret 
lab848B ld a,(lab88FA) ; draw disc at cell
    ld b,a
    ld a,(lab88F9)
    call lab84A1
    ld a,(lab88DE)
    ld c,a
    ld ix,lab8936
    call lab8622
    ret 
lab84A1 ld hl,#e05d ; screen address for cell
    add a,a
    add a,a
    add a,a
    ld e,a
    ld d,#0
    add hl,de
    ld de,#140
    inc b
lab84AF dec b
    ret z
    add hl,de
    jr lab84AF
lab84B4 ld a,#2 ; computer (AI) move
    ld (lab88E2),a
    call lab85CE
    jr c,lab8513
    ld a,#1
    ld (lab88E2),a
    call lab85CE
    jr c,lab8513

    ld a,(newDifficulty)
    or a : jr z,lab84F2 ; (etait dec a : decalait tous les niveaux)
    dec a : jr z,unSurDeux
    dec a : jr z,troisSurQuatre
    jp ia_difficile ; difficulté max : recherche sur 3 niveaux (ia_choisir_coup)

unSurDeux ld a,%10101010 : rlca : ld (unSurDeux+1),a : jr c,lab84F2 : jr tester_victoire_adversaire

troisSurQuatre ld a,%10001000 : rlca : ld (troisSurQuatre+1),a : jr c,lab84F2 : jr tester_victoire_adversaire

tester_victoire_adversaire
    xor a
    ld (lab88E4),a
lab84D3 call lab8519 ; search winning move for player 2
    ld (lab88E5),a
    ld c,a
    call lab860E
    cp #ff
    jr z,lab84E7
    call lab855A
    or a
    jr z,lab850D
lab84E7 ld a,(lab88E4) ; turn switch after AI
    inc a
    ld (lab88E4),a
    cp #7
    jr c,lab84D3


lab84F2 xor a ; reset column scan
    ld (lab88E4),a
lab84F6 call lab8519 ; search (second pass)
    ld (lab88E5),a
    ld c,a
    call lab860E
    cp #ff
    jr nz,lab850D
    ld a,(lab88E4)
    inc a
    ld (lab88E4),a
    jr lab84F6
lab850D ld a,(lab88E5) ; column found
    ld (lab88D8),a
lab8513 ld a,#2 ; code
    ld (lab88D9),a
    ret 

; scan des colonnes
lab8519
    ld hl,table_priorite_colonnes
    ld a,(newDifficulty) : cp 3 : jr nz,.table_normale : ld hl,table_priorite_naive : .table_normale ; niveau 3 choisi un scan différent des colonnes
    ld a,(lab88E4) ; difficulty move table
    ld e,a
    ld d,#0
    add hl,de
    ld a,(hl)
    ret 

lab8525 push af ; write cell value
    ld a,b
    add a,a
    add a,a
    add a,a
    sub b
    add a,c
    ld e,a
    ld d,#0
    ld hl,lab890C
    add hl,de
    pop af
    ld (hl),a
    ret 
lab8536 xor a ; count pieces in column
    ld (lab88E9),a
    ld (lab88EA),a
lab853D ld a,(lab88EA)
    ld c,a
    call lab85F1
    or a
    jr z,lab854B
    ld hl,lab88E9
    inc (hl)
lab854B ld a,(lab88EA)
    inc a
    ld (lab88EA),a
    cp #7
    jr c,lab853D
    ld a,(lab88E9)
    ret 
lab855A ld a,(lab88E5) ; evaluate candidate move
    ld c,a
    call lab860E
    ld (lab88E6),a
    ld b,a
    ld a,(lab88E5)
    ld c,a
    ld a,#2
    call lab8525
    ld a,#1
    ld (lab88E2),a
    call lab8536
    or a
    jr nz,lab85BD
    xor a
    ld (lab88E8),a
lab857D ld a,(lab88E8) ; iterate board columns
    ld c,a
    call lab860E
    cp #ff
    jr z,lab85AF
    ld (lab88E7),a
    ld b,a
    ld a,(lab88E8)
    ld c,a
    ld a,#1
    call lab8525
    ld a,#1
    ld (lab88E2),a
    call lab8536
    push af
    ld a,(lab88E7)
    ld b,a
    ld a,(lab88E8)
    ld c,a
    xor a
    call lab8525
    pop af
    cp #2
    jr nc,lab85BD
lab85AF ld a,(lab88E8)
    inc a
    ld (lab88E8),a
    cp #7
    jr c,lab857D
    xor a
    jr lab85BF
lab85BD ld a,#1
lab85BF push af
    ld a,(lab88E6)
    ld b,a
    ld a,(lab88E5)
    ld c,a
    xor a
    call lab8525
    pop af
    ret 
lab85CE xor a ; find immediate winning move
    ld (lab88E3),a
lab85D2 ld a,(lab88E3) ; scan columns
    ld c,a
    call lab85F1
    or a
    jr nz,lab85E9
    ld a,(lab88E3)
    inc a
    ld (lab88E3),a
    cp #7
    jr c,lab85D2
    or a
    ret 
lab85E9 ld a,(lab88E3) ; winning column found
    ld (lab88D8),a
    scf
    ret 
lab85F1 call lab860E ; test if move wins
    cp #ff
    jr z,lab860C
    ld (lab88D9+2),a
    ld a,c
    ld (lab88D8),a
    ld a,(lab88E2)
    ld (lab88D9),a
    call lab825A
    ld a,(lab88F2)
    ret 
lab860C xor a
    ret 
lab860E ld b,#5 ; free cells in column
lab8610 call lab847C ; code
    or a
    jr z,lab861D
    ld a,b
    or a
    jr z,lab861F
    dec b
    jr lab8610
lab861D ld a,b
    ret 
lab861F ld a,#ff
    ret 
lab8622 ld a,c ; draw sprite using color mask
    cp #cc
    ld ix,lab8A15+1
    jr z,lab863B
    cp #c
    ld ix,lab8B36
    jr z,lab863B
    ld ix,lab8936
    call lab88B2
    ret 
lab863B call lab8647
    ret 
lab863F ld ix,lab8C56 ; erase sprite/cell
    call lab8647
    ret 
lab8647 ld e,#18 ; render glyph block
lab8649 push hl ; code
    ld d,#6
lab864C ld a,(hl)
    and (ix+0)
    or (ix+1)
    ld (hl),a
    inc hl
    inc ix
    inc ix
    dec d
    jr nz,lab864C
    pop hl
    ld a,h
    add a,#8
    ld h,a
    jr nc,lab8667
    ld bc,#c050
    add hl,bc
lab8667 dec e ; code
    jr nz,lab8649
    ret 
lab866B ld hl,#c008 ; draw board frame
    ld c,#1
    ld b,#c8
    ld a,#3
    call lab8899
    ld hl,#c009
    ld c,#2
    ld b,#c8
    ld a,#fc
    call lab8899
    ld hl,#c00b
    ld c,#1
    ld b,#c8
    ld a,#30
    call lab8899
    ld hl,#c047
    ld c,#1
    ld b,#c8
    ld a,#3
    call lab8899
    ld hl,#c045
    ld c,#2
    ld b,#c8
    ld a,#fc
    call lab8899
    ld hl,#c044
    ld c,#1
    ld b,#c8
    ld a,#30
    call lab8899
    ld hl,#f008
    ld c,#40
    ld b,#1
    ld a,#fc
    call lab8899
    ld hl,#f808
    ld c,#40
    ld b,#1
    ld a,#30
    call lab8899
    ret 
lab86CC ld hl,#c000 ; draw grid
    ld c,#8
    ld b,#c8
    call lab86E1
    ld hl,#c048
    ld c,#8
    ld b,#c8
    call lab86E1
    ret 
lab86E1 ld ix,lab8D76 ; fill screen area from table
    ld a,#8
    ld (lab88EB),a
lab86EA push bc
    push hl
    ld d,c
lab86ED ld a,(ix+0)
    ld (hl),a
    inc hl
    ld a,(ix+1)
    ld (hl),a
    inc hl
    dec d
    dec d
    jr nz,lab86ED
    pop hl
    pop bc
    inc ix
    inc ix
    ld a,(lab88EB)
    dec a
    ld (lab88EB),a
    jr nz,lab8713
    ld ix,lab8D76
    ld a,#8
    ld (lab88EB),a
lab8713 ld a,h ; code
    add a,#8
    ld h,a
    jr nc,lab871F
    push bc
    ld bc,#c050
    add hl,bc
    pop bc
lab871F djnz lab86EA
    ret 
lab8722 ld hl,#c05c ; draw bottom border
    ld c,#38
    ld b,#1
    ld a,#fc
    call lab8899
    ld hl,#c05c
    ld c,#1
    ld b,#c0
    ld a,#fc
    call lab8899
    ld hl,#ff8c
    ld c,#38
    ld b,#1
    ld a,#3
    call lab8899
    ld hl,#c093
    ld c,#1
    ld b,#c0
    ld a,#3
    call lab8899
    ret 
lab8753 push hl ; draw piece sprite
    ld ix,lab8D86
    ld b,#7
    ld c,#1a
    call lab8761
    pop hl
    ret 
lab8761 push hl ; sprite render loop
    ld d,b
lab8763 ld a,(hl) ; code
    and (ix+0)
    or (ix+1)
    ld (hl),a
    inc hl
    inc ix
    inc ix
    dec d
    jr nz,lab8763
    pop hl
    ld a,h
    add a,#8
    ld h,a
    jr nc,lab8780
    push bc
    ld bc,#c050
    add hl,bc
    pop bc
lab8780 dec c ; code
    jr nz,lab8761
    ret 
lab8784 ld a,l ; draw glyph string
    ld (lab88EC),a
    ld a,h
    ld (lab88ED),a
    ld a,e
    ld (lab88EE),a
    ld a,d
    ld (lab88EF),a
    xor a
    ld (lab88F0),a
lab8798 ld a,(lab88EC) ; code
    ld l,a
    ld a,(lab88ED)
    ld h,a
    ld a,(lab88EE)
    ld e,a
    ld a,(lab88EF)
    ld d,a
lab87A8 ld a,(de)
    or a
    jr z,lab87BB
    ld c,a
    push de
    push hl
    call lab87C7
    pop hl
    ld de,#7
    add hl,de
    pop de
    inc de
    jr lab87A8
lab87BB ld a,(lab88F0)
    inc a
    ld (lab88F0),a
    cp #3
    jr c,lab8798
    ret 
lab87C7 ld ix,lab8EF2 ; find glyph for character
lab87CB ld a,(ix+0)
    or a
    ret z
    cp c
    jr z,lab87DA
    ld de,#8
    add ix,de
    jr lab87CB
lab87DA inc ix
    xor a
    ld (lab88F1),a
    ld b,#7
lab87E2 push bc
    push hl
    ld a,(ix+0)
    ld e,a
    ld d,#5
lab87EA sla e
    jr nc,lab87F5
    push de
    push hl
    call lab8813
    pop hl
    pop de
lab87F5 inc hl
    dec d
    jr nz,lab87EA
    pop hl
    call lab8851
    call lab8851
    call lab8851
    call lab8851
    inc ix
    ld a,(lab88F1)
    inc a
    ld (lab88F1),a
    pop bc
    djnz lab87E2
    ret 
lab8813 ld a,(lab88F0) ; special glyph render
    or a
    jr z,lab883E
    cp #1
    jr z,lab8835
    inc hl
    call lab8851
    ld a,(lab88F1)
    ld e,a
    ld d,#0
    push hl
    ld hl,lab8F53
    add hl,de
    ld a,(hl)
    pop hl
    ld c,#1
    ld b,#4
    jp lab8899
lab8835 ld a,#c3 ; cursor glyph
    ld c,#3
    ld b,#6
    jp lab8899
lab883E inc hl ; erase glyph
    inc hl
    call lab8851
    call lab8851
    call lab8851
    xor a
    ld c,#3
    ld b,#6
    jp lab8899
lab8851 ld a,h ; code
    add a,#8
    ld h,a
    ret nc
    push bc
    ld bc,#c050
    add hl,bc
    pop bc
    ret 
lab885D ld a,(de) ; draw vertical strip
    or a
    ret z
    ld c,a
    push de
    push hl
    call lab886E
    pop hl
    inc hl
    inc hl
    inc hl
    pop de
    inc de
    jr lab885D
lab886E ld ix,lab8F6D ; find glyph table entry
lab8872 ld a,(ix+0) ; code
    or a
    ret z
    cp c
    jr z,lab8881
    ld de,#f
    add ix,de
    jr lab8872
lab8881 inc ix ; code
    ld b,#7
lab8885 ld a,(ix+0) ; code
    ld (hl),a
    inc hl
    ld a,(ix+1)
    ld (hl),a
    dec hl
    inc ix
    inc ix
    call lab8851
    djnz lab8885
    ret 
lab8899 push bc ; fill horizontal bytes
    push hl
    ld d,c
lab889C ld (hl),a
    inc hl
    dec d
    jr nz,lab889C
    pop hl
    pop bc
    push af
    ld a,h
    add a,#8
    ld h,a
    jr nc,lab88AE
    ld de,#c050
    add hl,de
lab88AE pop af
    djnz lab8899
    ret 
lab88B2 ld e,#18 ; xor mask update
lab88B4 push hl
    ld d,#6
lab88B7 ld b,(ix+0)
    inc ix
    ld a,(hl)
    xor c
    and b
    xor (hl)
    ld (hl),a
    inc hl
    dec d
    jr nz,lab88B7
    pop hl
    ld a,h
    add a,#8
    ld h,a
    jr nc,lab88D2
    push bc
    ld bc,#c050
    add hl,bc
    pop bc
lab88D2 dec e
    jr nz,lab88B4
    ret 
; ---- IA difficile : point d'entree depuis lab84B4 ----
ia_difficile call ia_choisir_coup
    ld (lab88D8),a ; colonne choisie
    jp lab8513 ; joueur courant = 2, retour

; =====================================================================
; IA "difficile" : recherche sur 3 niveaux (ordi / humain / ordi)
; + test final "l'humain a-t-il un gain immediat ?" (ia_prudence)
;
; Appel   : call ia_choisir_coup
; Sortie  : A = colonne choisie (0-6)
; Ne modifie AUCUNE variable du jeu (travaille sur une copie du plateau).
; Detruit : tous les registres sauf les registres alternes (EXX non utilise)
; Depend  : lab890C (plateau 6x7, 0=vide 1=humain 2=ordi)
;           table_priorite_colonnes (7 colonnes, centre d'abord)
;
; Notes par reponse humaine h (g) :
;   -8 : l'humain gagne tout de suite        (perdre avant la fin de l'arbre)
;   -1 : l'humain gagnera au coup suivant     (double menace)
;    0 : rien de special
;   +1 : l'ordi peut gagner au 3e coup
; Un coup est juge sur (V = pire g, S = somme des g), compare dans cet ordre.
; =====================================================================

ia_choisir_coup
    call ia_init
    ld a,-100 : ld (ia_bestV),a : ld (ia_bestS),a
    xor a : ld (ia_bestCol),a : ld (ia_i1),a

.m1_boucle
    ld a,(ia_i1)
    ld e,a : ld d,0
    ld hl,table_priorite_colonnes
    add hl,de
    ld a,(hl)
    ld (ia_c1),a
    ld c,a
    call ia_lire_top                ; HL = case libre, A = contenu (0 = jouable)
    or a
    jp nz,.m1_suivant               ; colonne pleine
    ld c,2
    call ia_win
    jp c,.m1_gagne                  ; gain immediat de l'ordi
    ld a,(ia_c1) : ld c,a
    ld a,2
    call ia_poser

    ld a,1 : ld (ia_minV),a
    xor a : ld (ia_sumS),a : ld (ia_c2),a

.h_boucle
    ld a,(ia_c2) : ld c,a
    call ia_lire_top
    or a
    jr nz,.h_suivant
    ld c,1
    call ia_win
    ld a,-8
    jr c,.h_note                    ; l'humain gagne tout de suite
    ld a,(ia_c2) : ld c,a
    ld a,1
    call ia_poser
    call ia_noeud_ordi              ; A = note g
    push af
    ld a,(ia_c2) : ld c,a
    call ia_retirer
    pop af
.h_note
    ld b,a                          ; B = g
    ld hl,ia_sumS
    add a,(hl)
    ld (hl),a                       ; S += g
    ld a,(ia_minV)
    ld c,a
    ld a,b
    sub c                           ; g - minV
    jp p,.h_suivant                 ; g >= minV : rien a faire
    ld a,b : ld (ia_minV),a
.h_suivant
    ld a,(ia_c2) : inc a : ld (ia_c2),a
    cp 7
    jr c,.h_boucle

    ld a,(ia_c1) : ld c,a
    call ia_retirer                 ; on retire le coup m1

    ld a,(ia_minV)                  ; comparer (V,S) au meilleur
    ld hl,ia_bestV
    sub (hl)
    jr z,.egal_v
    jp m,.m1_suivant                ; moins bon
    jr .m1_meilleur
.egal_v
    ld a,(ia_sumS)
    ld hl,ia_bestS
    sub (hl)
    jr z,.m1_suivant                ; egalite parfaite : on garde la colonne prioritaire
    jp m,.m1_suivant
.m1_meilleur
    ld a,(ia_minV) : ld (ia_bestV),a
    ld a,(ia_sumS) : ld (ia_bestS),a
    ld a,(ia_c1) : ld (ia_bestCol),a
.m1_suivant
    ld a,(ia_i1) : inc a : ld (ia_i1),a
    cp 7
    jp c,.m1_boucle
    ld a,(ia_bestCol)
    ret
.m1_gagne
    ld a,(ia_c1)
    ret

; ---------------------------------------------------------------------
; Niveau 3 : l'ordi rejoue. Sortie A = +1 gain / 0 sur / -1 l'humain gagne ensuite
ia_noeud_ordi
    ld a,-1 : ld (ia_g3),a
    xor a : ld (ia_c3),a
.boucle
    ld a,(ia_c3) : ld c,a
    call ia_lire_top
    or a
    jr nz,.suivant
    ld c,2
    call ia_win
    jr c,.gagne
    ld a,(ia_g3)
    or a
    jp p,.suivant                   ; deja une position sure : inutile de tester
    ld a,(ia_prudence)
    or a
    jr z,.sur                       ; mode "3 niveaux stricts"
    ld a,(ia_c3) : ld c,a
    ld a,2
    call ia_poser
    call ia_humain_peut_gagner
    push af
    ld a,(ia_c3) : ld c,a
    call ia_retirer
    pop af
    jr c,.suivant
.sur
    xor a : ld (ia_g3),a
.suivant
    ld a,(ia_c3) : inc a : ld (ia_c3),a
    cp 7
    jr c,.boucle
    ld a,(ia_g3)
    ret
.gagne
    ld a,1
    ret

; CF=1 si l'humain a au moins un coup gagnant immediat
ia_humain_peut_gagner
    xor a : ld (ia_c4),a
.boucle
    ld a,(ia_c4) : ld c,a
    call ia_lire_top
    or a
    jr nz,.suivant
    ld c,1
    call ia_win
    ret c
.suivant
    ld a,(ia_c4) : inc a : ld (ia_c4),a
    cp 7
    jr c,.boucle
    or a                            ; CF=0
    ret

; ---------------------------------------------------------------------
; Test de victoire. Entree : HL = adresse de la case, C = joueur (1/2)
; Sortie : CF=1 si 4 alignes ou plus. HL et C conserves.
; La case elle-meme n'est pas lue (le pion peut etre pose ou non).
ia_win
    ld ix,ia_dirs
.axe
    ld e,(ix+0) : ld d,(ix+1)
    ld a,d : or e
    ret z                           ; fin de table : pas de victoire (CF=0)
    push hl
    ld b,1
.p1 add hl,de
    ld a,(hl) : cp c
    jr nz,.q1
    inc b
    jr .p1
.q1 pop hl
    push hl
    ld e,(ix+2) : ld d,(ix+3)
.p2 add hl,de
    ld a,(hl) : cp c
    jr nz,.q2
    inc b
    jr .p2
.q2 pop hl
    ld a,b : cp 4
    jr c,.suite
    scf
    ret
.suite
    ld de,4
    add ix,de
    jr .axe

; Entree C = colonne. Sortie HL = adresse de la 1re case libre (ou sentinelle
; si colonne pleine), A = son contenu (0 = jouable).
ia_lire_top
    ld hl,ia_top
    ld b,0
    add hl,bc : add hl,bc
    ld a,(hl) : inc hl : ld h,(hl) : ld l,a
    ld a,(hl)
    ret

; Entree C = colonne, A = joueur : pose un pion
ia_poser
    ld e,a
    ld hl,ia_top
    ld b,0
    add hl,bc : add hl,bc
    push hl
    ld a,(hl) : inc hl : ld h,(hl) : ld l,a
    ld (hl),e
    ld de,-8
    add hl,de
    ex de,hl
    pop hl
    ld (hl),e : inc hl : ld (hl),d
    ret

; Entree C = colonne : retire le dernier pion pose
ia_retirer
    ld hl,ia_top
    ld b,0
    add hl,bc : add hl,bc
    push hl
    ld e,(hl) : inc hl : ld d,(hl)
    ld hl,8
    add hl,de
    ld (hl),0
    ex de,hl
    pop hl
    ld (hl),e : inc hl : ld (hl),d
    ret

; Copie le plateau du jeu dans ia_sb (largeur 8 + sentinelles = 3) et
; calcule ia_top[] (adresse de la 1re case libre de chaque colonne)
ia_init
    ld hl,ia_sb
    ld de,ia_sb+1
    ld bc,63
    ld (hl),3
    ldir
    ld hl,lab890C
    ld de,ia_sb+8
    ld b,6
.ligne
    push bc
    ld bc,7
    ldir
    inc de                          ; saute la colonne sentinelle
    pop bc
    djnz .ligne
    ld ix,ia_top
    ld hl,ia_sb+48                  ; bas de la colonne 0
    ld b,7
.col
    push hl
.monte
    ld a,(hl)
    or a
    jr z,.trouve
    cp 3
    jr z,.trouve                    ; sentinelle : colonne pleine
    ld de,-8
    add hl,de
    jr .monte
.trouve
    ld (ix+0),l : ld (ix+1),h
    inc ix : inc ix
    pop hl
    inc hl
    djnz .col
    ret

; ---------------------------------------------------------------------
; Donnees (a laisser avec le reste des variables)
ia_prudence defb 1                  ; 1 = test final "gain humain immediat", 0 = 3 niveaux stricts
ia_dirs     defw 1,#ffff, 8,#fff8, 7,#fff9, 9,#fff7, 0
ia_sb       defs 64                 ; plateau prive (8 x 8 avec sentinelles)
ia_top      defs 14                 ; 7 pointeurs
ia_bestV    defb 0
ia_bestS    defb 0
ia_bestCol  defb 0
ia_i1       defb 0
ia_c1       defb 0
ia_c2       defb 0
ia_c3       defb 0
ia_c4       defb 0
ia_minV     defb 0
ia_sumS     defb 0
ia_g3       defb 0

defb 'ici commence le royaume des variables',0
; data: variables, board state, graphics and text tables
lab88D6 DEFB #00 ; temp row counter (board draw init)
lab88D7 DEFB #00 ; temp column counter (board draw init)
lab88D8 DEFB #00 ; selected column / cursor (0-6)
lab88D9 DEFB #01,#00,#00 ; current player (1/2)
lab88DC DEFB #00 ; win direction row delta
lab88DD DEFB #00 ; win direction column delta
lab88DE DEFB #00 ; animation mask byte
lab88DF DEFB #00 ; win animation counter
nbPlayer DEFB #02 ; game mode (1=one player,2=two players)
legacyDifficulty DEFB #02 ; difficulty (1=facile,2=difficile)
newDifficulty defb 0
lab88E2 DEFB #00 ; AI search mode
lab88E3 DEFB #00 ; AI loop counter
lab88E4 DEFB #00 ; AI column scan
lab88E5 DEFB #00 ; AI candidate column
lab88E6 DEFB #00 ; AI best column
lab88E7 DEFB #00 ; AI saved row
lab88E8 DEFB #00 ; AI saved column
lab88E9 DEFB #00 ; AI empty count
lab88EA DEFB #00 ; AI loop index
lab88EB DEFB #00 ; render loop counter
lab88EC DEFB #00 ; glyph render: source address low
lab88ED DEFB #00 ; glyph render: source address high
lab88EE DEFB #00 ; glyph render: dest address low
lab88EF DEFB #00 ; glyph render: dest address high
lab88F0 DEFB #00 ; glyph color plane index
lab88F1 DEFB #00 ; glyph row counter
lab88F2 DEFB #00 ; game over / win flag
lab88F3 DEFB #00 ; moves played count
lab88F4 DEFB #00 ; AI depth / fill count
lab88F5 DEFB #00 ; last placed piece row
lab88F6 DEFB #00 ; last placed piece column
lab88F7 DEFB #00 ; AI step row delta
lab88F8 DEFB #00 ; AI step column delta
lab88F9 DEFB #00 ; AI test cell row
lab88FA DEFB #00 ; AI test cell column
lab88FB DEFB #01,#00,#00,#01,#01,#01 ; AI direction vector table (4 pairs)
lab8901 DEFB #01,#ff,#01,#00,#00 ; sound data block
lab8906 DEFB #00,#00,#00,#0c,#0a,#00 ; sound pointer temp
lab890C DEFB #00 ; board state array (6x7 cells)
lab890D DEFB #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
    DEFB #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
    DEFB #00,#00,#00,#00,#00,#00,#00,#00,#00
lab8936 DEFB #00,#00,#ff,#ff,#00,#00,#00,#55,#ff,#ff,#aa,#00,#00,#ff,#ff,#ff ; board cell graphics table
    DEFB #ff,#00,#00,#ff,#ff,#ff,#ff,#00,#55,#ff,#ff,#ff,#ff,#aa,#55,#ff
    DEFB #ff,#ff,#ff,#aa,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
    DEFB #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
    DEFB #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
    DEFB #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
    DEFB #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#55,#ff,#ff,#ff
    DEFB #ff,#aa,#55,#ff,#ff,#ff,#ff,#aa,#00,#ff,#ff,#ff,#ff,#00,#00,#ff
    DEFB #ff,#ff,#ff,#00,#00,#55,#ff,#ff,#aa,#00,#00,#00,#ff,#ff,#00,#00
    DEFB #50,#55,#49,#53,#53,#41,#4e,#43,#45,#20,#34,#00,#41,#50,#50,#55
    DEFB #59,#45,#5a,#20,#55,#4e,#45,#20,#54,#4f,#55,#43,#48,#45,#00

niveau_debutant      defb '1: DEBUTANT',#00 ; text: 1 = FACILE
niveau_intermediaire defb '2: INTERMEDIAIRE',0
niveau_avance        defb '3: AVANCE',0
niveau_difficile     defb '4: DIFFICILE',#00 ; text: 2 = DIFFICILE
niveau_deux_joueurs  defb '5: DEUX JOUEURS',0 ; text: 3 = DEUX JOUEURS


table_priorite_colonnes DEFB #03,#02,#04,#01,#05,#00,#06 ; difficulty move priority table
table_priorite_naive    defb 1,6,0,5,2,4,3


lab8A15 DEFB #06,#ff,#00,#ff,#00,#ff,#00,#ff,#00,#ff,#00,#ff,#00,#ff,#00,#ff ; cursor and menu sprite masks
    DEFB #00,#aa,#50,#55,#88,#ff,#00,#ff,#00,#ff,#00
lab8A30 DEFB #ff,#00,#00
lab8A33 DEFB #f0,#00,#f0,#ff,#00,#ff
lab8A39 DEFB #00,#ff,#00,#aa,#50
lab8A3E DEFB #00,#f0,#00,#f0,#55,#88,#ff,#00,#ff
lab8A47 DEFB #00,#00,#b0,#00,#70,#00,#f0,#00,#e4,#ff,#00
lab8A52 DEFB #ff,#00,#00,#b0,#00,#70,#00,#f0,#00,#cc,#ff,#00,#aa,#50,#00,#30
    DEFB #00
lab8A63 DEFB #70,#00,#f0,#00,#e4,#55,#82,#aa,#50,#00,#b0,#00,#f0,#00,#f0,#00
    DEFB #cc,#55,#82,#aa,#50,#00,#70,#00,#f0,#00,#f0,#00,#e4,#55,#82,#aa
    DEFB #50,#00,#f0,#00,#f0,#00,#f0,#00,#cc,#55,#82,#aa,#50,#00,#f0,#00
    DEFB #f0,#00,#e4,#00,#cc,#55,#82,#aa,#50,#00,#f0,#00,#f0,#00,#f0,#00
    DEFB #cc,#55,#82,#aa,#50,#00,#f0,#00,#f0,#00,#e4,#00,#cc,#55,#82,#aa
    DEFB #50,#00,#f0,#00,#f0,#00,#cc,#00,#cc,#55,#82,#aa,#44,#00,#f0,#00
    DEFB #e4,#00,#e4,#00,#c9,#55,#82,#aa,#44,#00,#d8,#00,#cc,#00,#cc,#00
    DEFB #c3,#55,#82,#aa,#44,#00,#e4,#00,#cc,#00,#cc,#00,#c3,#55,#82,#aa
    DEFB #44,#00,#cc,#00,#cc,#00,#cc,#00,#c3,#55,#82,#ff,#00,#00,#cc,#00
    DEFB #cc,#00,#c9,#00,#c3,#ff,#00,#ff,#00,#00,#c6,#00,#cc,#00,#c3,#00
    DEFB #c3,#ff,#00,#ff,#00,#aa,#41,#00,#c3,#00,#c3,#55,#82,#ff,#00,#ff
    DEFB #00,#ff,#00,#00,#c3,#00,#c3,#ff,#00,#ff,#00,#ff,#00,#ff,#00,#aa
    DEFB #41,#55,#82,#ff,#00,#ff,#00,#ff,#00,#ff,#00,#ff,#00,#ff,#00,#ff
    DEFB #00,#ff,#00
lab8B36 DEFB #ff,#00,#ff,#00,#ff,#00,#ff,#00,#ff,#00,#ff,#00,#ff,#00,#ff,#00 ; player 2 sprite masks
    DEFB #aa,#14,#55,#08,#ff,#00,#ff,#00,#ff,#00,#ff,#00,#00,#3c,#00,#3c
    DEFB #ff,#00,#ff,#00,#ff,#00,#aa,#14,#00,#3c,#00,#3c,#55,#08,#ff,#00
    DEFB #ff,#00,#00,#38,#00
lab8B6B DEFB #34,#00,#3c,#00,#2c,#ff,#00,#ff,#00,#00,#38,#00
lab8B77 DEFB #34,#00,#3c,#00,#0c,#ff,#00,#aa,#14,#00,#30,#00
lab8B83 DEFB #34,#00,#3c,#00,#2c,#55,#0a,#aa,#14,#00,#38,#00
lab8B8F DEFB #3c,#00,#3c,#00,#0c,#55,#0a,#aa,#14,#00,#34,#00,#3c,#00,#3c,#00
    DEFB #2c,#55,#0a,#aa,#14,#00,#3c,#00,#3c,#00,#3c,#00,#0c,#55,#0a,#aa
    DEFB #14,#00,#3c,#00,#3c,#00,#2c,#00,#0c,#55,#0a,#aa,#14,#00,#3c,#00
    DEFB #3c,#00,#3c,#00,#0c,#55,#0a,#aa,#14,#00,#3c,#00,#3c,#00,#2c,#00
    DEFB #0c,#55,#0a,#aa,#14,#00,#3c,#00,#3c,#00,#0c,#00,#0c,#55,#0a,#aa
    DEFB #04,#00,#3c,#00,#2c,#00,#2c,#00,#0d,#55,#0a,#aa,#04,#00,#1c,#00
    DEFB #0c,#00,#0c,#00,#0f,#55,#0a,#aa,#04,#00,#2c,#00,#0c,#00,#0c,#00
    DEFB #0f,#55,#0a,#aa,#04,#00,#0c,#00,#0c,#00,#0c,#00,#0f,#55,#0a,#ff
    DEFB #00,#00,#0c,#00,#0c,#00,#0d,#00,#0f,#ff,#00,#ff,#00,#00,#0e,#00
    DEFB #0c,#00,#0f,#00,#0f,#ff,#00,#ff,#00,#aa,#05,#00,#0f,#00,#0f,#55
    DEFB #0a,#ff,#00,#ff,#00,#ff,#00,#00,#0f,#00,#0f,#ff,#00,#ff,#00,#ff
    DEFB #00,#ff,#00,#aa,#05,#55,#0a,#ff,#00,#ff,#00,#ff,#00,#ff,#00,#ff
    DEFB #00,#ff,#00,#ff,#00,#ff,#00
lab8C56 DEFB #ff,#00,#ff,#00,#aa,#01,#55,#02,#ff,#00,#ff,#00,#ff,#00,#aa,#01 ; erase/clear sprite masks
    DEFB #00,#03,#00,#03,#55,#02,#ff,#00,#ff,#00,#aa,#01,#00,#00,#00,#00
    DEFB #55,#02,#ff,#00,#ff,#00,#00,#02,#00,#00,#00,#00,#00,#01,#ff,#00
    DEFB #aa,#01,#00,#00,#00,#00,#00,#00,#00,#00,#55,#02,#aa,#01,#00,#00
    DEFB #00,#00,#00,#00,#00,#00,#55,#02,#aa,#01,#00,#00,#00,#00,#00,#00
    DEFB #00,#00,#55,#02,#aa,#00,#00,#00,#00,#00,#00,#00,#00,#00,#55,#00
    DEFB #00,#02,#00,#00,#00,#00,#00,#00,#00,#00,#00,#54,#00,#02,#00,#00
    DEFB #00,#00,#00,#00,#00,#00,#00,#54,#00,#02,#00,#00,#00,#00,#00,#00
    DEFB #00,#00,#00,#54,#00,#02,#00,#00,#00,#00,#00,#00,#00,#00,#00,#54
    DEFB #00,#02,#00,#00,#00,#00,#00,#00,#00,#00,#00,#54,#00,#02,#00,#00
    DEFB #00,#00,#00,#00,#00,#00,#00,#54,#00,#02,#00,#00,#00,#00,#00,#00
    DEFB #00,#00,#00,#54,#00,#02,#00,#00,#00,#00,#00,#00,#00,#00,#00,#54
    DEFB #aa,#00,#00,#00,#00,#00,#00,#00,#00,#00,#55,#00,#aa,#54,#00,#00
    DEFB #00,#00,#00,#00,#00,#00,#55,#a8,#aa,#54,#00,#00,#00,#00,#00,#00
    DEFB #00,#00,#55,#a8,#aa,#54,#00,#00,#00,#00,#00,#00,#00,#00,#55,#a8
    DEFB #ff,#00,#00,#a8,#00,#00,#00,#00,#00,#54,#ff,#00,#ff,#00,#aa,#54
    DEFB #00,#00,#00,#00,#55,#a8,#ff,#00,#ff,#00,#aa,#54,#00,#fc,#00,#fc
    DEFB #55,#a8,#ff,#00,#ff,#00,#ff,#00,#aa,#54,#55,#a8,#ff,#00,#ff,#00
lab8D76 DEFB #03,#03,#03,#03,#47,#8b,#47,#8b,#47,#8b,#47,#8b,#03,#03,#03,#03 ; screen fill pattern table
lab8D86 DEFB #ff,#00,#ff,#00,#ff,#00,#ff,#00,#ff,#00,#ff,#00,#ff,#00,#ff,#00 ; piece sprite graphics table
    DEFB #ff,#00,#ff,#00,#ff,#00,#ff,#00,#ff,#00,#ff,#00,#ff,#00,#ff,#00
    DEFB #ff,#00,#00,#03,#ff,#00,#ff,#00,#ff,#00,#ff,#00,#ff,#00,#00,#03
    DEFB #00,#03,#00,#03,#ff,#00,#ff,#00,#ff,#00,#ff,#00,#00,#03,#00,#03
    DEFB #00,#03,#ff,#00,#ff,#00,#ff,#00,#aa,#01,#00,#03,#00,#03,#00,#03
    DEFB #55,#02,#ff,#00,#ff,#00,#00,#03,#00,#03,#00,#03,#00,#03,#00,#03
    DEFB #ff,#00,#ff,#00,#00,#03,#00,#03,#00,#03,#00,#03,#00,#03,#ff,#00
    DEFB #ff,#00,#00,#03,#00,#03,#00,#03,#00,#03,#00,#03,#ff,#00,#ff,#00
    DEFB #00,#03,#00,#03,#00,#03,#00,#03,#00,#03,#ff,#00,#aa,#01,#00,#03
    DEFB #00,#03,#00,#03,#00,#03,#00,#03,#55,#02,#aa,#01,#00,#03,#00,#03
    DEFB #00,#03,#00,#03,#00,#03,#55,#02,#aa,#01,#00,#03,#00,#03,#00,#03
    DEFB #00,#03,#00,#03,#55,#02,#aa,#01,#00,#03,#00,#03,#00,#03,#00,#03
    DEFB #00,#03,#55,#02,#aa,#01,#00,#03,#00,#03,#00,#03,#00,#03,#00,#03
    DEFB #55,#02,#aa,#01,#00,#03,#00,#03,#00,#03,#00,#03,#00,#03,#55,#02
    DEFB #aa,#01,#00,#03,#00,#03,#00,#03,#00,#03,#00,#03,#55,#02,#aa,#01
    DEFB #00,#03,#00,#03,#00,#03,#00,#03,#00,#03,#55,#02,#ff,#00,#00,#03
    DEFB #00,#03,#00,#03,#00,#03,#00,#03,#ff,#00,#ff,#00,#00,#03,#00,#03
    DEFB #00,#03,#00,#03,#00,#03,#ff,#00,#ff,#00,#00,#03,#00,#03,#00,#03
    DEFB #00,#03,#00,#03,#ff,#00,#ff,#00,#00,#03,#00,#03,#00,#03,#00,#03
    DEFB #00,#03,#ff,#00,#ff,#00,#aa,#01,#00,#03,#00,#03,#00,#03,#55,#02
    DEFB #ff,#00,#ff,#00,#ff,#00,#00,#03,#00,#03,#00,#03,#ff,#00,#ff,#00
    DEFB #ff,#00,#ff,#00,#00,#03,#00,#03,#00,#03,#ff,#00,#ff,#00,#ff,#00
    DEFB #ff,#00,#ff,#00,#00,#03,#ff,#00,#ff,#00,#ff,#00
lab8EF2 DEFB #50,#f0,#88,#88,#f0,#80,#80,#80,#55,#88,#88,#88,#88,#88,#88,#70 ; character glyph map
    DEFB #49,#70,#20,#20,#20,#20,#20,#70,#53,#78,#80,#80,#70,#08,#08,#f0
    DEFB #41,#70,#88,#88,#f8,#88,#88,#88,#4e,#88,#c8,#a8,#98,#88,#88,#88
    DEFB #43,#70,#88,#80
lab8F26 DEFB #80,#80 ; color lookup
lab8F28 DEFB #88,#70,#45,#f8,#80,#80,#f0,#80,#80,#f8,#34,#10,#30,#50,#90,#f8 ; color lookup 2
    DEFB #10,#10,#44,#f0,#88,#88,#88,#88,#88,#f0,#4c,#80,#80,#80,#80,#80
    DEFB #80,#f8
lab8F4A DEFB #58,#88,#88,#50,#20,#50,#88,#88,#00 ; glyph offset table
lab8F53 DEFB #30,#3c,#0c,#0c,#0c,#0f,#0f ; glyph color table
lab8F5A DEFB #50,#55,#49,#53,#53,#41,#4e,#43,#45,#00 ; initial screen sprite set A
lab8F64 DEFB #34 ; initial screen sprite set B
lab8F65 DEFB #20,#44,#45,#4c,#55,#58,#45,#00
lab8F6D DEFB #28,#00 ; menu text glyph table
lab8F6F DEFB #20,#10,#00,#20,#00
lab8F74 DEFB #20,#00
lab8F76 DEFB #20,#00
lab8F78 DEFB #10,#00
lab8F7A DEFB #00,#20,#29,#10,#00
lab8F7F DEFB #00
lab8F80 DEFB #20,#00
lab8F82 DEFB #10,#00
lab8F84 DEFB #10,#00
lab8F86 DEFB #10,#00
lab8F88 DEFB #20,#10,#00,#63,#00,#00,#00,#00
lab8F90 DEFB #10,#20,#20,#10,#20,#00
lab8F96 DEFB #20,#10,#10,#20
lab8F9A DEFB #32,#10,#20,#20,#10,#00
lab8FA0 DEFB #10,#00
lab8FA2 DEFB #20,#10
lab8FA4 DEFB #00
lab8FA5 DEFB #20,#00
lab8FA7 DEFB #30,#30,#30,#10
lab8FAB DEFB #20,#20,#10,#20
lab8FAF DEFB #10,#20
lab8FB1 DEFB #10,#20
lab8FB3 DEFB #10,#20,#10,#10,#20,#36
lab8FB9 DEFB #10,#20
lab8FBB DEFB #20,#00
lab8FBD DEFB #20,#00
lab8FBF DEFB #30,#20,#20,#10,#20,#10,#10,#20
lab8FC7 DEFB #62,#20,#00
lab8FCA DEFB #20,#00
lab8FCC DEFB #30,#20
lab8FCE DEFB #20,#10
lab8FD0 DEFB #20,#10
lab8FD2 DEFB #20,#10
lab8FD4 DEFB #30,#20,#79,#00,#00
lab8FD9 DEFB #00,#00
lab8FDB DEFB #20,#10,#20,#10
lab8FDF DEFB #10,#30
lab8FE1 DEFB #00
lab8FE2 DEFB #10,#10
lab8FE4 DEFB #20,#4f
lab8FE6 DEFB #10,#20,#20,#10,#20,#10
lab8FEC DEFB #20,#10
lab8FEE DEFB #20,#10,#20,#10,#10,#20
lab8FF4 DEFB #52
lab8FF5 DEFB #30,#20,#20,#10
lab8FF9 DEFB #20,#10
lab8FFB DEFB #30,#20
lab8FFD DEFB #20,#20
lab8FFF DEFB #20,#10
lab9001 DEFB #20,#10,#4b,#20,#10,#20,#20 ; data
lab9008 DEFB #30,#00 ; data
lab900A DEFB #30,#00
lab900C DEFB #20,#20,#20,#10
lab9010 DEFB #20,#10,#45 ; data
lab9013 DEFB #30,#30 ; data
lab9015 DEFB #20,#00 ; data
lab9017 DEFB #20,#00 ; data
lab9019 DEFB #30,#20,#20,#00 ; data
lab901D DEFB #20,#00
lab901F DEFB #30,#30,#41
lab9022 DEFB #10,#20,#20,#10,#20,#10 ; data
lab9028 DEFB #30,#30,#20,#10,#20,#10 ; data
lab902E DEFB #20,#10,#44,#30,#20,#20,#10
lab9035 DEFB #20,#10 ; data
lab9037 DEFB #20,#10,#20,#10 ; data
lab903B DEFB #20,#10
lab903D DEFB #30,#20,#59
lab9040 DEFB #20,#10,#20,#10 ; data
lab9044 DEFB #20,#10 ; data
lab9046 DEFB #10,#20,#00 ; data
lab9049 DEFB #20,#00 ; data
lab904B DEFB #20,#00
lab904D DEFB #20,#00
copyright    DEFB 'v3  by Beam,Grok,RDD',0
copy2        DEFB 'original creation by',0
oldcopyright DEFB 'Orko Ready  & Claude',0
defb 'nichoooooooooooooons!'

save 'p4.bin',#8000,$-#8000


