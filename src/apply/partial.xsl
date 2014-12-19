<?xml version="1.0" encoding="utf-8"?>
<!--@comment
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
-->

<!--
  Partial applications may only be used with dynamic functions
  (functions compatible with `f:apply').
-->

<stylesheet version="2.0"
  xmlns="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:f="http://www.lovullo.com/hoxsl/apply"
  xmlns:_f="http://www.lovullo.com/hoxsl/apply/_priv">

<import href="ref.xsl" />


<!--
  Partially apply dynamic function reference @var{fnref}

  When provided to @code{f:apply}, @var{fnref} will be applied with
  @var{args} as its beginning argments, followed by any arguments to
  `f:apply'.

  Note that you usually do not have to invoke this function directly:
  the dynamic function calls will handle currying/partial application
  for you, which has a much more inviting syntax.

  Partially applied functions may continue to be partially applied
  until their parameters are exhausted.  This can be used to implement
  currying.

  When destructuring the result of this function, note that the
  returned function reference may not match @var{fnref} by reference,
  as it may have been modified.
-->
<function name="f:partial" as="item()+">
  <param name="fnref" as="item()+" />
  <param name="args"  as="item()*" />

  <!-- note that, if FNREF is partially applied, then this arity
       represents the arity of the partially applied function, _not_
       the target function -->
  <variable name="arity" as="xs:integer"
            select="f:arity( $fnref )" />

  <variable name="argn" as="xs:integer"
            select="count( $args )" />

  <choose>
    <when test="$argn gt $arity">
      <apply-templates mode="f:partial-arity-error-hook"
                       select="$fnref">
        <with-param name="fnref" select="$fnref" />
        <with-param name="args"  select="$args" />
      </apply-templates>
    </when>

    <otherwise>
      <variable name="new-ref"
                select="f:push-args( $fnref, $args )" />

      <sequence select="if ( $argn eq $arity ) then
                          _f:apply-partial( $new-ref )
                        else
                          $new-ref" />
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
                    and exists( $fnref[ 2 ] )" />
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

  <variable name="arity" as="xs:integer"
            select="f:arity(.)" />
  <variable name="argn" as="xs:decimal"
            select="count( $args )" />

  <sequence
      select="error(
                QName( namespace-uri-for-prefix( 'f', . ),
                       'err:PARTIAL_PARAM_OVERFLOW' ),
                concat( 'Attempted partial application of ',
                        'function of arity ', $arity, ' with ',
                        $argn, ' arguments' ) )" />
</template>


<!--
  Apply a partial dynamic function application

  This function is called automatically by @code{f:partial} when
  partial application would otherwise result in the returning of a
  nullary function.  @emph{It performs no validations} to ensure the
  integrity of the data.

  Just as @code{f:apply}, please note that @emph{up to eight arguments
  are supported}.  This should be enough.
-->
<function name="_f:apply-partial">
  <param name="fnref" as="item()+" />

  <variable name="args"
            select="f:args( $fnref )" />

  <variable name="desc" as="element( f:ref )"
            select="$fnref[ 1 ]" />

  <!-- just as `f:apply', we support up to 8 arguments -->
  <apply-templates select="$desc" mode="f:apply">
    <with-param name="arg1" select="$args[ 1 ]" />
    <with-param name="arg2" select="$args[ 2 ]" />
    <with-param name="arg3" select="$args[ 3 ]" />
    <with-param name="arg4" select="$args[ 4 ]" />
    <with-param name="arg5" select="$args[ 5 ]" />
    <with-param name="arg6" select="$args[ 6 ]" />
    <with-param name="arg7" select="$args[ 7 ]" />
    <with-param name="arg8" select="$args[ 8 ]" />
  </apply-templates>
</function>

</stylesheet>
