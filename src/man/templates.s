.include "templates.h.s"
.include "man/entities.h.s"
.include "sys/animations.h.s"

;; PLAYER entity default values
player_tmpl::
    .db e_type_player                                   ; entity type
    .db e_cmp_input | e_cmp_render | e_cmp_movable | e_cmp_collider | e_cmp_anim ; components
    .db 2, 100                                          ; x, y
    .db 6, 20                                           ; w, h
    .db 0, 0                                            ; vx, vy
    .db 0, 0                                            ; e_lastX, e_lastY
    .dw 0x0000                                          ; behaviour
    .db 0                                               ; behaviour counter
    .dw #_spr_player_0                                  ; sprite
    .dw #man_anim_player                                ; animation
    .db #man_anim_player_time                           ; animation counter
    .db e_type_enemy | e_type_enemy_shot | e_type_object | e_type_enemy_background
    .db 0
    .dw #_spr_player_0                                  ; sprite
    .db 9                                               ; shot y relative  position
    .db 0                                               ; damage
    .db 1                                               ; strength
    .db 2
    .db 1
    .db 4
    .db 18


;; SOLDIER entity default values
enemy_tmpl::
    .db e_type_enemy                                    ; entity type
    .db e_cmp_render | e_cmp_collider | e_cmp_movable | e_cmp_ai | e_cmp_anim ; components
    .db 0, 100                                          ; x, y
    .db 6, 20                                           ; w, h
    .db 0, -1                                           ; vx, vy
    .db 0, 0                                            ; e_lastX, e_lastY
    .dw #sys_ai_behaviour_patrol_top_down               ; behaviour
    .db 10                                              ; behaviour counter
    .dw #_spr_enemy_soldier_0                           ; sprite
    .dw #man_anim_enemy_soldier                         ; animation
    .db #man_anim_player_time                           ; animation counter
    .db e_type_player_shot
    .db #e_state_moving
    .dw #_spr_enemy_soldier_0                           ; sprite
    .db 8                                               ; shot y relative  position
    .db 1                                               ; damage
    .db 1                                               ; strength
    .db 2
    .db 1
    .db 4
    .db 18

;; SOLDIER entity default values
enemy_top_patrol_tmpl::
    .db e_type_enemy                                    ; entity type
    .db e_cmp_render | e_cmp_collider | e_cmp_movable | e_cmp_ai | e_cmp_anim ; components
    .db 0, 100                                          ; x, y
    .db 6, 20                                           ; w, h
    .db 0, -1                                           ; vx, vy
    .db 0, 0                                            ; e_lastX, e_lastY
    .dw #sys_ai_behaviour_patrol_top                    ; behaviour
    .db 10                                              ; behaviour counter
    .dw #_spr_enemy_soldier_0                           ; sprite
    .dw #man_anim_enemy_soldier                         ; animation
    .db #man_anim_player_time                           ; animation counter
    .db e_type_player_shot
    .db #e_state_moving
    .dw #_spr_enemy_soldier_0                           ; sprite
    .db 8                                               ; shot y relative  position
    .db 1                                               ; damage
    .db 1                                               ; strength
    .db 2
    .db 2
    .db 4
    .db 18

;; SOLDIER entity default values
enemy_bot_patrol_tmpl::
    .db e_type_enemy                                    ; entity type
    .db e_cmp_render | e_cmp_collider | e_cmp_movable | e_cmp_ai | e_cmp_anim ; components
    .db 0, 100                                          ; x, y
    .db 6, 20                                           ; w, h
    .db 0, -1                                           ; vx, vy
    .db 0, 0                                            ; e_lastX, e_lastY
    .dw #sys_ai_behaviour_patrol_bot                    ; behaviour
    .db 10                                              ; behaviour counter
    .dw #_spr_enemy_soldier_0                           ; sprite
    .dw #man_anim_enemy_soldier                         ; animation
    .db #man_anim_player_time                           ; animation counter
    .db e_type_player_shot
    .db #e_state_moving
    .dw #_spr_enemy_soldier_0                           ; sprite
    .db 8                                               ; shot y relative  position
    .db 1                                               ; damage
    .db 1                                               ; strength
    .db 2
    .db 2
    .db 4
    .db 18

