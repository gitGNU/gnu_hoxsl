<?xml version="1.0" encoding="utf-8"?>
<!--
  Tests boilerplate generation for dynamic function applications

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
  xmlns:f="http://www.lovullo.com/hoxsl/apply"
  xmlns:foo="http://www.lovullo.com/_junk">


  <!-- SUT -->
  <import href="../../src/transform/apply-gen.xsl" />

  <!-- input stylesheet -->
  <import href="apply-gen-test-in.xsl" />

  <!-- N.B. it is expected tha a build process has already built this
       document before running this test -->
  <import href="apply-gen-test-in.xsl.out" />


  <function name="foo:apply-add-two">
    <param name="x" as="xs:decimal" />
    <param name="y" as="xs:decimal" />
    
    <apply-templates select="foo:add-two()"
                     mode="f:apply">
      <with-param name="arg1" select="$x" />
      <with-param name="arg2" select="$y" />
    </apply-templates>
  </function>
</stylesheet>

