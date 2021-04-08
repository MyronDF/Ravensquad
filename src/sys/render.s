.include "render.h.s"
.include "man/entities.h.s"
.include "cpctelera.h.s"

.globl cpct_getScreenPtr_asm
.globl cpct_drawSolidBox_asm
.globl cpct_setVideoMode_asm
.globl cpct_setPalette_asm

;; Palette to be used (first color [0000] = black, otherwise, white)
palette:
    ; .db HW_BLACK, HW_BRIGHT_WHITE, HW_BRIGHT_WHITE, HW_BRIGHT_WHITE
    ; .db HW_BRIGHT_WHITE, HW_BRIGHT_WHITE, HW_BRIGHT_WHITE, HW_BRIGHT_WHITE
    ; .db HW_BRIGHT_WHITE, HW_BRIGHT_WHITE, HW_BRIGHT_WHITE, HW_BRIGHT_WHITE 
    ; .db HW_BRIGHT_WHITE, HW_BRIGHT_WHITE, HW_BRIGHT_WHITE, HW_BRIGHT_WHITE

    ; palete from autogerated sprites/main_palette.c
    .db HW_BLACK, 0x44, 0x55, 0x5C 
    .db 0x4C, 0x56, 0x57, 0x5E
    .db 0x40, 0x4E, 0x47, 0x52
    .db 0x53, 0x4A, 0x43, HW_BLACK

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                     ;;
;;                        PRIVATE FUNCTIONS                            ;;
;;                                                                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SYS_RENDER_ONE_ENTITY                                               ;;
;; Renders one entity, modifies A, BC, DE, saves HL                    ;;
;; Deletes the previous entity drawn on screen position e_prevptr      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sys_render_one_entity::
    push hl                          ;; Stores HL in stack
    push bc

    ld A, e_type(ix)
    and #e_type_player_shot | #e_type_enemy_shot
    jp z, check_render_death
    call sys_render_bullet
    jp sys_render_one_entity_end

check_render_death::
    ;; if e->coms & e_cmp_hidetrack draw box to delete entity last pos
    ld  A, e_type(ix)                ;; Stores entity type in A
    and #e_type_dead
    jr nz, #delete_last_pos

    ld a, e_cmps(ix)
    and #e_cmp_hidetrack
    jr z, #sys_render_one_entity_cont1
    

