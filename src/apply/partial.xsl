<?xml version="1.0" encoding="utf-8"?>
<!--
  Partial function application

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

  Partial applications may only be used with dynamic functions
  (functions compatible with `f:apply').
-->

<stylesheet version="2.0"
  xmlns="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:f="http://www.lovullo.com/hoxsl/apply">


<!--
  Partially apply dynamic function reference FNREF

  When provided to `f:apply', FNREF will be applied with ARGS as its
  beginning argments, followed by any arguments to `f:apply'.

  Note that you usually do not have to invoke this function directly:
  the dynamic function calls will handle currying/partial application
  for you, which has a much more inviting syntax.

  TODO: Accept partial application as FNREF.
-->
<function name="f:partial">
  <param name="fnref" as="element(f:ref)" />
  <param name="args"  as="item()*" />

  <f:ref>
    <sequence select="$fnref/@*" />

    <attribute name="partial"
               select="count( $args )" />

    <sequence select="$fnref/*" />
  </f:ref>

  <!-- nested sequences are implicitly flattened, so we're not
       returning a sub-sequence here -->
  <sequence select="$args" />
</function>


<!--
  Determines whether FNREF is a partial application

  You really should not rely on this for your code—it is intended for
  internal use.  Instead, treat partial applications opaquely as their
  own functions.
-->
<function name="f:is-partial" as="xs:boolean">
  <param name="fnref" as="item()+" />

  <!-- if we're passed a sequence, then the function portion of the
       reference is first; all others are arguments -->
  <variable name="fn"
            select="$fnref[ 1 ]" />

  <!-- we never want to fail, so we perform our type check here rather
       than using param/@as -->
  <sequence select="$fn instance of element(f:ref)
                    and exists( $fn/@partial )
                    and number( $fn/@partial ) gt 0" />
</function>

</stylesheet>
