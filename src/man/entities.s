.include "entities.h.s"
.include "man/game.h.s"

;; Calculates the space needed in bytes
entities_storage_size = max_entities * sizeof_e

;; Globals
_entities::
entities_next_free: .dw entities_storage      ;; Pointer to the next free position
entities_storage:   .ds entities_storage_size ;; Pointer to storage's first pos
entities_end:       .db e_type_invalid

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                     ;;
;;                        PUBLIC FUNCTIONS                             ;;
;;                                                                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAN_ENTITY_INIT                                                     ;;
;; Initializes the memory needed to store all entities                 ;;
;; Modifies HL, DE, BC                                                 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_entity_init::
    ld hl, #entities_storage        ;; Stores entities_storage in HL
    ld (entities_next_free), hl     ;; Stores HL in entities next free
    ld (hl), #0
    ld  d, h                            ;; Stores h in d(no ld de, hl available)
    ld  e, l                            ;; Stores l in e
    inc de                              ;; Increments de
    ld  bc, #entities_storage_size - 1  ;; Stores in bc the size needed
    ldir                                ;; Uses ld to initialize the values
    ret 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAN_ENTITY_CREATE                                                   ;;
;; Increments current entities value, updates next free pointer        ;;
;; Modifies BC, HL, DE                                                 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_entity_create::
    ld   hl, (entities_next_free)   ;; Stores the pointer to next free in HL
    ld   d, h                       ;; Stores h in d
    ld   e, l                       ;; Stores l in e
    ld   bc, #sizeof_e              ;; Stores size of entity in BC
    add  hl, bc                     ;; Adds BC to HL
    ld   (entities_next_free), hl   ;; Stores HL (result of prev) in pointer next free
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAN_GAME_CREATE_TEMPLATE_ENTITY                                    ;;
;; Creates an entity based on template                                 ;;
;; Input                                                               ;;
;;      HL the address of the entity template                          ;;
;; Returns                                                             ;;
;;      IX the address of the entity created                           ;;
;; Modifies: HL, DE, BC, IY                                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_entity_create_entity::
    push hl
    call man_entity_create           ;; Creates one entity        
    pop hl
    push de
    ldir                             ;; Loads values
    pop ix
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAN_ENTITY_CREATE                                                   ;;
;; Increments current entities value, updates next free pointer        ;;
;; Input                                                               ;;
;;      IX pointer to the entity                                       ;;
;; Modifies AF                                                         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_entity_set4destruction::    ;;[42]
    ;; e->type |= e_type_dead
    ld a, e_type(ix)            ;;[19]
    or a, #e_type_dead          ;;[4]
    ld e_type(ix), a            ;;[19]
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAN_ENTITY_FORALL_MATCHING                                          ;;
;; Jumps to HL for every single entity, used by other systems          ;;
;; Input                                                               ;;
;;      HL = pointer of the function to call                           ;;
;;      B = signature to match: the component to match                 ;;
;; Modifies A, DE, BC, IX                                              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_entity_forall_matching::
    ld ix, #entities_storage    ;; Stores in ix a pointer to the first position
    ld a, e_type(ix)            ;; Stores in A current number of entities
    or a                        ;; Update Z flag when a==0
    jr nz, forall_sig_loop      ;; If zero flag is high, jump to loop
    ret
    forall_sig_loop:            ;; For all loop                
        ld a, e_cmps(ix)        ;; Stores the signature the component in A
        and b                   ;; e->type & signature
        or a                    ;; a == 0 ?
        jr z, next_sig          ;; Jumps is Z flag is high
        ld de, #next_ret        ;; Stores in DE the direction of next
        push bc                 ;; preserves B parameter (type of entity)
        push hl                 ;; preserves HL (function to call)
        push de                 ;; Stores in stack DE
        jp (hl)                 ;; Jumps to HL
    next_ret:
        pop hl                  ;; restores HL (function to call)
        pop bc                  ;; restores B parameter (type of entity)
    next_sig:                   ;; Next, used to restore the Program Counter (PC)
        ld de, #sizeof_e        ;; Stores in BC the size of the entities
        add ix, de              ;; Adds BC to the index (IX)
        ld a, e_type(ix)
        or a
        jr nz, forall_sig_loop  ;; If A > 0, jumps to forall_loop
    ret

