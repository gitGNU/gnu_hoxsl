# hoxsl manual Makefile
#
# Responsible for building the project documentation.
#
#  Copyright (C) 2014 LoVullo Assoicates, Inc.
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.
##

## hoxsl documentation Makefile
#
#  Copyright (C) 2016 Mike Gerwitz
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.
##

.DELETE_ON_ERROR:

path_src := ../src

stylesheets := $(shell find "$(path_src)" -name '*.xsl')
stexi       := $(stylesheets:.xsl=.texi)

info_TEXINFOS  = hoxsl.texi
hoxsl_TEXINFOS = license.texi $(stexi)

MAKEINFOHTML=$(MAKEINFO) --html

xsltexis: $(stexi)
%.texi: %.xsl
	$(JAVA) -jar "$(SAXON_CP)" \
	    -xsl:"$(top_builddir)/@LITERATE_XSL@/src/texinfo.xsl" \
	    "$<" > "$@"

clean-local:
	-rm -f $(stexi)
