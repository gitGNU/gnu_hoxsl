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

<import href="arity.xsl" />


<!--
  Partially apply dynamic function reference FNREF

  When provided to `f:apply', FNREF will be applied with ARGS as its
  beginning argments, followed by any arguments to `f:apply'.

  Note that you usually do not have to invoke this function directly:
  the dynamic function calls will handle currying/partial application
  for you, which has a much more inviting syntax.

  Partially applied functions may continue to be partially applied
  until their parameters are exhausted.  This can be used to implement
  currying.
-->
<function name="f:partial" as="item()+">
  <param name="fnref" as="item()+" />
  <param name="args"  as="item()*" />

  <!-- perform type check here, not above, since we can be passed a
       sequence (e.g.a  partially applied function) -->
  <variable name="ref"
            as="element(f:ref)"
            select="$fnref[ 1 ]" />

  <variable name="argout" as="item()*">
    <!-- include any previously applied arguments (if we're partially
         applying a partial application) -->
    <sequence select="remove( $fnref, 1 )" />

    <!-- nested sequences are implicitly flattened, so we're not
         returning a sub-sequence here -->
    <sequence select="$args" />
  </variable>

  <variable name="argn" as="xs:decimal"
            select="count( $argout )" />

  <variable name="arity" as="xs:decimal"
            select="f:arity( $ref )" />

  <choose>
    <when test="$argn gt $arity">
      <apply-templates mode="f:partial-arity-error-hook"
                       select="$ref">
        <with-param name="args"  select="$argout" />
        <with-param name="arity" select="$arity" />
        <with-param name="argn"  select="$argn" />
      </apply-templates>
    </when>

    <otherwise>
      <f:ref>
        <sequence select="$ref/@*" />

        <attribute name="partial"
                   select="count( $args )" />

        <sequence select="$ref/*" />
      </f:ref>

      <sequence select="$argout" />
    </otherwise>
  </choose>
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


<!--
  Hook invoked when the number of arguments of a partial application
  exceeds the parameter count of the target function

  The `target' function is the root of the partial application—given
  @t{Fx @arrow{} F'y @arrow{} F''z}, @t{F} is the target.

  Implementations may override this hook to display their own errors,
  or even handle the error and continue by returning a proper partial
  application.  For such implementation details, see
  @file{apply/partial.xsl}.
-->
<template mode="f:partial-arity-error-hook"
          match="f:ref"
          priority="1">
  <param name="args"  as="item()*" />
  <param name="arity" as="xs:decimal" />

  <variable name="ref" as="element(f:ref)"
            select="." />
  <variable name="argn" as="xs:decimal"
            select="count( $args )" />
  <variable name="fn"
            select="$ref/*[1]" />
  <variable name="fname"
            select="concat( '{', namespace-uri( $fn ), '}',
                    $fn/local-name() )" />

  <sequence
      select="error(
                QName( namespace-uri-for-prefix( 'f', $ref ),
                       'err:PARTIAL_PARAM_OVERFLOW' ),
                concat( 'Attempted partial application of ',
                        $fname, '#', $arity, ' with ',
                        $argn, ' arguments' ) )" />
</template>

</stylesheet>
