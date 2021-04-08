.include "input.h.s"
.include "man/game.h.s"
.include "man/entities.h.s"
.include "sys/generator.h.s"
.include "man/globals.h.s"

.globl cpct_scanKeyboard_f_asm
.globl cpct_isKeyPressed_asm

;; Define keys
; Keys::
Key_O:      .dw 0x0404
Key_P:      .dw 0x0803
Key_A:      .dw 0x2008
Key_Q:      .dw 0x0808
Key_M:      .dw 0x4004
Key_N:      .dw 0x4005
Key_S:      .dw 0x1007 
Key_Space:  .dw 0x8005
Key_1:      .dw 0x0108
Key_2:      .dw 0x0208
Key_Esc:    .dw 0x0408 

;; whether the space was pressed in previous iteration
Key_Space_Pressed: .db 0 
Key_S_Pressed:     .db 0
Key_M_Pressed:     .db 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                     ;;
;;                        PUBLIC FUNCTIONS                             ;;
;;                                                                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SYS_INPUT_INIT                                                      ;;
;; Initializes input system, does nothing right now                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sys_input_init::
    ret 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SYS_INPUT_UPDATE                                                    ;;
;; Checks if keys are pressed and updates character's speed, or shots  ;;
;; Also checks if the player is trying to get out of a margin, and     ;;
;; handles what happens when the player tries to go out from his area  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sys_input_update::
    call man_game_get_player

    ld e_vx(ix), #0                     ;; Sets X speed to 0
    ld e_vy(ix), #0                     ;; Sets Y speed to 0

    call cpct_scanKeyboard_f_asm        ;; Calls for scankeyboard
    
;;    ld hl, (Key_N)                      ;; Loads O keycode to HL
;;    call cpct_isKeyPressed_asm          ;; Calls for isKeyPressed
;;    jr  z, Check_S_Pressed                 ;; If O is not pressed, jumps
;;N_Pressed:
;;    call man_game_go_next_level
;;    ret  

Check_S_Pressed:
    ld hl, (Key_S)
    call cpct_isKeyPressed_asm
    jr z, S_Not_Pressed
    ld a, (Key_S_Pressed)
    or a
    jp nz, Check_M_Pressed
    call man_game_toggle_sound
    ld a, #1
    ld (Key_S_Pressed), a
    jp Check_M_Pressed
S_Not_Pressed:
    xor a
    ld (Key_S_Pressed), a

Check_M_Pressed:
    ld hl, (Key_M)
    call cpct_isKeyPressed_asm
    jr z, M_Not_Pressed
    ld a, (Key_M_Pressed)
    or a
    jp nz, Movement_Keys
    call man_game_toggle_music
    ld a, #1
    ld (Key_M_Pressed), a
    jp Movement_Keys
M_Not_Pressed:
    xor a
    ld (Key_M_Pressed), a

Movement_Keys:
    ld hl, (Key_O)                      ;; Loads O keycode to HL
    call cpct_isKeyPressed_asm          ;; Calls for isKeyPressed
    jr  z, O_NotPressed                 ;; If O is not pressed, jumps
O_Pressed:
    ld e_vx(ix), #-1                    ;; Updates X speed
O_NotPressed:
    ld hl, (Key_P)                      ;; Loads P keycode to HL
    call cpct_isKeyPressed_asm          ;; Calls for isKeyPressed
    jr z, P_NotPressed                  ;; If P is not pressed, jumps   
P_Pressed:
    ld e_vx(ix), #1                     ;; Updates X speed
P_NotPressed:
    ld hl, (Key_Q)                      ;; Loads Q keycode to HL
    call cpct_isKeyPressed_asm          ;; Calls for isKeyPressed
    jr z, Q_NotPressed                  ;; If Q is not pressed, jumps
Q_Pressed:
    ld e_vy(ix), #-2                    ;; Updates Y speed
