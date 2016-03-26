<?xml version="1.0" encoding="utf-8"?>
<!--@comment
  Implementation of the Thrush combinator

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
  The Thrush combinator is defined as @math{Txy = yx}.

  The Clojure macros @code{->} and @code{->>} (thread left/right) are
  popular Thrush-like implementations which result in a familiar
  pipeline-like style processing.

  This allows re-ordering applications in a way that humans actually
  think about them: left-to-right, not inside-out.  Here's an example:

  @example
    sum( filter( get-values( $foo ), predicate() ) ).
  @end example

  This would be better represented as a pipeline, as is common in
  shell:

  @example
    get-values foo | filter predicate | sum
  @end example

  which we might express using @code{f:thrush} as

  @example
    f:thrush( get-values( $foo ),
              filter( predicate() ),
              sum() )
  @end example

  assuming that @code{filter} and @code{sum} above return dynamic
  function references.

  Above, @code{f:thrush} is equivalent to Clojure's @code{->>}; this
  is aliased to @code{f:thrushr} for clarity, if you'd prefer to use
  that.  We also have @code{thrushl}, which is like Clojure's
  @code{->}, in that it maps the return value of a function to the
  @emph{first} parameter of the function following
  it.  @code{f:thrush} is an alias of @code{f:thrushr} (rather than
  @code{f:thrushl}) because it is a natural fit with partial
  application (especially currying).

  OOP does similar using objects and method chaining:

  @example
    get-values( 'foo' )
      .filter( predicate() )
      .sum();
  @end example

  Indeed, the syntax @code{A.B(C)} is just syntactic sugar for
  applying @code{B} within the context of @code{A}—@code{B(A,C)}—which
  can be done using @code{f:thrushl}.

  @emph{@code{thrushl} is not yet implemented.}
-->

<stylesheet version="2.0"
  xmlns="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:f="http://mikegerwitz.com/hoxsl/apply"
  xmlns:_f="http://mikegerwitz.com/hoxsl/apply/_priv">

<import href="../apply.xsl" />


<!--
  Alias of @code{f:thrushr}.
-->
<function name="f:thrush" as="item()">
  <param name="list" as="item()+" />

  <sequence select="f:thrushr( $list )" />
</function>


<!--
  Given a @var{list} of the form @code{(value, f1, f2, ...)}, return
  the result @code{...(f2(f1(value)))}

  If @var{list} consists only of @code{value}, simply return
  @code{value}.  Any number of functions may be provided in @var{list}
  to form a pipeline; the result of the final application will be
  returned.

  All functions @emph{must} be unary; partial application should be
  used to provide beginning arguments.  For example, this would yield
  the value @code{5}:

  @example
    <sequence select="f:thrush( 5, f:partial( f:add(), 4 ) )" />
  @end example

  See the @code{apply-gen} stylesheet for auto-generating curried
  functions to simplify the above partial application.
-->
<function name="f:thrushr" as="item()">
  <param name="list" as="item()+" />

  <sequence select="_f:thrushr-fold( subsequence( $list, 2 ),
                                     $list[ 1 ] )" />
</function>


<function name="_f:thrushr-fold" as="item()">
  <param name="fnref"  as="item()*" />
  <param name="result" />

  <choose>
    <when test="empty( $fnref )">
      <sequence select="$result" />
    </when>

    <otherwise>
      <!-- FIXME: need abstraction -->
      <variable name="next" as="item()*"
                select="subsequence( $fnref,
                                     f:length( $fnref ) + 1 )" />

      <!-- map the next unary function to the previous result, then
           pass that result along for further mapping -->
      <sequence select="_f:thrushr-fold(
                          $next,
                          f:partial( $fnref, $result ) )" />
    </otherwise>
  </choose>
</function>

</stylesheet>