;; SOLDIER entity default values
enemy_commander_tmpl::
    .db e_type_enemy                                    ; entity type
    .db e_cmp_render | e_cmp_collider | e_cmp_movable | e_cmp_ai | e_cmp_anim ; components
    .db 0, 100                                          ; x, y
    .db 6, 20                                           ; w, h
    .db 0, -1                                           ; vx, vy
    .db 0, 0                                            ; e_lastX, e_lastY
    .dw #sys_ai_behaviour_track_player                  ; behaviour
    .db 20                                              ; behaviour counter
    .dw #_spr_enemy_commander_0                         ; sprite
    .dw #man_anim_enemy_commander                       ; animation
    .db #man_anim_player_time                           ; animation counter
    .db e_type_player_shot
    .db #e_state_moving
    .dw #_spr_enemy_commander_0                         ; sprite
    .db 8                                               ; shot y relative  position
    .db 1                                               ; damage
    .db 3                                               ; strength
    .db 2
    .db 2
    .db 4
    .db 18

;; PLAYER SHOT entity default values
player_shot_tmpl::
    .db e_type_player_shot                              ; entity type
    .db e_cmp_hidetrack| e_cmp_render | e_cmp_collider | e_cmp_movable ; components
    .db 38, 96                                          ; x, y
    .db 1, 1                                            ; w, h
    .db 2, 0                                            ; vx, vy  DO NOT CHANGE VY
    .db 0, 0                                            ; e_lastX, e_lastY
    .dw 0x0000                                          ; behaviour
    .db 0                                               ; behaviour counter
    .dw 0x0000                                          ; sprite
    .dw 0x0000                                          ; animation
    .db 0                                               ; animation counter
    .db e_type_enemy
    .db 0
    .dw 0x0000                                          ; sprite
    .db 0                                               ; shot y relative  position
    .db 1                                               ; damage
    .db 0                                               ; strength
    .db 0
    .db 0
    .db 1
    .db 1

;; ENEMY SHOT template
enemy_shot_tmpl::
    .db e_type_enemy_shot                               ; entity type
    .db e_cmp_hidetrack| e_cmp_render | e_cmp_collider | e_cmp_movable ; components
    .db 38, 96                                          ; x, y
    .db 1, 1                                            ; w, h
    .db -2, 0                                           ; vx, vy  DO NOT CHANGE VY
    .db 0, 0                                            ; e_lastX, e_lastY
    .dw 0x0000                                          ; behaviour
    .db 0                                               ; behaviour counter
    .dw 0x0000                                          ; sprite
    .dw 0x0000                                          ; animation
    .db 0                                               ; animation counter
    .db e_type_player
    .db 0
    .dw 0x0000                                          ; sprite
    .db 0                                               ; shot y relative  position
    .db 1                                               ; damage
    .db 0                                               ; strength
    .db 0
    .db 0
    .db 1
    .db 1

;; TRENCH entity default values
trench_tmpl::
    .db e_type_enemy                                    ; entity type
    .db e_cmp_render | e_cmp_collider | e_cmp_movable | e_cmp_ai ; components
    .db 0, 100                                          ; x, y
    .db 11, 22                                          ; w, h
    .db 0, 0                                            ; vx, vy
    .db 0, 0                                            ; e_lastX, e_lastY
    .dw #sys_ai_behaviour_trench_explosive              ; behaviour
    .db 10                                              ; behaviour counter
    .dw #_spr_enemy_trench                              ; sprite
    .dw 0x0000                                          ; animation
    .db 0                                               ; animation counter
    .db e_type_player_shot
    .db 0
    .dw #_spr_enemy_trench                              ; sprite
    .db 6                                               ; shot y relative  position
    .db 1                                               ; damage
    .db 6                                               ; strength
    .db 1
    .db 1
    .db 10
    .db 20

;; TURRET entity default values
turret_tmpl::
    .db e_type_enemy                                    ; entity type
    .db e_cmp_render | e_cmp_collider | e_cmp_movable | e_cmp_ai ; components
    .db 0, 100                                          ; x, y
    .db 10, 18                                          ; w, h
    .db 0, 0                                            ; vx, vy
    .db 0, 0                                            ; e_lastX, e_lastY
    .dw #sys_ai_behaviour_inmovile_enemy                ; behaviour
    .db 10                                              ; behaviour counter
    .dw #_spr_enemy_turret                              ; sprite
    .dw 0x0000                                          ; animation
    .db 0                                               ; animation counter
    .db e_type_player_shot
    .db 0
    .dw #_spr_enemy_turret                              ; sprite
    .db 6                                               ; shot y relative  position
    .db 1                                               ; damage
    .db 4                                               ; strength
    .db 0
    .db 0
    .db 8
    .db 18

