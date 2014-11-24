## hoxsl Makefile
#
#  Copyright (C) 2014  LoVullo Associates, Inc.
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

path_src  := src
path_test := test

test_in_apply_gen := $(path_test)/transform/apply-gen-test-in.xsl.apply

.PHONY: check test

test: check
check: $(test_in_apply_gen)
	$(path_test)/runner

%.apply: %
	java -jar "$(SAXON_CP)" \
	    -xsl:"$(path_src)/transform/apply-gen.xsl" \
	    "$<" > "$@"

clean:
	$(RM) "$(test_in_apply_gen)"
