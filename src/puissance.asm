


org #8000 ; program origin / load address

; code: game logic and routines
lab8000 xor a ; entry point: init inks/mode, draw board, main loop
    ld (MovesPlayedCount),a
    ld (GameOverWinFlag),a
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
    call InitScreenAndMenu
    ld hl,#c05c
    ld c,#38
    ld b,#c0
    ld a,#c0
    call FillHorizontalBytes
    call DrawBoardFrame
    call DrawGrid
    ld hl,#e05d
    ld a,#6
    ld (TempRowCounter),a
lab809C push hl ; draw board rows loop
    ld a,#7
    ld (TempColumnCounter),a
lab80A2 push hl ; draw board columns loop
    call DrawPieceSprite
    call EraseSpriteCell
    pop hl
    ld de,#8
    add hl,de
    ld a,(TempColumnCounter)
    dec a
    ld (TempColumnCounter),a
    jr nz,lab80A2
    pop hl
    ld de,#140
    add hl,de
    ld a,(TempRowCounter)
    dec a
    ld (TempRowCounter),a
    jr nz,lab809C
    call DrawBottomBorder
    ld hl,lab890C
    ld de,lab890D
    ld bc,#29
    ld (hl),#0
    ldir
    xor a
    ld (SelectedColumn),a
    ld a,#1
    ld (CurrentPlayer),a
lab80DE ld a,(nbPlayer) ; main game loop
    cp #1
    jr nz,lab80F8
    ld a,(CurrentPlayer)
    cp #2
    jr nz,lab80F8
    call ShortDelay
    call ShortDelay
    call lab84B4
    jp DropDiscIntoSelectedColumn
lab80F8 call lab81BB ; handle keyboard input
    call DrawCursor
    call #bb06 ; vector KM_WAIT_CHAR
    push af
    ld a,#0
    call DrawCursor
    pop af
    cp #f2
    jr z,lab811A
    cp #f3
    jr z,lab8126
    cp #20
    jr z,DropDiscIntoSelectedColumn
    cp #fc
    jr z,lab8133
    jr lab80DE
lab811A ld a,(SelectedColumn) ; cursor left
    or a
    jr z,lab80DE
    dec a
    ld (SelectedColumn),a
    jr lab80DE
lab8126 ld a,(SelectedColumn) ; cursor right
    cp #6
    jr z,lab80DE
    inc a
    ld (SelectedColumn),a
    jr lab80DE
lab8133 ret  ; quit game

DropDiscIntoSelectedColumn ld a,(SelectedColumn) ; drop disc into selected column
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
lab815A ld a,(CurrentPlayer) ; place disc, animate drop, check win
    ld (hl),a
    ld a,b
    ld (CurrentPlayer+2),a
    xor a
    ld (CurrentPlayer+1),a
lab8166 ld a,(CurrentPlayer+1) ; animate falling disc
    ld b,a
    call ScreenAddressForBoardCell
    call lab81BB
    ld c,a
    ld ix,lab8936
    call DrawSpriteUsingColorMask
    ld a,(CurrentPlayer+1)
    ld hl,CurrentPlayer+2
    cp (hl)
    jr z,lab8194
    call lab81F7
    ld a,(CurrentPlayer+1)
    ld b,a
    call ScreenAddressForBoardCell
    call EraseSpriteCell
    ld hl,CurrentPlayer+1
    inc (hl)
    jr lab8166
lab8194 ld hl,#1de ; after move: sound, win check, turn switch
    call lab82FB
    call CheckFourInARow
    ld a,(GameOverWinFlag)
    or a
    jp nz,GameOverSequence
    ld a,(MovesPlayedCount)
    inc a
    ld (MovesPlayedCount),a
    cp #2a
    jp z,lab821F
    ld a,(CurrentPlayer)
    xor #3
    ld (CurrentPlayer),a
    jp lab80DE
lab81BB ld a,(CurrentPlayer) ; current player color mask
    cp #1
    ld a,#cc
    ret z
    ld a,#c
    ret 

ScreenAddressForCursorColumn ld a,(SelectedColumn) ; screen address for cursor column
    add a,a
    add a,a
    add a,a
    ld e,a
    ld d,#0
    ld hl,#c00d
    add hl,de
    ret 

DrawCursor push af ; draw cursor
    call ScreenAddressForCursorColumn
    pop af
    ld c,#6
    ld b,#6
    call FillHorizontalBytes
    ret 

ScreenAddressForBoardCell ld hl,#e05d ; screen address for board cell
    ld a,(SelectedColumn)
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

