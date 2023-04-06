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
# Run this script as 'tmp=$PWD ksh ./printf-2.sh gen' to regen the lines after the
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

# cdp : Check gdate vs printf.
#       $1:date-STRING [$2:printf-STRING]
#       When $2 not given we use $1
function cdp # 1:date-STRING [2:printf-STRING]
{ integer i
  for((i=0;i<2;i++))
  { M=$("$gd" +"$f" --date="$1")
    printf -v p "%($f)T" "exact ${2:-$1}"  
    [[ $p == $M ]] && return
  }
}

#
# Gen section.
# -----------
[ "$1" = gen ] &&
{ integer i
  for((i=0;i<2;i++)){ case $i in
  1) #===== Test lines generation ============================================

     # Various keywords last, this, next,
     # Note that ksh don't support fortnight
     for k in last this next ; do
     for u in years months weeks days hours minutes seconds ; do
     for d in '' ago ; do
       gen cdp "$k $u $d"
     done ; done ; done     

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
cdp 'last years '                                    || err_exit $(f $LINENO)
cdp 'last years ago'                                 || err_exit $(f $LINENO)
cdp 'last months '                                   || err_exit $(f $LINENO)
cdp 'last months ago'                                || err_exit $(f $LINENO)
cdp 'last weeks '                                    || err_exit $(f $LINENO)
cdp 'last weeks ago'                                 || err_exit $(f $LINENO)
cdp 'last days '                                     || err_exit $(f $LINENO)
cdp 'last days ago'                                  || err_exit $(f $LINENO)
cdp 'last hours '                                    || err_exit $(f $LINENO)
cdp 'last hours ago'                                 || err_exit $(f $LINENO)
cdp 'last minutes '                                  || err_exit $(f $LINENO)
cdp 'last minutes ago'                               || err_exit $(f $LINENO)
cdp 'last seconds '                                  || err_exit $(f $LINENO)
cdp 'last seconds ago'                               || err_exit $(f $LINENO)
cdp 'this years '                                    || err_exit $(f $LINENO)
cdp 'this years ago'                                 || err_exit $(f $LINENO)
cdp 'this months '                                   || err_exit $(f $LINENO)
cdp 'this months ago'                                || err_exit $(f $LINENO)
cdp 'this weeks '                                    || err_exit $(f $LINENO)
cdp 'this weeks ago'                                 || err_exit $(f $LINENO)
cdp 'this days '                                     || err_exit $(f $LINENO)
cdp 'this days ago'                                  || err_exit $(f $LINENO)
cdp 'this hours '                                    || err_exit $(f $LINENO)
cdp 'this hours ago'                                 || err_exit $(f $LINENO)
cdp 'this minutes '                                  || err_exit $(f $LINENO)
cdp 'this minutes ago'                               || err_exit $(f $LINENO)
cdp 'this seconds '                                  || err_exit $(f $LINENO)
cdp 'this seconds ago'                               || err_exit $(f $LINENO)
cdp 'next years '                                    || err_exit $(f $LINENO)
cdp 'next years ago'                                 || err_exit $(f $LINENO)
cdp 'next months '                                   || err_exit $(f $LINENO)
cdp 'next months ago'                                || err_exit $(f $LINENO)
cdp 'next weeks '                                    || err_exit $(f $LINENO)
cdp 'next weeks ago'                                 || err_exit $(f $LINENO)
cdp 'next days '                                     || err_exit $(f $LINENO)
cdp 'next days ago'                                  || err_exit $(f $LINENO)
cdp 'next hours '                                    || err_exit $(f $LINENO)
cdp 'next hours ago'                                 || err_exit $(f $LINENO)
cdp 'next minutes '                                  || err_exit $(f $LINENO)
cdp 'next minutes ago'                               || err_exit $(f $LINENO)
cdp 'next seconds '                                  || err_exit $(f $LINENO)
cdp 'next seconds ago'                               || err_exit $(f $LINENO)
# ======
exit $((Errors<125?Errors:125))
