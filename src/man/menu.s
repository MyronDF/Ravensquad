.include "info_screen.h.s"
.include "sys/render.h.s"
.include "sys/input.h.s"
.include "cpctelera.h.s"

menu_string:            .asciz "Sample Menu"
menu_start_string:      .asciz "Press 1 to start"
menu_show_tutorial:     .asciz "Press 2 to show help"
menu_music_playing:     .db 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                     ;;
;;                        PUBLIC FUNCTIONS                             ;;
;;                                                                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAN_MENU_INIT                                                       ;;
;; Initializes the menu                                                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_menu_init::
    ld a, (menu_music_playing)
    or a
    jp nz, post_music_initialization

    call man_game_initial_game_values
    ld de, #_msc_menu_theme
    call cpct_akp_musicInit_asm

    xor a
    inc a
    ld (menu_music_playing), a

post_music_initialization:

    call sys_render_set_border_and_palette_black
    ld a, #0xCC
    call sys_render_clear_screen

    ;; Calculate a video-memory location for printing a string
    ld   de, #CPCT_VMEM_START_ASM               ;; DE = Pointer to start of the screen
    ld    b, #0                ;; B = y coordinate (100 = 0x64)
    ld    c, #8                  ;; C = x coordinate (08  = 0x08)
    call cpct_getScreenPtr_asm   ;; Calculate video memory location and return it in HL

    ;; CPCT_GETSCREENPTR_ASM
    ;; (2B DE) screen_start	Pointer to the start of the screen (or a backbuffer)
    ;; (1B C ) x	[0-79] Byte-aligned column starting from 0 (x coordinate,
    ;; (1B B ) y	[0-199] row starting from 0 (y coordinate) in bytes)
    ;; Returns video mem address in HL
    call cpct_getScreenPtr_asm

    ld hl, #_main_menu_screen_end
    ld de, #0xFFFF
    call cpct_zx7b_decrunch_s_asm
    
    ;; CPCT_DRAWSPRITE_ASM
    ;;(2B HL) sprite	Source Sprite Pointer (array with pixel data)
    ;;(2B DE) memory	Destination video memory pointer
    ;;(1B C ) width	Sprite Width in bytes [1-63] (Beware, not in pixels!)
    ;;(1B B ) height	Sprite Height in bytes (>0)
    call cpct_drawSprite_asm        ;; Draws a sprite
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                     ;;
;;                        PUBLIC FUNCTIONS                             ;;
;;                                                                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAN_MENU_UPDATE                                                     ;;
;; Updates menu screen, checks for keys pressed and shows help or ends ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_menu_update::
    menu_loop:
    call cpct_akp_musicPlay_asm
    call cpct_waitVSYNC_asm
    call sys_input_check_menu_key
    or  a
    jr  z, menu_loop

    push af
    call cpct_akp_stop_asm          ;;Stop sound
    pop af

    cp #2
    jr c, startGame 
        call man_info_screen_help
        call man_menu_init
    jp menu_loop

    startGame:
    call sys_render_set_border_and_palette_yellow
    xor a
    call sys_render_clear_screen

    xor a
    ld (menu_music_playing), a
    ret