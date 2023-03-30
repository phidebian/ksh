########################################################################
#                                                                      #
#               This software is part of the ast package               #
#          Copyright (c) 1982-2012 AT&T Intellectual Property          #
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

PS1='$ '
. "${SHTESTS_COMMON:-${0%/*}/_common}"
	
# ======
# Test for issue#324
# 'err_''exit' is the name to use to avoid src/cmd/ksh93/tests/shtests
# grep -c counting.

# We don't want the alias (made by _common) instead we use our T function
# that will reference 'err_''exit' function located in _common too.
unalias 'err_''exit' 

function T
{ typeset l="$1" f="$2" x="$3" g=''
  printf  -v g  "$f" 1 2 3 4 5 6 7 8 9 0
  [ "$g" = "$x" ] || # src/cmd/ksh93/tests/shtest grep -c accounting
  'err_''exit' "$l" "printf '$f'"
}  

# This part was generated once, and can now be augmented with more test

x='1 2
3 4
5 6
7 8
9 0
'
f='%s %s\n'
T $LINENO "$f" "$x" # err_exit src/cmd/ksh93/tests/shtests grep -c accounting

x='1 1
2 2
3 3
4 4
5 5
6 6
7 7
8 8
9 9
0 0
'
f='%s %1$s\n'
T $LINENO "$f" "$x" # err_exit src/cmd/ksh93/tests/shtests grep -c accounting

x='1 1
2 2
3 3
4 4
5 5
6 6
7 7
8 8
9 9
0 0
'
f='%1$s %s\n'
T $LINENO "$f" "$x" # err_exit src/cmd/ksh93/tests/shtests grep -c accounting

x='1 1
2 2
3 3
4 4
5 5
6 6
7 7
8 8
9 9
0 0
'
f='%1$s %1$s\n'
T $LINENO "$f" "$x" # err_exit src/cmd/ksh93/tests/shtests grep -c accounting

x='1 1 2 2
3 3 4 4
5 5 6 6
7 7 8 8
9 9 0 0
'
f='%1$s %s %s %2$s\n'
T $LINENO "$f" "$x" # err_exit src/cmd/ksh93/tests/shtests grep -c accounting

x='1 1 2 3
4 4 5 6
7 7 8 9
0 0  
'
f='%s %1$s %s %s\n'
T $LINENO "$f" "$x" # err_exit src/cmd/ksh93/tests/shtests grep -c accounting

x='1 1 2 2
3 3 4 4
5 5 6 6
7 7 8 8
9 9 0 0
'
f='%s %1$s %2$s %s\n'
T $LINENO "$f" "$x" # err_exit src/cmd/ksh93/tests/shtests grep -c accounting

x='2 1
4 3
6 5
8 7
0 9
'
f='%2$s %s\n'
T $LINENO "$f" "$x" # err_exit src/cmd/ksh93/tests/shtests grep -c accounting

x='2 1 2 1
4 3 4 3
6 5 6 5
8 7 8 7
0 9 0 9
'
f='%2$s %1$s %2$s %1$s\n'
T $LINENO "$f" "$x" # err_exit src/cmd/ksh93/tests/shtests grep -c accounting

x='2 1 1 2 1 2
4 3 3 4 3 4
6 5 5 6 5 6
8 7 7 8 7 8
0 9 9 0 9 0
'
f='%2$s %1$s %s %2$s %1$s %s\n'
T $LINENO "$f" "$x" # err_exit src/cmd/ksh93/tests/shtests grep -c accounting

x=' 1 2
   3 4
     5 6
       7 8
9 0
'
f='%*2$s %s\n'
T $LINENO "$f" "$x" # err_exit src/cmd/ksh93/tests/shtests grep -c accounting

x=' 1 2
    4 5
       7 8
 
'
f='%*2$.*3$s %s\n'
T $LINENO "$f" "$x" # err_exit src/cmd/ksh93/tests/shtests grep -c accounting

x='  1 2
     4 5
        7 8
 
'
f='%*3$.*2$s %s\n'
T $LINENO "$f" "$x" # err_exit src/cmd/ksh93/tests/shtests grep -c accounting

x='2   5
     7        0
'
f='%*s %*.*s\n'
T $LINENO "$f" "$x" # err_exit src/cmd/ksh93/tests/shtests grep -c accounting

x='2 0005
     7 000000000
'
f='%*d %*.*d\n'
T $LINENO "$f" "$x" # err_exit src/cmd/ksh93/tests/shtests grep -c accounting

x='2.000000 5.0000
7.000000 0.000000000
'
f='%*f %*.*f\n'
T $LINENO "$f" "$x" # err_exit src/cmd/ksh93/tests/shtests grep -c accounting

x=' 3 2 1
    6 5 4
       9 8 7
  0
'
f='%3$*2$.*1$s %2$s %1$s\n'
T $LINENO "$f" "$x" # err_exit src/cmd/ksh93/tests/shtests grep -c accounting

x='1 5
6 0
'
f='%s %5$s\n'
T $LINENO "$f" "$x" # err_exit src/cmd/ksh93/tests/shtests grep -c accounting


# ======
exit $((Errors<125?Errors:125))
