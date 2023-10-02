########################################################################
#                                                                      #
#               This software is part of the ast package               #
#          Copyright (c) 1982-2011 AT&T Intellectual Property          #
#          Copyright (c) 2020-2023 Contributors to ksh 93u+m           #
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

R="$SHELL $0 run" 
((!$#)) &&  { $R&$R&$R&$R&$R&$R&$R&$R&$R&$R&$R&$R&$R&$R&$R& ; }

integer e=0
for((;;))
{ $(expr A : B >/dev/null) && ((e=1))
  ((SECONDS>2)) && break;
}
((!$#&&e)) && err_exit '$(:>/dev/null)'
# ======
exit $((Errors<125?Errors:125))
