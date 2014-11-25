<?xml version="1.0" encoding="ISO-8859-1"?>
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

<import href="apply/arity.xsl" />


<function name="f:apply">
  <param name="fnref" as="element(f:ref)" />

  <apply-templates select="$fnref" mode="f:apply" />
</function>


<function name="f:apply">
  <param name="fnref" as="element(f:ref)" />
  <param name="arg1" />

  <apply-templates select="$fnref" mode="f:apply">
    <with-param name="arg1" select="$arg1" />
  </apply-templates>
</function>


<function name="f:apply">
  <param name="fnref" as="element(f:ref)" />
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

</stylesheet>
