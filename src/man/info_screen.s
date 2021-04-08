.include "info_screen.h.s"
.include "sys/render.h.s"
.include "cpctelera.h.s"

;;man_score:  .dw 0x0000
level_string:            .asciz "Mission 1"
defeat_boss_string:      .asciz "Final Mission                                  Defeat the evil army boss"
game_over_string:        .asciz "Game over"
score_final_string:      .asciz "Score 00000"
controls_string1:        .asciz "Controls:"
controls_string2:        .asciz "Q     -> Move Up"
controls_string3:        .asciz "A     -> Move Down"   
controls_string4:        .asciz "O     -> Move Right  Esc -> Exit level"  
controls_string5:        .asciz "P     -> Move Left     S -> Sound on/off"
controls_string6:        .asciz "Space -> Shoot         M -> Music on/off"
controls_string7:        .asciz "Story"
controls_string8:        .asciz "An evil army has taken control of the "
controls_string9:        .asciz "world, but your squad didn't care enough"
controls_string10:       .asciz "to do something. The army knows that "
controls_string11:       .asciz "your squad is the only one with power"
controls_string12:       .asciz "and skill enough to stop them, so they"
controls_string13:       .asciz "have kidnapped your mates. "
controls_string14:       .asciz "Now you care. Now it's personal."
controls_string15:       .asciz "Press 1 to go back"

raven_games_1:           .asciz "A game by Raven Games"
raven_games_2:           .asciz "Hector Mateo Pastor Perez"
hector_mail:             .asciz "Hmateo09@gmail.com"
raven_games_3:           .asciz "Alejandro Culianez Llorca"
alex_mail:               .asciz "Acllorca777@gmail.com"
raven_games_4:           .asciz "Antonio Gomez"
antonio_mail:            .asciz "afgm@alu.ua.es"
special_thanks:          .asciz "Special Thanks to:"
enrique_string:          .asciz "Enrique Morales Castello"
making_music:            .asciz "For making such awesome music"
thank_for_playing:       .asciz "Thank you for playing!"

screen_pos_level:       .dw 0x0000
screen_pos_game_over:   .dw 0x0000
screen_pos_final_score: .dw 0x0000

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                     ;;
;;                        PUBLIC FUNCTIONS                             ;;
;;                                                                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAN_INFO_SCREEN_RESET_LEVEL_COUNT                                   ;;
;; Resets the level info text to default ("Level 1")                   ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_info_screen_reset_level_count::
    ld ix, #level_string+8
    ld a, #0x31
    ld (ix), a
    ret
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAN_INFO_SCREEN_LEVEL                                               ;;
;; Shows current level text in screen                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_info_screen_level::
    ld a, #0
    call sys_render_clear_screen
    call man_info_screen_reset_level_count

    ;; Set up draw char colours before calling draw string
    ld    h, #0         ;; D = Background PEN (0)
    ld    l, #3         ;; E = Foreground PEN (3)
    call cpct_setDrawCharM0_asm   ;; Set draw char colours

    ;; Calculate a video-memory location for printing a string
    ld   de, #CPCT_VMEM_START_ASM               ;; DE = Pointer to start of the screen
    ld    b, #96                  ;; B = y coordinate (96 = 0x60)
    ld    c, #24                  ;; C = x coordinate (24 = 0x18)
    call cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL

    ld  (screen_pos_level), hl

    ;; Print the string in video memory
    ;; HL already points to video memory, as it is the return
    ;; value from cpct_getScreenPtr_asm
    ld   iy, #level_string      ;; IY = Pointer to the string 
    call cpct_drawStringM0_asm  ;; Draw the string

    ;; Wait for VSYNC before continuing loop
    
    xor a
    add #100
    ld d, a

    loop_mission_screen_timer:
        halt 
        halt
        call cpct_waitVSYNC_asm
        ld a, d
        dec a
        ld d, a
        jp nz, loop_mission_screen_timer

    xor a
    call sys_render_clear_screen

    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAN_INFO_SCREEN_GAME_OVER                                           ;;
