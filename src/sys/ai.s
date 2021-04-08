.include "ai.h.s"
.include "man/game.h.s"
.include "man/entities.h.s"
.include "man/globals.h.s"
.include "man/sound_effects.h.s"

sys_ai_default_patrol_ai_counter = 30
sys_ai_default_track_player_ai_counter = 15
sys_ai_default_immovile_enemy_ai_counter = 10
sys_ai_default_tank_ai_counter = 40
sys_ai_default_trench_ai_counter = 40
sys_ai_default_mortar_ai_counter = 36
sys_ai_default_boss_ai_counter = 36

sys_ai_default_tank_shot_distance = 15
sys_ai_default_trench_shot_distance = 10 
sys_ai_default_mortar_shot_distance = 20
sys_ai_default_boss_shot_distance = 24

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                     ;;
;;                        PUBLIC FUNCTIONS                             ;;
;;                                                                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SYS_AI_BEHAVIOUR_SHOT                                               ;; 
;; Bheaviour of a player shot                                          ;;
;; INPUT                                                               ;;
;;      IX the address of the entity                                   ;;
;; Modifies AF                                                         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sys_ai_behaviour_shot::
    ld a, e_type(ix)
    and #e_type_dead
    ret nz
    ld a, e_ai_counter(ix)
    cp #1
    ret c
    dec a
    ld e_ai_counter(ix), a
    ret nz
    ld a, e_x(ix)
    cp #6
    jp nc, create_explosion
    ld a, #e_type_dead
    ld e_type(ix), a
    ret
create_explosion:
    push ix
    ld hl, #enemy_tank_explosion_tmpl
    call man_entity_create_entity
    pop iy
    ld a, e_x(iy)
    sub #5
    ld e_x(ix), a
    ld a, e_y(iy)
    sub #10
    ld e_y(ix), a
    push iy
    pop ix
    ;; if the shot gets into its maximum reach it is destroyed
    call man_game_entity_destroy
    ret

sys_ai_behaviour_boss_left_arm::

    ;; if e->y == 0 
    ld a, e_y(ix)
    sub #2                           ;; avoids out of top screen auto-destroy
    cp #20
    jr nc, sys_ai_bhv_left_arm
    
    ; ;; e->vy = 1
    ld e_vy(ix), #1
    jp boss_left_arm_check_shoot
    
    sys_ai_bhv_left_arm:
        ld a, e_y(ix)
        add e_h(ix)                 ;; adds the heigh e->h
        add #2                      ;; avoids out of bottom screen auto-destroy
        cp a, #90                   ;; if e->y+h > scr_max_y then delete entity
        jp c, boss_left_arm_check_shoot
        ; e->vy = -1
        ld e_vy(ix), #-1
    
boss_left_arm_check_shoot:
    ld a, e_ai_counter(ix)
    dec a
    ld e_ai_counter(ix), a
    ret nz

    ld a, #20
    ld e_ai_counter(ix), a

    push ix
    call man_game_enemy_shot
    ld a, #1
    ld e_vy(ix), a

    pop ix
    push ix
    call man_game_enemy_shot
    ld a, #-1
    ld e_vy(ix), a

    pop ix
    call man_game_enemy_shot
    ret

sys_ai_behaviour_boss_right_arm::
    ;; if e->y == 0 
    ld a, e_y(ix)
    sub #2                           ;; avoids out of top screen auto-destroy
    cp #120
    jr nc, sys_ai_bhv_right_arm
    
    ; ;; e->vy = 1
    ld e_vy(ix), #1
    jp boss_right_arm_check_shoot
    
    sys_ai_bhv_right_arm:
        ld a, e_y(ix)
        add e_h(ix)                 ;; adds the heigh e->h
        add #2                      ;; avoids out of bottom screen auto-destroy
        cp a, #180                  ;; if e->y+h > scr_max_y then delete entity
        jp c, boss_right_arm_check_shoot
        ; e->vy = -1
        ld e_vy(ix), #-1
    
boss_right_arm_check_shoot:
    ld a, e_ai_counter(ix)
    dec a
    ld e_ai_counter(ix), a
    ret nz

    ld a, #20
    ld e_ai_counter(ix), a

    ld b, #sys_ai_default_boss_ai_counter
    ld c, #sys_ai_default_boss_shot_distance
    call sys_ai_shot_limited_range_proyectile
    ret

sys_ai_behaviour_boss_chest_ai::
    ld a, e_type(ix)
    and #e_type_dead
    ret nz
    ld a, e_strength(ix)
    cp #3
    jp nc, boss_chest_ia
    call man_game_entity_destroy
    call man_game_end_game_animation_play
    call man_gui_set_no_lives
    call man_game_get_player
    call man_game_entity_destroy
    call man_game_end_game
    ret
