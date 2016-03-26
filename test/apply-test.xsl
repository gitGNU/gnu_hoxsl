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
            xmlns:f="http://mikegerwitz.com/hoxsl/apply"
            xmlns:foo="http://mikegerwitz.com/_junk">

  <import href="../src/apply.xsl" />


  <!-- catch errors (otherwise, we'd terminate) -->
  <template mode="f:apply"
            match="*"
            priority="2">
    <foo:unknown-dyn-fun />
  </template>


  <template mode="f:apply"
            match="f:ref[ foo:fn0 ]"
            priority="5">
    <!-- return something to show that we were called properly -->
    <foo:applied n="0" />
  </template>


  <template mode="f:apply"
            match="f:ref[ foo:fn1 ]"
            priority="5">
    <param name="arg1" />

    <foo:applied n="1" />
    <sequence select="$arg1" />
  </template>


  <template mode="f:apply"
            match="f:ref[ foo:fn2 ]"
            priority="5">
    <param name="arg1" />
    <param name="arg2" />

    <foo:applied n="2" />
    <sequence select="$arg1, $arg2" />
  </template>


  <template mode="f:apply"
            match="f:ref[ foo:fn3 ]"
            priority="5">
    <param name="arg1" />
    <param name="arg2" />
    <param name="arg3" />

    <foo:applied n="3" />
    <sequence select="$arg1, $arg2, $arg3" />
  </template>


  <template mode="f:apply"
            match="f:ref[ foo:fn4 ]"
            priority="5">
    <param name="arg1" />
    <param name="arg2" />
    <param name="arg3" />
    <param name="arg4" />

    <foo:applied n="4" />
    <sequence select="$arg1, $arg2, $arg3, $arg4" />
  </template>


  <template mode="f:apply"
            match="f:ref[ foo:fn5 ]"
            priority="5">
    <param name="arg1" />
    <param name="arg2" />
    <param name="arg3" />
    <param name="arg4" />
    <param name="arg5" />

    <foo:applied n="5" />
    <sequence select="$arg1, $arg2, $arg3, $arg4,
                        $arg5" />
  </template>


  <template mode="f:apply"
            match="f:ref[ foo:fn6 ]"
            priority="5">
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


  <template mode="f:apply"
            match="f:ref[ foo:fn7 ]"
            priority="5">
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


  <template mode="f:apply"
            match="f:ref[ foo:fn8 ]"
            priority="5">
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


  <function name="foo:arg8-check">
    <param name="args"   as="item()+" />
    <param name="result" as="item()+" />

    <sequence select="$result[ 1 ] instance of element( foo:applied )
                      and $result[ 2 ] is $args[1]
                      and $result[ 3 ] is $args[2]
                      and $result[ 4 ] is $args[3]
                      and $result[ 5 ] is $args[4]
                      and $result[ 6 ] is $args[5]
                      and $result[ 7 ] is $args[6]
                      and $result[ 8 ] is $args[7]
                      and $result[ 9 ] is $args[8]" />
  </function>
</stylesheet>
