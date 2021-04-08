.include "animations.h.s"
.include "man/entities.h.s"

;; Player animation
man_anim_player::
    .db man_anim_player_time
    .dw #_spr_player_0
    .db man_anim_player_time
    .dw #_spr_player_1
    .db man_anim_player_time
    .dw #_spr_player_2
    .db man_anim_player_time
    .dw #_spr_player_3
    .db 0 
    .dw #man_anim_player

man_anim_enemy_boss_chest::
    .db man_anim_player_time
    .dw #_spr_enemy_boss_chest_0
    .db man_anim_player_time
    .dw #_spr_enemy_boss_chest_1
    .db man_anim_player_time
    .dw #_spr_enemy_boss_chest_2
    .db man_anim_player_time
    .dw #_spr_enemy_boss_chest_3
    .db 0
    .dw #man_anim_enemy_boss_chest

man_anim_enemy_explosion::
    .db man_anim_enemy_explosion_time
    .dw #_spr_anim_enemy_explosion_0
    .db man_anim_enemy_explosion_time
    .dw #_spr_anim_enemy_explosion_1
    .db man_anim_enemy_explosion_time
    .dw #_spr_anim_enemy_explosion_2
    .db man_anim_enemy_explosion_time
    .dw #_spr_anim_enemy_explosion_3
    .db man_anim_enemy_explosion_time
    .dw #_spr_anim_enemy_explosion_4
    .db 0
    .dw #man_anim_enemy_explosion

man_anim_dog::
    .db man_anim_dog_time
    .dw #_spr_enemy_dog_0
    .db man_anim_dog_time
    .dw #_spr_enemy_dog_1
    .db man_anim_dog_time
    .dw #_spr_enemy_dog_2
    .db man_anim_dog_time
    .dw #_spr_enemy_dog_3
    .db 0 
    .dw #man_anim_dog

man_anim_enemy_soldier::
    .db man_anim_player_time
    .dw #_spr_enemy_soldier_0
    .db man_anim_player_time
    .dw #_spr_enemy_soldier_1
    .db man_anim_player_time
    .dw #_spr_enemy_soldier_2
    .db man_anim_player_time
    .dw #_spr_enemy_soldier_3
    .db 0 
    .dw #man_anim_enemy_soldier

man_anim_enemy_commander::
    .db man_anim_player_time
    .dw #_spr_enemy_commander_0
    .db man_anim_player_time
    .dw #_spr_enemy_commander_1
    .db man_anim_player_time
    .dw #_spr_enemy_commander_2
    .db man_anim_player_time
    .dw #_spr_enemy_commander_3
    .db 0 
    .dw #man_anim_enemy_commander

man_anim_bullet_destruction::
    .db man_anim_player_time
    .dw #_spr_bullet_destruction_0
    .db man_anim_player_time
    .dw #_spr_bullet_destruction_1
    .db man_anim_player_time
    .dw #_spr_bullet_destruction_2
    .db man_anim_player_time
    .dw #_spr_bullet_destruction_3
    .db 0 
    .dw #man_anim_bullet_destruction

man_anim_gatling::
    .db man_anim_player_time
    .dw #_spr_enemy_gatling_0
    .db man_anim_player_time
    .dw #_spr_enemy_gatling_1
    .db 0 
    .dw #man_anim_gatling

man_anim_pop_door::
    .db man_anim_pop_door_standing
    .dw #_spr_enemy_pop_door_0
    .db man_anim_pop_door_opening
    .dw #_spr_enemy_pop_door_1
    .db man_anim_pop_door_opening
    .dw #_spr_enemy_pop_door_2
    .db man_anim_pop_door_opening
    .dw #_spr_enemy_pop_door_3
    .db man_anim_pop_door_opening
    .dw #_spr_enemy_pop_door_4
    .db man_anim_pop_door_standing
    .dw #_spr_enemy_pop_door_5
    .db man_anim_pop_door_standing
    .dw #_spr_enemy_pop_door_4
    .db man_anim_pop_door_closing
    .dw #_spr_enemy_pop_door_3
    .db man_anim_pop_door_closing
    .dw #_spr_enemy_pop_door_2
    .db man_anim_pop_door_closing
    .dw #_spr_enemy_pop_door_1
    .db man_anim_pop_door_standing
    .dw #_spr_enemy_pop_door_0
    .db 0
    .dw #man_anim_pop_door

