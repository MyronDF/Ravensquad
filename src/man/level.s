.include "level.h.s"
.include "man/enemy.h.s"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LEVEL 1 ENTITIES ORDERED BY APPEARANCE                                            ;;
;; First three bytes are the distance already in asci                                ;;
;; The following bytes are the data of the enemies present on that level             ;;
;; The data is structured in sets of 3 bytes.                                        ;;   
;; - The first byte is what the player must go through for that enemy to appear      ;;
;; - The second byte is the Y position that the enemy will have when it is generated ;;
;; - The third byte is the type of enemy to be created                               ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

level_1::
    .dw   270
    .db    27
  ;;     Counter  Y_pos  Enemy_type
    .db    30,     50, enemy_type_patrol_top
    .db    20,    135, enemy_type_patrol_bottom
    .db    20,     45, enemy_type_soldier
    .db    20,    145, enemy_type_soldier
    .db    20,     85, enemy_type_soldier
    .db    30,     40, enemy_type_patrol_top
    .db     0,    135, enemy_type_patrol_bottom
    .db    18,     45, enemy_type_soldier
    .db     6,    135, enemy_type_soldier
    .db     6,     85, enemy_type_soldier
    .db    26,     55, enemy_type_patrol_top
    .db     0,    135, enemy_type_patrol_bottom
    .db     4,     85, enemy_type_soldier
    .db    22,     55, enemy_type_patrol_top
    .db     0,    135, enemy_type_patrol_bottom
    .db    14,     85, enemy_type_dog
    .db     4,     20, enemy_type_barbed_wire
    .db     0,    120, enemy_type_barbed_wire
    .db    14,     45, background_type_end_level_building
    .db   255,     80, enemy_type_soldier  ;; End level entity, used so we dont spawn random stuff

level_2::
    .dw   240
    .db    24
;;     Counter  Y_pos  Enemy_type
    .db    10,     20, enemy_type_patrol_top
    .db     0,    101, enemy_type_patrol_bottom
    .db     4,     80, enemy_type_patrol_top
    .db     0,    170, enemy_type_patrol_bottom
    .db    16,    105, enemy_type_soldier
    .db    10,     45, enemy_type_soldier
    .db    20,     45, enemy_type_patrol_top
    .db     0,    145, enemy_type_patrol_bottom
    .db     4,    101, enemy_type_soldier
    .db    26,     40, enemy_type_soldier
    .db     4,    120, enemy_type_patrol_bottom
    .db     0,     80, enemy_type_patrol_top
    .db     4,     40, enemy_type_dog
    .db    22,     30, enemy_type_patrol_top
    .db     0,    120, enemy_type_patrol_bottom
    .db     4,     60, enemy_type_dog
    .db     4,    140, enemy_type_dog
    .db    22,     20, enemy_type_patrol_top
    .db     0,    101, enemy_type_patrol_bottom
    .db     4,     80, enemy_type_soldier
    .db    26,    160, enemy_type_soldier
    .db     4,     70, enemy_type_dog
    .db     8,     90, enemy_type_dog
    .db     9,     85, enemy_type_turret
    .db     4,     20, enemy_type_barbed_wire
    .db     0,    120, enemy_type_barbed_wire
    .db    14,     45, background_type_end_level_building
    .db   255,     80, enemy_type_soldier  ;; End level entity, used so we dont spawn random stuff


level_3::
    .dw   750
    .db    75
