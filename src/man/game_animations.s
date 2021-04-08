.include "game_animations.h.s"
.include "man/entities.h.s"
.include "sys/animations.h.s"

saved_ally_string::          .asciz "You saved your"        ;; String score
friend_string::              .asciz "friend, but there"
theres_more_string::         .asciz "are more of them "
captured_string::            .asciz "still captured"

gave_you_string::            .asciz "He also gave you"
expanded_string::            .asciz "an expanded pistol" 
magazine_string::            .asciz "magazine, you can"
shoot_more_string::          .asciz "now shoot more."

end_game_string::            .asciz "The evil army has"
end_game_string_2::          .asciz "been defeated, the"
end_game_string_3::          .asciz "world is safe, and"
end_game_string_4::          .asciz "your friends are"
end_game_string_5::          .asciz "free."
end_game_string_6::          .asciz "Congratulations!"

animation_counter::          .db 0

man_game_animations_get_current_level_ally:
    ld hl, #background_captured_ally_tmpl
    call man_entity_create_entity

    call man_game_get_current_level

    dec a

    cp #1
    jp nz, check_second_level
    ld hl, #_spr_background_captured_ally
    ld e_sprite_h(ix), h
    ld e_sprite_l(ix), l
    ld e_w(ix), #4
    ld e_h(ix), #16
    ret
    check_second_level:
    cp #2
    jp nz, check_third_level
    ld hl, #_spr_background_captured_ally_2
    ld e_sprite_h(ix), h
    ld e_sprite_l(ix), l
    ld e_w(ix), #3
    ld e_h(ix), #14
    ret
    check_third_level:
    cp #4
    jp nz, check_fourth_level
    ld hl, #_spr_background_captured_ally_3
    ld e_sprite_h(ix), h
    ld e_sprite_l(ix), l
    ld e_w(ix), #8
    ld e_h(ix), #16
    ret
    check_fourth_level:
    cp #5
    jp nz, check_fifth_level
    ld hl, #_spr_background_captured_ally_4
    ld e_sprite_h(ix), h
    ld e_sprite_l(ix), l
    ld e_w(ix), #7
    ld e_h(ix), #22
    ret
    check_fifth_level:
    cp #6
    ld hl, #_spr_background_captured_ally_5
    ld e_sprite_h(ix), h
    ld e_sprite_l(ix), l
    ld e_w(ix), #8
    ld e_h(ix), #6
    ld a, e_y(ix)
    add #8
    ld e_y(ix), a
    ret