GameOverSequence ld hl,#1de ; game over sequence
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

CheckFourInARow xor a ; check four-in-a-row
    ld (GameOverWinFlag),a
    ld a,(SelectedColumn)
    ld (LastPlacedPieceRow),a
    ld a,(CurrentPlayer+2)
    ld (LastPlacedPieceColumn),a
    ld ix,AIDirectionVectors
    ld b,#4
lab8270 push bc ; code
    ld a,#1
    ld (AIFillCount),a
    ld a,(ix+0)
    ld (AIStepRowDelta),a
    ld a,(ix+1)
    ld (AIStepColumnDelta),a
    call StepDirectionWhileChecking
    ld a,(AIStepRowDelta)
    neg
    ld (AIStepRowDelta),a
    ld a,(AIStepColumnDelta)
    neg
    ld (AIStepColumnDelta),a
    call StepDirectionWhileChecking
    ld a,(AIFillCount)
    cp #4
    jr c,lab82B0
    ld a,#1
    ld (GameOverWinFlag),a
    ld a,(ix+0)
    ld (WinDirectionRowDelta),a
    ld a,(ix+1)
    ld (WinDirectionColumnDelta),a
lab82B0 inc ix
    inc ix
    pop bc
    djnz lab8270
    ret 

StepDirectionWhileChecking ld a,(LastPlacedPieceRow) ; step direction while checking
    ld (AITestCellRow),a
    ld a,(LastPlacedPieceColumn)
    ld (AITestCellColumn),a
lab82C4 ld a,(AITestCellRow) ; walk board cells in direction
    ld hl,AIStepRowDelta
    add a,(hl)
    ld (AITestCellRow),a
    cp #7
    ret nc
    ld a,(AITestCellColumn)
    ld hl,AIStepColumnDelta
    add a,(hl)
    ld (AITestCellColumn),a
    cp #6
    ret nc
    ld b,a
    ld a,(AITestCellRow)
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
    ld a,(CurrentPlayer)
    cp (hl)
    ret nz
    ld hl,AIFillCount
    inc (hl)
    jr lab82C4
lab82FB ld (SoundPointerTemp),hl ; play sound effect
    ld hl,SoundDataBlock+2
    call #bcaa ; vector SOUND_QUEUE
    ret 

InitScreenAndMenu ld hl,#c000 ; init screen and menu
    ld c,#50
    ld b,#c8
    call FillScreenAreaFromTable
    ld hl,#d057
    ld de,lab8F5A
    call DrawGlyphString
    ld hl,#f19b
    ld de,lab8F64
    call DrawGlyphString
    ld hl,#c9e4
    ld c,#cc
    call DrawSpriteUsingColorMask
    ld hl,#ca26
    ld c,#c
    call DrawSpriteUsingColorMask
    ld hl,#dc15
    ld c,#46
    ld b,#32
    ld a,#fc
    call FillHorizontalBytes
    ld hl,#e416
    ld c,#44
    ld b,#30
    ld a,#0
    call FillHorizontalBytes

    ld a,#4 : call #bb90 ; vector TXT_SET_PEN
    ld h,#3 :  ld l,#f : call #bb75 ; vector TXT_SET_CURSOR
    ld hl,niveau_debutant : call PrintZeroTerminatedString

    ld h,#3 :  ld l,#10 : call #bb75 ; vector TXT_SET_CURSOR
    ld hl,niveau_intermediaire : call PrintZeroTerminatedString

    ld a,#a : call #bb90 ; vector TXT_SET_PEN
    ld h,#3 :  ld l,#11 : call #bb75 ; vector TXT_SET_CURSOR
    ld hl,niveau_avance : call PrintZeroTerminatedString

    ld h,#3 :  ld l,#12 : call #bb75 ; vector TXT_SET_CURSOR
    ld hl,niveau_difficile : call PrintZeroTerminatedString

    ld a,#3 : call #bb90 ; vector TXT_SET_PEN
    ld h,#3 : ld l,#13 : call #bb75 ; vector TXT_SET_CURSOR
    ld hl,niveau_deux_joueurs :  call PrintZeroTerminatedString

    ld a,#4 : call #bb90 ; vector TXT_SET_PEN
    ld h,#1 : ld l,#17 : call #bb75 ; vector TXT_SET_CURSOR
    ld hl,copyright :  call PrintZeroTerminatedString

    ld a,#4 : call #bb90 ; vector TXT_SET_PEN
    ld h,#1 : ld l,#18 : call #bb75 ; vector TXT_SET_CURSOR
    ld hl,copy2 :  call PrintZeroTerminatedString

    ld a,#4 : call #bb90 ; vector TXT_SET_PEN
    ld h,#1 : ld l,#19 : call #bb75 ; vector TXT_SET_CURSOR
    ld hl,oldcopyright :  call PrintZeroTerminatedString

