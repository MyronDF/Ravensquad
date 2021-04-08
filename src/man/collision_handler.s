.include "collision_handler.h.s"
.include "man/entities.h.s"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                     ;;
;;                        PUBLIC FUNCTIONS                             ;;
;;                                                                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;MAN_ENTITY_COLLISION_INIT                                            ;;
;;Does nothing, placeholder so if we need this someday we have it      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_collision_handler_init::
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;MAN_ENTITY_COLLISION_UPDATE                                          ;;
;;Gets the player pointer, so the collision system can start checking  ;;
;;collisions, the player is always the first entity, so we can use his ;;
;;pointer as a start point                                             ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_collision_handler_update::
    call man_game_get_player       ;; Player is ALWAYS the first entity
    call sys_collision_check       ;; Calls collision system to check collisions
    ret
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAN_GAME_ENTITY_COLLISION                                           ;;
;; Destroys an entity                                                  ;;
;; Input                                                               ;;
;;      IX pointer to the entity A                                     ;;
;;      IY pointer to the entity B                                     ;;
;; Modifies BC, HL, DE                                                 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_collision_handler_handle_collision::
    ld a, e_type(iy)
    and #e_type_object
    or a
    jp z, check_if_enemy_killed_by_player_shot

    push ix
    push iy

    call man_gui_lives_up

    pop ix

    call man_game_entity_destroy

    push ix
    pop iy
    pop ix
    
    jp end_entity_collision

check_if_enemy_killed_by_player_shot:
    ld a, #e_type_player_shot           ;; Check if one of the entities is player shot or enemy
    or #e_type_enemy
    and e_type(iy)
    jp z, update_strength_entity_a
    ld a, #e_type_player_shot           ;; Check if the other entity is player shot or enemy
    or #e_type_enemy
    and e_type(ix)
    jp z, update_strength_entity_a

    push ix                             ;; Increase score
    push iy
    call man_gui_score_update
    pop iy
    pop ix

    update_strength_entity_a:
        ; updates the strength of A based on damage on the enemy B
        ld a, e_strength(ix)
        cp e_damage(iy)                 ; if damage > strength then destroy entity A
        jr c, _destroy_entity_a

        sub a, e_damage(iy)        
        ld e_strength(ix), a
        
        ;; if the stregth of A entity is lower or equal than 0 ...
        cp a, #1
        jr nc, update_strength_entity_b

        ;; ...the A entity is destroyed
        _destroy_entity_a:
        ld e_strength(ix), #0
        call man_game_entity_destroy
    
    update_strength_entity_b:

        ; updates the strength of A based on damage on the enemy A
        ld a, e_strength(iy)
        cp e_damage(ix)                 ; if damage > strength then destroy entity B
        jr c, _detroy_entity_b

        sub a, e_damage(ix)
        ld e_strength(iy), a

        ;; if the stregth of B entity is lower or equal than 0 ...
        cp a, #1
        ret nc
        
        ;; ...the B entity is destroyed
        _detroy_entity_b:
        ld e_strength(iy), #0
        push ix
        push iy
        pop ix
        call man_game_entity_destroy
        pop ix
    end_entity_collision:
    ret