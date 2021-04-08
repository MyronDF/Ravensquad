.include "GUI.h.s"
.include "man/entities.h.s"
.include "cpctelera.h.s"

;;man_score:  .dw 0x0000
score_string::          .asciz "00000"  ;; String score
distance_left:          .dw 0           ;; Distance left
partial_distance_left:  .db 0
current_bullet_X:       .db 0
current_bullets:        .db 0
bullets_cont:           .db 0
current_arrow_X:        .db 0
current_lives:          .db 5
lives_cont:             .db 5
current_lives_pos_x:    .db 77
screen_pos_score:       .dw 0x0000      ;; Position video memory location score
screen_pos_lives:       .dw 0x0000      ;; Position video memory location lives
screen_pos_lives_icon:  .dw 0x0000      ;; Position video memory location lives icons
screen_pos_distance:    .dw 0x0000      ;; Position video memory location distance

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                     ;;
;;                        PRIVATE FUNCTIONS                            ;;
;;                                                                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAN_GUI_DRAW_1_LIFE                                                 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_gui_draw_1_life:
    ld a, (current_lives_pos_x)

    ld   de, #CPCT_VMEM_START_ASM   ;; DE = Pointer to start of the screen
    ld    b, #02                    ;; B = y coordinate (02 = 0x02)
    ld    c, a                      ;; C = x coordinate
    call cpct_getScreenPtr_asm      ;; Calculate video memory location and return it in HL

    ld  (screen_pos_lives_icon), hl ;; Pointer so we can get lives_pos any time

    ex de, hl                       ;; Exchanges DE and HL
    ld hl, #_spr_1_up_menu
    ld c, #2                        ;; Stores width of sprite in C
    ld b, #5                        ;; Stores height of sprite in B
    
    ;; CPCT_DRAWSPRITE_ASM
    ;;(2B HL) sprite	Source Sprite Pointer (array with pixel data)
    ;;(2B DE) memory	Destination video memory pointer
    ;;(1B C ) width	    Sprite Width in bytes [1-63] (Beware, not in pixels!)
    ;;(1B B ) height	Sprite Height in bytes (>0)
    call cpct_drawSprite_asm        ;; Draw the string

    ld a, (current_lives_pos_x)
    sub #3
    ld (current_lives_pos_x), a

    ret

man_gui_drawBox_1_life:
    ld a, (current_lives_pos_x)
    add #3
    ld (current_lives_pos_x), a

    ;; Draw box to erased current face life
    ld   de, #CPCT_VMEM_START_ASM   ;; DE = Pointer to start of the screen
    ld    b, #02                    ;; B = y coordinate (02 = 0x02)
    ld    c, a                      ;; C = x coordinate 
    call cpct_getScreenPtr_asm      ;; Calculate video memory location and return it in HL

    ex de, hl
    ld a, #0x0C
    ld b, #2
    ld c, #5

    ;; CPCT_DRAWSOLIDBOX
    ;; (2B DE) memory	Video memory pointer to the upper left box corner byte
    ;; (1B A ) colour_pattern	1-byte colour pattern (in screen pixel format) to fill the box with
    ;; (1B C ) width	Box width in bytes [1-64] (Beware!  not in pixels!)
    ;; (1B B ) height	Box height in bytes (>0)
    call cpct_drawSolidBox_asm

    ret

man_gui_draw_active_bullet::
    ld a, (current_bullet_X)

    ld   de, #CPCT_VMEM_START_ASM   ;; DE = Pointer to start of the screen
    ld    b, #02                    ;; B = y coordinate (02 = 0x02)
    ld    c, a                      ;; C = x coordinate 
    call cpct_getScreenPtr_asm      ;; Calculate video memory location and return it in HL

    ex de, hl                       ;; Exchanges DE and HL
    ld hl, #_spr_background_bullet_active
    ld c, #2                        ;; Stores width of sprite in C
    ld b, #5                        ;; Stores height of sprite in B
    
    ;; CPCT_DRAWSPRITE_ASM
    ;;(2B HL) sprite	Source Sprite Pointer (array with pixel data)
    ;;(2B DE) memory	Destination video memory pointer
    ;;(1B C ) width	    Sprite Width in bytes [1-63] (Beware, not in pixels!)
    ;;(1B B ) height	Sprite Height in bytes (>0)
    call cpct_drawSprite_asm        ;; Draw the string

    ld a, (current_bullet_X)
    add #3
    ld (current_bullet_X), a
    ret

