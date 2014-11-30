<?xml version="1.0" encoding="utf-8"?>
<!--
  Dynamic function reference

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

  A dynamic function reference is a sequence describing a dynamic
  function to be applied.  It consists of two major parts—the dynamic
  function reference descriptor and the arguments to bind to its
  parameters:

  @example
    (desc[, arg1[, ...argn]])
  @end example

  The descriptor @var{desc} has the following format:

  @example
    <f:ref arity="N" [...]>
      <target />
    </f:ref>
  @end example

  where the @var{target} node shares the same QName as the function to
  be applied, and @var{@arity} is its arity.  The @var{f:ref} node may
  be decorated with additional attributes depending on its context or
  constructor.
-->

<stylesheet version="2.0"
  xmlns="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:f="http://www.lovullo.com/hoxsl/apply">


<!--
  Create a reference to dynamic function @var{name} with arity
  @var{arity}

  This function @emph{does not} verify that the function @var{name}
  exists, nor does it verify that the provided @var{arity} is valid
  for it.  Further, the returned function reference will work
  @emph{only with dynamic functions}—that is, an application template
  is needed.  See @file{transform/apply-gen.xsl} for more information
  and examples.
-->
<function name="f:make-ref" as="element( f:ref )">
  <param name="name"  as="xs:QName" />
  <param name="arity" as="xs:integer" />

  <variable name="ns"
            select="namespace-uri-from-QName( $name )" />

  <f:ref arity="{$arity}">
    <element name="{$name}"
             namespace="{$ns}" />
  </f:ref>
</function>


<!--
  Determines whether @var{fnref} represents a valid dynamic function
  reference

  This can be used to determine if @var{fnref} is valid as input to
  other functions, some of which may produce an error if called with
  an invalid dynamic function reference.

  @i{Implementation details:} To be valid, @var{fnref} must:

  @enumerate
  @item Be an element of type @code{f:ref};
  @item Have a numeric @code{@arity}; and
  @item Have a child target function node.
  @enumerate
-->
<function name="f:is-ref" as="xs:boolean">
  <param name="fnref" as="item()*" />

  <variable name="ref" select="$fnref[ 1 ]" />

  <!-- for @arity check: note that NaN != NaN -->
  <sequence select="$ref instance of element( f:ref )
                    and number( $ref/@arity ) = number( $ref/@arity )
                    and exists( $ref/*[ 1 ] )" />
</function>


<!--
  Retrieve the QName of the target dynamic function

  Usually, this would match precisely the QName of the target
  function.

  @i{Implementation details:} This actually represents the QName of
  the @emph{application template}, which could differ from the target
  function name.  One reason this may be the case is to provide a
  function alias.
-->
<function name="f:QName" as="xs:QName?">
  <param name="fnref" as="element( f:ref )" />

  <variable name="target" as="element()?"
            select="$fnref/element()[ 1 ]" />

  <sequence select="node-name( $target )" />
</function>


<!--
  Attempt to retrieve arity of dynamic function @var{fnref}

  @var{fnref} must be a dynamic function reference satisfying
  @code{f:is-ref}.  Partially applied function references will have an
  arity equivalent to the free parameters in the target function.
-->
<function name="f:arity" as="xs:integer">
  <param name="fnref" as="item()+" />

  <variable name="ref" as="element( f:ref )"
            select="$fnref[ 1 ]" />

  <!-- this implicitly asserts on the type; it should never fail if
       the system is being used properly -->
  <variable name="arity" as="xs:integer"
            select="$ref/@arity" />

  <sequence select="$arity" />
</function>

</stylesheet>
