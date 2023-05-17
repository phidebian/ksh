########################################################################
#                                                                      #
#              This file is part of the ksh 93u+m package              #
#          Copyright (c) 2022-2023 Contributors to ksh 93u+m           #
#                    <https://github.com/ksh93/ksh>                    #
#                      and is licensed under the                       #
#                 Eclipse Public License, Version 2.0                  #
#                                                                      #
#                A copy of the License is available at                 #
#      https://www.eclipse.org/org/documents/epl-2.0/EPL-2.0.html      #
#         (with md5 checksum 84283fa8859daf213bdda5a9f8d1be1d)         #
#                                                                      #
#                      Phi <phi.debian@gmail.com>                      #
#                  Martijn Dekker <martijn@inlv.org>                   #
#                                                                      #
########################################################################

PS1='$ '
. "${SHTESTS_COMMON:-${0%/*}/_common}"

# ======
# Test for https://github.com/ksh93/ksh/issues/324

function T
{
	typeset g
	printf -v g "$2" 1 2 3 4 5 6 7 8 9 0
	[[ $g == "$3" ]] || \err_exit "$1" "printf '$2': expected $(printf %q "$3"), got $(printf %q "$g")"
}

# This part was generated once, and can now be augmented with more test

x='1 2
3 4
5 6
7 8
9 0
'
f='%s %s\n'
T $LINENO "$f" "$x"

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
T $LINENO "$f" "$x"

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
T $LINENO "$f" "$x"

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
T $LINENO "$f" "$x"

x='1 1 2 2
3 3 4 4
5 5 6 6
7 7 8 8
9 9 0 0
'
f='%1$s %s %s %2$s\n'
T $LINENO "$f" "$x"

x='1 1 2 3
4 4 5 6
7 7 8 9
0 0  
'
f='%s %1$s %s %s\n'
T $LINENO "$f" "$x"

x='1 1 2 2
3 3 4 4
5 5 6 6
7 7 8 8
9 9 0 0
'
f='%s %1$s %2$s %s\n'
T $LINENO "$f" "$x"

x='2 1
4 3
6 5
8 7
0 9
'
f='%2$s %s\n'
T $LINENO "$f" "$x"

x='2 1 2 1
4 3 4 3
6 5 6 5
8 7 8 7
0 9 0 9
'
f='%2$s %1$s %2$s %1$s\n'
T $LINENO "$f" "$x"

x='2 1 1 2 1 2
4 3 3 4 3 4
6 5 5 6 5 6
8 7 7 8 7 8
0 9 9 0 9 0
'
f='%2$s %1$s %s %2$s %1$s %s\n'
T $LINENO "$f" "$x"

x=' 1 2
   3 4
     5 6
       7 8
9 0
'
f='%*2$s %s\n'
T $LINENO "$f" "$x"

x=' 1 2
    4 5
       7 8
 
'
f='%*2$.*3$s %s\n'
T $LINENO "$f" "$x"

x='  1 2
     4 5
        7 8
 
'
f='%*3$.*2$s %s\n'
T $LINENO "$f" "$x"

x='2   5
     7        0
'
f='%*s %*.*s\n'
T $LINENO "$f" "$x"

x='2 0005
     7 000000000
'
f='%*d %*.*d\n'
T $LINENO "$f" "$x"

x='2.000000 5.0000
7.000000 0.000000000
'
f='%*f %*.*f\n'
T $LINENO "$f" "$x"

x=' 3 2 1
    6 5 4
       9 8 7
  0
'
f='%3$*2$.*1$s %2$s %1$s\n'
T $LINENO "$f" "$x"

x='1 5
6 0
'
f='%s %5$s\n'
T $LINENO "$f" "$x"

# ======
exit $((Errors<125?Errors:125))
