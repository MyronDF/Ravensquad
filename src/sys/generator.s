.include "generator.h.s"
.include "man/entities.h.s"
.include "man/globals.h.s"
.include "man/enemy.h.s"
.include "man/level.h.s"

available_background_items: .db 0
current_level_data: .dw 0x0000
current_counter: .dw 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                     ;;
;;                        PUBLIC FUNCTIONS                             ;;
;;                                                                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SYS_GENERATOR_INIT                                                  ;;
;; Initializes values (pointer to level data)                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sys_generator_init::
    ld a, #0
    ld (current_counter), a
    ld (available_background_items), a
    call man_game_get_current_level
    call man_level_get_level_data
    inc hl
    inc hl
    inc hl
    ld (current_level_data), hl
    ret 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SYS_GENERATOR_RESET_CURRENT_LEVEL                                   ;;
;; Resets the pointer so we can start again checking data from the     ;;
;; current level                                                       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sys_generator_reset_current_level::
    ld a, #0
    ld (current_counter), a
    ld (available_background_items), a
    call man_game_get_current_level
    call man_level_get_level_data
    inc hl
    inc hl
    inc hl
    ld (current_level_data), hl
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SYS_GENERATOR_ENEMIES_UPDATE                                        ;;
;; Checks for the next entity that must be spawn, and spawns it if the ;;
;; counter has reached the value needed                                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sys_generator_enemies_update::
    generator_start:
        ld ix, (current_level_data)
        ld a, l_counter(ix)
        ld hl, #current_counter
        sub (hl)
        jr nc, update_current_counter

        ld a, #1
        ld (current_counter), a

        ld a, l_enemy_type(ix)
        call man_enemy_get_enemy_template
        ld a, l_y_position(ix)
        call man_entity_create_entity
        
        ld e_y(ix), a
        ld a, #scr_max_x
        sub e_w(ix)
        sub #2
        ld e_x(ix), a
        jr jump_to_next_entity

    update_current_counter:
        ld a, (current_counter)
        inc a
        ld (current_counter), a
        jp end_generator_update

    jump_to_next_entity:
        ld hl, (current_level_data)
        inc hl
        inc hl
        inc hl
        ld (current_level_data), hl
        ld ix, (current_level_data)
        ld a, l_counter(ix)
        cp #1
        jp c, generator_start

    end_generator_update:
        ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SYS_GENERATOR_BACKGROUND_UPDATE                                     ;;
;; Generates new background items if we have available background items;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sys_generator_background_update::
    ld a, (available_background_items)
    cp #1

    jr c, end_generate_background

    sub #1
    ld (available_background_items), a

    ld hl, #grass_tmpl                 ;; Loads default values direction in HL
    call man_entity_create_entity

get_random:
    call cpct_getRandom_mxor_u8_asm     ;; Generates a random, stored in L
    ld a, l                             ;; Stores L in A
    cp #180
    jr nc, get_random                   ;; If A < 200, jumps to change speed
    cp #20
    jr c, get_random                    ;; IF A < 20, gets another random

    ld e_y(ix), a
    ld a, #scr_max_x
    sub e_w(ix)
    sub #2
    ld e_x(ix), a

end_generate_background:
    ret

increase_background_available_objects:
    ld a, (available_background_items)
    cp #2
    jp z, end_increase_background_objects
    inc a
    ld (available_background_items), a
    end_increase_background_objects:
    ret