;;     Counter  Y_pos  Enemy_type
    .db    30,     75, enemy_type_stone
    .db    20,     50, enemy_type_stone
    .db    20,    135, enemy_type_stone
    .db    20,     85, enemy_type_stone
    .db    20,     30, enemy_type_stone
    .db    20,    100, enemy_type_stone
    .db    20,    135, enemy_type_stone
    .db    20,     30, enemy_type_stone
    .db    20,    175, enemy_type_stone
    .db    20,     80, enemy_type_stone
    .db    16,     40, enemy_type_stone
    .db     0,     60, enemy_type_stone
    .db     4,     50, enemy_type_turret
    .db    10,    140, enemy_type_stone
    .db    10,    160, enemy_type_stone
    .db    10,    175, enemy_type_stone
    .db    10,     30, enemy_type_stone
    .db    10,     50, enemy_type_stone
    .db    10,     70, enemy_type_stone
    .db    10,     90, enemy_type_stone
    .db    10,    170, enemy_type_stone
    .db     0,     80, enemy_type_stone
    .db    10,    160, enemy_type_stone
    .db     0,     70, enemy_type_stone
    .db    10,    150, enemy_type_stone
    .db     0,     60, enemy_type_stone
    .db    10,    140, enemy_type_stone
    .db     0,     50, enemy_type_stone
    .db    10,    130, enemy_type_stone
    .db     0,     40, enemy_type_stone
    .db    10,    120, enemy_type_stone
    .db     0,     30, enemy_type_stone
    .db    10,    110, enemy_type_stone
    .db     0,     20, enemy_type_stone
    .db    10,    100, enemy_type_stone
    .db    10,     90, enemy_type_stone
    .db    10,     80, enemy_type_stone
    .db    10,     70, enemy_type_stone
    .db    10,     60, enemy_type_stone
    .db    30,     20, enemy_type_stone
    .db    36,     40, enemy_type_stone
    .db     0,     20, enemy_type_stone
    .db     4,     30, enemy_type_turret
    .db    10,     60, enemy_type_stone
    .db    10,     80, enemy_type_stone
    .db     0,     40, enemy_type_stone
    .db    10,    100, enemy_type_stone
    .db    10,    120, enemy_type_stone
    .db    10,    100, enemy_type_stone
    .db    10,     80, enemy_type_stone
    .db    46,    110, enemy_type_stone
    .db     0,    130, enemy_type_stone
    .db     4,    120, enemy_type_turret
    .db    10,     30, enemy_type_stone
    .db    10,    130, enemy_type_stone
    .db    10,     50, enemy_type_stone
    .db    10,    150, enemy_type_stone
    .db    10,     70, enemy_type_stone
    .db    30,     50, enemy_type_turret
    .db     0,    130, enemy_type_turret
    .db    10,     20, enemy_type_barbed_wire
    .db     0,    120, enemy_type_barbed_wire
    .db   255,     80, enemy_type_soldier  ;; End level entity, used so we dont spawn random stuff


level_4::
    .dw   340
    .db    34
;;     Counter  Y_pos  Enemy_type
    .db    12,     20, enemy_type_barbed_wire
    .db     0,    120, enemy_type_barbed_wire
    .db     8,     78, enemy_type_turret
    .db     0,     98, enemy_type_turret
    .db    10,     20, enemy_type_patrol_top
    .db     0,    101, enemy_type_patrol_bottom
    .db    10,    140, enemy_type_soldier
    .db    10,     60, enemy_type_soldier
    .db    10,     80, enemy_type_dog
    .db    22,     80, enemy_type_barbed_wire
    .db     0,    120, enemy_type_barbed_wire
    .db     4,     40, enemy_type_turret
    .db     4,    101, enemy_type_patrol_bottom
    .db     4,    170, enemy_type_patrol_bottom
    .db    32,     55, enemy_type_patrol_top
    .db     0,    135, enemy_type_patrol_bottom
    .db     4,     85, enemy_type_soldier
    .db    20,     95, enemy_type_soldier
    .db    16,    140, enemy_type_soldier
    .db     4,     70, enemy_type_dog
    .db    24,     80, enemy_type_barbed_wire
    .db     6,     40, enemy_type_turret
    .db     0,    150, enemy_type_turret
    .db    32,     10, enemy_type_patrol_top
    .db     0,    101, enemy_type_patrol_bottom
    .db     4,     40, enemy_type_patrol_top
    .db     0,    150, enemy_type_patrol_bottom
    .db     4,    101, enemy_type_soldier
    .db    10,     40, enemy_type_soldier
    .db    10,    140, enemy_type_soldier
    .db    10,     80, enemy_type_soldier
    .db    25,     85, enemy_type_trench
    .db     4,     20, enemy_type_barbed_wire
    .db     0,    120, enemy_type_barbed_wire
    .db    14,     45, background_type_end_level_building
    .db   255,     80, enemy_type_soldier  ;; End level entity, used so we dont spawn random stuff


level_5::
    .dw   450
    .db    45
