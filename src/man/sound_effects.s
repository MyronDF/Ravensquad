.include "man/sound_effects.h.s"

playing_sound: .db 0
sound_counter: .db 60

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                     ;;
;;                        PUBLIC FUNCTIONS                             ;;
;;                                                                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAN_SOUND_EFFECTS_INIT                                              ;;
;; Initializes sound effects                                           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_sound_effects_init::
    ld de, #_msc_menu_theme         
    call cpct_akp_SFXInit_asm
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAN_SOUND_EFFECTS_PLAY                                              ;;
;; Starts playing shot sound                                           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_sound_effects_play::
    call man_game_get_sound_enabled
    or a
    ret z
    
    ld a, #1
    ld (playing_sound), a

    call cpct_getRandom_lcg_u8_asm
    ld a, l
    and #7
    ld l, a
    ld a, #60
    add l
    ld (sound_counter), a
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAN_SOUND_EFFECTS_UPDATE                                            ;;
;; Updates shot sound status                                           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_sound_effects_update::
    call man_game_get_sound_enabled
    or a
    ret z
    ld a, (playing_sound)
    or a
    ret z

    ld a, (sound_counter)
    sub #3
    ld (sound_counter), a
    cp #10
    jr nc, man_sound_effects_update_cont

    ;; finalizes playing sound
    ld a, #0
    ld (playing_sound), a
    jr man_sound_effects_update_end

    man_sound_effects_update_cont:
    push de
    push hl
    push bc

    ld l, #1            ;; Number of the instrument in the SFX Song (>0), same as the number given to the instrument in Arkos Tracker.
    ld h, #15           ;; Volume [0-15], 0 = off, 15 = maximum volume.
    ld d, #0            ;; Speed (0 = As original, [1-255] = new Speed (1 is fastest))
    ld e, a             ;; Note to be played with the given instrument [0-143]
    ld bc, #0x0000      ;; Inverted Pitch (-0xFFFF -> 0xFFFF).  0 is no pitch.  The higher the pitch, the lower the sound.
    ld a, #7            ;; Bitmask representing channels to use for reproducing the sound (Ch.A = 001 (1), Ch.B = 010 (2), Ch.C = 100 (4))    
    call cpct_akp_SFXPlay_asm

    pop bc
    pop hl
    pop de

    man_sound_effects_update_end:
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                     ;;
;;                        PRIVATE FUNCTIONS                            ;;
;;                                                                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAN_SOUND_EFFECTS_PLAY                                              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_sound_effects_play_test::
    ld a, #60

    sfx_loop:
        ld l, #1            ;; Number of the instrument in the SFX Song (>0), same as the number given to the instrument in Arkos Tracker.
        ld h, #15           ;; Volume [0-15], 0 = off, 15 = maximum volume.
        ld e, a             ;; Note to be played with the given instrument [0-143]
        ld d, #0            ;; Speed (0 = As original, [1-255] = new Speed (1 is fastest))
        ld bc, #0x0000      ;; Inverted Pitch (-0xFFFF -> 0xFFFF).  0 is no pitch.  The higher the pitch, the lower the sound.
        push af
        ld a, #7            ;; Bitmask representing channels to use for reproducing the sound (Ch.A = 001 (1), Ch.B = 010 (2), Ch.C = 100 (4))    
        call cpct_akp_SFXPlay_asm
        call cpct_akp_musicPlay_asm    
        pop af
        add a,#-1
        cp a, #10
        jr nc, sfx_loop    

    ret