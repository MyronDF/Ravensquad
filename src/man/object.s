.include "object.h.s"
.include "man/entities.h.s"
.include "man/templates.h.s"

man_object_generate::
    push ix
    ld hl, #object_1_up_tmpl
    call man_entity_create_entity
    push ix
    pop iy
    pop ix
    ld a, e_x(ix)
    add #1
    ld e_x(iy), a
    ld a, e_y(ix)
    add #5
    ld e_y(iy), a
    ret