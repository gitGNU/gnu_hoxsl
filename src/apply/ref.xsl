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

  <f:ref arity="{$arity}" length="1">
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

  Usually, this will match precisely the QName of the target
  function.

  @var{fnreF} must be a valid dynamic function reference.

  @i{Implementation details:} This actually represents the QName of
  the @emph{application template}, which could differ from the target
  function name.  One reason this may be the case is to provide a
  function alias.
-->
<function name="f:QName" as="xs:QName?">
  <param name="fnref" as="item()+" />

  <variable name="desc" as="element( f:ref )"
            select="$fnref[ 1 ]" />

  <variable name="target" as="element()?"
            select="$desc/element()[ 1 ]" />

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


<!--
  Retrieve a sequence of the partially applied arguments of
  @var{fnref}

  The resulting sequence may be empty.  @var{fnref} is assumed to be a
  valid dynamic function reference; you should verify that assumption
  beforehand.
-->
<function name="f:args" as="item()*">
  <param name="fnref" as="item()+" />

  <variable name="desc" as="element( f:ref )"
            select="$fnref[ 1 ]" />
  <variable name="length" as="xs:double"
            select="$desc/@length" />

  <sequence select="subsequence( $fnref, 2, ( $length - 1 ) )" />
</function>


<!--
  Set partially applied arguments of @var{fnref} to @var{args},
  replacing any existing arguments

  The arity of @var{fnref} will be adjusted relative to the number of
  items in @var{args} such that the resulting dynamic function
  reference has the illusion of being its own, new function:
  increasing the argument count of @var{fnref} will @emph{decrease}
  the arity of the resulting reference and vice versa.

  @emph{No validations are performed on arity}—if there exist more
  arguments than the number of target function parameters, no error
  will be raised.

  @var{fnref} must be a valid dynamic function reference.
-->
<function name="f:set-args" as="item()+">
  <param name="fnref" as="item()+" />
  <param name="args"  as="item()*" />

  <variable name="desc" as="element( f:ref )"
            select="$fnref[ 1 ]" />

  <!-- this reference may be partially applied; see below arity
       adjustment -->
  <variable name="target-arity" as="xs:double"
            select="$desc/@arity + count( f:args( $fnref ) )" />

  <f:ref>
    <sequence select="$desc/@*" />

    <!-- treat partial applications as their own functions (with their
         own arities) -->
    <attribute name="arity"
               select="$target-arity - count( $args )" />

    <attribute name="length"
               select="count( $args ) + 1" />

    <sequence select="$desc/*" />
  </f:ref>

  <!-- be sure to retain the adjacent data (which is offset by the
       _original_ reference length) -->
  <sequence select="$args,
                    subsequence( $fnref,
                                 $desc/@length + 1 )" />
</function>


<!--
  Pushes @var{args} onto the argument list of @var{fnref}

  This operates just as @code{f:set-args}, but retains existing arguments.
-->
<function name="f:push-args" as="item()+">
  <param name="fnref" as="item()+" />
  <param name="args"  as="item()*" />

  <sequence select="f:set-args($fnref,
                               (f:args( $fnref ), $args) )" />
</function>


<!--
  Unshifts @var{args} onto the argument list of @var{fnref}

  This operates just as @code{f:set-args}, but retains existing arguments.
-->
<function name="f:unshift-args" as="item()+">
  <param name="fnref" as="item()+" />
  <param name="args"  as="item()*" />

  <sequence select="f:set-args($fnref,
                               ($args, f:args( $fnref )) )" />
</function>


<!--
  Retrieve length of @var{fnref} as a number of sequence items

  While the reference is intended to be opaque, it is no secret that
  the data are stored as a sequence.  The length is therefore
  important for stepping through that sequence of data, similar to how
  data/struct length are required for pointer arithmetic when dealing
  with memory in C.

  So, this doesn't break encapsulation: it just tells us how big we
  are, which is an external quality that can be easily discovered
  without our help; we just cache it for both performance and
  convenience.  Aren't we nice?
-->
<function name="f:length" as="xs:double">
  <param name="fnref" as="item()+" />

  <variable name="desc" as="element( f:ref )"
            select="$fnref[ 1 ]" />

  <sequence select="number( $desc/@length )" />
</function>

</stylesheet>
