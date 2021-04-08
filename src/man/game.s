.include "game.h.s"
.include "man/entities.h.s"
.include "man/templates.h.s"
.include "man/collision_handler.h.s"
.include "man/GUI.h.s"
.include "man/menu.h.s"
.include "man/globals.h.s"
.include "man/game_animations.h.s"
.include "man/sound_effects.h.s"

.include "sys/physics.h.s"
.include "sys/render.h.s"
.include "sys/ai.h.s"
.include "sys/input.h.s"
.include "sys/animations.h.s" 
.include "sys/collision.h.s"

;; consts
player_available_shots = 2
enemies_available_shots = 30

;; stores the max number of shots for a player
_man_player_current_shots: .db player_available_shots
_man_player_available_shots: .db player_available_shots
;; stores the max number of shots for a player
_man_enemies_available_shots: .db enemies_available_shots

player_pointer:   .dw 0x0000  ;; Player pointer
game_playing:     .db 1       ;; Aux to check if the game is playing
current_level:    .db 1       ;; Aux so we can know what level are we currently
level_ended:      .db 0       ;; Aux to chekc if the current game has ended
distance_reached: .db 0
is_car_level:     .db 1
sound_enabled:    .db 0
music_enabled:    .db 1

player_shot_max_reach = 50 ;; player shot max reach (alcance max)
enemy_shot_max_reach = 50  ;; enemy shot max reach (alcance max)

.globl cpct_getRandom_lcg_u8_asm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                     ;;
;;                        PUBLIC FUNCTIONS                             ;;
;;                                                                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAN_GAME_INIT                                                       ;;
;; Initializes systems and managers needed for the game                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_game_init::   
    call sys_render_init                    ;; Init render system
    call man_sound_effects_init             ;; Init sound effects
    ret 

man_game_get_sound_enabled::
    ld a, (sound_enabled)
    ret

man_game_get_music_enabled::
    ld a, (music_enabled)
    ret

man_game_get_distance_reached::
    ld a, (distance_reached)
    ret

man_game_get_is_car_level::
    ld a, (is_car_level)
    ret

man_game_toggle_music::
    ld a, (music_enabled)
    xor #1
    ld (music_enabled), a
    ret nz
    call cpct_akp_stop_asm
    ret

man_game_toggle_sound::
    ld a, (sound_enabled)
    xor #1
    ld (sound_enabled), a
    ret

man_game_set_distance_reached::
    ld (distance_reached), a
    ret

man_game_increase_current_shots::
    ld a, (_man_player_current_shots)
    inc a
    ld (_man_player_current_shots), a
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAN_GAME_INIT_GAMEPLAY_SYS_MAN_VAL                                  ;;
;; Resets values from some systems, managers and values to initial     ;; 
;; values, so the game can be restarted                                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_game_init_gameplay_sys_man_val::   
    ld a, (_man_player_current_shots)
    ld (_man_player_available_shots), a

    ld a, #enemies_available_shots
    ld (_man_enemies_available_shots), a

    ld a, #0
    ld (distance_reached), a

    call sys_render_clear_all_sprites
    call man_entity_init                    ;; Init entity manager
    call sys_generator_init
    call man_gui_init                       ;; Init GUI manager
    call man_game_create_default_entities
    call man_collision_handler_init
    call sys_input_init                     ;; Init input system
    ret 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAN_GAME_END_GAME                                                   ;;
