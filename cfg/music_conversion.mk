############################################################################
##                        CPCTELERA ENGINE                                ##
##                 Automatic image conversion file                        ##
##------------------------------------------------------------------------##
## This file is intended for users to automate music conversion from      ##
## original files (like Arkos Tracker .aks) into data arrays.             ##
############################################################################

##
## NEW MACROS
##

# Default values
#$(eval $(call AKS2DATA, SET_FOLDER   , src/ ))
#$(eval $(call AKS2DATA, SET_OUTPUTS  , h s  )) { bin, h, hs, s }
#$(eval $(call AKS2DATA, SET_SFXONLY  , no   )) { yes, no       }
#$(eval $(call AKS2DATA, SET_EXTRAPAR ,      )) 
# Conversion
#$(eval $(call AKS2DATA, CONVERT      , music.aks , array , mem_address ))

##
## OLD MACROS (For compatibility)
##

## AUTOMATED MUSIC CONVERSION EXAMPLE (Uncomment EVAL line to use)

## Convert music/song.aks to src/music/song.s and src/music/song.h
##		This file contains a music created with Arkos Tracker. This macro 
## will convert the music into a data array called g_mysong that will be
## placed at the 0x42A0 memory address in an absolue way.
##

#$(eval $(call AKS2C,music/song.aks,g_mysong,src/music/,0x42A0))
$(eval $(call AKS2C,assets/music/menu_theme.aks,msc_menu_theme,src/music/,0x3000))
$(eval $(call AKS2C,assets/music/level_ended.aks,msc_level_ended,src/music/,0x32c2))
$(eval $(call AKS2C,assets/music/level_1.aks,msc_level_1,src/music/,0x3368))
$(eval $(call AKS2C,assets/music/level_2.aks,msc_level_2,src/music/,0x359d))
$(eval $(call AKS2C,assets/music/level_3.aks,msc_level_3,src/music/,0x38b4))
$(eval $(call AKS2C,assets/music/final_level.aks,msc_final_level,src/music/,0x3ba1))


############################################################################
##              DETAILED INSTRUCTIONS AND PARAMETERS                      ##
##------------------------------------------------------------------------##
##                                                                        ##
## Macro used for conversion is AKS2C, which has up to 5 parameters:      ##
##  (1): AKS file to be converted to data array                           ##
##  (2): C identifier for the generated data array (will have underscore  ##
##       in front in ASM)                                                 ##
##  (3): Output folder for .s and .h files generated (Default same folder)##
##  (4): Memory address where music data will be loaded                   ##
##  (5): Aditional options (you can use this to pass aditional modifiers  ##
##       to cpct_aks2c)                                                   ##
##                                                                        ##
## Macro is used in this way (one line for each image to be converted):   ##
##  $(eval $(call AKS2C,(1),(2),(3),(4),(5))                              ##
##                                                                        ##
## Important:                                                             ##
##  * Do NOT separate macro parameters with spaces, blanks or other chars.##
##    ANY character you put into a macro parameter will be passed to the  ##
##    macro. Therefore ...,src/music,... will represent "src/music"       ##
##    folder, whereas ...,  src/music,... means "  src/sprites" folder.   ##
##  * You can omit parameters by leaving them empty.                      ##
##  * Parameter  (5) (Aditional options) is  optional and  generally not  ##
##    required.                                                           ##
############################################################################