;;     Counter  Y_pos  Enemy_type
    .db    12,     20, enemy_type_barbed_wire
    .db     0,    120, enemy_type_barbed_wire
    .db     8,     85, enemy_type_turret
    .db    26,     80, enemy_type_trench
    .db     4,     20, enemy_type_barbed_wire
    .db     0,    120, enemy_type_barbed_wire
    .db    32,     20, enemy_type_barbed_wire
    .db     0,     75, enemy_type_barbed_wire
    .db     8,    140, enemy_type_trench
    .db    30,     80, enemy_type_barbed_wire
    .db     0,    120, enemy_type_barbed_wire
    .db     8,     15, enemy_type_trench
    .db     0,     50, enemy_type_trench
    .db    28,     65, enemy_type_trench
    .db     0,    105, enemy_type_trench
    .db     4,     20, enemy_type_barbed_wire
    .db     0,    130, enemy_type_barbed_wire
    .db    40,     20, enemy_type_patrol_top
    .db     0,    101, enemy_type_patrol_bottom
    .db    10,     50, enemy_type_soldier
    .db    10,     80, enemy_type_dog
    .db    22,     80, enemy_type_barbed_wire
    .db     0,    120, enemy_type_barbed_wire
    .db     4,     40, enemy_type_trench
    .db     4,    101, enemy_type_patrol_bottom
    .db     4,    170, enemy_type_patrol_bottom
    .db    32,     55, enemy_type_patrol_top
    .db     0,    135, enemy_type_patrol_bottom
    .db     4,     85, enemy_type_soldier
    .db     4,     70, enemy_type_dog
    .db    22,     80, enemy_type_barbed_wire
    .db    10,     40, enemy_type_trench
    .db     0,    150, enemy_type_trench
    .db    32,     10, enemy_type_patrol_top
    .db     0,    101, enemy_type_patrol_bottom
    .db     4,     40, enemy_type_patrol_top
    .db     0,    150, enemy_type_patrol_bottom
    .db     4,    101, enemy_type_soldier
    .db    37,     85, enemy_type_tank
    .db     4,     20, enemy_type_barbed_wire
    .db     0,    120, enemy_type_barbed_wire
    .db    14,     45, background_type_end_level_building
    .db   255,     80, enemy_type_soldier  ;; End level entity, used so we dont spawn random stuff


level_6::
    .dw   420
    .db    42
;;     Counter  Y_pos  Enemy_type
    .db    12,     20, enemy_type_barbed_wire
    .db     0,    120, enemy_type_barbed_wire
    .db     8,     85, enemy_type_tank
    .db     6,     20, enemy_type_patrol_top
    .db     0,    101, enemy_type_patrol_bottom
    .db     4,     50, enemy_type_soldier
    .db     4,    110, enemy_type_soldier
    .db     4,     90, enemy_type_dog
    .db    42,     70, enemy_type_barbed_wire
    .db     0,    125, enemy_type_barbed_wire
    .db     0,     30, enemy_type_tank
    .db    16,    101, enemy_type_patrol_bottom
    .db     4,    150, enemy_type_patrol_bottom
    .db    10,    101, enemy_type_soldier
    .db    42,     15, enemy_type_barbed_wire
    .db     0,     70, enemy_type_barbed_wire
    .db     8,    145, enemy_type_tank
    .db     6,     20, enemy_type_patrol_top
    .db     4,     90, enemy_type_patrol_top
    .db    40,     90, enemy_type_tank
    .db     4,     75, enemy_type_barbed_wire
    .db     0,    130, enemy_type_barbed_wire
    .db     6,     10, enemy_type_patrol_top
    .db     0,    101, enemy_type_patrol_bottom
    .db     4,     40, enemy_type_patrol_top
    .db     0,    150, enemy_type_patrol_bottom
    .db     4,     90, enemy_type_dog
    .db     2,     90, enemy_type_soldier
    .db    40,     20, enemy_type_tank
    .db     0,    170, enemy_type_tank
    .db     4,     40, enemy_type_barbed_wire
    .db     0,    100, enemy_type_barbed_wire
    .db     6,     10, enemy_type_patrol_top
    .db     0,    101, enemy_type_patrol_bottom
    .db     4,     90, enemy_type_patrol_top
    .db     0,    150, enemy_type_patrol_bottom
    .db    36,     20, enemy_type_barbed_wire
    .db     0,    130, enemy_type_barbed_wire
    .db     4,     90, enemy_type_tank
    .db    10,     80, enemy_type_barbed_wire
    .db    37,     90, enemy_type_mortar
    .db     4,     20, enemy_type_barbed_wire
    .db     0,    120, enemy_type_barbed_wire
    .db    14,     45, background_type_end_level_building
    .db   255,     80, enemy_type_soldier  ;; End level entity, used so we dont spawn random stuff