;; Sets game_playing to zero, so we know the game has ended            ;;
;; TODO: In the future, this should be a flag check, so we dont use a  ;;
;; byte for this                                                       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_game_end_game::
    ld a, #0
    ld (game_playing), a
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAN_GAME_PLAY                                                       ;;
;; Game loop, manages the menu, the info screen for the first level,   ;;
;; the game initialization, and the game over screen. It loops         ;;
;; forever, so the game can be played as many times as player wants    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_game_play::
    main_loop:
        call man_menu_init              ;; Init menu
        call man_menu_update            ;; Menu update until 1 is pressed
        call man_info_screen_level      ;; Screen first level
        call man_game_play_game         ;; Starts the game
        call man_info_screen_game_over  ;; Screen Game Over
    jp main_loop
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAN_GAME_PLAYER_SHOT                                                ;;
;; Creates a template shot                                             ;;
;; Input                                                               ;;
;;      IX the address of the entity                                   ;;
;; Modifies: AC                                                        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_game_player_shot::
    ; if _man_player_available_shots == 0 return
    ld a, (_man_player_available_shots)
    or a
    ret z

    ;; --_man_player_available_shots
    dec a
    ld (_man_player_available_shots), a

    ; iy = player entity
    push ix
    pop iy

    call man_sound_effects_play
    call man_gui_draw_inactive_bullet
    
    ;; creates shot entity
    ld hl, #player_shot_tmpl                    ;; Loads default shot values address in HL
    call man_entity_create_entity               ;; Creates test sprite    
    
    ; sets the counter of the player_shot_max_reach
    ld a, #player_shot_max_reach
    ld e_ai_counter(ix), a

    ;; e_shot->y = e_player->y - e_shot->h;
    ld a, e_y(iy)
    add e_vy(iy)
    add a, e_shot_y(iy)
    ld e_y(ix), a    

    ;; e_shot->x = e_player->x+c;
    ld a, e_x(iy)
    add #3
    ld e_x(ix), a

    ; if vx = vy = 0 the shot vx = template default, vy = 0
    ld a, e_vx(iy)
    add e_vy(iy)
    ret z

    ; sets the shot->vy = e->vy
    ld a, e_vy(iy)
    cp #0
    ret z
    ld e_vy(ix), a 

    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAN_GAME_ENEMY_SHOT                                                 ;;
;; Creates a template shot                                             ;;
;; Input                                                               ;;
;;      IX the address of the entity                                   ;;
;; Modifies: AF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_game_enemy_shot::
    ld a, e_type(ix)
    and #e_type_dead
    ret nz

    ; if _man_enemies_available_shots == 0 return
    ld a, (_man_enemies_available_shots)
    or a
    ret z

    ;; --_man_enemies_available_shots
    dec a
    ld (_man_enemies_available_shots), a

    ; iy = enemy entity
    push ix
    pop iy

    call man_sound_effects_play

    ;; creates shot entity
    ld hl, #enemy_shot_tmpl                    ;; Loads default shot values address in HL
    call man_entity_create_entity               ;; Creates test sprite    
    
    ; sets the counter of the enemy_shot_max_reach
    ld a, #enemy_shot_max_reach
    ld e_ai_counter(ix), a

    ;; e_shot->y = e->y - e_shot->h;
    ld a, e_y(iy)
    add e_vy(iy)
    add a, e_shot_y(iy)
    ld e_y(ix), a    

    ;; e_shot->x = e->x+c;
    ld a, e_x(iy)
    sub #2
    ld e_x(ix), a

    ; if vx = vy = 0 the shot vx = template default, vy = 0
    ld a, e_vx(iy)
    add e_vy(iy)
    ret z

    ; sets the shot->vy = e->vy
    ;;ld a, e_vy(iy)
    ;;cp #0
    ;;ret z
    ;;ld e_vy(ix), a 

    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAN_GAME_GET_PLAYER                                                 ;;
;; Stores player pointer in ix                                         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_game_get_player::
    ld ix, (player_pointer)
    ret

man_game_get_player_hl::
    ld hl, (player_pointer)
    ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAN_GAME_ENTITY_DESTROY                                             ;;
;; Destroys an entity                                                  ;;
;; Input                                                               ;;
;;      IX pointer to the entity                                       ;;
;; Modifies BC, HL, DE                                                 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_game_entity_destroy::
    ld a, e_type(ix)
    and #e_type_dead
    ret nz

    ;; mark the entity for destruction
    call man_entity_set4destruction
    ret