WaitKeyRelease call #bb09 ; vector KM_READ_CHAR ; wait key release
    jr c,WaitKeyRelease
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


PrintZeroTerminatedString ld a,(hl) ; print zero-terminated string
    or a
    ret z
    push hl
    call #bb5a ; vector TXT_OUTPUT
    pop hl
    inc hl
    jr PrintZeroTerminatedString
lab83D4 ld a,#8 ; game over animation
    ld (WinAnimationCounter),a
lab83D9 ld a,#30 ; game over draw loop
    ld (AnimationMask),a
    call AnimateWinningDiscRemoval
    call ShortDelay
    call lab81BB
    ld (AnimationMask),a
    call AnimateWinningDiscRemoval
    call ShortDelay
    ld hl,WinAnimationCounter
    dec (hl)
    jr nz,lab83D9
    ld a,#30
    ld (AnimationMask),a
    call AnimateWinningDiscRemoval
    ld b,#4
lab8400 push bc ; code
    call ShortDelay
    pop bc
    djnz lab8400
    ret 

ShortDelay ld b,#c ; short delay
lab840A push bc
    call #bd19 ; vector MC_WAIT_FLYBACK
    pop bc
    djnz lab840A
    ret 

AnimateWinningDiscRemoval ld a,(LastPlacedPieceRow) ; animate winning disc removal
    ld (AITestCellRow),a
    ld a,(LastPlacedPieceColumn)
    ld (AITestCellColumn),a
    call DrawDiscAtCell
    ld a,(WinDirectionRowDelta)
    ld (AIStepRowDelta),a
    ld a,(WinDirectionColumnDelta)
    ld (AIStepColumnDelta),a
    call StepCellInDirection
    ld a,(WinDirectionRowDelta)
    neg
    ld (AIStepRowDelta),a
    ld a,(WinDirectionColumnDelta)
    neg
    ld (AIStepColumnDelta),a
    call StepCellInDirection
    ret 

StepCellInDirection ld a,(LastPlacedPieceRow) ; step cell in direction
    ld (AITestCellRow),a
    ld a,(LastPlacedPieceColumn)
    ld (AITestCellColumn),a
lab8450 ld a,(AITestCellRow) ; code
    ld hl,AIStepRowDelta
    add a,(hl)
    ld (AITestCellRow),a
    cp #7
    ret nc
    ld a,(AITestCellColumn)
    ld hl,AIStepColumnDelta
    add a,(hl)
    ld (AITestCellColumn),a
    cp #6
    ret nc
    ld b,a
    ld a,(AITestCellRow)
    ld c,a
    call lab847C
    ld hl,CurrentPlayer
    cp (hl)
    ret nz
    call DrawDiscAtCell
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

DrawDiscAtCell ld a,(AITestCellColumn) ; draw disc at cell
    ld b,a
    ld a,(AITestCellRow)
    call ScreenAddressForCell
    ld a,(AnimationMask)
    ld c,a
    ld ix,lab8936
    call DrawSpriteUsingColorMask
    ret 

ScreenAddressForCell ld hl,#e05d ; screen address for cell
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
    ld (AISearchMode),a
    call FindImmediateWinningMove
    jr c,lab8513
    ld a,#1
    ld (AISearchMode),a
    call FindImmediateWinningMove
    jr c,lab8513

    ld a,(newDifficulty)
    or a : jr z,ResetColumnScan
    dec a : jr z,ResetColumnScan
    dec a : jr z,unSurDeux
    dec a : jr z,troisSurQuatre
    jr tester_victoire_adversaire ; difficulté max, on teste tout le temps

unSurDeux ld a,%10101010 : rlca : ld (unSurDeux+1),a : jr c,ResetColumnScan : jr tester_victoire_adversaire

troisSurQuatre ld a,%10001000 : rlca : ld (troisSurQuatre+1),a : jr c,ResetColumnScan : jr tester_victoire_adversaire

tester_victoire_adversaire
    xor a
    ld (AIColumnScan),a