boss_chest_ia:
    push ix
    call man_game_get_player

    ld a, e_x(ix)
    cp #45
    jp c, player_not_touching_laser

    call man_game_entity_destroy
    call man_gui_lives_down
    call man_gui_reset_distance
    
    ld de, #0xC000
    ld b, #20
    ld c, #60
    call cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL

    ex de, hl
    ld a, #0x00
    ld b, #160
    ld c, #20
    call cpct_drawSolidBox_asm
    pop ix
    ret 
    
player_not_touching_laser:
    pop ix
    
    ld de, #0xC000
    ld b, #20
    ld c, #77
    call cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL

    ex de, hl
    ld a, #0xC0
    ld b, #160
    ld c, #3
    call cpct_drawSolidBox_asm

    ld de, #0xC000
    ld b, #20
    ld c, #45
    call cpct_getScreenPtr_asm       ;; Calculate video memory location and return it in HL

    ex de, hl
    ld a, #0xCC
    ld b, #160
    ld c, #1
    call cpct_drawSolidBox_asm

    ld a, e_ai_counter(ix)
    dec a
    ld e_ai_counter(ix), a
    ret nz

    ld a, #20
    ld e_ai_counter(ix), a

    call man_game_enemy_shot

    ret

sys_ai_behaviour_play_sound_effect::
    ld a, e_ai_counter(ix)
    cp a, #10
    ret c
    ld a, #1
    ld e_ai_counter(ix), a

    ld e, a

    ld l, #1            ;; Number of the instrument in the SFX Song (>0), same as the number given to the instrument in Arkos Tracker.
    ld h, #15           ;; Volume [0-15], 0 = off, 15 = maximum volume.
    ld d, #0            ;; Speed (0 = As original, [1-255] = new Speed (1 is fastest))
    ld e, #1            ;; Note to be played with the given instrument [0-143]
    ld bc, #0x0000      ;; Inverted Pitch (-0xFFFF -> 0xFFFF).  0 is no pitch.  The higher the pitch, the lower the sound.
    ld a, #2            ;; Bitmask representing channels to use for reproducing the sound (Ch.A = 001 (1), Ch.B = 010 (2), Ch.C = 100 (4))    
    call cpct_akp_SFXPlay_asm    

    call man_sound_effects_play  

    ret

sys_ai_behaviour_patrol_bot::
    call sys_ai_behaviour_bottom
    ld a, e_ai_counter(ix)
    dec a
    ld e_ai_counter(ix), a
    or a
    ret nz
    ld a, #sys_ai_default_patrol_ai_counter
    ld e_ai_counter(ix), a
    call man_game_enemy_shot
    ret

sys_ai_behaviour_patrol_top::
    call sys_ai_behaviour_top
    ld a, e_ai_counter(ix)
    dec a
    ld e_ai_counter(ix), a
    or a
    ret nz
    ld a, #sys_ai_default_patrol_ai_counter
    ld e_ai_counter(ix), a
    call man_game_enemy_shot
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SYS_AI_BEHAVIOUR_ENEMY0                                             ;; 
;; Bheaviour of a player shot                                          ;;
;; INPUT                                                               ;;
;;      IX the address of the entity                                   ;;
;; Modifies AF,HL                                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sys_ai_behaviour_top::  
    ;; if e->y == 0 
    ld a, e_y(ix)
    sub #2                           ;; avoids out of top screen auto-destroy
    cp #scr_min_y
    jr nc, sys_ai_bhv_top
    
    ; ;; e->vy = 1
    ld e_vy(ix), #1
    ret
    
    sys_ai_bhv_top:
        ld a, e_y(ix)
        add e_h(ix)                 ;; adds the heigh e->h
        add #2                      ;; avoids out of bottom screen auto-destroy
        cp a, #scr_mid_y            ;; if e->y+h > scr_max_y then delete entity
        ret c
        ; e->vy = -1
        ld e_vy(ix), #-1
    ret

sys_ai_behaviour_bottom::  
    ;; if e->y == 0 
    ld a, e_y(ix)
    sub #2                           ;; avoids out of top screen auto-destroy
    cp #scr_mid_y
    jr nc, sys_ai_bhv_bottom
    
    ; ;; e->vy = 1
    ld e_vy(ix), #1
    ret
    
    sys_ai_bhv_bottom:
        ld a, e_y(ix)
        add e_h(ix)                 ;; adds the heigh e->h
        add #2                      ;; avoids out of bottom screen auto-destroy
        cp a, #scr_max_y            ;; if e->y+h > scr_max_y then delete entity
        ret c
        ; e->vy = -1
        ld e_vy(ix), #-1
    ret

sys_ai_behaviour_explosion:: 
    ld a, e_ai_counter(ix)
    dec a
    ld e_ai_counter(ix), a
    ret nz
    ;; If animation has ended, destroy the entity
    call man_game_entity_destroy
    ret

