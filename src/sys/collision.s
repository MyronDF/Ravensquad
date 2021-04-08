.include "collision.h.s"
.include "man/entities.h.s"
.include "man/GUI.h.s"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                     ;;
;;                        PUBLIC FUNCTIONS                             ;;
;;                                                                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SYS_COLLISION_CHECK                                                 ;;
;; Checks collision between entity in ix and entity in iy              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sys_collision_check::
    X_LOOP:
    ld A, e_type(ix)
    or A
    jr z, END

    push ix
    pop iy
    ld bc, #sizeof_e
    add iy, bc

    jp Y_LOOP
    
    END:
        ret 

    Y_LOOP:
        ld A, e_type(iy)
        or A
        jr z, END_Y_LOOP
        
        ld A, e_type(iy)
        and #e_type_dead
        jr nz, next_enemy

        ld A, e_cmps(iy)
        and #e_cmp_collider
        jr z, next_enemy

        ld A, e_type(iy)
        and e_collides_with(ix)
        or a
        jr z, next_enemy

        BOUNDINGBOX_START:
            ld a, e_y(ix)
            add e_end_Y(ix)
            sub e_start_Y(iy)
            sub e_y(iy)
            jr c, next_enemy

            ld a, e_y(iy)
            add e_end_Y(iy)
            sub e_start_Y(ix)
            sub e_y(ix)
            jr c, next_enemy

            ld a, e_x(ix)       ;;[19]
            add e_end_X(ix)         ;;[4]
            sub e_start_X(iy)
            sub e_x(iy)         ;;[4]
            jr c, next_enemy

            ld a, e_x(iy)
            add e_end_X(iy)
            sub e_start_X(iy)
            sub e_x(ix)
            jr c, next_enemy

            ;; we have a colligions, destroys both entities
            call man_collision_handler_handle_collision   

            ld A, e_type(iy)
            and #e_type_object
            or a
            jp nz, next_enemy

            ld A, e_type(ix)
            and #e_type_player
            or a
            jr nz, PLAYER_DEAD

            jr END_Y_LOOP

            next_enemy:
                ld bc, #sizeof_e
                add iy, bc
                jp Y_LOOP
    END_Y_LOOP:
        ld bc, #sizeof_e
        add ix, bc
        jp X_LOOP

    PLAYER_DEAD:
        call man_gui_lives_down
        call man_gui_reset_distance

        ret