man_anim_enemy_claymore::
    .db man_anim_enemy_claymore_time
    .dw #_spr_enemy_claymore_0
    .db man_anim_enemy_claymore_time
    .dw #_spr_enemy_claymore_1
    .db 0
    .dw #man_anim_enemy_claymore

man_anim_enemy_mortar::
    .db #32
    .dw #_spr_enemy_mortar_0
    .db man_anim_enemy_mortar_time
    .dw #_spr_enemy_mortar_1
    .db man_anim_enemy_mortar_time
    .dw #_spr_enemy_mortar_2
    .db man_anim_enemy_mortar_time
    .dw #_spr_enemy_mortar_3
    .db 0
    .dw #man_anim_enemy_mortar
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PUBLIC CONSTANTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_man_anim_sizeof = 3
_man_anim_time = 0
_man_anim_sprite_l = 1
_man_anim_sprite_h = 2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                     ;;
;;                        PRIVATE FUNCTIONS                            ;;
;;                                                                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; _SYS_ANIMATIONS_UPDATE_ONE_ENTITY                                   ;;
;; Animates entity sprites based on animation definition               ;;
;; INPUT                                                               ;;
;;      IX the address of the entity                                   ;;
;; Modifies AZ, BC, IY                                                 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_sys_animations_update_one_entity::
    ; --(e->anim_counter)
    ld a, e_state(ix)
    or a
    jr nz, animate
    ld c, e_default_sprite_l(ix)
    ld b, e_default_sprite_h(ix)    
    ld e_sprite_l(ix), c
    ld e_sprite_h(ix), b
    ret
animate:
    ld a, e_anim_counter(ix)
    dec a
    ld e_anim_counter(ix), a

    ; if e->anim_counter > 0 return 
    or a
    ret nz

    ; ++e->anim: go to next animation
    ld b, e_anim_h(ix)
    ld c, e_anim_l(ix)
    ld iy, #_man_anim_sizeof
    add iy, bc
    push iy
    pop bc
    ld e_anim_h(ix), b
    ld e_anim_l(ix), c
    
    ; e->anim->time == 0 ?
    ld a, _man_anim_time(iy)
    or a
    jr nz, #_sys_animations_update_one_entity_cont

    ; e->anim = e->anim->val.next
    ld c, _man_anim_sprite_l(iy)
    ld b, _man_anim_sprite_h(iy) 
    ld e_anim_l(ix), c
    ld e_anim_h(ix), b
    ld iy, #0
    add iy, bc

    _sys_animations_update_one_entity_cont:
    ; e->sprite = e->anim->val.sprite;
    ld c, _man_anim_sprite_l(iy)
    ld b, _man_anim_sprite_h(iy)    
    ld e_sprite_l(ix), c
    ld e_sprite_h(ix), b
    ; e->anim_counter = e->anim->time;
    ld a, _man_anim_time(iy)
    ld e_anim_counter(ix), a
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                     ;;
;;                        PUBLIC FUNCTIONS                             ;;
;;                                                                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SYS_ANIMATIONS_UPDATE                                               ;; 
;; Calls for manager forall function, so it can update every entity    ;;
;; Modifies HL,BC                                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sys_animations_update::
    ld hl, #_sys_animations_update_one_entity   ;; Stores in HL update one entity address
    ld b, #e_cmp_anim
    call man_entity_forall_matching             ;; Calls for entity manager forall
    ret	
	                 