;; Draws the game over text, shows final score                         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_info_screen_game_over::
    ld a, #0
    call sys_render_clear_screen

    ;; Set up draw char colours before calling draw string
    ld    h, #0         ;; D = Background PEN (0)
    ld    l, #3         ;; E = Foreground PEN (3)
    call cpct_setDrawCharM0_asm   ;; Set draw char colours
    
    ;; Calculate a video-memory location for printing a string
    ld   de, #CPCT_VMEM_START_ASM               ;; DE = Pointer to start of the screen
    ld    b, #90                  ;; B = y coordinate (90 = 0x5A)
    ld    c, #22                  ;; C = x coordinate (22 = 0x16)
    call cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL

    ld  (screen_pos_game_over), hl

    ;; Print the string in video memory
    ;; HL already points to video memory, as it is the return
    ;; value from cpct_getScreenPtr_asm
    ld   iy, #game_over_string    ;; IY = Pointer to the string 
    call cpct_drawStringM0_asm    ;; Draw the string

    ;; Copy score of GUI to final score
    ld hl, #score_string            ;; Score GUI
    ld de, #score_final_string+6    ;; Final score
    ld bc, #4                       ;; Repeat operations

    ldir

    ld   de, #CPCT_VMEM_START_ASM               ;; DE = Pointer to start of the screen
    ld    b, #104                 ;; B = y coordinate (98 = 0x68)
    ld    c, #18                  ;; C = x coordinate (21 = 0x12)
    call cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL

    ld  (screen_pos_final_score), hl

    ;; Print the string in video memory
    ;; HL already points to video memory, as it is the return
    ;; value from cpct_getScreenPtr_asm
    ld   iy, #score_final_string  ;; IY = Pointer to the string 
    call cpct_drawStringM0_asm    ;; Draw the string

    ;; Wait for VSYNC before continuing loop
    xor a
    add #200

    ld d, a

    loop_game_over_timer:
        halt 
        halt
        call cpct_waitVSYNC_asm
        ld a, d
        dec a
        ld d, a
        jp nz, loop_game_over_timer

    xor a
    call sys_render_clear_screen

    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAN_INFO_SCREEN_LEVEL_UPDATE                                        ;;
;; Increases current level text in 1, draws it on screen               ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_info_screen_level_update::
    xor a
    call sys_render_clear_screen

    ;; Set up draw char colours before calling draw string
    ld    h, #0         ;; D = Background PEN (0)
    ld    l, #3         ;; E = Foreground PEN (3)
    call cpct_setDrawCharM0_asm   ;; Set draw char colours

    ld   ix, #level_string+8
    ld   hl, (screen_pos_level)
update_level:
    ld   a, (ix)
    inc  a
    cp   #0x3A
    jp   nz, normal_level
    ld a, #0
    call sys_render_clear_screen
    ret
    jp post_draw_level
normal_level:
    ld   (ix), a
    ld   iy, #level_string      ;; IY = Pointer to the string 
    call cpct_drawStringM0_asm  ;; Draw the string
post_draw_level:
    ; Wait for VSYNC before continuing loop
    xor a
    add #100

    ld d, a

    loop_level_update_timer:
        halt 
        halt
        call cpct_waitVSYNC_asm
        ld a, d
        dec a
        ld d, a
        jp nz, loop_level_update_timer

    ld a, #0
    call sys_render_clear_screen

    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAN_INFO_SCREEN_HELP                                                ;;
