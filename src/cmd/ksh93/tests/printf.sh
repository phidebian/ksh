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

# We don't want the alias (made by _common) instead we use our chk() function
# that will reference 'err_''exit' function located in _common too.
unalias 'err_''exit' 

typeset -a S ; S+=(0)
while read -r l ; do S+=("$l") ; done <$0

function chk
{ [ "$g" = "$x" ] || # src/cmd/ksh93/tests/shtest grep -c accounting
  'err_''exit' "$l" "${S[$1]}"
}  

# This part was generated once, and can now be augmented with more test


# err_exit src/cmd/ksh93/tests/shtests grep -c accounting
x='1 2
3 4
5 6
7 8
9 0
'
printf -v g '%s %s\n'                     1 2 3 4 5 6 7 8 9 0 ; chk $LINENO

# err_exit src/cmd/ksh93/tests/shtests grep -c accounting
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
printf -v g '%s %1$s\n'                   1 2 3 4 5 6 7 8 9 0 ; chk $LINENO

# err_exit src/cmd/ksh93/tests/shtests grep -c accounting
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
printf -v g '%1$s %s\n'                   1 2 3 4 5 6 7 8 9 0 ; chk $LINENO

# err_exit src/cmd/ksh93/tests/shtests grep -c accounting
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
printf -v g '%1$s %1$s\n'                 1 2 3 4 5 6 7 8 9 0 ; chk $LINENO

# err_exit src/cmd/ksh93/tests/shtests grep -c accounting
x='1 1 2 2
3 3 4 4
5 5 6 6
7 7 8 8
9 9 0 0
'
printf -v g '%1$s %s %s %2$s\n'           1 2 3 4 5 6 7 8 9 0 ; chk $LINENO

# err_exit src/cmd/ksh93/tests/shtests grep -c accounting
x='1 1 2 3
4 4 5 6
7 7 8 9
0 0  
'
printf -v g '%s %1$s %s %s\n'             1 2 3 4 5 6 7 8 9 0 ; chk $LINENO

# err_exit src/cmd/ksh93/tests/shtests grep -c accounting
x='1 1 2 2
3 3 4 4
5 5 6 6
7 7 8 8
9 9 0 0
'
printf -v g '%s %1$s %2$s %s\n'           1 2 3 4 5 6 7 8 9 0 ; chk $LINENO

# err_exit src/cmd/ksh93/tests/shtests grep -c accounting
x='2 1
4 3
6 5
8 7
0 9
'
printf -v g '%2$s %s\n'                   1 2 3 4 5 6 7 8 9 0 ; chk $LINENO

# err_exit src/cmd/ksh93/tests/shtests grep -c accounting
x='2 1 2 1
4 3 4 3
6 5 6 5
8 7 8 7
0 9 0 9
'
printf -v g '%2$s %1$s %2$s %1$s\n'       1 2 3 4 5 6 7 8 9 0 ; chk $LINENO

# err_exit src/cmd/ksh93/tests/shtests grep -c accounting
x='2 1 1 2 1 2
4 3 3 4 3 4
6 5 5 6 5 6
8 7 7 8 7 8
0 9 9 0 9 0
'
printf -v g '%2$s %1$s %s %2$s %1$s %s\n' 1 2 3 4 5 6 7 8 9 0 ; chk $LINENO

# err_exit src/cmd/ksh93/tests/shtests grep -c accounting
x=' 1 2
   3 4
     5 6
       7 8
9 0
'
printf -v g '%*2$s %s\n'                  1 2 3 4 5 6 7 8 9 0 ; chk $LINENO

# err_exit src/cmd/ksh93/tests/shtests grep -c accounting
x=' 1 2
    4 5
       7 8
 
'
printf -v g '%*2$.*3$s %s\n'              1 2 3 4 5 6 7 8 9 0 ; chk $LINENO

# err_exit src/cmd/ksh93/tests/shtests grep -c accounting
x='  1 2
     4 5
        7 8
 
'
printf -v g '%*3$.*2$s %s\n'              1 2 3 4 5 6 7 8 9 0 ; chk $LINENO

# err_exit src/cmd/ksh93/tests/shtests grep -c accounting
x='2   5
     7        0
'
printf -v g '%*s %*.*s\n'                 1 2 3 4 5 6 7 8 9 0 ; chk $LINENO

# err_exit src/cmd/ksh93/tests/shtests grep -c accounting
x='2 0005
     7 000000000
'
printf -v g '%*d %*.*d\n'                 1 2 3 4 5 6 7 8 9 0 ; chk $LINENO

# err_exit src/cmd/ksh93/tests/shtests grep -c accounting
x='2.000000 5.0000
7.000000 0.000000000
'
printf -v g '%*f %*.*f\n'                 1 2 3 4 5 6 7 8 9 0 ; chk $LINENO

# err_exit src/cmd/ksh93/tests/shtests grep -c accounting
x=' 3 2 1
    6 5 4
       9 8 7
  0
'
printf -v g '%3$*2$.*1$s %2$s %1$s\n'     1 2 3 4 5 6 7 8 9 0 ; chk $LINENO

# err_exit src/cmd/ksh93/tests/shtests grep -c accounting
x='1 5
6 0
'
printf -v g '%s %5$s\n'                   1 2 3 4 5 6 7 8 9 0 ; chk $LINENO

# err_exit src/cmd/ksh93/tests/shtests grep -c accounting
x='\\ \\\\
'
printf -v g '%1$b %1$s\n'             '\\\\'                  ; chk $LINENO

# err_exit src/cmd/ksh93/tests/shtests grep -c accounting
x='\\\\ \\
'
printf -v g '%1$s %1$b\n'             '\\\\'                  ; chk $LINENO
 
# err_exit src/cmd/ksh93/tests/shtests grep -c accounting
x='1.2 1 1 1 1.200000e+00 1.2
'
printf -v g '%1$s %1$d %1$x %1$o %1$e %1$g\n' 1.2             ; chk $LINENO

# ======
exit $((Errors<125?Errors:125))