Q_NotPressed:
    ld hl, (Key_Esc)                    ;; Loads Esc keycode to HL
    call cpct_isKeyPressed_asm          ;; Calls for isKeyPressed
    jr z, Esc_NotPressed                ;; If A is not pressed, jumps
Esc_Pressed:
    call man_game_finish
Esc_NotPressed:
    ld hl, (Key_A)                      ;; Loads A keycode to HL
    call cpct_isKeyPressed_asm          ;; Calls for isKeyPressed
    jr z, A_NotPressed                  ;; If A is not pressed, jumps
A_Pressed:
    ld e_vy(ix), #2                     ;; Updates Y speed
A_NotPressed:
    ld hl, (Key_Space)                  ;; Loads space keycode to HL
    call cpct_isKeyPressed_asm          ;; Calls for isKeyPressed
    jr z, NothingPressed                 ;; If space is not pressed, jumps
Space_Pressed:
    call man_game_get_is_car_level      ;; We dont want the player to shoot if the level is a car level
    or a
    jp nz, CheckIsMoving

    ld a, (Key_Space_Pressed)
    or a
    jp nz, CheckIsMoving
    inc a
    ld (Key_Space_Pressed), a           ;; sets the flag Key_Space_Pressed to true
    push ix
    call man_game_player_shot       
    pop ix
    jr CheckIsMoving
NothingPressed:
    ;; space key released
    xor a                      
    ld (Key_Space_Pressed), a
CheckIsMoving:
    call man_game_get_is_car_level
    or a
    jp z, not_car_level

    ld a, #1
    ld e_vx(ix), a

not_car_level:    
    ld a, e_vx(ix)
    or e_vy(ix)
    jr z, NotMoving
    ld a, #e_state_moving
    jp CheckMargins
NotMoving:
    ld a, #e_state_standing
CheckMargins:
    ld e_state(ix), a
    call sys_physics_scroll_off
    
    call man_game_get_distance_reached
    or a
    jp nz, CheckGameEnded

    ld a, e_x(ix)
    add e_vx(ix)
    cp #10
    jr c, CheckLeftMargin     
    push ix

    ;;Stuff that happens when the player walks out of his zone goes here    
    call man_gui_distance_update
    call sys_generator_enemies_update
    call sys_physics_scroll_on
    pop ix
    ld e_vx(ix), #0
    jp CheckLeftMargin

CheckGameEnded:
    ld a, e_x(ix)
    cp #60
    jp c, CheckLeftMargin
    call man_game_go_next_level
    jp exit 

CheckLeftMargin:
    ld a, e_x(ix)
    add e_vx(ix)
    cp #1
    jr nc, CheckTopMargin
    ld e_vx(ix), #0
CheckTopMargin:
    ld a, e_y(ix)
    add e_vy(ix)
    cp #scr_min_y
    jr nc, CheckBottomMargin
    ld e_vy(ix), #0
CheckBottomMargin:
    ld a, e_y(ix)
    add e_vy(ix)
    add e_h(ix)
    cp #scr_max_y
    jr c, exit    
    ld e_vy(ix), #0
exit:
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SYS_INPUT_CHECK_MENU_KEY                                            ;; 
;; Checks for the keys used in the main menu and help screen, returns  ;;
;; in A if 1 or 2 keys are pressed                                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sys_input_check_menu_key::
    call cpct_scanKeyboard_f_asm        ;; Calls for scankeyboard

    ld      hl, (Key_1)                      ;; Loads O keycode to HL
    call    cpct_isKeyPressed_asm          ;; Calls for isKeyPressed
    jr      z, notPressed_1
    ld      a, #1
    jp      end_menu_check_key

    notPressed_1:        ;; Calls for scankeyboard

    ld      hl, (Key_2)                      ;; Loads O keycode to HL
    call    cpct_isKeyPressed_asm          ;; Calls for isKeyPressed
    jr      z, notPressed_2
    ld      a, #2
    jp      end_menu_check_key

    notPressed_2:
        ld a, #0

    end_menu_check_key:

    ret
