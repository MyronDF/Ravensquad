############################################################################
##                        CPCTELERA ENGINE                                ##
##                 Automatic image conversion file                        ##
##------------------------------------------------------------------------##
## This file is intended for users to automate image conversion from JPG, ##
## PNG, GIF, etc. into C-arrays.                                          ##
############################################################################

##
## NEW MACROS
##

## 16 colours palette
#PALETTE=0 1 2 3 6 9 11 12 13 15 16 18 20 24 25 26

## Default values

#$(eval $(call IMG2SP, SET_MASK        , none               ))  { interlaced, none }

#$(eval $(call IMG2SP, SET_EXTRAPAR    ,                    ))
#$(eval $(call IMG2SP, SET_IMG_FORMAT  , sprites            ))	{ sprites, zgtiles, screen }
#$(eval $(call IMG2SP, SET_OUTPUT      , c                  ))  { bin, c }
#$(eval $(call IMG2SP, SET_PALETTE_FW  , $(PALETTE)         ))
#$(eval $(call IMG2SP, CONVERT_PALETTE , $(PALETTE), g_palette ))

#$(eval $(call IMG2SP, SET_FOLDER, src/sprites/ ))
#$(eval $(call IMG2SP, SET_MODE, 0))  
#$(eval $(call IMG2SP, SET_PALETTE_FW, $(PALETTE)))
#$(eval $(call IMG2SP, CONVERT_PALETTE, $(PALETTE), g_palette))
#$(eval $(call IMG2SP, SET_OUTPUT, bin))  
#$(eval $(call IMG2SP, CONVERT, assets/sprite.png , 8, 8, sprite))
##
## OLD MACROS (For compatibility)
##

## Example firmware palette definition as variable in cpct_img2tileset format

# PALETTE={0 1 3 4 7 9 10 12 13 16 19 20 21 24 25 26}

## AUTOMATED IMAGE CONVERSION EXAMPLE (Uncomment EVAL line to use)
##
##    This example would convert img/example.png into src/example.{c|h} files.
##    A C-array called pre_example[24*12*2] would be generated with the definition
##    of the image example.png in mode 0 screen pixel format, with interlaced mask.
##    The palette used for conversion is given through the PALETTE variable and
##    a pre_palette[16] array will be generated with the 16 palette colours as 
##	  hardware colour values.

#$(eval $(call IMG2SPRITES,img/example.png,0,pre,24,12,$(PALETTE),mask,src/,hwpalette))

# SET PALETTE AND FOLDER
PALETTE=0 1 2 3 6 9 11 12 13 15 16 18 20 24 25 26
$(eval $(call IMG2SP, SET_FOLDER      , src/sprites/               ))
$(eval $(call IMG2SP, SET_PALETTE_FW  , $(PALETTE)         ))
$(eval $(call IMG2SP, CONVERT_PALETTE , $(PALETTE), main_palette ))

# BULLET SPRITE
$(eval $(call IMG2SP, CONVERT         , assets/sprites/world_animations/anim_bullet_destruction.png ,  6,  5, spr_bullet_destruction))

# OBJECT SPRITES
$(eval $(call IMG2SP, CONVERT         , assets/sprites/objects/object_1_up.png , 8,  7, spr_object_1_up))

# ENEMIES SPRITES
$(eval $(call IMG2SP, CONVERT         , assets/sprites/enemies/enemy_commander.png ,    12, 20, spr_enemy_commander))
$(eval $(call IMG2SP, CONVERT 		  , assets/sprites/enemies/enemy_barbed_wire.png ,	 6, 55, spr_enemy_barbed_wire))
$(eval $(call IMG2SP, CONVERT         , assets/sprites/enemies/enemy_dog.png , 			12, 20, spr_enemy_dog))
$(eval $(call IMG2SP, CONVERT         , assets/sprites/enemies/enemy_boss_chest.png , 	28, 30, spr_enemy_boss_chest))
$(eval $(call IMG2SP, CONVERT         , assets/sprites/enemies/enemy_boss_right_arm.png,28, 16, spr_enemy_boss_right_arm))
$(eval $(call IMG2SP, CONVERT         , assets/sprites/enemies/enemy_boss_left_arm.png,	28, 16, spr_enemy_boss_left_arm))
$(eval $(call IMG2SP, CONVERT         , assets/sprites/enemies/enemy_soldier.png , 		12, 20, spr_enemy_soldier))
$(eval $(call IMG2SP, CONVERT         , assets/sprites/enemies/enemy_tank.png , 		30, 19, spr_enemy_tank))
$(eval $(call IMG2SP, CONVERT         , assets/sprites/enemies/enemy_trench.png , 		22, 22, spr_enemy_trench))
$(eval $(call IMG2SP, CONVERT         , assets/sprites/enemies/enemy_turret.png , 		20, 18, spr_enemy_turret))
$(eval $(call IMG2SP, CONVERT         , assets/sprites/enemies/enemy_gatling.png , 		22, 16, spr_enemy_gatling))
$(eval $(call IMG2SP, CONVERT         , assets/sprites/enemies/enemy_pop_door.png , 	18, 38, spr_enemy_pop_door))
$(eval $(call IMG2SP, CONVERT         , assets/sprites/enemies/enemy_claymore.png , 	12,  7, spr_enemy_claymore))
$(eval $(call IMG2SP, CONVERT         , assets/sprites/enemies/enemy_mortar.png ,     	16, 20, spr_enemy_mortar))
$(eval $(call IMG2SP, CONVERT         , assets/sprites/enemies/enemy_stone.png ,     	16, 14, spr_enemy_stone))
$(eval $(call IMG2SP, CONVERT         , assets/sprites/world_animations/anim_enemy_explosion.png, 22, 20, spr_anim_enemy_explosion))