man_gui_draw_inactive_bullet::
    ld a, (current_bullet_X)

    ld a, (current_bullet_X)
    sub #3
    ld (current_bullet_X), a

    ld   de, #CPCT_VMEM_START_ASM   ;; DE = Pointer to start of the screen
    ld    b, #02                    ;; B = y coordinate (02 = 0x02)
    ld    c, a                      ;; C = x coordinate
    call cpct_getScreenPtr_asm      ;; Calculate video memory location and return it in HL

    ex de, hl                       ;; Exchanges DE and HL
    ld hl, #_spr_background_bullet_inactive
    ld c, #2                        ;; Stores width of sprite in C
    ld b, #5                        ;; Stores height of sprite in B
    
    ;; CPCT_DRAWSPRITE_ASM
    ;;(2B HL) sprite	Source Sprite Pointer (array with pixel data)
    ;;(2B DE) memory	Destination video memory pointer
    ;;(1B C ) width	    Sprite Width in bytes [1-63] (Beware, not in pixels!)
    ;;(1B B ) height	Sprite Height in bytes (>0)
    call cpct_drawSprite_asm        ;; Draw the string
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                     ;;
;;                        PUBLIC FUNCTIONS                             ;;
;;                                                                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAN_GUI_INIT                                                        ;;
;; Initializes GUI values, (score, lives, distance left)               ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_gui_init::

    ;; distance_init
    ld   de, #CPCT_VMEM_START_ASM   ;; DE = Pointer to start of the screen
    ld    b, #00                    ;; B = y coordinate (00 = 0x00)
    ld    c, #00                    ;; C = x coordinate (00 = 0x00)
    call cpct_getScreenPtr_asm      ;; Calculate video memory location and return it in HL

    ex de, hl
    ld a, #0x0C
    ld b, #9
    ld c, #64

    ;; CPCT_DRAWSOLIDBOX
    ;; (2B DE) memory	Video memory pointer to the upper left box corner byte
    ;; (1B A ) colour_pattern	1-byte colour pattern (in screen pixel format) to fill the box with
    ;; (1B C ) width	Box width in bytes [1-64] (Beware!  not in pixels!)
    ;; (1B B ) height	Box height in bytes (>0)
    call cpct_drawSolidBox_asm      

    ld de, #CPCT_VMEM_START_ASM
    ld b, #0
    ld c, #64
    call cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL

    ex de, hl
    ld a, #0x0C
    ld b, #9
    ld c, #16
    call cpct_drawSolidBox_asm

    ld   de, #CPCT_VMEM_START_ASM   ;; DE = Pointer to start of the screen
    ld    b, #190                   ;; B = y coordinate (190 = 0xBE)
    ld    c, #00                    ;; C = x coordinate (00 = 0x00)
    call cpct_getScreenPtr_asm      ;; Calculate video memory location and return it in HL

    ex de, hl
    ld a, #0x0C
    ld b, #10
    ld c, #64

    ;; CPCT_DRAWSOLIDBOX
    ;; (2B DE) memory	Video memory pointer to the upper left box corner byte
    ;; (1B A ) colour_pattern	1-byte colour pattern (in screen pixel format) to fill the box with
    ;; (1B C ) width	Box width in bytes [1-64] (Beware!  not in pixels!)
    ;; (1B B ) height	Box height in bytes (>0)
    call cpct_drawSolidBox_asm      

    ld de, #CPCT_VMEM_START_ASM
    ld b, #190
    ld c, #64
    call cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL

    ex de, hl
    ld a, #0x0C
    ld b, #10
    ld c, #16
    call cpct_drawSolidBox_asm

    ld de, #CPCT_VMEM_START_ASM
    ld b, #190
    ld c, #20
    call cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL

    ex de, hl                        ;; Exchanges DE and HL
    ld hl, #_spr_background_goal_metter
    ld c, #44                        ;; Stores width of sprite in C
    ld b, #10                        ;; Stores height of sprite in B

    ;; CPCT_DRAWSPRITE_ASM
    ;;(2B HL) sprite	Source Sprite Pointer (array with pixel data)
    ;;(2B DE) memory	Destination video memory pointer
    ;;(1B C ) width	    Sprite Width in bytes [1-63] (Beware, not in pixels!)
    ;;(1B B ) height	Sprite Height in bytes (>0)
    call cpct_drawSprite_asm         ;; Draws a sprite

    ld de, #CPCT_VMEM_START_ASM
    ld b, #190
    ld c, #20
    call cpct_getScreenPtr_asm      ;; Calculate video memory location and return it in HL

    ex de, hl                       ;; Exchanges DE and HL
    ld hl, #_spr_background_arrow
    ld c, #4                        ;; Stores width of sprite in C
    ld b, #9                        ;; Stores height of sprite in B
    call cpct_drawSprite_asm        ;; Draws a sprite

    ld a, #20
    ld (current_arrow_X), a

    ;; Icons of life
    ld a, #77
    ld (current_lives_pos_x), a
    ld a, (current_lives)
    ld (lives_cont), a

    loop_icons_life:
        call man_gui_draw_1_life
        ld a, (lives_cont)
        dec a
        ld (lives_cont), a
        jp nz, loop_icons_life

    ld a, #30
    ld (current_bullet_X), a

    call man_game_get_current_max_shots
    ld (bullets_cont), a

    loop_bullet_icons:
        call man_gui_draw_active_bullet
        ld a, (bullets_cont)
        dec a
        ld (bullets_cont), a
        jp nz, loop_bullet_icons

    ;; Score init

    ;; Set up draw char colours before calling draw string
    ld    h, #2         ;; D = Background PEN (2)
    ld    l, #3         ;; E = Foreground PEN (3)
    call cpct_setDrawCharM0_asm   ;; Set draw char colours

    ;; Calculate a video-memory location for printing a string
    ld   de, #CPCT_VMEM_START_ASM   ;; DE = Pointer to start of the screen
    ld    b, #01                    ;; B = y coordinate (01 = 0x01)
    ld    c, #02                    ;; C = x coordinate (02 = 0x02)
    call cpct_getScreenPtr_asm      ;; Calculate video memory location and return it in HL

    ld  (screen_pos_score), hl      ;; Pointer so we can get score_pos any time

    ;; Print the string in video memory
    ;; HL already points to video memory, as it is the return
    ;; value from cpct_getScreenPtr_asm
    ld   iy, #score_string          ;; IY = Pointer to the string 
    call cpct_drawStringM0_asm      ;; Draw the string

    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAN_GUI_SCORE_UPDATE                                                ;;