;; Shows the info screen (controls, objective of the game)             ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_info_screen_help::
    ld a, #0xFF
    call sys_render_clear_screen

    ld  c, #1                       ;; Loads 0 in C
    call cpct_setVideoMode_asm      ;; Sets video mode to value in C

    ld e, #0
    ld d, #3
    call cpct_setDrawCharM1_asm

    ;; Calculate a video-memory location for printing a string
    ld   de, #CPCT_VMEM_START_ASM ;; DE = Pointer to start of the screen
    ld    b, #8                   ;; B = y coordinate (90 = 0x5A)
    ld    c, #0                   ;; C = x coordinate (22 = 0x16)
    call cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL

    ;; Print the string in video memory
    ;; HL already points to video memory, as it is the return
    ;; value from cpct_getScreenPtr_asm
    ld   e, l
    ld   d, h
    ld   hl, #controls_string1    ;; Pointer to the string 
    ld   c, #0
    ld   b, #3
    call cpct_drawStringM1_f_asm

    ;; Calculate a video-memory location for printing a string
    ld   de, #CPCT_VMEM_START_ASM  ;; DE = Pointer to start of the screen
    ld    b, #28                   ;; B = y coordinate (90 = 0x5A)
    ld    c, #0                    ;; C = x coordinate (22 = 0x16)
    call cpct_getScreenPtr_asm     ;; Calculate video memory location and return it in HL


    ;; Print the string in video memory
    ;; HL already points to video memory, as it is the return
    ;; value from cpct_getScreenPtr_asm
    ld   iy, #controls_string2    ;; IY = Pointer to the string 
    call cpct_drawStringM1_asm    ;; Draw the string

    ;; Calculate a video-memory location for printing a string
    ld   de, #CPCT_VMEM_START_ASM  ;; DE = Pointer to start of the screen
    ld    b, #38                   ;; B = y coordinate (90 = 0x5A)
    ld    c, #0                    ;; C = x coordinate (22 = 0x16)
    call cpct_getScreenPtr_asm     ;; Calculate video memory location and return it in HL

    ;; Print the string in video memory
    ;; HL already points to video memory, as it is the return
    ;; value from cpct_getScreenPtr_asm
    ld   iy, #controls_string3    ;; IY = Pointer to the string 
    call cpct_drawStringM1_asm    ;; Draw the string

    ;; Calculate a video-memory location for printing a string
    ld   de, #CPCT_VMEM_START_ASM               ;; DE = Pointer to start of the screen
    ld    b, #48                  ;; B = y coordinate (90 = 0x5A)
    ld    c, #0                   ;; C = x coordinate (22 = 0x16)
    call cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL

    ;; Print the string in video memory
    ;; HL already points to video memory, as it is the return
    ;; value from cpct_getScreenPtr_asm
    ld   iy, #controls_string4    ;; IY = Pointer to the string 
    call cpct_drawStringM1_asm    ;; Draw the string

    ;; Calculate a video-memory location for printing a string
    ld   de, #CPCT_VMEM_START_ASM               ;; DE = Pointer to start of the screen
    ld    b, #58                  ;; B = y coordinate (90 = 0x5A)
    ld    c, #0                   ;; C = x coordinate (22 = 0x16)
    call cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL

    ;; Print the string in video memory
    ;; HL already points to video memory, as it is the return
    ;; value from cpct_getScreenPtr_asm
    ld   iy, #controls_string5    ;; IY = Pointer to the string 
    call cpct_drawStringM1_asm    ;; Draw the string

    ;; Calculate a video-memory location for printing a string
    ld   de, #CPCT_VMEM_START_ASM               ;; DE = Pointer to start of the screen
    ld    b, #68                  ;; B = y coordinate (90 = 0x5A)
    ld    c, #0                   ;; C = x coordinate (22 = 0x16)
    call cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL

    ;; Print the string in video memory
    ;; HL already points to video memory, as it is the return
    ;; value from cpct_getScreenPtr_asm
    ld   iy, #controls_string6    ;; IY = Pointer to the string 
    call cpct_drawStringM1_asm    ;; Draw the string

    ;; Calculate a video-memory location for printing a string
    ld   de, #CPCT_VMEM_START_ASM               ;; DE = Pointer to start of the screen
    ld    b, #78                  ;; B = y coordinate (90 = 0x5A)
    ld    c, #35                   ;; C = x coordinate (22 = 0x16)
    call cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL

    ;; Print the string in video memory
    ;; HL already points to video memory, as it is the return
    ;; value from cpct_getScreenPtr_asm
    ld   e, l
    ld   d, h
    ld   hl, #controls_string7    ;; IY = Pointer to the string 
    ld   c, #0
    ld   b, #3
    call cpct_drawStringM1_f_asm

    ;; Calculate a video-memory location for printing a string
    ld   de, #CPCT_VMEM_START_ASM               ;; DE = Pointer to start of the screen
    ld    b, #98                  ;; B = y coordinate (90 = 0x5A)
    ld    c, #0                   ;; C = x coordinate (22 = 0x16)
    call cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL

    ;; Print the string in video memory
    ;; HL already points to video memory, as it is the return
    ;; value from cpct_getScreenPtr_asm
    ld   iy, #controls_string8    ;; IY = Pointer to the string 
    call cpct_drawStringM1_asm    ;; Draw the string

    ;; Calculate a video-memory location for printing a string
    ld   de, #CPCT_VMEM_START_ASM               ;; DE = Pointer to start of the screen
    ld    b, #108                 ;; B = y coordinate (90 = 0x5A)
    ld    c, #0                   ;; C = x coordinate (22 = 0x16)
    call cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL

    ;; Print the string in video memory
    ;; HL already points to video memory, as it is the return
    ;; value from cpct_getScreenPtr_asm
    ld   iy, #controls_string9    ;; IY = Pointer to the string 
    call cpct_drawStringM1_asm    ;; Draw the string

    ;; Calculate a video-memory location for printing a string
    ld   de, #CPCT_VMEM_START_ASM               ;; DE = Pointer to start of the screen
    ld    b, #118                 ;; B = y coordinate (90 = 0x5A)
    ld    c, #0                   ;; C = x coordinate (22 = 0x16)
    call cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL

    ;; Print the string in video memory
    ;; HL already points to video memory, as it is the return
    ;; value from cpct_getScreenPtr_asm
    ld   iy, #controls_string10   ;; IY = Pointer to the string 
    call cpct_drawStringM1_asm    ;; Draw the string
    
    ;; Calculate a video-memory location for printing a string
    ld   de, #CPCT_VMEM_START_ASM               ;; DE = Pointer to start of the screen
    ld    b, #128                 ;; B = y coordinate (90 = 0x5A)
    ld    c, #0                   ;; C = x coordinate (22 = 0x16)
    call cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL

    ;; Print the string in video memory
    ;; HL already points to video memory, as it is the return
    ;; value from cpct_getScreenPtr_asm
    ld   iy, #controls_string11   ;; IY = Pointer to the string 
    call cpct_drawStringM1_asm    ;; Draw the string

    ;; Calculate a video-memory location for printing a string
    ld   de, #CPCT_VMEM_START_ASM               ;; DE = Pointer to start of the screen
    ld    b, #138                 ;; B = y coordinate (90 = 0x5A)
    ld    c, #0                   ;; C = x coordinate (22 = 0x16)
    call cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL

    ;; Print the string in video memory
    ;; HL already points to video memory, as it is the return
    ;; value from cpct_getScreenPtr_asm
    ld   iy, #controls_string12   ;; IY = Pointer to the string 
    call cpct_drawStringM1_asm    ;; Draw the string

    ;; Calculate a video-memory location for printing a string
    ld   de, #CPCT_VMEM_START_ASM               ;; DE = Pointer to start of the screen
    ld    b, #148                 ;; B = y coordinate (90 = 0x5A)
    ld    c, #0                   ;; C = x coordinate (22 = 0x16)
    call cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL

    ;; Print the string in video memory
    ;; HL already points to video memory, as it is the return
    ;; value from cpct_getScreenPtr_asm
    ld   iy, #controls_string13   ;; IY = Pointer to the string 
    call cpct_drawStringM1_asm    ;; Draw the string

    ;; Calculate a video-memory location for printing a string
    ld   de, #CPCT_VMEM_START_ASM               ;; DE = Pointer to start of the screen
    ld    b, #168                 ;; B = y coordinate (90 = 0x5A)
    ld    c, #0                   ;; C = x coordinate (22 = 0x16)
    call cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL

    ;; Print the string in video memory
    ;; HL already points to video memory, as it is the return
    ;; value from cpct_getScreenPtr_asm
    ld   iy, #controls_string14   ;; IY = Pointer to the string 
    call cpct_drawStringM1_asm    ;; Draw the string

    ;; Calculate a video-memory location for printing a string
    ld   de, #CPCT_VMEM_START_ASM               ;; DE = Pointer to start of the screen
    ld    b, #188                 ;; B = y coordinate (90 = 0x5A)
    ld    c, #20                  ;; C = x coordinate (22 = 0x16)
    call cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL

    ;; Print the string in video memory
    ;; HL already points to video memory, as it is the return
    ;; value from cpct_getScreenPtr_asm
    ld   e, l
    ld   d, h
    ld   hl, #controls_string15    ;; Pointer to the string 
    ld   c, #0
    ld   b, #3
    call cpct_drawStringM1_f_asm

    menu_loop:
    call cpct_akp_musicPlay_asm
    call cpct_waitVSYNC_asm
    call sys_input_check_menu_key
    or  a
    jr  z, menu_loop

    ld a, #0XCC
    call sys_render_clear_screen
    halt 
    halt
    call cpct_waitVSYNC_asm

    ld  c, #0                       ;; Loads 0 in C
    call cpct_setVideoMode_asm      ;; Sets video mode to value in C

    ret