;; FLOWER background object default values
flower_tmpl::
    .db e_type_background_object                        ; entity type
    .db e_cmp_render | e_cmp_movable                    ; components
    .db 0, 100                                          ; x, y
    .db 5, 10                                           ; w, h
    .db 0, 0                                            ; vx, vy
    .db 0, 0                                            ; e_lastX, e_lastY
    .dw 0x0000                                          ; behaviour
    .db 0                                               ; behaviour counter
    .dw #_spr_background_flower                         ; sprite
    .dw 0x0000                                          ; animation
    .db 0                                               ; animation counter
    .db #0x00
    .db 0
    .dw #_spr_background_flower                         ; sprite
    .db 0                                               ; shot y relative  position
    .db 0                                               ; damage
    .db 0                                               ; strength
    .db 0
    .db 0
    .db 0
    .db 0
    
;; GRASS background object default values
grass_tmpl::
    .db e_type_background_object                        ; entity type
    .db e_cmp_render | e_cmp_movable | e_cmp_background ; components
    .db 0, 100                                          ; x, y
    .db 4, 6                                            ; w, h
    .db 0, 0                                            ; vx, vy
    .db 0, 0                                            ; e_lastX, e_lastY
    .dw 0x0000                                          ; behaviour
    .db 0                                               ; behaviour counter
    .dw #_spr_background_grass                          ; sprite
    .dw 0x0000                                          ; animation
    .db 0                                               ; animation counter
    .db 0x00
    .db 0
    .dw #_spr_background_grass                          ; sprite
    .db 0                                               ; shot y relative  position
    .db 0                                               ; damage
    .db 0                                               ; strength
    .db 0
    .db 0
    .db 0
    .db 0

enemy_tank_tmpl::
    .db e_type_enemy                                    ; entity type
    .db e_cmp_render | e_cmp_collider | e_cmp_movable | e_cmp_ai ; components
    .db 0, 100                                          ; x, y
    .db 15, 19                                          ; w, h
    .db 0, 0                                            ; vx, vy
    .db 0, 0                                            ; e_lastX, e_lastY
    .dw #sys_ai_behaviour_tank                          ; behaviour
    .db 10                                              ; behaviour counter
    .dw #_spr_enemy_tank                                ; sprite
    .dw 0x0000                                          ; animation
    .db 0                                               ; animation counter
    .db e_type_player_shot
    .db 0
    .dw #_spr_enemy_tank                                ; sprite
    .db 4                                               ; shot y relative  position
    .db 1                                               ; damage
    .db 8                                               ; strength
    .db 0
    .db 1
    .db 13
    .db 19

enemy_mortar_tmpl::
    .db e_type_enemy                                    ; entity type
    .db e_cmp_render | e_cmp_collider | e_cmp_movable | e_cmp_ai | e_cmp_anim ; components
    .db 0, 100                                          ; x, y
    .db 8, 16                                           ; w, h
    .db 0, 0                                            ; vx, vy
    .db 0, 0                                            ; e_lastX, e_lastY
    .dw #sys_ai_behaviour_mortar                        ; behaviour
    .db 36                                              ; behaviour counter
    .dw #_spr_enemy_mortar_0                            ; sprite
    .dw #man_anim_enemy_mortar                          ; animation
    .db 36                                              ; animation counter
    .db e_type_player_shot
    .db #e_state_moving
    .dw #_spr_enemy_mortar_0                            ; sprite
    .db 4                                               ; shot y relative  position
    .db 1                                               ; damage
    .db 4                                               ; strength
    .db 0
    .db 0
    .db 6
    .db 16

;; KEEP OUT sign background object default values
keep_out_sign_tmpl::
    .db e_type_background_object                        ; entity type
    .db e_cmp_render | e_cmp_movable                    ; components
    .db 0, 100                                          ; x, y
    .db 11, 18                                          ; w, h
    .db 0, 0                                            ; vx, vy
    .db 0, 0                                            ; e_lastX, e_lastY
    .dw 0x0000                                          ; behaviour
    .db 0                                               ; behaviour counter
    .dw #_spr_background_keepout                        ; sprite
    .dw 0x0000                                          ; animation
    .db 0                                               ; animation counter
    .db 0x00
    .db 0
    .dw #_spr_background_keepout                        ; sprite
    .db 0                                               ; shot y relative  position
    .db 0                                               ; damage
    .db 0                                               ; strength
    .db 0
    .db 0
    .db 0
    .db 0