lab84D3 call lab8519 ; search winning move for player 2
    ld (AICandidateColumn),a
    ld c,a
    call FreeCellsInColumn
    cp #ff
    jr z,lab84E7
    call EvaluateCandidateMove
    or a
    jr z,lab850D
lab84E7 ld a,(AIColumnScan) ; turn switch after AI
    inc a
    ld (AIColumnScan),a
    cp #7
    jr c,lab84D3


ResetColumnScan xor a ; reset column scan
    ld (AIColumnScan),a
lab84F6 call lab8519 ; search (second pass)
    ld (AICandidateColumn),a
    ld c,a
    call FreeCellsInColumn
    cp #ff
    jr nz,lab850D
    ld a,(AIColumnScan)
    inc a
    ld (AIColumnScan),a
    jr lab84F6
lab850D ld a,(AICandidateColumn) ; column found
    ld (SelectedColumn),a
lab8513 ld a,#2 ; code
    ld (CurrentPlayer),a
    ret 

; scan des colonnes
lab8519
    ld hl,table_priorite_colonnes
    ld a,(newDifficulty) : cp 3 : jr nz,.table_normale : ld hl,table_priorite_naive : .table_normale ; niveau 3 choisi un scan différent des colonnes
    ld a,(AIColumnScan) ; difficulty move table
    ld e,a
    ld d,#0
    add hl,de
    ld a,(hl)
    ret 

WriteCellValue push af ; write cell value
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

CountPiecesInColumn xor a ; count pieces in column
    ld (AIEmptyCount),a
    ld (AILoopIndex),a
lab853D ld a,(AILoopIndex)
    ld c,a
    call TestIfMoveWins
    or a
    jr z,lab854B
    ld hl,AIEmptyCount
    inc (hl)
lab854B ld a,(AILoopIndex)
    inc a
    ld (AILoopIndex),a
    cp #7
    jr c,lab853D
    ld a,(AIEmptyCount)
    ret 

EvaluateCandidateMove ld a,(AICandidateColumn) ; evaluate candidate move
    ld c,a
    call FreeCellsInColumn
    ld (AIBestColumn),a
    ld b,a
    ld a,(AICandidateColumn)
    ld c,a
    ld a,#2
    call WriteCellValue
    ld a,#1
    ld (AISearchMode),a
    call CountPiecesInColumn
    or a
    jr nz,lab85BD
    xor a
    ld (AISavedColumn),a
lab857D ld a,(AISavedColumn) ; iterate board columns
    ld c,a
    call FreeCellsInColumn
    cp #ff
    jr z,lab85AF
    ld (AISavedRow),a
    ld b,a
    ld a,(AISavedColumn)
    ld c,a
    ld a,#1
    call WriteCellValue
    ld a,#1
    ld (AISearchMode),a
    call CountPiecesInColumn
    push af
    ld a,(AISavedRow)
    ld b,a
    ld a,(AISavedColumn)
    ld c,a
    xor a
    call WriteCellValue
    pop af
    cp #2
    jr nc,lab85BD
lab85AF ld a,(AISavedColumn)
    inc a
    ld (AISavedColumn),a
    cp #7
    jr c,lab857D
    xor a
    jr lab85BF
lab85BD ld a,#1
lab85BF push af
    ld a,(AIBestColumn)
    ld b,a
    ld a,(AICandidateColumn)
    ld c,a
    xor a
    call WriteCellValue
    pop af
    ret 

FindImmediateWinningMove xor a ; find immediate winning move
    ld (AILoopCounter),a
lab85D2 ld a,(AILoopCounter) ; scan columns
    ld c,a
    call TestIfMoveWins
    or a
    jr nz,WinningColumnFound
    ld a,(AILoopCounter)
    inc a
    ld (AILoopCounter),a
    cp #7
    jr c,lab85D2
    or a
    ret 

WinningColumnFound ld a,(AILoopCounter) ; winning column found
    ld (SelectedColumn),a
    scf
    ret 

TestIfMoveWins call FreeCellsInColumn ; test if move wins
    cp #ff
    jr z,lab860C
    ld (CurrentPlayer+2),a
    ld a,c
    ld (SelectedColumn),a
    ld a,(AISearchMode)
    ld (CurrentPlayer),a
    call CheckFourInARow
    ld a,(GameOverWinFlag)
    ret 

lab860C xor a
    ret 

FreeCellsInColumn ld b,#5 ; free cells in column
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