man_info_screen_credits::
    ld  c, #1                       ;; Loads 0 in C
    call cpct_setVideoMode_asm      ;; Sets video mode to value in C

    ld a, #0xFF
    call sys_render_clear_screen

    ld e, #0
    ld d, #3
    call cpct_setDrawCharM1_asm
    
    ;; Calculate a video-memory location for printing a string
    ld   de, #CPCT_VMEM_START_ASM ;; DE = Pointer to start of the screen
    ld    b, #8                   ;; B = y coordinate (90 = 0x5A)
    ld    c, #19                  ;; C = x coordinate (22 = 0x16)
    call cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL

    ld   iy, #raven_games_1       ;; IY = Pointer to the string 
    call cpct_drawStringM1_asm    ;; Draw the string
    
    ;; Calculate a video-memory location for printing a string
    ld   de, #CPCT_VMEM_START_ASM ;; DE = Pointer to start of the screen
    ld    b, #28                  ;; B = y coordinate (90 = 0x5A)
    ld    c, #15                  ;; C = x coordinate (22 = 0x16)
    call cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL

    ld   iy, #raven_games_2       ;; IY = Pointer to the string 
    call cpct_drawStringM1_asm    ;; Draw the string
    
    ;; Calculate a video-memory location for printing a string
    ld   de, #CPCT_VMEM_START_ASM ;; DE = Pointer to start of the screen
    ld    b, #38                  ;; B = y coordinate (90 = 0x5A)
    ld    c, #21                  ;; C = x coordinate (22 = 0x16)
    call cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL

    ld   iy, #hector_mail         ;; IY = Pointer to the string 
    call cpct_drawStringM1_asm    ;; Draw the string

    ;; Calculate a video-memory location for printing a string
    ld   de, #CPCT_VMEM_START_ASM ;; DE = Pointer to start of the screen
    ld    b, #58                  ;; B = y coordinate (90 = 0x5A)
    ld    c, #15                  ;; C = x coordinate (22 = 0x16)
    call cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL

    ld   iy, #raven_games_3       ;; IY = Pointer to the string 
    call cpct_drawStringM1_asm    ;; Draw the string
    
    ;; Calculate a video-memory location for printing a string
    ld   de, #CPCT_VMEM_START_ASM ;; DE = Pointer to start of the screen
    ld    b, #68                  ;; B = y coordinate (90 = 0x5A)
    ld    c, #18                  ;; C = x coordinate (22 = 0x16)
    call cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL

    ld   iy, #alex_mail           ;; IY = Pointer to the string 
    call cpct_drawStringM1_asm    ;; Draw the string

    ;; Calculate a video-memory location for printing a string
    ld   de, #CPCT_VMEM_START_ASM ;; DE = Pointer to start of the screen
    ld    b, #88                  ;; B = y coordinate (90 = 0x5A)
    ld    c, #25                  ;; C = x coordinate (22 = 0x16)
    call cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL

    ld   iy, #raven_games_4       ;; IY = Pointer to the string 
    call cpct_drawStringM1_asm    ;; Draw the string

    ;; Calculate a video-memory location for printing a string
    ld   de, #CPCT_VMEM_START_ASM ;; DE = Pointer to start of the screen
    ld    b, #98                  ;; B = y coordinate (90 = 0x5A)
    ld    c, #24                  ;; C = x coordinate (22 = 0x16)
    call cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL

    ld   iy, #antonio_mail       ;; IY = Pointer to the string 
    call cpct_drawStringM1_asm    ;; Draw the string

    ;; Calculate a video-memory location for printing a string
    ld   de, #CPCT_VMEM_START_ASM ;; DE = Pointer to start of the screen
    ld    b, #120                 ;; B = y coordinate (90 = 0x5A)
    ld    c, #20                   ;; C = x coordinate (22 = 0x16)
    call cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL

    ld   iy, #special_thanks      ;; IY = Pointer to the string 
    call cpct_drawStringM1_asm    ;; Draw the string


    ;; Calculate a video-memory location for printing a string
    ld   de, #CPCT_VMEM_START_ASM ;; DE = Pointer to start of the screen
    ld    b, #130                 ;; B = y coordinate (90 = 0x5A)
    ld    c, #15                  ;; C = x coordinate (22 = 0x16)
    call cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL

    ld   iy, #enrique_string      ;; IY = Pointer to the string 
    call cpct_drawStringM1_asm    ;; Draw the string
    ;; Calculate a video-memory location for printing a string
    ld   de, #CPCT_VMEM_START_ASM ;; DE = Pointer to start of the screen
    ld    b, #140                 ;; B = y coordinate (90 = 0x5A)
    ld    c, #10                   ;; C = x coordinate (22 = 0x16)
    call cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL

    ld   iy, #making_music        ;; IY = Pointer to the string 
    call cpct_drawStringM1_asm    ;; Draw the string

    ;; Calculate a video-memory location for printing a string
    ld   de, #CPCT_VMEM_START_ASM ;; DE = Pointer to start of the screen
    ld    b, #180                 ;; B = y coordinate (90 = 0x5A)
    ld    c, #18                   ;; C = x coordinate (22 = 0x16)
    call cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL

    ld   iy, #thank_for_playing   ;; IY = Pointer to the string 
    call cpct_drawStringM1_asm    ;; Draw the string

    ld de, #_msc_menu_theme
    call cpct_akp_musicInit_asm

    ld d, #7
    extern_loop_timer_end_game_image:
        push de
        xor a
        add #240

        loop_timer_end_game_image:
            call cpct_akp_musicPlay_asm
            halt 
            halt
            call cpct_waitVSYNC_asm
            ld a, (animation_counter)
            dec a
            ld (animation_counter), a
            jp nz, loop_timer_end_game_image
        pop de
        ld a, d
        dec a
        ld d, a
        jp nz, extern_loop_timer_end_game_image

    ld  c, #0                       ;; Loads 0 in C
    call cpct_setVideoMode_asm      ;; Sets video mode to value in C
    ret