man_game_create_explosion::
    push ix
    ld hl, #effect_explosion_tmpl
    call man_entity_create_entity
    pop iy
    ld a, e_y(iy)
    ld e_y(ix), a
    ld a, e_x(iy)
    ld e_x(ix), a
    
    push iy
    pop ix
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAN_GAME_ENTITY_FINALIZE_TASKS                                      ;;
;; Update counters and others tasks before remove an entity            ;;
;; Input                                                               ;;
;;      IX pointer to the entity                                       ;;
;; Modifies BC, HL, DE                                                 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_game_entity_finalize_tasks::
        ld a, e_type(ix)
        and #e_type_enemy
        or a
        jp z, man_ent_finalize_player_shot
    man_ent_finalize_enemy:
        call cpct_getRandom_lcg_u8_asm
        ld a, l
        and #15
        jp nz, man_ent_finalize_player_shot
        call man_object_generate
        ret
    ;; finalizes player shot
    man_ent_finalize_player_shot:
        ld a, e_type(ix)    
        and a, #e_type_player_shot
        jr z, man_ent_finalize_enemy_shot
        ld a, e_x(ix)
        cp #240
        jp nc, player_shot_out_of_screen
        call man_game_create_explosion
    player_shot_out_of_screen:
        ld a, (_man_player_available_shots)
        ld hl, #_man_player_current_shots
        cp (hl)
        ret nc
        inc a
        ld (_man_player_available_shots), a
        call man_gui_draw_active_bullet
        ret
    ;; finalizes enemy shot
    man_ent_finalize_enemy_shot:
        ld a, e_type(ix)    
        and a, #e_type_enemy_shot
        jr z, man_entity_finalize_background_item
        ld a, e_x(ix)
        cp #240
        jp nc, enemy_shot_out_of_screen
        call man_game_create_explosion
    enemy_shot_out_of_screen:
        ld a, (_man_enemies_available_shots)
        cp #enemies_available_shots
        ret nc
        inc a
        ld (_man_enemies_available_shots), a
        ret
    ;; Finalizes a background entity
    man_entity_finalize_background_item:
        ld a, e_cmps(ix)
        and a, #e_cmp_background
        jp z, exit_finalize_entity
        call increase_background_available_objects
    exit_finalize_entity:
        ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                     ;;
;;                        PRIVATE FUNCTIONS                            ;;
;;                                                                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAN_GAME_CREATE_DEFAULT_ENTITIES                                    ;;
;; Creates the player entity and some background objects               ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_game_create_default_entities::
    ;; creates player entity
    ld hl, #player_tmpl                       ;; Loads default values direction in HL
    call man_entity_create_entity             ;; Creates test sprite

    ld (player_pointer), ix

    call man_level_is_car_level
    or a
    jp z, game_is_not_car_level

    ld hl, #_spr_player_car
    ld e_sprite_l(ix), l
    ld e_sprite_h(ix), h
    ld a, #18
    ld e_w(ix), a
    ld a, #21
    ld e_h(ix), a
    ld a, e_cmps(ix)
    xor #e_cmp_anim
    ld e_cmps(ix), a
    ld a, #17
    ld e_end_X(ix), a
    ld a, #18
    ld e_end_Y(ix), a
    ld a, #1
    ld e_start_X(ix), a
    ld a, #4
    ld e_start_Y(ix), a
    ret

game_is_not_car_level:
    ld a, (current_level)
    cp #9
    ret z
    cp #10
    ret z
    cp #11
    jp nz, create_keep_out_sign
    call man_game_end_game_animation_play
    call man_gui_set_no_lives
    call man_game_get_player
    call man_game_entity_destroy
    call man_game_end_game
    ret
create_keep_out_sign:
    ;; Creates keep out sign 
    ld hl, #keep_out_sign_tmpl         
    call man_entity_create_entity
    ld a, #65
    ld e_x(ix), a
    ld a, #170
    ld e_y(ix), a

    ;; Creates grass
    ld hl, #grass_tmpl
    call man_entity_create_entity
    ld a, #20
    ld e_x(ix), a
    ld a, #80
    ld e_y(ix), a

    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAN_GAME_PLAY_GAME                                                  ;;
;; Initializes systems, managers, and values, calls                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_game_play_game::
    call man_game_initial_game_values
    game_play:
        call man_game_init_gameplay_sys_man_val ;; Initializes values, systems, managers
        call man_game_play_loop
        call cpct_akp_stop_asm
        ld a, (level_ended)
        or a
        jp nz, next_level
        call man_gui_get_lives
        or a
        jp nz, game_play
    jp end_game
next_level:
    call man_info_screen_level_update
    call man_game_initial_level_values
    jp game_play