DrawSpriteUsingColorMask ld a,c ; draw sprite using color mask
    cp #cc
    ld ix,CursorAndMenuSpriteMasks+1
    jr z,lab863B
    cp #c
    ld ix,lab8B36
    jr z,lab863B
    ld ix,lab8936
    call XorMaskUpdate
    ret 

lab863B call RenderGlyphBlock
    ret 

EraseSpriteCell ld ix,lab8C56 ; erase sprite/cell
    call RenderGlyphBlock
    ret 

RenderGlyphBlock ld e,#18 ; render glyph block
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

DrawBoardFrame ld hl,#c008 ; draw board frame
    ld c,#1
    ld b,#c8
    ld a,#3
    call FillHorizontalBytes
    ld hl,#c009
    ld c,#2
    ld b,#c8
    ld a,#fc
    call FillHorizontalBytes
    ld hl,#c00b
    ld c,#1
    ld b,#c8
    ld a,#30
    call FillHorizontalBytes
    ld hl,#c047
    ld c,#1
    ld b,#c8
    ld a,#3
    call FillHorizontalBytes
    ld hl,#c045
    ld c,#2
    ld b,#c8
    ld a,#fc
    call FillHorizontalBytes
    ld hl,#c044
    ld c,#1
    ld b,#c8
    ld a,#30
    call FillHorizontalBytes
    ld hl,#f008
    ld c,#40
    ld b,#1
    ld a,#fc
    call FillHorizontalBytes
    ld hl,#f808
    ld c,#40
    ld b,#1
    ld a,#30
    call FillHorizontalBytes
    ret 

DrawGrid ld hl,#c000 ; draw grid
    ld c,#8
    ld b,#c8
    call FillScreenAreaFromTable
    ld hl,#c048
    ld c,#8
    ld b,#c8
    call FillScreenAreaFromTable
    ret 

FillScreenAreaFromTable ld ix,lab8D76 ; fill screen area from table
    ld a,#8
    ld (RenderLoopCounter),a
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
    ld a,(RenderLoopCounter)
    dec a
    ld (RenderLoopCounter),a
    jr nz,lab8713
    ld ix,lab8D76
    ld a,#8
    ld (RenderLoopCounter),a
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

DrawBottomBorder ld hl,#c05c ; draw bottom border
    ld c,#38
    ld b,#1
    ld a,#fc
    call FillHorizontalBytes
    ld hl,#c05c
    ld c,#1
    ld b,#c0
    ld a,#fc
    call FillHorizontalBytes
    ld hl,#ff8c
    ld c,#38
    ld b,#1
    ld a,#3
    call FillHorizontalBytes
    ld hl,#c093
    ld c,#1
    ld b,#c0
    ld a,#3
    call FillHorizontalBytes
    ret 

DrawPieceSprite push hl ; draw piece sprite
    ld ix,lab8D86
    ld b,#7
    ld c,#1a
    call SpriteRenderLoop
    pop hl
    ret 

SpriteRenderLoop push hl ; sprite render loop
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
    jr nz,SpriteRenderLoop
    ret 

DrawGlyphString ld a,l ; draw glyph string
    ld (GlyphSourceAddressLow),a
    ld a,h
    ld (GlyphSourceAddressHigh),a
    ld a,e
    ld (GlyphDestAddressLow),a
    ld a,d
    ld (GlyphDestAddressHigh),a
    xor a
    ld (GlyphColorPlaneIndex),a
lab8798 ld a,(GlyphSourceAddressLow) ; code
    ld l,a
    ld a,(GlyphSourceAddressHigh)
    ld h,a
    ld a,(GlyphDestAddressLow)
    ld e,a
    ld a,(GlyphDestAddressHigh)
    ld d,a
lab87A8 ld a,(de)
    or a
    jr z,lab87BB
    ld c,a
    push de
    push hl
    call FindGlyphForCharacter
    pop hl
    ld de,#7
    add hl,de
    pop de
    inc de
    jr lab87A8
lab87BB ld a,(GlyphColorPlaneIndex)
    inc a
    ld (GlyphColorPlaneIndex),a
    cp #3
    jr c,lab8798
    ret 

FindGlyphForCharacter ld ix,lab8EF2 ; find glyph for character
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
    ld (GlyphRowCounter),a
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
    call SpecialGlyphRender
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
    ld a,(GlyphRowCounter)
    inc a
    ld (GlyphRowCounter),a
    pop bc
    djnz lab87E2
    ret 

