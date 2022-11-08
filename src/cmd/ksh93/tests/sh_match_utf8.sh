########################################################################
#                                                                      #
#               This software is part of the ast package               #
#          Copyright (c) 1982-2012 AT&T Intellectual Property          #
#                    Copyright (c) 2012 Roland Mainz                   #
#          Copyright (c) 2020-2022 Contributors to ksh 93u+m           #
#                      and is licensed under the                       #
#                 Eclipse Public License, Version 2.0                  #
#                                                                      #
#                A copy of the License is available at                 #
#      https://www.eclipse.org/org/documents/epl-2.0/EPL-2.0.html      #
#         (with md5 checksum 84283fa8859daf213bdda5a9f8d1be1d)         #
#                                                                      #
#                    David Korn <dgkorn@gmail.com>                     #
#                Roland Mainz <roland.mainz@nrubsig.org>               #
#            Johnothan King <johnothanking@protonmail.com>             #
#                  Martijn Dekker <martijn@inlv.org>                   #
#                                                                      #
########################################################################

#
# This test module tests the .sh.match pattern matching facility
#

. "${SHTESTS_COMMON:-${0%/*}/_common}"

# Force wchar RE match.
LC_ALL=C.UTF8

# Issue #577
# =====
[[ "[a] b [c] d" =~ ^\[[^]]+\] ]]  && [ ! "${.sh.match}" = '[a]' ] && err_exit 'pattern ^\[[^]]+ broken'


# ======
exit $((Errors<125?Errors:125))
