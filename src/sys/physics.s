.include "physics.h.s"
.include "man/entities.h.s"
.include "man/globals.h.s"

;; flag to activates left scroll due to player movement to the right
_left_scroll: .db 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                     ;;
;;                        PRIVATE FUNCTIONS                            ;;
;;                                                                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SYS_PHYSICS_UPDATE_ONE_ENTITY                                       ;;
;; Updates the coordinates of the current entity, adding the speed     ;;
;; value to X                                                          ;;
;; Modifies A, DE, C. Does not modify HL because we do a backup in     ;;
;; stack                                                               ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_sys_physics_update_one_entity::
    ld a, e_x(ix)           ;; Stores X value in A
    ld e_lastX(ix), a       ;; Stores A value in lastX

    ;; d = (x < 127 ? 0 : 1)    
    ld d,#1
    cp #scr_mid_x
    jr nc, _s_p_u_o_e_xlt
    ld d,#0

    _s_p_u_o_e_xlt:
    
    ld a, e_y(ix)           ;; Stores Y value in A
    ld e_lastY(ix), a       ;; Stores A value in lastY

    ;; e = (y < 127 ? 0 : 1)
    ld e,#1
    cp #scr_mid_y
    jr nc, _s_p_u_o_e_ylt
    ld e,#0

    _s_p_u_o_e_ylt::

    ;;
    ;;CHANGE_X:       
    ;;

    ;; aplies left scroll if it is active except to the player and player shot
    ld a, e_type(ix)
    and #e_type_player | e_type_player_shot
    or a
    jr z, _s_p_u_o_e_scroll_cont1 
        ld a, #0                    ;; the entity is the player or player shot
        jr _s_p_u_o_e_scroll_cont2
    _s_p_u_o_e_scroll_cont1:        
        ld a, (_left_scroll)        ;; the entity is not the player nor the player shot
    _s_p_u_o_e_scroll_cont2:

    ;; aplies vx to x
    add e_x(ix)             ;; Stores X value of entity in A
    add e_vx(ix)            ;; Adds the speed value to X

    ld  e_x(ix), A          ;; Stores A in e_x(ix)

    ;;
    ;; checks if the new x is within the screen boundaries
    ;;

    ; x was lower than scr_mid_x before the displacement?
    ld a,d
    or a
    jr nz, _s_p_u_o_e_xlt_127_cont

    ; x was lower than scr_mid_x
    ; checks if x < 0 
    _s_p_u_o_e_xlt_127::
    ld a, e_x(ix)            ;; checks e->x sign after increment vx    
    and #128                  
    jr nz, _s_p_u_o_e_delete ;; if x is a negative number (out of screen) ==> delete
    
    ; checks if x < scr_min_x
    ld a, e_x(ix)
    cp #scr_min_x
    jr c, _s_p_u_o_e_delete
    jp _s_p_u_o_e_y          ;; x has not sign, remains inside the screen, continues checking y boundaries

    ; x was greater than scr_mid_x 
    ; checks if x + h > scr_max_x
    _s_p_u_o_e_xlt_127_cont::
    ld a, e_x(ix)
    add e_w(ix)              ;; adds the with 
    cp a, #scr_max_x             ;; if x+w > scr_max_x then x greater than scr_max_x (out of screen) ==> delete
    jr nc, _s_p_u_o_e_delete

     _s_p_u_o_e_y::

    ;;
    ;;CHANGE_Y:       
    ;;
    ld  A, e_y(ix)          ;; Stores Y value of entity in A
    add e_vy(ix)            ;; Adds the speed value to Y
    ld  e_y(ix), A          ;; Stores A in e_y(ix)

    ;;
    ;; checks if the new y is within the screen boundaries
    ;;
    ; y was lower than 127 before the displacement?
    ld a,e
    or a
    jr nz, _s_p_u_o_e_ylt_127_cont

    ; y was lower than scr_mid_y
    
    ; checks if y < 0
    _s_p_u_o_e_ylt_127::
    ld a, e_y(ix)            ;; checks e->y sign after increment vy
    and #128                
    jr c, _s_p_u_o_e_delete ;; if y is a negative number (out of screen) ==> delete
    
    ; checks if y < scr_min_y
    ld a, e_y(ix)
    cp #scr_min_y
    jr c, _s_p_u_o_e_delete
    ret                      

    ; y+h was greater than scr_mid_y
    ; checks if y + h > scr_max_y 
    _s_p_u_o_e_ylt_127_cont::
    ld a, e_type(ix)
    and #e_type_player_shot | #e_type_enemy_shot
    jp nz, checkBulletPos
    ld a, e_y(ix)
    add e_h(ix)
    cp #scr_max_y                 ;; if e->y+h > scr_max_y then delete entity
    jr nc, _s_p_u_o_e_delete
    ret 

checkBulletPos:
    ld a, e_y(ix)
    add e_h(ix)
    add #6
    cp #scr_max_y                 ;; if e->y+h > scr_max_y then delete entity
    jr nc, _s_p_u_o_e_delete
    ret 

_s_p_u_o_e_delete:
    call man_game_entity_destroy

    ret

_sys_physics_move_left:
    ld a, e_type(ix)
    and a,#e_type_player
    ret nz

    ld a, e_vx(ix)
    dec a
    ld e_vx(ix),a
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                     ;;
;;                        PUBLIC FUNCTIONS                             ;;
;;                                                                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SYS_PHYSICS_UPDATE                                                  ;; 
;; Calls for manager forall function, so it can update every entity    ;;
;; Modifies HL,BC                                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sys_physics_update::
    ld hl, #_sys_physics_update_one_entity   ;; Stores in HL update one entity address
    ld b, #e_cmp_movable
    call man_entity_forall_matching          ;; Calls for entity manager forall
    ret	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SYS_PHYSICS_SCROLL_ON                                               ;; 
;; Sets scroll to 1                                                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sys_physics_scroll_on::
    ld a, #-1
    ld (_left_scroll), a
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SYS_PHYSICS_SCROLL_OFF                                              ;; 
;; Sets scroll to 0                                                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sys_physics_scroll_off::
    ld a, #0
    ld (_left_scroll), a
    ret