SpecialGlyphRender ld a,(GlyphColorPlaneIndex) ; special glyph render
    or a
    jr z,lab883E
    cp #1
    jr z,lab8835
    inc hl
    call lab8851
    ld a,(GlyphRowCounter)
    ld e,a
    ld d,#0
    push hl
    ld hl,lab8F53
    add hl,de
    ld a,(hl)
    pop hl
    ld c,#1
    ld b,#4
    jp FillHorizontalBytes
lab8835 ld a,#c3 ; cursor glyph
    ld c,#3
    ld b,#6
    jp FillHorizontalBytes
lab883E inc hl ; erase glyph
    inc hl
    call lab8851
    call lab8851
    call lab8851
    xor a
    ld c,#3
    ld b,#6
    jp FillHorizontalBytes
lab8851 ld a,h ; code
    add a,#8
    ld h,a
    ret nc
    push bc
    ld bc,#c050
    add hl,bc
    pop bc
    ret 

DrawVerticalStrip ld a,(de) ; draw vertical strip
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
    jr DrawVerticalStrip
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

FillHorizontalBytes push bc ; fill horizontal bytes
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
    djnz FillHorizontalBytes
    ret 

XorMaskUpdate ld e,#18 ; xor mask update
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

defb 'ici commence le royaume des variables',0
; data: variables, board state, graphics and text tables
TempRowCounter DEFB #00 ; temp row counter (board draw init)
TempColumnCounter DEFB #00 ; temp column counter (board draw init)
SelectedColumn DEFB #00 ; selected column / cursor (0-6)
CurrentPlayer DEFB #01,#00,#00 ; current player (1/2)
WinDirectionRowDelta DEFB #00 ; win direction row delta
WinDirectionColumnDelta DEFB #00 ; win direction column delta
AnimationMask DEFB #00 ; animation mask byte
WinAnimationCounter DEFB #00 ; win animation counter
nbPlayer DEFB #02 ; game mode (1=one player,2=two players)
legacyDifficulty DEFB #02 ; difficulty (1=facile,2=difficile)
newDifficulty defb 0
AISearchMode DEFB #00 ; AI search mode
AILoopCounter DEFB #00 ; AI loop counter
AIColumnScan DEFB #00 ; AI column scan
AICandidateColumn DEFB #00 ; AI candidate column
AIBestColumn DEFB #00 ; AI best column
AISavedRow DEFB #00 ; AI saved row
AISavedColumn DEFB #00 ; AI saved column
AIEmptyCount DEFB #00 ; AI empty count
AILoopIndex DEFB #00 ; AI loop index
RenderLoopCounter DEFB #00 ; render loop counter
GlyphSourceAddressLow DEFB #00 ; glyph render: source address low
GlyphSourceAddressHigh DEFB #00 ; glyph render: source address high
GlyphDestAddressLow DEFB #00 ; glyph render: dest address low
GlyphDestAddressHigh DEFB #00 ; glyph render: dest address high
GlyphColorPlaneIndex DEFB #00 ; glyph color plane index
GlyphRowCounter DEFB #00 ; glyph row counter
GameOverWinFlag DEFB #00 ; game over / win flag
MovesPlayedCount DEFB #00 ; moves played count
AIFillCount DEFB #00 ; AI depth / fill count
LastPlacedPieceRow DEFB #00 ; last placed piece row
LastPlacedPieceColumn DEFB #00 ; last placed piece column
AIStepRowDelta DEFB #00 ; AI step row delta
AIStepColumnDelta DEFB #00 ; AI step column delta
AITestCellRow DEFB #00 ; AI test cell row
AITestCellColumn DEFB #00 ; AI test cell column
AIDirectionVectors DEFB #01,#00,#00,#01,#01,#01 ; AI direction vector table (4 pairs)
SoundDataBlock DEFB #01,#ff,#01,#00,#00 ; sound data block
SoundPointerTemp DEFB #00,#00,#00,#0c,#0a,#00 ; sound pointer temp
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


table_priorite_colonnes DEFB #03,#02,#04,#01,#05,#00 ; difficulty move priority table
table_priorite_naive    defb 1,6,0,5,2,4,3


CursorAndMenuSpriteMasks DEFB #06,#ff,#00,#ff,#00,#ff,#00,#ff,#00,#ff,#00,#ff,#00,#ff,#00,#ff ; cursor and menu sprite masks
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
copyright    DEFB 'v2  by Beam,Grok,RDD',0
copy2        DEFB 'original creation by',0
oldcopyright DEFB 'Orko Ready  & Claude',0
defb 'nichoooooooooooooons!'

save 'p4.bin',#8000,$-#8000


