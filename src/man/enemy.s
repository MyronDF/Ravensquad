.include "enemy.h.s"
.include "templates.h.s"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                     ;;
;;                        PUBLIC FUNCTIONS                             ;;
;;                                                                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;MAN_ENEMY_GET_ENEMY_TEMPLATE                                         ;;
;;Input: Enemy type in A                                               ;;
;;Returns: Enemy template pointer stored in HL                         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_enemy_get_enemy_template::
check_soldier:                  ;; Check if requested enemy is soldier
    or a
    jr nz, check_dog
    ld hl, #enemy_tmpl
    ret
check_dog:                     ;; Check if requested enemy is tank
    cp #enemy_type_dog
    jr nz, check_turret
    ld hl, #enemy_dog_tmpl
    ret
check_turret:                   ;; Check if requested enemy is trench
    cp #enemy_type_turret
    jr nz, check_trench
    ld hl, #turret_tmpl
    ret
check_trench:                   ;; Check if requested enemy is trench
    cp #enemy_type_trench
    jr nz, check_tank
    ld hl, #trench_tmpl
    ret
check_tank:                     ;; Check if requested enemy is tank
    cp #enemy_type_tank
    jr nz, check_barbed_wire
    ld hl, #enemy_tank_tmpl
    ret
check_barbed_wire:
    cp #enemy_type_barbed_wire
    jr nz, check_enemy_commander
    ld hl, #enemy_barbed_wire_tmpl
    ret
check_enemy_commander:
    cp #enemy_type_commander
    jr nz, check_enemy_patrol_top
    ld hl, #enemy_commander_tmpl
    ret
check_enemy_patrol_top:
    cp #enemy_type_patrol_top
    jr nz, check_enemy_patrol_bottom
    ld hl, #enemy_top_patrol_tmpl
    ret
check_enemy_patrol_bottom:
    cp #enemy_type_patrol_bottom
    jr nz, check_enemy_gatling
    ld hl, #enemy_bot_patrol_tmpl
    ret
check_enemy_gatling:
    cp #enemy_type_gatling
    jr nz, check_enemy_pop_door
    ld hl, #enemy_gatling_tmpl
    ret
check_enemy_pop_door:
    cp #enemy_type_pop_door
    jr nz, check_enemy_claymore
    ld hl, #enemy_pop_door_tmpl
    ret
check_enemy_claymore:
    cp #enemy_type_claymore
    jr nz, check_enemy_mortar
    ld hl, #enemy_claymore_tmpl
    ret
check_enemy_mortar:
    cp #enemy_type_mortar
    jr nz, check_enemy_stone
    ld hl, #enemy_mortar_tmpl
    ret
check_enemy_stone:
    cp #enemy_type_stone
    jr nz, check_enemy_boss_left_arm
    ld hl, #enemy_stone_tmpl
    ret
check_enemy_boss_left_arm:
    cp #enemy_type_boss_left_arm
    jr nz, check_enemy_boss_right_arm
    ld hl, #enemy_boss_left_arm_tmpl
    ret
check_enemy_boss_right_arm:
    cp #enemy_type_boss_right_arm
    jr nz, check_enemy_boss_chest
    ld hl, #enemy_boss_right_arm_tmpl
    ret
check_enemy_boss_chest:
    cp #enemy_type_boss_chest
    jr nz, check_end_level_building
    ld hl, #enemy_boss_chest_tmpl
    ret
check_end_level_building:
    cp #background_type_end_level_building
    jr nz, check_next
    ld hl, #background_end_level_building_tmpl
    ret
check_next:
    ret

