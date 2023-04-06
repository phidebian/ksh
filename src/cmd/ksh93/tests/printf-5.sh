########################################################################
#                                                                      #
#               This software is part of the ast package               #
#          Copyright (c) 1982-2011 AT&T Intellectual Property          #
#          Copyright (c) 2020-2022 Contributors to ksh 93u+m           #
#                      and is licensed under the                       #
#                 Eclipse Public License, Version 2.0                  #
#                                                                      #
#                A copy of the License is available at                 #
#      https://www.eclipse.org/org/documents/epl-2.0/EPL-2.0.html      #
#         (with md5 checksum 84283fa8859daf213bdda5a9f8d1be1d)         #
#                                                                      #
#                  David Korn <dgk@research.att.com>                   #
#                  Martijn Dekker <martijn@inlv.org>                   #
#            Johnothan King <johnothanking@protonmail.com>             #
#                                                                      #
########################################################################

. "${SHTESTS_COMMON:-${0%/*}/_common}"

# PHI: Initial version.
#      The intent is to check Issue #182, but other printf issues can
#      be hosted here.

# Issue #182.
# printf %T date parsing: GNU-style "ago" date spec completely broken #182 
# https://github.com/ksh93/ksh/issues/182
#

# Usage:
# Edit this file and fill more tests in the "Gen section".
# Don't edit line after the #-- Lines ... ----- marker, this script regen
# them based on the generation section.
#
# Run this script as 'tmp=$PWD ksh ./printf-5.sh gen' to regen the lines after the
#-- Lines ... ----- marker
# The newly gen'ed printf.sh can then be committed in GIT.

[ ! "${KSH_VERSION:-}" ] &&
{ echo "must be run from a ksh" ; exit 1
}

# This test requires a decent gnudate. On a system with no gnudate, we skip
# the test with a warning (don't count as an error).
#
gd=$(	set -o noglob
	IFS=:
	search=$PATH:$userPATH:
	for p in $search
	do	[[ -z $p ]] && p=.
		for c in gnudate gdate date
		do	if	[[ -x $p/$c && $(LC_ALL=C "$p/$c" --version 2>/dev/null) == 'date (GNU coreutils)'* ]]
			then	print -r -- "$p/$c"
				exit 0
			fi
		done
	done
	exit 1
) ||
{ warning "GNU date(1) required -- tests skipped"; exit 0
}

# ksh93 printf %T don't (can't?) handle TZ correctly when crossing DST during
# time traveling i.e "-xyz month"
export TZ=UTC

# Failure report.
typeset -a L="" ; while IFS='' read -r l ; do L+=( "$l" ) ; done <$0
function f # 1:lineno p:printf-output M:string-to-match
{ printf '%s  (expected %q, got %q)' "${L[$1]%  *}" "$M" "$p"
}
 
# Gen test lines
function gen # $1:chck-func $2... check args.
{ typeset a f=$1; shift
  printf -v a "'%s' " "$@"
  printf '%s %-48s || err_''exit $(f $LINENO)\n' "$f" "$a"
}

f='%Y-%m-%d %H:%M:%S'

# Check functions
# ---------------
#

#
# cps : Check printf vs a string
function cps # $1:printf-STRING $2:match-string 
{ M="$2" ; printf -v p "%($f)T" "$1"  
  [[ $p == $M ]]
}

#
# Gen section.
# -----------
[ "$1" = gen ] &&
{ integer i
  for((i=0;i<2;i++)){ case $i in
  1) #===== Test lines generation ============================================

     # Week dates
     gen cps "2020W20"             "2020-05-11 00:00:00"
     gen cps "2020W20 exact"       "2020-05-11 00:00:00" 
     gen cps "2020-W20"            "2020-05-11 00:00:00"
     gen cps "2020-W20 exact"      "2020-05-11 00:00:00" 
     gen cps "2020W20  fri"        "2020-05-15 00:00:00" 
     gen cps "2020-W20 fri"        "2020-05-15 00:00:00" 
     gen cps "2020W20  next fri"   "2020-05-22 00:00:00" 
     gen cps "2020-W20 next fri"   "2020-05-22 00:00:00" 
     gen cps "2020W20  second fri" "2020-05-08 00:00:00" 
     gen cps "2020-W20 second fri" "2020-05-08 00:00:00" 
     gen cps "2020W20  third fri"  "2020-05-15 00:00:00" 
     gen cps "2020-W20 third fri"  "2020-05-15 00:00:00" 

     # ksh don't handle Week dates with Day# 2020-W20-D20           

     # Emit  the end of test trailer.
     echo '# ======'
     echo 'exit $((Errors<125?Errors:125))'
     
     #===== Test lines generation ============================================
     exit 0
     ;;
  0) printf "%s\n" "${L[@]:1:LINENO+3}";;
  esac }
}>$0
#-- Lines after this point are gen'd, don't edit (you've been warned) ---------
cps '2020W20' '2020-05-11 00:00:00'                  || err_exit $(f $LINENO)
cps '2020W20 exact' '2020-05-11 00:00:00'            || err_exit $(f $LINENO)
cps '2020-W20' '2020-05-11 00:00:00'                 || err_exit $(f $LINENO)
cps '2020-W20 exact' '2020-05-11 00:00:00'           || err_exit $(f $LINENO)
cps '2020W20  fri' '2020-05-15 00:00:00'             || err_exit $(f $LINENO)
cps '2020-W20 fri' '2020-05-15 00:00:00'             || err_exit $(f $LINENO)
cps '2020W20  next fri' '2020-05-22 00:00:00'        || err_exit $(f $LINENO)
cps '2020-W20 next fri' '2020-05-22 00:00:00'        || err_exit $(f $LINENO)
cps '2020W20  second fri' '2020-05-08 00:00:00'      || err_exit $(f $LINENO)
cps '2020-W20 second fri' '2020-05-08 00:00:00'      || err_exit $(f $LINENO)
cps '2020W20  third fri' '2020-05-15 00:00:00'       || err_exit $(f $LINENO)
cps '2020-W20 third fri' '2020-05-15 00:00:00'       || err_exit $(f $LINENO)
# ======
exit $((Errors<125?Errors:125))