enemy_dog_tmpl::
    .db e_type_enemy                                    ; entity type
    .db e_cmp_render | e_cmp_movable | e_cmp_ai | e_cmp_anim | e_cmp_collider ; components
    .db 0, 100                                          ; x, y
    .db 6, 20                                           ; w, h
    .db -1, 0                                           ; vx, vy
    .db 0, 0                                            ; e_lastX, e_lastY
    .dw #sys_ai_enemy_dog                               ; behaviour
    .db 0                                               ; behaviour counter
    .dw #_spr_enemy_dog_0                               ; sprite
    .dw #man_anim_dog                                   ; animation
    .db #man_anim_dog_time                              ; animation counter
    .db e_type_player_shot
    .db #e_state_moving
    .dw #_spr_enemy_dog_0                               ; sprite
    .db 0                                               ; shot y relative  position
    .db 1                                               ; damage
    .db 0                                               ; strength
    .db 0
    .db 2
    .db 4
    .db 20

background_end_level_building_tmpl::
    .db e_type_background_object                        ; entity type
    .db e_cmp_render | e_cmp_movable                    ; components
    .db 0, 100                                          ; x, y
    .db 10, 60                                          ; w, h
    .db 0, 0                                            ; vx, vy
    .db 0, 0                                            ; e_lastX, e_lastY
    .dw 0x0000                                          ; behaviour
    .db 0                                               ; behaviour counter
    .dw #_spr_background_end_level_building             ; sprite
    .dw 0x0000                                          ; animation
    .db 0                                               ; animation counter
    .db 0x00
    .db 0
    .dw #_spr_background_end_level_building             ; sprite
    .db 0                                               ; shot y relative  position
    .db 0                                               ; damage
    .db 0                                               ; strength
    .db 0
    .db 0
    .db 0
    .db 0

enemy_barbed_wire_tmpl::
    .db e_type_enemy_background
    .db e_cmp_render | e_cmp_movable | e_cmp_collider
    .db 0, 100
    .db 3, 55
    .db 0, 0
    .db 0, 0
    .dw 0x0000
    .db 0
    .dw #_spr_enemy_barbed_wire
    .dw 0x0000
    .db 0
    .db 0x00
    .db 0
    .dw #_spr_enemy_barbed_wire
    .db 0
    .db 1                                               ; damage
    .db 99                                              ; strength
    .db 0
    .db 0
    .db 2
    .db 55

;; CAPTURED ALLY background object default values
background_captured_ally_tmpl::
    .db e_type_background_object                        ; entity type
    .db e_cmp_render                                    ; components
    .db 0, 103                                          ; x, y
    .db 4, 16                                           ; w, h
    .db 0, 0                                            ; vx, vy
    .db 0, 0                                            ; e_lastX, e_lastY
    .dw 0x0000                                          ; behaviour
    .db 0                                               ; behaviour counter
    .dw #_spr_background_captured_ally                  ; sprite
    .dw 0x0000                                          ; animation
    .db 0                                               ; animation counter
    .db 0x00
    .db 0
    .dw #_spr_background_captured_ally                  ; sprite
    .db 0                                               ; shot y relative  position
    .db 0                                               ; damage
    .db 0                                               ; strength
    .db 0
    .db 0
    .db 0
    .db 0

;; CAPTURED ALLY background object default values
effect_explosion_tmpl::
    .db e_type_background_object                        ; entity type
    .db e_cmp_render | e_cmp_anim | e_cmp_movable | e_cmp_ai | e_cmp_hidetrack ; components
    .db 0, 100                                          ; x, y
    .db 3, 5                                            ; w, h
    .db 0, 0                                            ; vx, vy
    .db 0, 0                                            ; e_lastX, e_lastY
    .dw #sys_ai_behaviour_explosion                     ; behaviour
    .db 16                                              ; behaviour counter
    .dw #_spr_bullet_destruction_0                      ; sprite
    .dw #man_anim_bullet_destruction                    ; animation
    .db #man_anim_player_time                           ; animation counter
    .db 0x00
    .db #e_state_moving
    .dw #_spr_bullet_destruction_0                      ; sprite
    .db 0                                               ; shot y relative  position
    .db 0                                               ; damage
    .db 0                                               ; strength
    .db 0
    .db 0
    .db 0
    .db 0

