.include "man/music.h.s"

man_music_get_current_screen_music::
    call man_game_get_current_level
    cp #1
    jp nz, check_level_2
    ld de, #_msc_level_1
    ret
check_level_2:
    cp #2
    jp nz, check_level_3
    ld de, #_msc_level_1
    ret
check_level_3:
    cp #3
    jp nz, check_level_4
    ld de, #_msc_level_3
    ret
check_level_4:
    cp #4
    jp nz, check_level_5
    ld de, #_msc_level_2
    ret
check_level_5:
    cp #5
    jp nz, check_level_6
    ld de, #_msc_level_2
    ret
check_level_6:
    cp #6
    jp nz, check_level_7
    ld de, #_msc_level_2
    ret
check_level_7:
    cp #7
    jp nz, check_level_8
    ld de, #_msc_level_3
    ret
check_level_8:
    cp #8
    jp nz, check_level_9
    ld de, #_msc_level_1
    ret
check_level_9:
    cp #9
    jp nz, check_level_10
    ld de, #_msc_final_level
    ret
check_level_10:
    ld de, #_msc_level_2
    ret