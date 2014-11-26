<?xml version="1.0" encoding="utf-8"?>
<!--
  Dynamic function application

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

  This can be used to create higher-order functions.

  If you need more arguments than this, then you may want to consider
  another approach.
-->

<stylesheet version="2.0"
  xmlns="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:f="http://www.lovullo.com/hoxsl/apply">

<import href="apply/partial.xsl" />


<function name="f:apply">
  <param name="fnref" as="element(f:ref)" />

  <apply-templates select="$fnref" mode="f:apply" />
</function>


<!-- WARNING: inconsistent state: only `f:apply#{1,2}' support partial
     application at the moment -->

<function name="f:apply">
  <param name="fnref" as="item()+" />
  <param name="arg1" />

  <sequence select="f:partial( $fnref, $arg1 )" />
</function>


<function name="f:apply">
  <param name="fnref" as="item()+" />
  <param name="arg1" />
  <param name="arg2" />

  <apply-templates select="$fnref" mode="f:apply">
    <with-param name="arg1" select="$arg1" />
    <with-param name="arg2" select="$arg2" />
  </apply-templates>
</function>


<function name="f:apply">
  <param name="fnref" as="element(f:ref)" />
  <param name="arg1" />
  <param name="arg2" />
  <param name="arg3" />

  <apply-templates select="$fnref" mode="f:apply">
    <with-param name="arg1" select="$arg1" />
    <with-param name="arg2" select="$arg2" />
    <with-param name="arg3" select="$arg3" />
  </apply-templates>
</function>


<function name="f:apply">
  <param name="fnref" as="element(f:ref)" />
  <param name="arg1" />
  <param name="arg2" />
  <param name="arg3" />
  <param name="arg4" />

  <apply-templates select="$fnref" mode="f:apply">
    <with-param name="arg1" select="$arg1" />
    <with-param name="arg2" select="$arg2" />
    <with-param name="arg3" select="$arg3" />
    <with-param name="arg4" select="$arg4" />
  </apply-templates>
</function>


<function name="f:apply">
  <param name="fnref" as="element(f:ref)" />
  <param name="arg1" />
  <param name="arg2" />
  <param name="arg3" />
  <param name="arg4" />
  <param name="arg5" />

  <apply-templates select="$fnref" mode="f:apply">
    <with-param name="arg1" select="$arg1" />
    <with-param name="arg2" select="$arg2" />
    <with-param name="arg3" select="$arg3" />
    <with-param name="arg4" select="$arg4" />
    <with-param name="arg5" select="$arg5" />
  </apply-templates>
</function>


<function name="f:apply">
  <param name="fnref" as="element(f:ref)" />
  <param name="arg1" />
  <param name="arg2" />
  <param name="arg3" />
  <param name="arg4" />
  <param name="arg5" />
  <param name="arg6" />

  <apply-templates select="$fnref" mode="f:apply">
    <with-param name="arg1" select="$arg1" />
    <with-param name="arg2" select="$arg2" />
    <with-param name="arg3" select="$arg3" />
    <with-param name="arg4" select="$arg4" />
    <with-param name="arg5" select="$arg5" />
    <with-param name="arg6" select="$arg6" />
  </apply-templates>
</function>


<function name="f:apply">
  <param name="fnref" as="element(f:ref)" />
  <param name="arg1" />
  <param name="arg2" />
  <param name="arg3" />
  <param name="arg4" />
  <param name="arg5" />
  <param name="arg6" />
  <param name="arg7" />

  <apply-templates select="$fnref" mode="f:apply">
    <with-param name="arg1" select="$arg1" />
    <with-param name="arg2" select="$arg2" />
    <with-param name="arg3" select="$arg3" />
    <with-param name="arg4" select="$arg4" />
    <with-param name="arg5" select="$arg5" />
    <with-param name="arg6" select="$arg6" />
    <with-param name="arg7" select="$arg7" />
  </apply-templates>
</function>


<function name="f:apply">
  <param name="fnref" as="element(f:ref)" />
  <param name="arg1" />
  <param name="arg2" />
  <param name="arg3" />
  <param name="arg4" />
  <param name="arg5" />
  <param name="arg6" />
  <param name="arg7" />
  <param name="arg8" />

  <apply-templates select="$fnref" mode="f:apply">
    <with-param name="arg1" select="$arg1" />
    <with-param name="arg2" select="$arg2" />
    <with-param name="arg3" select="$arg3" />
    <with-param name="arg4" select="$arg4" />
    <with-param name="arg5" select="$arg5" />
    <with-param name="arg6" select="$arg6" />
    <with-param name="arg7" select="$arg7" />
    <with-param name="arg8" select="$arg8" />
  </apply-templates>
</function>


<!--
  Abort processing on unknown function reference

  This will occur if no application template is defined for the
  given function reference.  Override it if you wish to perform
  autoloading or what have you.

  If you generate the nullary and application template using
  apply-gen, then you won't have to worry about this.
-->
<template mode="f:apply"
          match="*"
          priority="1">
  <message terminate="yes">
    <text>error: cannot apply unknown function reference: </text>
    <copy-of select="." />
  </message>
</template>


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

</stylesheet>
