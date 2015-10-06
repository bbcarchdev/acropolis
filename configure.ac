## Acropolis: The Research & Education Space software stack
##
## A platform being jointly delivered by Jisc, the British Universities
## Film & Video Council (BUFVC), and the BBC with the aim of bringing as
## much as possible of the UK’s publicly-held archives, and more besides,
## to learners and teachers across the UK.
##
## Author: Mo McRoberts <mo.mcroberts@bbc.co.uk>
##
## Copyright (c) 2015 BBC
##
##  Licensed under the Apache License, Version 2.0 (the "License");
##  you may not use this file except in compliance with the License.
##  You may obtain a copy of the License at
##
##      http://www.apache.org/licenses/LICENSE-2.0
##
##  Unless required by applicable law or agreed to in writing, software
##  distributed under the License is distributed on an "AS IS" BASIS,
##  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
##  See the License for the specific language governing permissions and
##  limitations under the License.

AC_INIT([res],m4_esyscmd([/bin/sh m4/get-version.sh]),[RESFeedback@bbc.co.uk],,[https://bbcarchdev.github.io/acropolis/])
AC_CONFIG_MACRO_DIR([m4])

dnl Ordinarily, we would not do this, but as this is a developer-focussed
dnl package, it makes sense to install by default somewhere out of the way.
AC_PREFIX_DEFAULT([/opt/res])

AM_INIT_AUTOMAKE([foreign])
AM_MAINTAINER_MODE

BT_PROG_XCODE
AC_PROG_CC([clang c99 gcc cc])
BT_PROG_CC_DEBUG
BT_PROG_CC_WARN
AC_PROG_CC_C99

LT_INIT

BT_ENABLE_POSIX_FULL
AC_SYS_LARGEFILE

BT_REQUIRE_LIBURI_INCLUDED
BT_REQUIRE_LIBSQL_INCLUDED
BT_REQUIRE_LIBSPARQLCLIENT_INCLUDED

use_docbook_html5=yes
BT_BUILD_DOCS

XML2HTMLFLAGS="--param \"html.linksfile\" \"'file://\$(abs_top_srcdir)/docbook-html5/res-links.xml'\" \
  --param \"html.navfile\" \"'file://\$(abs_top_srcdir)/docbook-html5/res-nav.xml'\" \
  --param \"html.ie78css\" \"'//bbcarchdev.github.io/painting-by-numbers/ie78.css'\""
AC_SUBST([XML2HTMLFLAGS])

LINKS='${top_srcdir}/docbook-html5/res-links.xml'
AC_SUBST([LINKS])

NAV='${top_srcdir}/docbook-html5/res-nav.xml'
AC_SUBST([NAV])

BT_DEFINE_PREFIX

acropolishtdocdir='${docdir}'
AC_SUBST([acropolishtdocdir])

here=`pwd`

AC_CONFIG_SUBDIRS([liblod])
BT_LIB_ADD_PKGCONFIG([$here/liblod])

AC_CONFIG_SUBDIRS([libawsclient])
BT_LIB_ADD_PKGCONFIG([$here/libawsclient])

AC_CONFIG_SUBDIRS([libcluster])
BT_LIB_ADD_PKGCONFIG([$here/libcluster])

AC_CONFIG_SUBDIRS([libmq])
BT_LIB_ADD_PKGCONFIG([$here/libmq])

AC_CONFIG_SUBDIRS([anansi])
BT_LIB_ADD_PKGCONFIG([$here/anansi])

AC_CONFIG_SUBDIRS([quilt])
BT_LIB_ADD_PKGCONFIG([$here/quilt])

AC_CONFIG_SUBDIRS([twine])
BT_LIB_ADD_PKGCONFIG([$here/twine])

AC_CONFIG_SUBDIRS([twine-anansi-bridge])
BT_LIB_ADD_PKGCONFIG([$here/twine-anansi-bridge])

AC_CONFIG_SUBDIRS([spindle])
BT_LIB_ADD_PKGCONFIG([$here/spindle])

AC_CONFIG_FILES([
Makefile
m4/Makefile
docbook-html5/Makefile
docs/Makefile
])

AC_OUTPUT