end_game:
    call cpct_akp_stop_asm
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAN_GAME_INITIAL_GAME_VALUES                                               ;;
;; Restores initial values for the current game (score, lives, initial values);;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_game_initial_game_values::
    call man_music_get_current_screen_music
    call cpct_akp_musicInit_asm
    ld a, #1
    ld (current_level), a
    call man_level_is_car_level
    ld (is_car_level), a
    ld a, #player_available_shots
    ld (_man_player_current_shots), a
    call man_gui_reset_score
    call man_gui_reset_lives
    call man_game_initial_level_values
    ret
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAN_GAME_INITIAL_LEVEL_VALUES                                              ;;
;; Restores initial values for a level (shot numbers, and level ended), resets;;
;; distance to end the level, resets the generator counter                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_game_initial_level_values::
    ld a, (_man_player_current_shots)
    ld (_man_player_available_shots), a
    ld a, #enemies_available_shots
    ld (_man_enemies_available_shots), a
    ld a, #0
    ld (level_ended), a
    ld (distance_reached), a

    ld a, (current_level)
    cp #9 
    jp z, change_palette
    cp #10
    jp nz, not_level_9_or_10

change_palette:

    call sys_render_set_palette_gray_and_clean_screen

not_level_9_or_10:
    call man_gui_reset_distance
    call sys_generator_reset_current_level
    call man_music_get_current_screen_music
    call cpct_akp_musicInit_asm
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAN_GAME_FINISH                                                            ;;
;; Finalizes the game (Esc pressed)                                           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_game_finish::
    ld a, #0
    ld (game_playing), a
    call man_gui_set_no_lives
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAN_GAME_PLAY_LOOP                                                         ;;
;; Main loop for the current game, handles the update of the managers and     ;;
;; systems, checks if the current game has to end, or if we have to advance   ;;
;; to the next level                                                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_game_play_loop::
    loop:    
        ld a, (music_enabled)
        or a
        jr z, skip_music_1
        call cpct_akp_musicPlay_asm
    skip_music_1:
        call sys_input_update                       ;; Update input system
        call sys_ai_update                          ;; Update ai system
        call sys_physics_update                     ;; Update physics system
        call sys_generator_background_update        ;; Update background generation
        call sys_animations_update                  ;; Update animations system
        call man_collision_handler_update
        call cpct_waitVSYNC_asm
        call man_sound_effects_update
        ld a, (music_enabled)
        or a
        jr z, skip_music_2
        call cpct_akp_musicPlay_asm
    skip_music_2:
        call sys_render_update                      ;; Update render system
        call man_entity_destroy_marked_for_death    ;; Update entity manager
        call cpct_waitVSYNC_asm

        ;; Check if level has ended
        ld a, (level_ended)
        and a
        jp z, check_game_ended
        ;; LEVEL HAS ENDED
        call cpct_akp_stop_asm          ;;Stop sound
        call man_game_animation_play

        ret

        ;; Check if the game has ended
    check_game_ended:
        ld a, (game_playing)
        and a
        jp nz, loop
        call man_game_start_game
    ret 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAN_GAME_START_GAME                                                        ;;
;; Sets game_playing to 1, so we know the game has started                    ;;
;; TODO: In the future, this should be a flag check, so we dont use a full    ;;
;; byte for this                                                              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_game_start_game::
    ld a, #1
    ld (game_playing), a
    ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAN_GAME_GO_NEXT_LEVEL                                                     ;;
;; Increases current_level, sets level_ended to 1, so the game knows it has   ;;
;; to end current level and load the next one                                 ;;
;; TODO: In the future, level_ended should be a flag check, so we dont use a  ;;
;; byte for this
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_game_go_next_level::
    ld a, (current_level)
    inc a
    ld (current_level), a
    call man_level_is_car_level
    ld (is_car_level), a
    ld a, #1
    ld (level_ended), a
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAN_GAME_GET_CURRENT_LEVEL                                                 ;;
;; Returns the level we currently are, stored in A                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_game_get_current_level::
    ld a, (current_level)
    ret

man_game_get_current_max_shots::
    ld a, (_man_player_current_shots)
    ret

man_game_get_current_available_shots::
    ld a, (_man_player_available_shots)
    ret 