sys_ai_behaviour_track_player::
    ld a, #0
    ld e_vy(ix), a
    ld e_vx(ix), a

    ld a, e_y(ix)

    call man_game_get_player_hl

    push hl
    pop iy

    cp e_y(iy)
    jp c, track_player_move_down

track_player_check_if_move_up:
    ld a, e_y(iy)
    add #10
    cp e_y(ix)
    jp c, track_player_move_up

    track_player_move_down:
        ld a, e_y(iy)
        add e_h(iy)
        cp #188
        jp nc, end_ai_track_player
        ld a, e_y(ix)
        cp e_y(iy)
        jr nc, track_player_end_vertical_movement
        ld a, #2
        ld e_vy(ix), a
        jp track_player_end_vertical_movement
        
    track_player_move_up:
        ld a, #-2
        ld e_vy(ix), a
    
    track_player_end_vertical_movement:

    ld a, e_ai_counter(ix)
    dec a
    ld e_ai_counter(ix), a
    or a
    ret nz
    ld a, #sys_ai_default_track_player_ai_counter
    ld e_ai_counter(ix), a
    call man_game_enemy_shot

    end_ai_track_player:
        ret



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SYS_AI_BEHAVIOUR_TRENCH                                             ;; 
;; Behaviour of the trench enemy, doesnt move, just shots              ;;
;; INPUT                                                               ;;
;;      IX the address of the entity                                   ;;
;; Modifies AF,HL                                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sys_ai_behaviour_inmovile_enemy::
    ld a, e_ai_counter(ix)
    dec a
    ld e_ai_counter(ix), a
    or a
    ret nz
    ld a, #sys_ai_default_immovile_enemy_ai_counter
    ld e_ai_counter(ix), a
    call man_game_enemy_shot
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SYS_AI_BEHAVIOUR_LEFT_RIGHT                                         ;; 
;; Bheaviour of a player shot                                          ;;
;; INPUT                                                               ;;
;;      IX the address of the entity                                   ;;
;; Modifies                                                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sys_ai_behaviour_left_right::
    ;; if e->x == 0 
    ld a, e_x(ix)
    or a
    jr nz, #sys_ai_bh_l_r_cont
    
    ;; e->vx = 1
    ld e_vx(ix), #1
    ret
    
    sys_ai_bh_l_r_cont:
        ; a = right_bound = 80 - e->w
        ld a, #scr_max_x
        ld b, e_w(ix)
        sub a,b
        ; e->x == right_bound
        cp a, e_x(ix)
        ret nz
        ; e->vx = -1
        ld e_vx(ix), #-1
    ret

sys_ai_behaviour_patrol_top_down::   
    call sys_ai_behaviour_top_down
    ld a, e_ai_counter(ix)
    dec a
    ld e_ai_counter(ix), a
    or a
    ret nz
    ld a, #sys_ai_default_patrol_ai_counter
    ld e_ai_counter(ix), a
    call man_game_enemy_shot
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SYS_AI_BEHAVIOUR_TOP_BOTTOM                                         ;; 
;; Bheaviour of a player shot                                          ;;
;; INPUT                                                               ;;
;;      IX the address of the entity                                   ;;
;; Modifies                                                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sys_ai_behaviour_top_down::
    ;; if e->y == 0 
    ld a, e_y(ix)
    sub #2                           ;; avoids out of top screen auto-destroy
    cp #scr_min_y
    jr nc, #sys_ai_bh_t_b_cont
    
    ; ;; e->vy = 1
    ld e_vy(ix), #1
    ret
    
    sys_ai_bh_t_b_cont:
        ld a, e_y(ix)
        add e_h(ix)                 ;; adds the heigh e->h
        add #2                      ;; avoids out of bottom screen auto-destroy
        cp a, #scr_max_y            ;; if e->y+h > scr_max_y then delete entity
        ret c
        ; e->vy = -1
        ld e_vy(ix), #-1
    ret

sys_ai_enemy_dog::
    ld a, #0
    ld e_vy(ix), a
    ld e_vx(ix), a

    ld a, e_y(ix)

    call man_game_get_player_hl

    push hl
    pop iy

    cp e_y(iy)
    jp c, enemy_dog_move_down

enemy_dog_check_if_move_up:
    ld a, e_y(iy)
    add #5
    cp e_y(ix)
    jp c, enemy_dog_move_up

    ld a, #-1
    ld e_vx(ix), a
    jp end_ai_enemy_dog

    enemy_dog_move_down:
        ld a, #2
        ld e_vy(ix), a
        jp end_ai_enemy_dog
        
    enemy_dog_move_up:
        ld a, #-2
        ld e_vy(ix), a
    
    end_ai_enemy_dog:
        ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SYS_AI_UPDATE                                                       ;; 