level_7::
    .dw   600
    .db    60
;;     Counter  Y_pos  Enemy_type
    .db    10,     40, enemy_type_claymore
    .db     0,    140, enemy_type_claymore
    .db    10,    100, enemy_type_claymore
    .db     0,     50, enemy_type_claymore
    .db    10,    170, enemy_type_claymore
    .db     0,     20, enemy_type_claymore
    .db    10,     40, enemy_type_claymore
    .db     0,     90, enemy_type_claymore
    .db    10,     60, enemy_type_claymore
    .db     0,    170, enemy_type_claymore
    .db    10,    170, enemy_type_claymore
    .db    10,     80, enemy_type_tank
    .db    10,    100, enemy_type_claymore
    .db    10,    150, enemy_type_claymore
    .db     0,     40, enemy_type_claymore
    .db    10,     35, enemy_type_claymore
    .db     0,    160, enemy_type_claymore
    .db    10,     30, enemy_type_claymore
    .db    10,    140, enemy_type_claymore
    .db     0,     40, enemy_type_claymore
    .db    10,     70, enemy_type_claymore
    .db     0,    170, enemy_type_claymore
    .db    10,     90, enemy_type_claymore
    .db    10,    160, enemy_type_claymore
    .db     0,     60, enemy_type_claymore
    .db    10,     40, enemy_type_claymore
    .db     0,     60, enemy_type_claymore
    .db    10,     45, enemy_type_gatling
    .db    10,    135, enemy_type_claymore
    .db     0,     20, enemy_type_claymore
    .db    10,     85, enemy_type_claymore
    .db    10,    150, enemy_type_claymore
    .db     0,     30, enemy_type_claymore
    .db    10,     40, enemy_type_claymore
    .db     0,    160, enemy_type_claymore
    .db    10,     80, enemy_type_claymore
    .db     0,    130, enemy_type_claymore
    .db    10,    140, enemy_type_claymore
    .db     0,     90, enemy_type_claymore
    .db    10,     70, enemy_type_claymore
    .db     0,    130, enemy_type_claymore
    .db    10,     90, enemy_type_claymore
    .db     0,     30, enemy_type_claymore
    .db    10,     80, enemy_type_claymore
    .db     0,    100, enemy_type_claymore
    .db    10,     90, enemy_type_mortar
    .db    10,    100, enemy_type_claymore
    .db     0,     30, enemy_type_claymore
    .db    10,    110, enemy_type_claymore
    .db     0,     50, enemy_type_claymore
    .db    10,    160, enemy_type_claymore
    .db     0,     60, enemy_type_claymore
    .db    10,     90, enemy_type_claymore
    .db    10,    130, enemy_type_claymore
    .db     0,    150, enemy_type_claymore
    .db    10,    140, enemy_type_gatling
    .db    10,     30, enemy_type_claymore
    .db     0,    170, enemy_type_claymore
    .db    10,    140, enemy_type_claymore
    .db     0,     20, enemy_type_claymore
    .db    10,     40, enemy_type_claymore
    .db     0,    155, enemy_type_claymore
    .db    10,     80, enemy_type_claymore
    .db    10,    170, enemy_type_claymore
    .db     0,     30, enemy_type_claymore
    .db    10,     60, enemy_type_claymore
    .db     0,    130, enemy_type_claymore
    .db    10,     30, enemy_type_claymore
    .db     0,    160, enemy_type_claymore
    .db    10,     80, enemy_type_claymore
    .db    10,    150, enemy_type_claymore
    .db     0,     50, enemy_type_claymore
    .db    10,    140, enemy_type_claymore
    .db     0,     30, enemy_type_claymore
    .db    10,    130, enemy_type_claymore
    .db     0,     90, enemy_type_claymore
    .db    10,    140, enemy_type_claymore
    .db     0,     20, enemy_type_claymore
    .db    10,    150, enemy_type_claymore
    .db     0,     35, enemy_type_claymore
    .db    10,    170, enemy_type_claymore
    .db     0,     50, enemy_type_claymore
    .db    10,    130, enemy_type_claymore
    .db     0,     90, enemy_type_claymore
    .db    10,     30, enemy_type_gatling
    .db     0,    170, enemy_type_gatling
    .db    20,     90, enemy_type_mortar
    .db    10,     40, enemy_type_claymore
    .db     0,    160, enemy_type_claymore
    .db    10,     30, enemy_type_gatling
    .db     0,    140, enemy_type_gatling
    .db    10,     20, enemy_type_barbed_wire
    .db     0,    120, enemy_type_barbed_wire
    .db   255,     80, enemy_type_soldier  ;; End level entity, used so we dont spawn random stuff


