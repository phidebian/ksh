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
# Run this script as "ksh ./printf.sh gen" to regen the lines after the
#-- Lines ... ----- marker
# The newly gen'ed printf.sh can then be committed in GIT.

[ ! "${KSH_VERSION:-}" ] &&
{ echo "must be run from a ksh" ; exit 1
}

# This test require a descent gnudate, on system with no gnudate, we skip
# the test with a warning (don't count as an error).
#
gd=$(command -v gnudate || command -v gdate || command -v date)
$gd --version | grep -q GNU ||
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
# cdp : Check gdate vs printf.
#       $1:date-STRING [$2:printf-STRING]
#       When $2 not given we use $1
function cdp # 1:date-STRING [2:printf-STRING]
{ integer i
  for((i=0;i<2;i++))
  { M=$(date +"$f" --date="$1")
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
     echo '. "${SHTESTS_COMMON:-${0%/*}/_common}"'

     # Trivial
     gen cdp now

     # Abs time
     gen cdp "@1234567890.987654321" "#1234567890.987654321"

     # The ago case, inspired by Martijn #182 test case, here we do less
     # test than Martijn, but span on more rollover, to trig bug that works
     # on 1 rollover but not mode (modulo bugs)
     for i in -40 -20 -10 -5 -0 0 _0 5 +5 10 +10 20 +20 40 +40 ; do
     for u in years months weeks days hours minutes seconds ; do
     for d in '' ago ; do
       gen cdp "$i $u $d"
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
. "${SHTESTS_COMMON:-${0%/*}/_common}"
cdp 'now'                                            || err_exit $(f $LINENO)
cdp '@1234567890.987654321' '#1234567890.987654321'  || err_exit $(f $LINENO)
cdp '-40 years '                                     || err_exit $(f $LINENO)
cdp '-40 years ago'                                  || err_exit $(f $LINENO)
cdp '-40 months '                                    || err_exit $(f $LINENO)
cdp '-40 months ago'                                 || err_exit $(f $LINENO)
cdp '-40 weeks '                                     || err_exit $(f $LINENO)
cdp '-40 weeks ago'                                  || err_exit $(f $LINENO)
cdp '-40 days '                                      || err_exit $(f $LINENO)
cdp '-40 days ago'                                   || err_exit $(f $LINENO)
cdp '-40 hours '                                     || err_exit $(f $LINENO)
cdp '-40 hours ago'                                  || err_exit $(f $LINENO)
cdp '-40 minutes '                                   || err_exit $(f $LINENO)
cdp '-40 minutes ago'                                || err_exit $(f $LINENO)
cdp '-40 seconds '                                   || err_exit $(f $LINENO)
cdp '-40 seconds ago'                                || err_exit $(f $LINENO)
cdp '-20 years '                                     || err_exit $(f $LINENO)
cdp '-20 years ago'                                  || err_exit $(f $LINENO)
cdp '-20 months '                                    || err_exit $(f $LINENO)
cdp '-20 months ago'                                 || err_exit $(f $LINENO)
cdp '-20 weeks '                                     || err_exit $(f $LINENO)
cdp '-20 weeks ago'                                  || err_exit $(f $LINENO)
cdp '-20 days '                                      || err_exit $(f $LINENO)
cdp '-20 days ago'                                   || err_exit $(f $LINENO)
cdp '-20 hours '                                     || err_exit $(f $LINENO)
cdp '-20 hours ago'                                  || err_exit $(f $LINENO)
cdp '-20 minutes '                                   || err_exit $(f $LINENO)
cdp '-20 minutes ago'                                || err_exit $(f $LINENO)
cdp '-20 seconds '                                   || err_exit $(f $LINENO)
cdp '-20 seconds ago'                                || err_exit $(f $LINENO)
cdp '-10 years '                                     || err_exit $(f $LINENO)
cdp '-10 years ago'                                  || err_exit $(f $LINENO)
cdp '-10 months '                                    || err_exit $(f $LINENO)
cdp '-10 months ago'                                 || err_exit $(f $LINENO)
cdp '-10 weeks '                                     || err_exit $(f $LINENO)
cdp '-10 weeks ago'                                  || err_exit $(f $LINENO)
cdp '-10 days '                                      || err_exit $(f $LINENO)
cdp '-10 days ago'                                   || err_exit $(f $LINENO)
cdp '-10 hours '                                     || err_exit $(f $LINENO)
cdp '-10 hours ago'                                  || err_exit $(f $LINENO)
cdp '-10 minutes '                                   || err_exit $(f $LINENO)
cdp '-10 minutes ago'                                || err_exit $(f $LINENO)
cdp '-10 seconds '                                   || err_exit $(f $LINENO)
cdp '-10 seconds ago'                                || err_exit $(f $LINENO)
cdp '-5 years '                                      || err_exit $(f $LINENO)
cdp '-5 years ago'                                   || err_exit $(f $LINENO)
cdp '-5 months '                                     || err_exit $(f $LINENO)
cdp '-5 months ago'                                  || err_exit $(f $LINENO)
cdp '-5 weeks '                                      || err_exit $(f $LINENO)
cdp '-5 weeks ago'                                   || err_exit $(f $LINENO)
cdp '-5 days '                                       || err_exit $(f $LINENO)
cdp '-5 days ago'                                    || err_exit $(f $LINENO)
cdp '-5 hours '                                      || err_exit $(f $LINENO)
cdp '-5 hours ago'                                   || err_exit $(f $LINENO)
cdp '-5 minutes '                                    || err_exit $(f $LINENO)
cdp '-5 minutes ago'                                 || err_exit $(f $LINENO)
cdp '-5 seconds '                                    || err_exit $(f $LINENO)
cdp '-5 seconds ago'                                 || err_exit $(f $LINENO)
cdp '0 years '                                       || err_exit $(f $LINENO)
cdp '0 years ago'                                    || err_exit $(f $LINENO)
cdp '0 months '                                      || err_exit $(f $LINENO)
cdp '0 months ago'                                   || err_exit $(f $LINENO)
cdp '0 weeks '                                       || err_exit $(f $LINENO)
cdp '0 weeks ago'                                    || err_exit $(f $LINENO)
cdp '0 days '                                        || err_exit $(f $LINENO)
cdp '0 days ago'                                     || err_exit $(f $LINENO)
cdp '0 hours '                                       || err_exit $(f $LINENO)
cdp '0 hours ago'                                    || err_exit $(f $LINENO)
cdp '0 minutes '                                     || err_exit $(f $LINENO)
cdp '0 minutes ago'                                  || err_exit $(f $LINENO)
cdp '0 seconds '                                     || err_exit $(f $LINENO)
cdp '0 seconds ago'                                  || err_exit $(f $LINENO)
cdp '0 years '                                       || err_exit $(f $LINENO)
cdp '0 years ago'                                    || err_exit $(f $LINENO)
cdp '0 months '                                      || err_exit $(f $LINENO)
cdp '0 months ago'                                   || err_exit $(f $LINENO)
cdp '0 weeks '                                       || err_exit $(f $LINENO)
cdp '0 weeks ago'                                    || err_exit $(f $LINENO)
cdp '0 days '                                        || err_exit $(f $LINENO)
cdp '0 days ago'                                     || err_exit $(f $LINENO)
cdp '0 hours '                                       || err_exit $(f $LINENO)
cdp '0 hours ago'                                    || err_exit $(f $LINENO)
cdp '0 minutes '                                     || err_exit $(f $LINENO)
cdp '0 minutes ago'                                  || err_exit $(f $LINENO)
cdp '0 seconds '                                     || err_exit $(f $LINENO)
cdp '0 seconds ago'                                  || err_exit $(f $LINENO)
cdp '0 years '                                       || err_exit $(f $LINENO)
cdp '0 years ago'                                    || err_exit $(f $LINENO)
cdp '0 months '                                      || err_exit $(f $LINENO)
cdp '0 months ago'                                   || err_exit $(f $LINENO)
cdp '0 weeks '                                       || err_exit $(f $LINENO)
cdp '0 weeks ago'                                    || err_exit $(f $LINENO)
cdp '0 days '                                        || err_exit $(f $LINENO)
cdp '0 days ago'                                     || err_exit $(f $LINENO)
cdp '0 hours '                                       || err_exit $(f $LINENO)
cdp '0 hours ago'                                    || err_exit $(f $LINENO)
cdp '0 minutes '                                     || err_exit $(f $LINENO)
cdp '0 minutes ago'                                  || err_exit $(f $LINENO)
cdp '0 seconds '                                     || err_exit $(f $LINENO)
cdp '0 seconds ago'                                  || err_exit $(f $LINENO)
cdp '5 years '                                       || err_exit $(f $LINENO)
cdp '5 years ago'                                    || err_exit $(f $LINENO)
cdp '5 months '                                      || err_exit $(f $LINENO)
cdp '5 months ago'                                   || err_exit $(f $LINENO)
cdp '5 weeks '                                       || err_exit $(f $LINENO)
cdp '5 weeks ago'                                    || err_exit $(f $LINENO)
cdp '5 days '                                        || err_exit $(f $LINENO)
cdp '5 days ago'                                     || err_exit $(f $LINENO)
cdp '5 hours '                                       || err_exit $(f $LINENO)
cdp '5 hours ago'                                    || err_exit $(f $LINENO)
cdp '5 minutes '                                     || err_exit $(f $LINENO)
cdp '5 minutes ago'                                  || err_exit $(f $LINENO)
cdp '5 seconds '                                     || err_exit $(f $LINENO)
cdp '5 seconds ago'                                  || err_exit $(f $LINENO)
cdp '5 years '                                       || err_exit $(f $LINENO)
cdp '5 years ago'                                    || err_exit $(f $LINENO)
cdp '5 months '                                      || err_exit $(f $LINENO)
cdp '5 months ago'                                   || err_exit $(f $LINENO)
cdp '5 weeks '                                       || err_exit $(f $LINENO)
cdp '5 weeks ago'                                    || err_exit $(f $LINENO)
cdp '5 days '                                        || err_exit $(f $LINENO)
cdp '5 days ago'                                     || err_exit $(f $LINENO)
cdp '5 hours '                                       || err_exit $(f $LINENO)
cdp '5 hours ago'                                    || err_exit $(f $LINENO)
cdp '5 minutes '                                     || err_exit $(f $LINENO)
cdp '5 minutes ago'                                  || err_exit $(f $LINENO)
cdp '5 seconds '                                     || err_exit $(f $LINENO)
cdp '5 seconds ago'                                  || err_exit $(f $LINENO)
cdp '10 years '                                      || err_exit $(f $LINENO)
cdp '10 years ago'                                   || err_exit $(f $LINENO)
cdp '10 months '                                     || err_exit $(f $LINENO)
cdp '10 months ago'                                  || err_exit $(f $LINENO)
cdp '10 weeks '                                      || err_exit $(f $LINENO)
cdp '10 weeks ago'                                   || err_exit $(f $LINENO)
cdp '10 days '                                       || err_exit $(f $LINENO)
cdp '10 days ago'                                    || err_exit $(f $LINENO)
cdp '10 hours '                                      || err_exit $(f $LINENO)
cdp '10 hours ago'                                   || err_exit $(f $LINENO)
cdp '10 minutes '                                    || err_exit $(f $LINENO)
cdp '10 minutes ago'                                 || err_exit $(f $LINENO)
cdp '10 seconds '                                    || err_exit $(f $LINENO)
cdp '10 seconds ago'                                 || err_exit $(f $LINENO)
cdp '10 years '                                      || err_exit $(f $LINENO)
cdp '10 years ago'                                   || err_exit $(f $LINENO)
cdp '10 months '                                     || err_exit $(f $LINENO)
cdp '10 months ago'                                  || err_exit $(f $LINENO)
cdp '10 weeks '                                      || err_exit $(f $LINENO)
cdp '10 weeks ago'                                   || err_exit $(f $LINENO)
cdp '10 days '                                       || err_exit $(f $LINENO)
cdp '10 days ago'                                    || err_exit $(f $LINENO)
cdp '10 hours '                                      || err_exit $(f $LINENO)
cdp '10 hours ago'                                   || err_exit $(f $LINENO)
cdp '10 minutes '                                    || err_exit $(f $LINENO)
cdp '10 minutes ago'                                 || err_exit $(f $LINENO)
cdp '10 seconds '                                    || err_exit $(f $LINENO)
cdp '10 seconds ago'                                 || err_exit $(f $LINENO)
cdp '20 years '                                      || err_exit $(f $LINENO)
cdp '20 years ago'                                   || err_exit $(f $LINENO)
cdp '20 months '                                     || err_exit $(f $LINENO)
cdp '20 months ago'                                  || err_exit $(f $LINENO)
cdp '20 weeks '                                      || err_exit $(f $LINENO)
cdp '20 weeks ago'                                   || err_exit $(f $LINENO)
cdp '20 days '                                       || err_exit $(f $LINENO)
cdp '20 days ago'                                    || err_exit $(f $LINENO)
cdp '20 hours '                                      || err_exit $(f $LINENO)
cdp '20 hours ago'                                   || err_exit $(f $LINENO)
cdp '20 minutes '                                    || err_exit $(f $LINENO)
cdp '20 minutes ago'                                 || err_exit $(f $LINENO)
cdp '20 seconds '                                    || err_exit $(f $LINENO)
cdp '20 seconds ago'                                 || err_exit $(f $LINENO)
cdp '20 years '                                      || err_exit $(f $LINENO)
cdp '20 years ago'                                   || err_exit $(f $LINENO)
cdp '20 months '                                     || err_exit $(f $LINENO)
cdp '20 months ago'                                  || err_exit $(f $LINENO)
cdp '20 weeks '                                      || err_exit $(f $LINENO)
cdp '20 weeks ago'                                   || err_exit $(f $LINENO)
cdp '20 days '                                       || err_exit $(f $LINENO)
cdp '20 days ago'                                    || err_exit $(f $LINENO)
cdp '20 hours '                                      || err_exit $(f $LINENO)
cdp '20 hours ago'                                   || err_exit $(f $LINENO)
cdp '20 minutes '                                    || err_exit $(f $LINENO)
cdp '20 minutes ago'                                 || err_exit $(f $LINENO)
cdp '20 seconds '                                    || err_exit $(f $LINENO)
cdp '20 seconds ago'                                 || err_exit $(f $LINENO)
cdp '40 years '                                      || err_exit $(f $LINENO)
cdp '40 years ago'                                   || err_exit $(f $LINENO)
cdp '40 months '                                     || err_exit $(f $LINENO)
cdp '40 months ago'                                  || err_exit $(f $LINENO)
cdp '40 weeks '                                      || err_exit $(f $LINENO)
cdp '40 weeks ago'                                   || err_exit $(f $LINENO)
cdp '40 days '                                       || err_exit $(f $LINENO)
cdp '40 days ago'                                    || err_exit $(f $LINENO)
cdp '40 hours '                                      || err_exit $(f $LINENO)
cdp '40 hours ago'                                   || err_exit $(f $LINENO)
cdp '40 minutes '                                    || err_exit $(f $LINENO)
cdp '40 minutes ago'                                 || err_exit $(f $LINENO)
cdp '40 seconds '                                    || err_exit $(f $LINENO)
cdp '40 seconds ago'                                 || err_exit $(f $LINENO)
cdp '40 years '                                      || err_exit $(f $LINENO)
cdp '40 years ago'                                   || err_exit $(f $LINENO)
cdp '40 months '                                     || err_exit $(f $LINENO)
cdp '40 months ago'                                  || err_exit $(f $LINENO)
cdp '40 weeks '                                      || err_exit $(f $LINENO)
cdp '40 weeks ago'                                   || err_exit $(f $LINENO)
cdp '40 days '                                       || err_exit $(f $LINENO)
cdp '40 days ago'                                    || err_exit $(f $LINENO)
cdp '40 hours '                                      || err_exit $(f $LINENO)
cdp '40 hours ago'                                   || err_exit $(f $LINENO)
cdp '40 minutes '                                    || err_exit $(f $LINENO)
cdp '40 minutes ago'                                 || err_exit $(f $LINENO)
cdp '40 seconds '                                    || err_exit $(f $LINENO)
cdp '40 seconds ago'                                 || err_exit $(f $LINENO)
# ======
exit $((Errors<125?Errors:125))
