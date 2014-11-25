<?xml version="1.0" encoding="utf-8"?>
<!--
  Arity calculations on dynamic and partially applied functions

  Copyright (C) 2014 LoVullo Associates, Inc.

    This file is part of hoxsl.

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
-->

<stylesheet version="2.0"
  xmlns="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:f="http://www.lovullo.com/hoxsl/apply">



<!--
  Attempt to retrieve arity of dynamic function

  The input must be a function reference.  Partially applied function
  references will have an arity equivalent to the remaining parameters
  in the original function.

  If the arity cannot be determined, -1 is returned.
-->
<function name="f:arity" as="xs:decimal">
  <param name="fnref" as="element(f:ref)" />

  <sequence select="if ( $fnref/@arity ) then
                      $fnref/@arity
                    else
                      -1" />
</function>

</stylesheet>
