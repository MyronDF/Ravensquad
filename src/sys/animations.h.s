.module Animations_Manager

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PUBLIC CONSTANTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_anim_player_time = 4
man_anim_dog_time = 4
man_anim_pop_door_opening = 4
man_anim_pop_door_closing = 1
man_anim_pop_door_standing = 40
man_anim_enemy_explosion_time = 2
man_anim_enemy_claymore_time = 10
man_anim_enemy_mortar_time = 2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                     ;;
;;                        PUBLIC FUNCTIONS                             ;;
;;                                                                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl sys_animations_update
.globl _sys_animations_update_one_entity