;; Calls for AI manager forall function, so it can update every entity ;;
;; Modifies HL,BC                                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sys_ai_update::
    ld hl, #_sys_ia_update_one_entity       ;; Stores in HL update one entity address
    ld b, #e_cmp_ai                         ;; only ia entities are processed
    call man_entity_forall_matching         ;; Calls for entity manager forall
    ret	

sys_ai_behaviour_tank::
    ld a, e_ai_counter(ix)
    dec a
    ld e_ai_counter(ix), a
    ret nz
    ld b, #sys_ai_default_tank_ai_counter
    ld c, #sys_ai_default_tank_shot_distance
    call sys_ai_shot_limited_range_proyectile
    ret

sys_ai_behaviour_mortar::
    ld a, e_ai_counter(ix)
    dec a
    ld e_ai_counter(ix), a
    ret nz
    ld a, #e_state_moving
    ld e_state(ix), a
    ld b, #sys_ai_default_mortar_ai_counter
    ld c, #sys_ai_default_mortar_shot_distance
    call sys_ai_shot_limited_range_proyectile
    ret

sys_ai_behaviour_trench_explosive::
    ld a, e_ai_counter(ix)
    dec a
    ld e_ai_counter(ix), a
    ret nz
    ld b, #sys_ai_default_trench_ai_counter
    ld c, #sys_ai_default_trench_shot_distance
    call sys_ai_shot_limited_range_proyectile
    ret

sys_ai_shot_limited_range_proyectile::
    push bc
    ld e_ai_counter(ix), b
    call man_game_enemy_shot
    ld hl, #sys_ai_behaviour_shot
    ld e_behaviour_l(ix), l
    ld e_behaviour_h(ix), h
    pop bc
    ld e_ai_counter(ix), c
    ld a, e_cmps(ix)
    or #e_cmp_ai
    ld e_cmps(ix), a

    call man_game_get_player_hl
    push hl
    pop iy
    ld a, e_y(ix)
    sub #20
    cp e_y(iy)
    jp nc, ai_tank_shot_up
    ld a, e_y(ix)
    add #20
    cp e_y(iy)
    jp c, ai_tank_shot_down
    ret
ai_tank_shot_up:
    sub #20
    cp e_y(iy)
    jp nc, ai_tank_shot_very_up
    ld a, #-1
    ld e_vy(ix), a
    ret
ai_tank_shot_very_up:
    ld a, #-2
    ld e_vy(ix), a
    ret
ai_tank_shot_down:
    add #20
    cp e_y(iy)
    jp c, ai_tank_shot_very_down
    ld a, #1
    ld e_vy(ix), a
    ret 
ai_tank_shot_very_down:
    ld a, #2
    ld e_vy(ix), a
    ret

sys_ai_behaviour_gatling::
    ld a, e_ai_counter(ix)
    dec a
    ld e_ai_counter(ix), a
    or a
    ret nz
    ld a, #sys_ai_default_tank_ai_counter
    ld e_ai_counter(ix), a

    push ix
    call man_game_enemy_shot
    ld a, #1
    ld e_vy(ix), a

    pop ix
    push ix
    call man_game_enemy_shot
    ld a, #-1
    ld e_vy(ix), a

    pop ix
    call man_game_enemy_shot

    ret

sys_ai_pop_door::
    ld c, e_sprite_l(ix)
    ld b, e_sprite_h(ix)   
    ld hl, #_spr_enemy_pop_door_5

check_if_door_is_opened:
    sbc hl, bc 
    jp z, disable_door_collision
check_if_door_is_going_to_close:
    ld c, e_sprite_l(ix)
    ld b, e_sprite_h(ix)   
    ld hl, #_spr_enemy_pop_door_4

    sbc hl, bc
    jp z, disable_door_collision
enable_door_collision:
    ld a, e_cmps(ix)
    or #e_cmp_collider
    ld e_cmps(ix), a
    ret
disable_door_collision:
    ld a, e_cmps(ix)
    res 5, a
    ld e_cmps(ix), a
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                     ;;
;;                        PRIVATE FUNCTIONS                            ;;
;;                                                                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; _SYS_AI_UPDATE_ONE_ENTITY                                           ;; 
;; Calls for manager forall function, so it can update every entity    ;;
;; INPUT                                                               ;;
;;      IX the address of the entity                                   ;;
;; Modifies HL,DE                                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_sys_ia_update_one_entity::
    ;; stores the the behaviour address of the entity in BC
    ld h, e_behaviour_h(ix)
    ld l, e_behaviour_l(ix)    

    ;; if the handler points to 0 (null, no handler) then return
    ld a, h
    add l
    or a
    ret z

    ld de, #ia_update_next  ;; Stores in DE the return address after call
    push de                 ;; Stores in stack DE
    jp (hl)                 ;; Calls the behaviour function 
ia_update_next:
    ret