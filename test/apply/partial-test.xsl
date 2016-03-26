<?xml version="1.0" encoding="utf-8"?>
<!--
  Tests partial function application

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
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:f="http://mikegerwitz.com/hoxsl/apply"
  xmlns:foo="http://mikegerwitz.com/_junk">

  <!-- SUT -->
  <import href="../../src/apply/partial.xsl" />

  <!-- numerous templates for arity tests -->
  <import href="../apply-test.xsl" />

  <!-- generated -->
  <import href="partial-test.xsl.apply" />


  <!-- the default implementation is to raise an error, which can't be
       tested without XSLT 3.0 support -->
  <template mode="f:partial-arity-error-hook"
            match="f:ref"
            priority="5">
    <param name="args"  as="item()*" />

    <variable name="arity"
              select="f:arity(.)" />

    <foo:partial-error arity="{$arity}" />

    <sequence select="." />
    <sequence select="$args" />
  </template>


  <function name="foo:ternary">
    <param name="x" />
    <param name="y" />
    <param name="z" />

    <foo:ternary-applied />
    <sequence select="$x, $y, $z" />
  </function>
</stylesheet>
