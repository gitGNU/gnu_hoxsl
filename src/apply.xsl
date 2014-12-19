<?xml version="1.0" encoding="utf-8"?>
<!--@comment
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
-->

<!--
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
  <param name="fnref" as="item()+" />

  <sequence select="f:partial( $fnref, () )" />
</function>


<function name="f:apply">
  <param name="fnref" as="item()+" />
  <param name="arg1" />

  <sequence select="f:partial( $fnref, $arg1 )" />
</function>


<function name="f:apply">
  <param name="fnref" as="item()+" />
  <param name="arg1" />
  <param name="arg2" />

  <sequence select="f:partial( $fnref,
                               ($arg1, $arg2) )" />
</function>


<function name="f:apply">
  <param name="fnref" as="item()+" />
  <param name="arg1" />
  <param name="arg2" />
  <param name="arg3" />

  <sequence select="f:partial( $fnref,
                               ($arg1, $arg2, $arg3) )" />
</function>


<function name="f:apply">
  <param name="fnref" as="item()+" />
  <param name="arg1" />
  <param name="arg2" />
  <param name="arg3" />
  <param name="arg4" />

  <sequence select="f:partial( $fnref,
                               ($arg1, $arg2, $arg3, $arg4) )" />
</function>


<function name="f:apply">
  <param name="fnref" as="item()+" />
  <param name="arg1" />
  <param name="arg2" />
  <param name="arg3" />
  <param name="arg4" />
  <param name="arg5" />

  <sequence select="f:partial( $fnref,
                               ($arg1, $arg2, $arg3, $arg4,
                                $arg5) )" />
</function>


<function name="f:apply">
  <param name="fnref" as="item()+" />
  <param name="arg1" />
  <param name="arg2" />
  <param name="arg3" />
  <param name="arg4" />
  <param name="arg5" />
  <param name="arg6" />

  <sequence select="f:partial( $fnref,
                               ($arg1, $arg2, $arg3, $arg4,
                                $arg5, $arg6) )" />
</function>


<function name="f:apply">
  <param name="fnref" as="item()+" />
  <param name="arg1" />
  <param name="arg2" />
  <param name="arg3" />
  <param name="arg4" />
  <param name="arg5" />
  <param name="arg6" />
  <param name="arg7" />

  <sequence select="f:partial( $fnref,
                               ($arg1, $arg2, $arg3, $arg4,
                                $arg5, $arg6, $arg7) )" />
</function>


<function name="f:apply">
  <param name="fnref" as="item()+" />
  <param name="arg1" />
  <param name="arg2" />
  <param name="arg3" />
  <param name="arg4" />
  <param name="arg5" />
  <param name="arg6" />
  <param name="arg7" />
  <param name="arg8" />

  <sequence select="f:partial( $fnref,
                               ($arg1, $arg2, $arg3, $arg4,
                                $arg5, $arg6, $arg7, $arg8) )" />
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
@menu
* Partial Application::  Partial function application and currying
* Thrush::               Organizing function calls into a pipeline
* Ref API::              Low-level interface to hoxsl functions
@end menu

@node Partial Application
@section Partial Application
@include ../src/apply/partial.texi

@node Thrush
@section Thrush
@include ../src/apply/thrush.texi

@node Ref API
@section Ref API
@include ../src/apply/ref.texi
-->

</stylesheet>