level_8::
    .dw   500
    .db    50
;;     Counter  Y_pos  Enemy_type
    .db    12,     20, enemy_type_barbed_wire
    .db     0,    120, enemy_type_barbed_wire
    .db     8,     85, enemy_type_gatling
    .db    10,     20, enemy_type_patrol_top
    .db     0,    101, enemy_type_patrol_bottom
    .db     4,     50, enemy_type_soldier
    .db     4,    110, enemy_type_soldier
    .db     4,     90, enemy_type_dog
    .db    42,     70, enemy_type_barbed_wire
    .db     0,    125, enemy_type_barbed_wire
    .db     0,     30, enemy_type_gatling
    .db    16,    101, enemy_type_patrol_bottom
    .db     4,    150, enemy_type_patrol_bottom
    .db    10,    101, enemy_type_soldier
    .db    42,     15, enemy_type_barbed_wire
    .db     0,     70, enemy_type_barbed_wire
    .db     8,    145, enemy_type_gatling
    .db    10,     20, enemy_type_patrol_top
    .db     4,     90, enemy_type_patrol_top
    .db    26,     75, enemy_type_barbed_wire
    .db     0,    130, enemy_type_barbed_wire
    .db    10,     30, enemy_type_gatling
    .db     4,     80, enemy_type_mortar
    .db     0,    140, enemy_type_mortar
    .db    22,     30, enemy_type_patrol_top
    .db     0,    101, enemy_type_patrol_bottom
    .db     4,     40, enemy_type_patrol_top
    .db     0,    150, enemy_type_patrol_bottom
    .db     4,     90, enemy_type_dog
    .db     2,     90, enemy_type_soldier
    .db    36,     20, enemy_type_gatling
    .db     0,    170, enemy_type_gatling
    .db     4,     40, enemy_type_barbed_wire
    .db     0,    100, enemy_type_barbed_wire
    .db    16,     20, enemy_type_patrol_top
    .db     0,    101, enemy_type_patrol_bottom
    .db     4,     90, enemy_type_patrol_top
    .db     0,    150, enemy_type_patrol_bottom
    .db    10,     90, enemy_type_dog
    .db    40,     15, enemy_type_barbed_wire
    .db     0,    130, enemy_type_barbed_wire
    .db     6,     90, enemy_type_gatling
    .db     4,     40, enemy_type_mortar
    .db     0,    140, enemy_type_mortar
    .db    40,     20, enemy_type_barbed_wire
    .db     0,    130, enemy_type_barbed_wire
    .db     4,     80, enemy_type_gatling
    .db    33,     85, enemy_type_commander
    .db     4,     20, enemy_type_barbed_wire
    .db     0,    120, enemy_type_barbed_wire
    .db    14,     45, background_type_end_level_building
    .db   255,     80, enemy_type_soldier  ;; End level entity, used so we dont spawn random stuff

level_9::
    .dw   720
    .db    72