;; CAPTURED ALLY background object default values
object_1_up_tmpl::
    .db e_type_object                                   ; entity type
    .db e_cmp_render | e_cmp_movable | e_cmp_collider   ; components
    .db 0, 100                                          ; x, y
    .db 4, 7                                            ; w, h
    .db 0, 0                                            ; vx, vy
    .db 0, 0                                            ; e_lastX, e_lastY
    .dw #0x0000                                         ; behaviour
    .db 0                                               ; behaviour counter
    .dw #_spr_object_1_up                               ; sprite
    .dw #0x0000                                         ; animation
    .db 0                                               ; animation counter
    .db 0x00
    .db 0
    .dw #_spr_object_1_up                               ; sprite
    .db 0                                               ; shot y relative  position
    .db 0                                               ; damage
    .db 0                                               ; strength
    .db 0
    .db 0
    .db 3
    .db 7

enemy_gatling_tmpl::
    .db e_type_enemy                                    ; entity type
    .db e_cmp_render | e_cmp_collider | e_cmp_movable | e_cmp_ai | e_cmp_anim ; components
    .db 0, 100                                          ; x, y
    .db 11, 16                                          ; w, h
    .db 0, 0                                            ; vx, vy
    .db 0, 0                                            ; e_lastX, e_lastY
    .dw #sys_ai_behaviour_gatling                       ; behaviour
    .db 30                                              ; behaviour counter
    .dw #_spr_enemy_gatling_0                           ; sprite
    .dw #man_anim_gatling                               ; animation
    .db #man_anim_player_time                           ; animation counter
    .db e_type_player_shot
    .db #e_state_moving
    .dw #_spr_enemy_gatling_0                           ; sprite
    .db 9                                               ; shot y relative  position
    .db 1                                               ; damage
    .db 6                                               ; strength
    .db 0
    .db 0
    .db 10
    .db 16

enemy_pop_door_tmpl::
    .db e_type_enemy                                    ; entity type
    .db e_cmp_render | e_cmp_collider | e_cmp_movable | e_cmp_anim | e_cmp_ai ; components
    .db 0, 100                                          ; x, y
    .db 9, 38                                           ; w, h
    .db 0, 0                                            ; vx, vy
    .db 0, 0                                            ; e_lastX, e_lastY
    .dw #sys_ai_pop_door                                ; behaviour
    .db 0                                               ; behaviour counter
    .dw #_spr_enemy_pop_door_0                          ; sprite
    .dw #man_anim_pop_door                              ; animation
    .db #man_anim_pop_door_standing                     ; animation counter
    .db 0
    .db #e_state_moving
    .dw #_spr_enemy_pop_door_0                          ; sprite
    .db 0                                               ; shot y relative  position
    .db 1                                               ; damage
    .db 99                                              ; strength
    .db 0
    .db 0
    .db 8
    .db 38

enemy_tank_explosion_tmpl::
    .db e_type_enemy_background                         ; entity type
    .db e_cmp_render | e_cmp_collider | e_cmp_movable | e_cmp_anim | e_cmp_ai ; components
    .db 0, 100                                          ; x, y
    .db 11, 20                                          ; w, h
    .db 0, 0                                            ; vx, vy
    .db 0, 0                                            ; e_lastX, e_lastY
    .dw #sys_ai_behaviour_explosion                     ; behaviour
    .db 10                                              ; behaviour counter
    .dw #_spr_anim_enemy_explosion_0                    ; sprite
    .dw #man_anim_enemy_explosion                       ; animation
    .db #man_anim_enemy_explosion_time                  ; animation counter
    .db 0
    .db #e_state_moving
    .dw #_spr_anim_enemy_explosion_0                    ; sprite
    .db 0                                               ; shot y relative  position
    .db 1                                               ; damage
    .db 99                                              ; strength
    .db 1
    .db 2
    .db 10
    .db 19

