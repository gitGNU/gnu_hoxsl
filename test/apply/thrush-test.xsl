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
            xmlns:xs="http://www.w3.org/2001/XMLSchema"
            xmlns:f="http://www.lovullo.com/hoxsl/apply"
            xmlns:foo="http://www.lovullo.com/_junk">

  <import href="../../src/apply/thrush.xsl" />

  <import href="thrush-test.xsl.apply" />


  <function name="foo:give-foo" as="node()">
    <param name="_" />

    <!-- little bunny... -->
    <foo:foo hop="forest"/>
  </function>


  <function name="foo:echo" as="item()">
    <param name="item" as="item()" />

    <sequence select="$item" />
  </function>


  <function name="foo:add1" as="xs:decimal">
    <param name="to" as="xs:decimal" />

    <sequence select="$to + 1" />
  </function>


  <function name="foo:add" as="xs:decimal">
    <param name="x" as="xs:decimal" />
    <param name="y" as="xs:decimal" />

    <sequence select="$x + $y" />
  </function>


  <function name="foo:add3" as="xs:decimal">
    <param name="x" as="xs:decimal" />
    <param name="y" as="xs:decimal" />
    <param name="z" as="xs:decimal" />

    <sequence select="$x + $y + $z" />
  </function>


  <function name="foo:double" as="xs:decimal">
    <param name="value" as="xs:decimal" />

    <sequence select="$value * 2" />
  </function>
</stylesheet>