;;     Counter  Y_pos  Enemy_type
    .db    20,     14, enemy_type_pop_door
    .db     0,     59, enemy_type_pop_door
    .db     0,    104, enemy_type_pop_door
    .db     0,    149, enemy_type_pop_door
    .db    60,     80, enemy_type_gatling
    .db     6,     20, enemy_type_patrol_top
    .db     0,    101, enemy_type_patrol_bottom
    .db     4,     90, enemy_type_patrol_top
    .db     0,    150, enemy_type_patrol_bottom
    .db    10,    140, enemy_type_soldier
    .db    10,     60, enemy_type_soldier
    .db    10,     80, enemy_type_dog
    .db    20,    120, enemy_type_gatling
    .db     6,     30, enemy_type_patrol_top
    .db     0,     80, enemy_type_patrol_top
    .db    14,    140, enemy_type_soldier
    .db    10,     60, enemy_type_soldier
    .db    10,     85, enemy_type_commander
    .db    10,     14, enemy_type_pop_door
    .db     0,     59, enemy_type_pop_door
    .db     0,    104, enemy_type_pop_door
    .db     0,    149, enemy_type_pop_door
    .db    60,     95, enemy_type_gatling
    .db     6,     20, enemy_type_patrol_top
    .db     0,    101, enemy_type_patrol_bottom
    .db    14,     80, enemy_type_dog
    .db    10,     95, enemy_type_soldier
    .db    10,     30, enemy_type_soldier
    .db    30,    120, enemy_type_commander
    .db    10,     14, enemy_type_pop_door
    .db     0,     59, enemy_type_pop_door
    .db     0,    104, enemy_type_pop_door
    .db     0,    149, enemy_type_pop_door
    .db    60,     50, enemy_type_gatling
    .db     6,     80, enemy_type_patrol_top
    .db     0,    160, enemy_type_patrol_bottom
    .db    14,    101, enemy_type_soldier
    .db    10,     20, enemy_type_soldier
    .db    30,    120, enemy_type_commander
    .db    10,     14, enemy_type_pop_door
    .db     0,     59, enemy_type_pop_door
    .db     0,    104, enemy_type_pop_door
    .db     0,    149, enemy_type_pop_door
    .db    60,     70, enemy_type_gatling
    .db    20,    130, enemy_type_gatling
    .db    10,     80, enemy_type_dog
    .db     0,    100, enemy_type_dog
    .db    30,    120, enemy_type_commander
    .db    10,     14, enemy_type_pop_door
    .db     0,     59, enemy_type_pop_door
    .db     0,    104, enemy_type_pop_door
    .db     0,    149, enemy_type_pop_door
    .db    62,     85, enemy_type_commander
    .db     0,    120, enemy_type_commander
    .db    14,     40, enemy_type_commander
    .db    18,     45, background_type_end_level_building
    .db   255,     80, enemy_type_soldier  ;; End level entity, used so we dont spawn random stuff

level_Boss:
    .dw    10
    .db     1
    .db     8,     20, enemy_type_boss_left_arm
    .db     0,    164, enemy_type_boss_right_arm
    .db     0,     85, enemy_type_boss_chest

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                     ;;
;;                        PUBLIC FUNCTIONS                             ;;
;;                                                                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAN_LEVEL_GET_LEVEL_DATA                                            ;;
;; Input: Level number in A                                            ;;
;; Returns in HL the data of the level A                               ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_level_get_level_data::
    dec a
    jp nz, check_level_2_data
    ld hl, #level_1
    jp exit_get_level_data
check_level_2_data:
    dec a
    jp nz, check_level_3_data
    ld hl, #level_2
    jp exit_get_level_data
check_level_3_data:
    dec a
    jp nz, check_level_4_data
    ld hl, #level_3
    jp exit_get_level_data
check_level_4_data:
    dec a
    jp nz, check_level_5_data
    ld hl, #level_4
    jp exit_get_level_data
check_level_5_data:
    dec a
    jp nz, check_level_6_data
    ld hl, #level_5
    jp exit_get_level_data
check_level_6_data:
    dec a
    jp nz, check_level_7_data
    ld hl, #level_6
    jp exit_get_level_data
check_level_7_data:
    dec a
    jp nz, check_level_8_data
    ld hl, #level_7
    jp exit_get_level_data
check_level_8_data:
    dec a
    jp nz, check_level_9_data
    ld hl, #level_8
    jp exit_get_level_data
check_level_9_data:
    dec a
    jp nz, check_level_boss_data
    ld hl, #level_9
    jp exit_get_level_data
check_level_boss_data:
    ld hl, #level_Boss
exit_get_level_data:
    ret

man_level_is_car_level::
    call man_game_get_current_level
    cp #3
    jp nz, check_next_car_level
    jp level_is_car_level
check_next_car_level:
    cp #7
    jp nz, no_car_level
level_is_car_level:
    ld a, #1
    ret
no_car_level:
    xor a
    ret