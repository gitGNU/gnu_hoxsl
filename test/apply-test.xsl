<?xml version="1.0" encoding="utf-8"?>
<!--
  Tests dynamic function application

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
            xmlns:f="http://www.lovullo.com/hoxsl/apply"
            xmlns:foo="http://www.lovullo.com/_junk">

  <import href="../src/apply.xsl" />


  <template mode="f:apply" match="f:ref[ foo:fn0 ]">
    <!-- return something to show that we were called properly -->
    <foo:applied n="0" />
  </template>


  <template mode="f:apply" match="f:ref[ foo:fn1 ]">
    <param name="arg1" />

    <foo:applied n="1" />
    <sequence select="$arg1" />
  </template>


  <template mode="f:apply" match="f:ref[ foo:fn2 ]">
    <param name="arg1" />
    <param name="arg2" />

    <foo:applied n="2" />
    <sequence select="$arg1, $arg2" />
  </template>


  <template mode="f:apply" match="f:ref[ foo:fn3 ]">
    <param name="arg1" />
    <param name="arg2" />
    <param name="arg3" />

    <foo:applied n="3" />
    <sequence select="$arg1, $arg2, $arg3" />
  </template>


  <template mode="f:apply" match="f:ref[ foo:fn4 ]">
    <param name="arg1" />
    <param name="arg2" />
    <param name="arg3" />
    <param name="arg4" />

    <foo:applied n="4" />
    <sequence select="$arg1, $arg2, $arg3, $arg4" />
  </template>


  <template mode="f:apply" match="f:ref[ foo:fn5 ]">
    <param name="arg1" />
    <param name="arg2" />
    <param name="arg3" />
    <param name="arg4" />
    <param name="arg5" />

    <foo:applied n="5" />
    <sequence select="$arg1, $arg2, $arg3, $arg4,
                        $arg5" />
  </template>


  <template mode="f:apply" match="f:ref[ foo:fn6 ]">
    <param name="arg1" />
    <param name="arg2" />
    <param name="arg3" />
    <param name="arg4" />
    <param name="arg5" />
    <param name="arg6" />

    <foo:applied n="6" />
    <sequence select="$arg1, $arg2, $arg3, $arg4,
                        $arg5, $arg6" />
  </template>


  <template mode="f:apply" match="f:ref[ foo:fn7 ]">
    <param name="arg1" />
    <param name="arg2" />
    <param name="arg3" />
    <param name="arg4" />
    <param name="arg5" />
    <param name="arg6" />
    <param name="arg7" />

    <foo:applied n="7" />
    <sequence select="$arg1, $arg2, $arg3, $arg4,
                        $arg5, $arg6, $arg7" />
  </template>


  <template mode="f:apply" match="f:ref[ foo:fn8 ]">
    <param name="arg1" />
    <param name="arg2" />
    <param name="arg3" />
    <param name="arg4" />
    <param name="arg5" />
    <param name="arg6" />
    <param name="arg7" />
    <param name="arg8" />

    <foo:applied n="8" />
    <sequence select="$arg1, $arg2, $arg3, $arg4,
                        $arg5, $arg6, $arg7, $arg8" />
  </template>
</stylesheet>