;; Increases current score in 10, draws again                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_gui_score_update::
    ld   ix, #score_string+3
    ld   b, #1
    update_score:
        ld   a, (ix)
        inc  a
        cp   #0x3A
        jp   nz, postUpdate_score
        inc  b
        ld   a, #0x30
        ld   (ix), a
        dec  ix
        jp   update_score
    
    postUpdate_score:
        ld   (ix), a
        
        ld a, b
        cp #3
        jp c, score_thousand_no_life_1_up
        call man_gui_lives_up
    
    score_thousand_no_life_1_up:
        ld   hl, (screen_pos_score)
        ld   iy, #score_string      ;; IY = Pointer to the string 
        call cpct_drawStringM0_asm  ;; Draw the string

    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAN_GUI_DISTANCE_UPDATE                                             ;;
;; Updates distance in interface, only draws if value is multiple of 10;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_gui_distance_update::
    ld a, (partial_distance_left)
    dec a
    ld (partial_distance_left), a

    jp nz, update_total_distance_left

    call man_game_get_current_level
    call man_level_get_level_data
    inc hl
    inc hl
    ld a, (hl)
    ld (partial_distance_left), a

    ld de, #CPCT_VMEM_START_ASM
    ld b, #190
    ld a, (current_arrow_X)
    ld c, a
    call cpct_getScreenPtr_asm      ;; Calculate video memory location and return it in HL

    ex de, hl
    ld a, #0x0C     ;; Azul GUI
    ld b, #9
    ld c, #8
    call cpct_drawSolidBox_asm

    ld a, (current_arrow_X)
    add #4
    ld (current_arrow_X), a

    ld de, #CPCT_VMEM_START_ASM
    ld b, #190
    ld a, (current_arrow_X)
    ld c, a
    call cpct_getScreenPtr_asm      ;; Calculate video memory location and return it in HL

    ex de, hl                        ;; Exchanges DE and HL
    ld hl, #_spr_background_arrow
    ld c, #4                         ;; Stores width of sprite in C
    ld b, #9                         ;; Stores height of sprite in B

    ;; CPCT_DRAWSPRITE_ASM
    ;;(2B HL) sprite	Source Sprite Pointer (array with pixel data)
    ;;(2B DE) memory	Destination video memory pointer
    ;;(1B C ) width	Sprite Width in bytes [1-63] (Beware, not in pixels!)
    ;;(1B B ) height	Sprite Height in bytes (>0)
    call cpct_drawSprite_asm        ;; Draws a sprite

