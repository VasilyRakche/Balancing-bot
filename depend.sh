#****************************************************
# File          : depend.sh
# Author        : Peter  Miller
# Date          : 10.03.2008
# Description   : Miller,P.A. (1998),Recursive Make 
#                  Considered Harmful,AUUGN Journal 
#                  of AUUG Inc., 19(1), pp. 14-25
# Source        : http://aegis.sourceforge.net/auug97.pdf
#****************************************************

#!/bin/bash
DIR_d=$($1)
DIR_o=$($2)
shift 2

DEPFLAGS="-MM -MG $@"
case $DIR_d in
"" | ".")
arm-none-eabi-gcc $DEPFLAGS |
sed -e "s@\(.*\)\.o:@\1.d \1.o:@"
;;
*)
arm-none-eabi-gcc $DEPFLAGS |
sed -e "s@\(.*\)\.o:@$DIR_d/\1.d $DIR_o/\1.o:@"
;;
esac
