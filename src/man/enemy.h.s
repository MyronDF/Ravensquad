.module Enemy_manager

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PUBLIC CONSTANTS                                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
enemy_type_soldier                  = 0x00
enemy_type_dog                      = 0x01
enemy_type_turret                   = 0x02
enemy_type_trench                   = 0x03
enemy_type_tank                     = 0x04
enemy_type_barbed_wire              = 0x05
enemy_type_commander                = 0x06
enemy_type_patrol_top               = 0x07
enemy_type_patrol_bottom            = 0x08
enemy_type_gatling                  = 0x09
enemy_type_pop_door                 = 0x0A
enemy_type_claymore                 = 0x0B
enemy_type_mortar                   = 0x0C
enemy_type_stone                    = 0x0D
enemy_type_boss_left_arm            = 0x0E
enemy_type_boss_right_arm           = 0x0F
enemy_type_boss_chest               = 0x10
background_type_end_level_building  = 0x80

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                     ;;
;;                        PUBLIC FUNCTIONS                             ;;
;;                                                                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl man_enemy_get_enemy_template