update_total_distance_left:
    ld hl, (distance_left)
    dec hl
    ld (distance_left), hl

    ld bc, #0x0001

    sbc hl, bc

    jp nc, exit_distance_update

    ld a, #1
    call man_game_set_distance_reached

exit_distance_update:
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAN_GUI_LIVES_UP                                                    ;;
;; Increases lives number and redraws the info on screen               ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_gui_lives_up::
    ld a, (current_lives)
    cp #9
    ret z
    call man_gui_draw_1_life
    ld a, (current_lives)
    inc a
    ld (current_lives), a
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAN_GUI_LIVES_DOWN                                                  ;;
;; Decreases lives number and redraws the info on screen               ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_gui_lives_down::
    call man_gui_drawBox_1_life
    ld a, (current_lives)
    dec a
    ld (current_lives), a
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAN_GUI_GET_LIVES                                                   ;;
;; Returns current lives number stored in A                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_gui_get_lives::
    ld a, (current_lives)
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAN_GUI_RESET_LIVES                                                 ;;
;; Sets lives to initial value 5                                       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_gui_reset_lives::
    ld a, #5
    ld (current_lives), a
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAN_GUI_SET_NO_LIVES                                                ;;
;; Sets lives to 0 (finalizes the game)                                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_gui_set_no_lives::
    ld a, #0
    ld (current_lives), a
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAN_GUI_RESET_SCORE                                                 ;;
;; Sets score to 0                                                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_gui_reset_score::
    ld hl, #score_string
    ld (hl), #0x30
    ld d, h
    ld e, l
    inc de
    ld bc, #4
    ldir

    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAN_GUI_RESET_DISTANCE                                              ;;
;; Resets distance to default value                                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_gui_reset_distance:
    call man_game_get_current_level
    call man_level_get_level_data
    ld a, (hl)
    ld (distance_left), a
    inc hl
    ld a, (hl)
    ld hl, #distance_left
    inc hl
    ld (hl), a

    call man_game_get_current_level
    call man_level_get_level_data
    inc hl
    inc hl
    ld a, (hl)
    ld (partial_distance_left), a
    ret
    