man_entity_forall_matching_not_player::
    ld ix, #entities_storage    ;; Stores in ix a pointer to the first position
    ld de, #sizeof_e        ;; Stores in BC the size of the entities
    add ix, de              ;; Adds BC to the index (IX)
    ld a, e_type(ix)            ;; Stores in A current number of entities
    or a                        ;; Update Z flag when a==0
    jr nz, forall_not_player_sig_loop      ;; If zero flag is high, jump to loop
    ret
    forall_not_player_sig_loop:            ;; For all loop                
        ld a, e_cmps(ix)        ;; Stores the signature the component in A
        and b                   ;; e->type & signature
        or a                    ;; a == 0 ?
        jr z, next_sig_not_player          ;; Jumps is Z flag is high
        ld de, #next_ret_not_player        ;; Stores in DE the direction of next
        push bc                 ;; preserves B parameter (type of entity)
        push hl                 ;; preserves HL (function to call)
        push de                 ;; Stores in stack DE
        jp (hl)                 ;; Jumps to HL
    next_ret_not_player:
        pop hl                  ;; restores HL (function to call)
        pop bc                  ;; restores B parameter (type of entity)
    next_sig_not_player:                   ;; Next, used to restore the Program Counter (PC)
        ld de, #sizeof_e        ;; Stores in BC the size of the entities
        add ix, de              ;; Adds BC to the index (IX)
        ld a, e_type(ix)
        or a
        jr nz, forall_not_player_sig_loop  ;; If A > 0, jumps to forall_loop
    ret

man_entity_forall::
    ld ix, #entities_storage    ;; Stores in ix a pointer to the first position
    ld a, e_type(ix)            ;; Stores in A current number of entities
    or a                        ;; Update Z flag when a==0
    jr nz, forall_sig_loop      ;; If zero flag is high, jump to loop
    ret
    forall_loop:                ;; For all loop                
        ld de, #next            ;; Stores in DE the direction of next
        push de                 ;; Stores in stack DE
        jp (hl)                 ;; Jumps to HL
    next:                       ;; Next, used to restore the Program Counter (PC
        ld de, #sizeof_e        ;; Stores in BC the size of the entities
        add ix, de              ;; Adds BC to the index (IX)
        ld a, e_type(ix)
        or a
        jr nz, forall_loop  ;; If A > 0, jumps to forall_loop
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAN_ENTITY_DESTROY_MARKED_FOR_DEATH                                 ;;
;; Updates entities, updates next free pointer and current entities    ;;
;; Modifies AF, DE, BC, IX, HL                                         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_entity_destroy_marked_for_death::
    ld ix, #entities_storage

    destroy_loop:
        ld a, e_type(ix) ;; if entity is invalid, we have reached the end of the array
        or a
        ret z

        and #e_type_dead
        or a
        jp z, check_next_entity_to_destroy

        ld a, e_type(ix)
        and #e_type_player
        or a
        jp z, begin_entity_destruction

        call man_game_end_game      ;; Sets game to end on next cycle
        
    begin_entity_destruction:
        call man_game_entity_finalize_tasks
        
        ld iy, (entities_next_free)
        ld bc, #-sizeof_e
        add iy, bc

        push iy
        pop hl

        ld (entities_next_free), hl

        push ix
        pop de
        ld bc, #sizeof_e
        call cpct_memcpy_asm        ;; Calls cpct_memcpy_asm

        ld a, #e_type_invalid
        ld e_type(iy), a

        jp destroy_loop

check_next_entity_to_destroy:
        ld bc, #sizeof_e
        add ix, bc
        jp destroy_loop