enemy_claymore_tmpl::
    .db e_type_enemy                                    ; entity type
    .db e_cmp_render | e_cmp_collider | e_cmp_movable | e_cmp_anim ; components
    .db 0, 100                                          ; x, y
    .db 6, 7                                            ; w, h
    .db 0, 0                                            ; vx, vy
    .db 0, 0                                            ; e_lastX, e_lastY
    .dw #0x0000                                         ; behaviour
    .db 0                                               ; behaviour counter
    .dw #_spr_enemy_claymore_0                          ; sprite
    .dw #man_anim_enemy_claymore                        ; animation
    .db #man_anim_enemy_claymore_time                   ; animation counter
    .db 0
    .db #e_state_moving
    .dw #_spr_enemy_claymore_0                          ; sprite
    .db 0                                               ; shot y relative  position
    .db 1                                               ; damage
    .db 99                                              ; strength
    .db 0
    .db 0
    .db 5
    .db 7

enemy_stone_tmpl::
    .db e_type_enemy                                    ; entity type
    .db e_cmp_render | e_cmp_collider | e_cmp_movable   ; components
    .db 0, 100                                          ; x, y
    .db 8, 14                                           ; w, h
    .db 0, 0                                            ; vx, vy
    .db 0, 0                                            ; e_lastX, e_lastY
    .dw #0x0000                                         ; behaviour
    .db 0                                               ; behaviour counter
    .dw #_spr_enemy_stone                               ; sprite
    .dw 0x0000                                          ; animation
    .db 0                                               ; animation counter
    .db 0
    .db 0
    .dw #_spr_enemy_stone                               ; sprite
    .db 0                                               ; shot y relative  position
    .db 1                                               ; damage
    .db 99                                              ; strength
    .db 0
    .db 0
    .db 7
    .db 14

enemy_boss_chest_tmpl::
    .db e_type_enemy                                    ; entity type
    .db e_cmp_render | e_cmp_collider | e_cmp_movable | e_cmp_anim | e_cmp_ai ; components
    .db 0, 100                                          ; x, y
    .db 14, 30                                          ; w, h
    .db 0, 0                                            ; vx, vy
    .db 0, 0                                            ; e_lastX, e_lastY
    .dw #sys_ai_behaviour_boss_chest_ai                 ; behaviour
    .db 20                                              ; behaviour counter
    .dw #_spr_enemy_boss_chest_0                        ; sprite
    .dw #man_anim_enemy_boss_chest                      ; animation
    .db #man_anim_player_time                           ; animation counter
    .db #e_type_player_shot
    .db #e_state_moving
    .dw #_spr_enemy_boss_chest_0                        ; sprite
    .db 25                                              ; shot y relative  position
    .db 1                                               ; damage
    .db 104                                             ; strength
    .db 1
    .db 2
    .db 27
    .db 27

enemy_boss_right_arm_tmpl::
    .db e_type_enemy                                    ; entity type
    .db e_cmp_render | e_cmp_collider | e_cmp_movable | e_cmp_ai  ; components
    .db 0, 100                                          ; x, y
    .db 14, 16                                          ; w, h
    .db 0, 1                                            ; vx, vy
    .db 0, 0                                            ; e_lastX, e_lastY
    .dw #sys_ai_behaviour_boss_right_arm                ; behaviour
    .db 20                                              ; behaviour counter
    .dw #_spr_enemy_boss_right_arm                      ; sprite
    .dw 0x0000                                          ; animation
    .db 0                                               ; animation counter
    .db #e_type_player_shot
    .db 0
    .dw #_spr_enemy_boss_right_arm                      ; sprite
    .db 10                                              ; shot y relative  position
    .db 1                                               ; damage
    .db 20                                              ; strength
    .db 1
    .db 2
    .db 27
    .db 14

enemy_boss_left_arm_tmpl::
    .db e_type_enemy                                    ; entity type
    .db e_cmp_render | e_cmp_collider | e_cmp_movable | e_cmp_ai   ; components
    .db 0, 100                                          ; x, y
    .db 14, 16                                          ; w, h
    .db 0, 1                                            ; vx, vy
    .db 0, 0                                            ; e_lastX, e_lastY
    .dw #sys_ai_behaviour_boss_left_arm                 ; behaviour
    .db 20                                              ; behaviour counter
    .dw #_spr_enemy_boss_left_arm                       ; sprite
    .dw 0x0000                                          ; animation
    .db 0                                               ; animation counter
    .db #e_type_player_shot
    .db 0
    .dw #_spr_enemy_boss_left_arm                       ; sprite
    .db 10                                              ; shot y relative  position
    .db 1                                               ; damage
    .db 20                                              ; strength
    .db 1
    .db 2
    .db 27
    .db 14