delete_last_pos:
    ld   de, #0xC000                 ;; First video memory position
    ld    b, e_lastY(ix)             ;; Stores e_y(ix) in B 
    ld    c, e_lastX(ix)             ;; Stores e_x(ix) in C

    ;; CPCT_GETSCREENPTR_ASM
    ;; (2B DE) screen_start	Pointer to the start of the screen (or a backbuffer)
    ;; (1B C ) x	[0-79] Byte-aligned column starting from 0 (x coordinate,
    ;; (1B B ) y	[0-199] row starting from 0 (y coordinate) in bytes)
    ;; Returns video mem address in HL
    call cpct_getScreenPtr_asm      
    ex de, hl                        ;; Exchanges DE and HL
    xor a                            ;; Clears A 
    ld  c, e_w(ix)                   ;; Stores width in c
    ld  b, e_h(ix)                   ;; Stores height in b

    ;; CPCT_DRAWSOLIDBOX
    ;; (2B DE) memory	Video memory pointer to the upper left box corner byte
    ;; (1B A ) colour_pattern	1-byte colour pattern (in screen pixel format) to fill the box with
    ;; (1B C ) width	Box width in bytes [1-64] (Beware!  not in pixels!)
    ;; (1B B ) height	Box height in bytes (>0)
    call cpct_drawSolidBox_asm      

    sys_render_one_entity_cont1:

    ;; checks if the entity was set for deletion (don't draw)
    ld  A, e_type(ix)                ;; Stores entity type in A
    and #e_type_dead
    jr nz, #sys_render_one_entity_end
    
    ld  A, e_type(ix)                ;; Stores entity type in A
    cp  #0x81                        ;; CP 81, used to raise flag Z if A = 0x81
    ld de, #0xC000                   ;; First video memory position
    ld  b, e_y(ix)                   ;; Stores e_y(ix) in B 
    ld  c, e_x(ix)                   ;; Stores e_x(ix) in C

    ;; CPCT_GETSCREENPTR_ASM
    ;; (2B DE) screen_start	Pointer to the start of the screen (or a backbuffer)
    ;; (1B C ) x	[0-79] Byte-aligned column starting from 0 (x coordinate,
    ;; (1B B ) y	[0-199] row starting from 0 (y coordinate) in bytes)
    ;; Returns video mem address in HL
    call cpct_getScreenPtr_asm
    ex de, hl                        ;; Exchanges DE and HL
    ld l, e_sprite(ix)               ;; Stores first byte of pointer to sprite in H
    ld h, e_sprite+1(ix)             ;; Stores second byte of pointer to sprite in L
    ld c, e_w(ix)                    ;; Stores width of sprite in C
    ld b, e_h(ix)                    ;; Stores height of sprite in B

    ;; CPCT_DRAWSPRITE_ASM
    ;;(2B HL) sprite	Source Sprite Pointer (array with pixel data)
    ;;(2B DE) memory	Destination video memory pointer
    ;;(1B C ) width	Sprite Width in bytes [1-63] (Beware, not in pixels!)
    ;;(1B B ) height	Sprite Height in bytes (>0)
    call cpct_drawSprite_asm        ;; Draws a sprite

    sys_render_one_entity_end:
    pop bc
    pop hl                          ;; Restores HL from stack
    ret

sys_render_bullet::
    ld   de, #0xC000                 ;; First video memory position
    ld    b, e_lastY(ix)             ;; Stores e_y(ix) in B 
    ld    c, e_lastX(ix)             ;; Stores e_x(ix) in C

    ;; CPCT_GETSCREENPTR_ASM
    ;; (2B DE) screen_start	Pointer to the start of the screen (or a backbuffer)
    ;; (1B C ) x	[0-79] Byte-aligned column starting from 0 (x coordinate,
    ;; (1B B ) y	[0-199] row starting from 0 (y coordinate) in bytes)
    ;; Returns video mem address in HL
    call cpct_getScreenPtr_asm    

    xor a
    ld (hl), a

    ;; checks if the entity was set for deletion (don't draw)
    ld  A, e_type(ix)                ;; Stores entity type in A
    and #e_type_dead
    jr nz, #sys_render_bullet_end
    
    ld de, #0xC000                   ;; First video memory position
    ld  b, e_y(ix)                   ;; Stores e_y(ix) in B 
    ld  c, e_x(ix)                   ;; Stores e_x(ix) in C

    ;; CPCT_GETSCREENPTR_ASM
    ;; (2B DE) screen_start	Pointer to the start of the screen (or a backbuffer)
    ;; (1B C ) x	[0-79] Byte-aligned column starting from 0 (x coordinate,
    ;; (1B B ) y	[0-199] row starting from 0 (y coordinate) in bytes)
    ;; Returns video mem address in HL
    call cpct_getScreenPtr_asm

    ld a, #0xff
    ld (hl), a

    sys_render_bullet_end:
    ret

sys_render_remove_sprite::
    ld   de, #0xC000                 ;; First video memory position
    ld    b, e_y(ix)             ;; Stores e_y(ix) in B 
    ld    c, e_x(ix)             ;; Stores e_x(ix) in C

    ;; CPCT_GETSCREENPTR_ASM
    ;; (2B DE) screen_start	Pointer to the start of the screen (or a backbuffer)
    ;; (1B C ) x	[0-79] Byte-aligned column starting from 0 (x coordinate,
    ;; (1B B ) y	[0-199] row starting from 0 (y coordinate) in bytes)
    ;; Returns video mem address in HL
    call cpct_getScreenPtr_asm      
    ex de, hl                        ;; Exchanges DE and HL
    xor a                            ;; Clears A 
    ld  c, e_w(ix)                   ;; Stores width in c
    ld  b, e_h(ix)                   ;; Stores height in b

    ;; CPCT_DRAWSOLIDBOX
    ;; (2B DE) memory	Video memory pointer to the upper left box corner byte
    ;; (1B A ) colour_pattern	1-byte colour pattern (in screen pixel format) to fill the box with
    ;; (1B C ) width	Box width in bytes [1-64] (Beware!  not in pixels!)
    ;; (1B B ) height	Box height in bytes (>0)
    call cpct_drawSolidBox_asm      
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                     ;;
;;                        PUBLIC FUNCTIONS                             ;;
;;                                                                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SYS_RENDER_SET_BORDER_AND_PALETTE_YELLOW                            ;;
;; Changes the first value of the palette to yellow, sets border color ;;
;; to yellow                                                           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sys_render_set_border_and_palette_yellow::
    cpctm_setBorder_asm HW_BLACK   ;; Sets border color
    ld a, #0x1E 
    ld (palette), a 
    ld  hl, #palette                ;; Stores palette pointer in HL
    ld  de, #16                     ;; Stores 16 in DE
    call cpct_setPalette_asm        ;; Sets the palette to the values in HL, reads DE values
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SYS_RENDER_SET_BORDER_AND_PALETTE_BLACK                             ;;
;; Same as the previous function, but sets color to black              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sys_render_set_border_and_palette_black::
    cpctm_setBorder_asm HW_RED      ;; Sets border color
    ld a, #0x54
    ld (palette), a 
    ld  hl, #palette                ;; Stores palette pointer in HL
    ld  de, #16                     ;; Stores 16 in DE
    call cpct_setPalette_asm        ;; Sets the palette to the values in HL, reads DE values
    ret

sys_render_set_palette_gray_and_clean_screen::
    ld a, #0x40
    ld (palette), a 
    ld  hl, #palette                ;; Stores palette pointer in HL
    ld  de, #16                     ;; Stores 16 in DE
    call cpct_setPalette_asm        ;; Sets the palette to the values in HL, reads DE values
    xor a
    call sys_render_clear_screen
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SYS_RENDER_INIT                                                     ;;
;; Initializes the video mode and palette                              ;;
;; Modifies HL, DE, C                                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sys_render_init::
    ;; MODE 0
    ld  c, #0                       ;; Loads 0 in C
    call cpct_setVideoMode_asm      ;; Sets video mode to value in C

    ;; BORDER 13, SET_PALETTE
    cpctm_setBorder_asm HW_YELLOW   ;; Sets border color
    ld  hl, #palette                ;; Stores palette pointer in HL
    ld  de, #16                     ;; Stores 16 in DE
    call cpct_setPalette_asm        ;; Sets the palette to the values in HL, reads DE values
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SYS_RENDER_UPDATE                                                   ;;
;; Updates the screen, stores in HL the position in memory of          ;;
;; sys_render_one_entity, and calls entity method forall               ;;
;; Modifies HL                                                         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sys_render_update::
    ld hl, #sys_render_one_entity   ;; Stores in HL render one entity address
    ld b, #e_cmp_render
    call man_entity_forall_matching_not_player ;; Calls for entity manager forall

    call man_game_get_player
    call sys_render_one_entity
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SYS_RENDER_CLEAR_ALL_SPRITES                                        ;;
;; Clears every entity sprite, used when the player dies or advances to;;
;; the next level                                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sys_render_clear_all_sprites::
    ld hl, #sys_render_remove_sprite
    ld b, #e_cmp_render
    call man_entity_forall_matching ;; Calls for entity manager forall
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SYS_RENDER_CLEAR_SCREEN                                             ;;
;; Sets every byte in video memory to value stored in A                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sys_render_clear_screen::
    ld  hl, #0xC000
    ld  de, #0xC001
    ld  bc, #0x4000
    ld  (hl), a
    ldir

    ret