man_game_animation_play::
    ld de, #_msc_level_ended
    call cpct_akp_musicInit_asm

    call man_game_get_current_level
    cp #4
    ret z
    cp #8
    ret z
    cp #10
    ret z
    cp #11
    ret z

    call man_game_increase_current_shots
    call sys_render_set_palette_gray_and_clean_screen

    ;; Set up draw char colours before calling draw string
    ld    h, #0         ;; D = Background PEN (0)
    ld    l, #3         ;; E = Foreground PEN (3)
    call cpct_setDrawCharM0_asm   ;; Set draw char colours

    ld   de, #0xC000                ;; DE = Pointer to start of the screen
    ld    b, #10                    ;; B = y coordinate (00 = 0x00)
    ld    c, #12                    ;; C = x coordinate (00 = 0x00)
    call cpct_getScreenPtr_asm      ;; Calculate video memory location and return it in HL

    ld   iy, #saved_ally_string     ;; IY = Pointer to the string 
    call cpct_drawStringM0_asm      ;; Draw the string

    ld   de, #0xC000                ;; DE = Pointer to start of the screen
    ld    b, #20                    ;; B = y coordinate (00 = 0x00)
    ld    c, #06                    ;; C = x coordinate (00 = 0x00)
    call cpct_getScreenPtr_asm      ;; Calculate video memory location and return it in HL

    ld   iy, #friend_string         ;; IY = Pointer to the string 
    call cpct_drawStringM0_asm      ;; Draw the string

    ld   de, #0xC000                ;; DE = Pointer to start of the screen
    ld    b, #30                    ;; B = y coordinate (00 = 0x00)
    ld    c, #08                    ;; C = x coordinate (00 = 0x00)
    call cpct_getScreenPtr_asm      ;; Calculate video memory location and return it in HL

    ld   iy, #theres_more_string     ;; IY = Pointer to the string 
    call cpct_drawStringM0_asm      ;; Draw the string

    call cpct_drawStringM0_asm      ;; Draw the string
    ld   de, #0xC000                ;; DE = Pointer to start of the screen
    ld    b, #40                    ;; B = y coordinate (00 = 0x00)
    ld    c, #12                    ;; C = x coordinate (00 = 0x00)
    call cpct_getScreenPtr_asm      ;; Calculate video memory location and return it in HL

    ld   iy, #captured_string       ;; IY = Pointer to the string 
    call cpct_drawStringM0_asm      ;; Draw the string

    ld   de, #0xC000                ;; DE = Pointer to start of the screen
    ld    b, #130                   ;; B = y coordinate (00 = 0x00)
    ld    c, #8                     ;; C = x coordinate (00 = 0x00)
    call cpct_getScreenPtr_asm      ;; Calculate video memory location and return it in HL

    ld   iy, #gave_you_string       ;; IY = Pointer to the string 
    call cpct_drawStringM0_asm      ;; Draw the string

    ld   de, #0xC000                ;; DE = Pointer to start of the screen
    ld    b, #140                   ;; B = y coordinate (00 = 0x00)
    ld    c, #4                     ;; C = x coordinate (00 = 0x00)
    call cpct_getScreenPtr_asm      ;; Calculate video memory location and return it in HL

    ld   iy, #expanded_string       ;; IY = Pointer to the string 
    call cpct_drawStringM0_asm      ;; Draw the string

    ld   de, #0xC000                ;; DE = Pointer to start of the screen
    ld    b, #150                   ;; B = y coordinate (00 = 0x00)
    ld    c, #6                     ;; C = x coordinate (00 = 0x00)
    call cpct_getScreenPtr_asm      ;; Calculate video memory location and return it in HL

    ld   iy, #magazine_string       ;; IY = Pointer to the string 
    call cpct_drawStringM0_asm      ;; Draw the string

    ld   de, #0xC000                ;; DE = Pointer to start of the screen
    ld    b, #160                   ;; B = y coordinate (00 = 0x00)
    ld    c, #8                     ;; C = x coordinate (00 = 0x00)
    call cpct_getScreenPtr_asm      ;; Calculate video memory location and return it in HL

    ld   iy, #shoot_more_string     ;; IY = Pointer to the string 
    call cpct_drawStringM0_asm      ;; Draw the string

    call man_game_animations_get_current_level_ally

    ld a, #65
    ld e_x(ix), a
    ;;ld a, #95
    ;;ld e_y(ix), a

    ld de, #0xC000
    ld c, e_x(ix)
    ld b, e_y(ix)
    
    call cpct_getScreenPtr_asm    

    ex de, hl                        ;; Exchanges DE and HL
    ld l, e_sprite(ix)               ;; Stores first byte of pointer to sprite in H
    ld h, e_sprite+1(ix)             ;; Stores second byte of pointer to sprite in L
    ld c, e_w(ix)                    ;; Stores width of sprite in C
    ld b, e_h(ix)                    ;; Stores height of sprite in B

    call cpct_drawSprite_asm

    xor a
    ld e_type(ix), a

    ld hl, #player_tmpl                       ;; Loads default values direction in HL
    call man_entity_create_entity             ;; Creates test sprite

    ld a, #1
    ld e_vx(ix), a
    xor a
    ld e_x(ix), a

    ld a, #e_state_moving
    ld e_state(ix), a

    end_level_animation_loop:
        ld a, e_x(ix)
        add e_vx(ix)
        ld e_x(ix), a

        ld de, #0xC000
        ld c, e_x(ix)
        ld b, e_y(ix)
        
        call cpct_getScreenPtr_asm    

        ex de, hl                        ;; Exchanges DE and HL
        ld l, e_sprite(ix)               ;; Stores first byte of pointer to sprite in H
        ld h, e_sprite+1(ix)             ;; Stores second byte of pointer to sprite in L
        ld c, e_w(ix)                    ;; Stores width of sprite in C
        ld b, e_h(ix)                    ;; Stores height of sprite in B

        call cpct_drawSprite_asm

        .rept 4
            call cpct_akp_musicPlay_asm
            halt 
            halt
            call cpct_waitVSYNC_asm
        .endm

        call _sys_animations_update_one_entity

        ld a, e_x(ix)
        cp #58

        jp c, end_level_animation_loop

        xor a
        ld e_type(ix), a

        call sys_render_set_border_and_palette_yellow
        call cpct_akp_stop_asm


        ld hl, #_end_level_scr_end      ;;Load end level screen
        ld de, #0xFFFF
        call cpct_zx7b_decrunch_s_asm

        xor a
        add #100
        ld d, a

        loop_timer_end_level_image:
            halt 
            halt
            call cpct_waitVSYNC_asm
            ld a, d
            dec a
            ld d, a
            jp nz, loop_timer_end_level_image

        ld    h, #0         ;; D = Background PEN (0)
        ld    l, #3         ;; E = Foreground PEN (3)
        call cpct_setDrawCharM0_asm   ;; Set draw char colours

        ret

        
