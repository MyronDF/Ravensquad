.module Entity_Manager

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PUBLIC CONSTANTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Entities atributes
e_type          = 0     ;; [1] Entity type
e_cmps          = 1     ;; [1] TODO: Entity components 
e_x             = 2     ;; [1] X coordinate of the entity (0-79)
e_y             = 3     ;; [1] Y coordinate of the entity (0-199)
e_w             = 4     ;; [1] Width of the renderable
e_h             = 5     ;; [1] Height of the renderable
e_vx            = 6     ;; [1] X speed of the renderable      
e_vy            = 7     ;; [1] Y speed of the renderable      
e_lastX         = 8     ;; [1] X position on last cycle
e_lastY         = 9     ;; [1] Y position on last cycle
e_behaviour_l   = 10    ;; [1] Behaviour low byte
e_behaviour_h   = 11    ;; [1] Behaviour high byte
e_ai_counter    = 12    ;; [1] AI counter
e_sprite        = 13    ;; [2] Sprite of the renderable
e_anim_l        = 15    ;; [1] pointer to the animation low
e_anim_h        = 16    ;; [1] pointer to the animation high
e_anim_counter  = 17    ;; [1] animation counter
e_collides_with = 18    ;; [1] collision destination
e_state         = 19    ;; [1] entity internal state
e_default_sprite= 20    ;; [2] 
e_shot_y        = 22    ;; [1] shot Y position relative to shooter entity
e_damage        = 23    ;; [1] entity damage caused in strength of other entities when both collides
e_strength      = 24    ;; [1] entity strength (more strength allows to survive more collisions, shots, grenades, ...)
e_start_X       = 25
e_start_Y       = 26
e_end_X         = 27
e_end_Y         = 28

e_sprite_l      = 13    ;; [2] Sprite of the renderable low
e_sprite_h      = 14    ;; [2] Sprite of the renderable high
e_default_sprite_l = 20
e_default_sprite_h = 21

;; Entity info
sizeof_e            = 29    ;; Size in bytes (1+1+1+1+1+1+1+1+1+1+2+1+2+2+1)
max_entities        = 40    ;; Max entities to be drawn in the screen

;; Entity types
e_type_invalid              = 0x00  ;; All bits down means the entity is invalid
e_type_player               = 0x01  ;; Entity player controllable by input
e_type_enemy                = 0x02  ;; Default enemy
e_type_enemy_background     = 0x04  ;; Explosion type
e_type_player_shot          = 0x08  ;; Entity player shot
e_type_enemy_shot           = 0x10  ;; Entity enemy shot
e_type_background_object    = 0x20
e_type_object               = 0x40

e_type_dead         = 0x80          ;; Upper bit signals dead entity
e_type_default      = e_type_enemy  ;; Default entity

;; Entity components
e_cmp_render        = 0x01  ;; Renderable entity
e_cmp_movable       = 0x02  ;; Movable entity
e_cmp_input         = 0x04  ;; IA behaviour
e_cmp_ai            = 0x08  ;; IA behaviour
e_cmp_anim          = 0x10  ;; Animation behaviour 
e_cmp_collider      = 0x20  ;; Collider behaviour
e_cmp_hidetrack     = 0x40  ;; Hide sprite with box
e_cmp_background    = 0x80  ;; Sprite with multiple parts

;; states
e_state_standing    = 0x00
e_state_moving      = 0x01


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                     ;;
;;                        PUBLIC FUNCTIONS                             ;;
;;                                                                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl man_entity_init
.globl man_entity_create
.globl man_entity_set4destruction
.globl man_entity_create_entity
.globl man_entity_destroy_marked_for_death