# PLAYER SPRITE
$(eval $(call IMG2SP, CONVERT         , assets/sprites/player/player_sprite.png , 		12, 20, spr_player))
$(eval $(call IMG2SP, CONVERT         , assets/sprites/player/player_car_sprite.png , 	36, 21, spr_player_car))

# BACKGROUND ENTITIES SPRITES
$(eval $(call IMG2SP, CONVERT         , assets/sprites/background/background_flower.png , 				10, 10, spr_background_flower))
$(eval $(call IMG2SP, CONVERT         , assets/sprites/background/background_grass.png , 				 8,  6, spr_background_grass))
$(eval $(call IMG2SP, CONVERT         , assets/sprites/background/background_keep_out_sign.png , 		22, 18, spr_background_keepout))
$(eval $(call IMG2SP, CONVERT         , assets/sprites/background/background_captured_ally.png , 		 8, 16, spr_background_captured_ally))
$(eval $(call IMG2SP, CONVERT         , assets/sprites/background/background_captured_ally_2.png ,		 6, 14, spr_background_captured_ally_2))
$(eval $(call IMG2SP, CONVERT         , assets/sprites/background/background_captured_ally_3.png ,		16, 16, spr_background_captured_ally_3))
$(eval $(call IMG2SP, CONVERT         , assets/sprites/background/background_captured_ally_4.png ,		14, 22, spr_background_captured_ally_4))
$(eval $(call IMG2SP, CONVERT         , assets/sprites/background/background_captured_ally_5.png ,		16,  6, spr_background_captured_ally_5))
$(eval $(call IMG2SP, CONVERT         , assets/sprites/background/background_end_level_building.png , 	20, 60, spr_background_end_level_building))
$(eval $(call IMG2SP, CONVERT         , assets/sprites/background/background_goal_metter.png ,			88, 10, spr_background_goal_metter))
$(eval $(call IMG2SP, CONVERT         , assets/sprites/background/background_arrow.png ,		     	 8,  9, spr_background_arrow))
$(eval $(call IMG2SP, CONVERT         , assets/sprites/background/background_1_up_menu.png ,		     4,  5, spr_1_up_menu))
$(eval $(call IMG2SP, CONVERT         , assets/sprites/background/background_bullet_active_menu.png ,	 4,  5, spr_background_bullet_active))
$(eval $(call IMG2SP, CONVERT         , assets/sprites/background/background_bullet_inactive_menu.png , 4,  5, spr_background_bullet_inactive))

# MENU SCREEN
$(eval $(call IMG2SP, SET_IMG_FORMAT  , screen))
$(eval $(call IMG2SP, SET_OUTPUT	  , bin))
$(eval $(call IMG2SP, CONVERT         , assets/sprites/screens/screen_menu.png , 		160, 200, scr_menu))
$(eval $(call IMG2SP, CONVERT		  , assets/sprites/screens/screen_end_level.png ,	160, 200, scr_end_lvl))

############################################################################
##              DETAILED INSTRUCTIONS AND PARAMETERS                      ##
##------------------------------------------------------------------------##
##                                                                        ##
## Macro used for conversion is IMG2SPRITES, which has up to 9 parameters:##
##  (1): Image file to be converted into C sprite (PNG, JPG, GIF, etc)    ##
##  (2): Graphics mode (0,1,2) for the generated C sprite                 ##
##  (3): Prefix to add to all C-identifiers generated                     ##
##  (4): Width in pixels of each sprite/tile/etc that will be generated   ##
##  (5): Height in pixels of each sprite/tile/etc that will be generated  ##
##  (6): Firmware palette used to convert the image file into C values    ##
##  (7): (mask / tileset / zgtiles)                                       ##
##     - "mask":    generate interlaced mask for all sprites converted    ##
##     - "tileset": generate a tileset array with pointers to all sprites ##
##     - "zgtiles": generate tiles/sprites in Zig-Zag pixel order and     ##
##                  Gray Code row order                                   ##
##  (8): Output subfolder for generated .C/.H files (in project folder)   ##
##  (9): (hwpalette)                                                      ##
##     - "hwpalette": output palette array with hardware colour values    ##
## (10): Aditional options (you can use this to pass aditional modifiers  ##
##       to cpct_img2tileset)                                             ##
##                                                                        ##
## Macro is used in this way (one line for each image to be converted):   ##
##  $(eval $(call IMG2SPRITES,(1),(2),(3),(4),(5),(6),(7),(8),(9), (10))) ##
##                                                                        ##
## Important:                                                             ##
##  * Do NOT separate macro parameters with spaces, blanks or other chars.##
##    ANY character you put into a macro parameter will be passed to the  ##
##    macro. Therefore ...,src/sprites,... will represent "src/sprites"   ##
##    folder, whereas ...,  src/sprites,... means "  src/sprites" folder. ##
##                                                                        ##
##  * You can omit parameters but leaving them empty. Therefore, if you   ##
##  wanted to specify an output folder but do not want your sprites to    ##
##  have mask and/or tileset, you may omit parameter (7) leaving it empty ##
##     $(eval $(call IMG2SPRITES,imgs/1.png,0,g,4,8,$(PAL),,src/))        ##
############################################################################