man_game_end_game_animation_play::
    ld de, #_msc_menu_theme
    call cpct_akp_musicInit_asm

    call sys_render_set_border_and_palette_yellow
    xor a
    call sys_render_clear_screen

    ;; Set up draw char colours before calling draw string
    ld    h, #0         ;; D = Background PEN (0)
    ld    l, #3         ;; E = Foreground PEN (3)
    call cpct_setDrawCharM0_asm   ;; Set draw char colours

    ld   de, #0xC000                ;; DE = Pointer to start of the screen
    ld    b, #10                    ;; B = y coordinate (00 = 0x00)
    ld    c, #4                     ;; C = x coordinate (00 = 0x00)
    call cpct_getScreenPtr_asm      ;; Calculate video memory location and return it in HL

    ld   iy, #end_game_string       ;; IY = Pointer to the string 
    call cpct_drawStringM0_asm      ;; Draw the string
    
    ;; Set up draw char colours before calling draw string
    ld    h, #0         ;; D = Background PEN (0)
    ld    l, #3         ;; E = Foreground PEN (3)
    call cpct_setDrawCharM0_asm   ;; Set draw char colours

    ld   de, #0xC000                ;; DE = Pointer to start of the screen
    ld    b, #20                    ;; B = y coordinate (00 = 0x00)
    ld    c, #4                     ;; C = x coordinate (00 = 0x00)
    call cpct_getScreenPtr_asm      ;; Calculate video memory location and return it in HL

    ld   iy, #end_game_string_2     ;; IY = Pointer to the string 
    call cpct_drawStringM0_asm      ;; Draw the string
    
    ;; Set up draw char colours before calling draw string
    ld    h, #0         ;; D = Background PEN (0)
    ld    l, #3         ;; E = Foreground PEN (3)
    call cpct_setDrawCharM0_asm   ;; Set draw char colours

    ld   de, #0xC000                ;; DE = Pointer to start of the screen
    ld    b, #30                    ;; B = y coordinate (00 = 0x00)
    ld    c, #4                     ;; C = x coordinate (00 = 0x00)
    call cpct_getScreenPtr_asm      ;; Calculate video memory location and return it in HL

    ld   iy, #end_game_string_3     ;; IY = Pointer to the string 
    call cpct_drawStringM0_asm      ;; Draw the string
    
    ;; Set up draw char colours before calling draw string
    ld    h, #0         ;; D = Background PEN (0)
    ld    l, #3         ;; E = Foreground PEN (3)
    call cpct_setDrawCharM0_asm   ;; Set draw char colours

    ld   de, #0xC000                ;; DE = Pointer to start of the screen
    ld    b, #40                    ;; B = y coordinate (00 = 0x00)
    ld    c, #4                     ;; C = x coordinate (00 = 0x00)
    call cpct_getScreenPtr_asm      ;; Calculate video memory location and return it in HL

    ld   iy, #end_game_string_4     ;; IY = Pointer to the string 
    call cpct_drawStringM0_asm      ;; Draw the string
    
    ;; Set up draw char colours before calling draw string
    ld    h, #0         ;; D = Background PEN (0)
    ld    l, #3         ;; E = Foreground PEN (3)
    call cpct_setDrawCharM0_asm   ;; Set draw char colours

    ld   de, #0xC000                ;; DE = Pointer to start of the screen
    ld    b, #50                    ;; B = y coordinate (00 = 0x00)
    ld    c, #4                     ;; C = x coordinate (00 = 0x00)
    call cpct_getScreenPtr_asm      ;; Calculate video memory location and return it in HL

    ld   iy, #end_game_string_5     ;; IY = Pointer to the string 
    call cpct_drawStringM0_asm      ;; Draw the string

    ld   de, #0xC000                ;; DE = Pointer to start of the screen
    ld    b, #170                   ;; B = y coordinate (00 = 0x00)
    ld    c, #8                    ;; C = x coordinate (00 = 0x00)
    call cpct_getScreenPtr_asm      ;; Calculate video memory location and return it in HL

    ld   iy, #end_game_string_6     ;; IY = Pointer to the string 
    call cpct_drawStringM0_asm      ;; Draw the string

    ld hl, #player_tmpl                       ;; Loads default values direction in HL
    call man_entity_create_entity             ;; Creates test sprite

    ld e_x(ix), #36
    ld e_y(ix), #94

    ld a, #e_state_moving
    ld e_state(ix), a

    ld d, #7
    extern_loop_timer_end_game_image:
        push de
        xor a
        add #240
        ld (animation_counter), a

        loop_timer_end_game_image:
            ld de, #0xC000
            ld c, e_x(ix)
            ld b, e_y(ix)
            
            call cpct_getScreenPtr_asm    

            ex de, hl                        ;; Exchanges DE and HL
            ld l, e_sprite(ix)               ;; Stores first byte of pointer to sprite in H
            ld h, e_sprite+1(ix)             ;; Stores second byte of pointer to sprite in L
            ld c, e_w(ix)                    ;; Stores width of sprite in C
            ld b, e_h(ix)                    ;; Stores height of sprite in B

            call cpct_drawSprite_asm
            call _sys_animations_update_one_entity
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

    call man_info_screen_credits

    ret