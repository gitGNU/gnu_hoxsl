<?xml version="1.0" encoding="utf-8"?>
<!--
  Generate boilerplate for dynamic function applications

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
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:f="http://www.lovullo.com/hoxsl/apply"
  xmlns:fgen="http://www.lovullo.com/hoxsl/apply/gen"
  xmlns:out="http://www.lovullo.com/hoxsl/apply/gen/_out"
  exclude-result-prefixes="#default fgen">

<output indent="yes"
        encoding="utf-8" />

<namespace-alias stylesheet-prefix="out"
                 result-prefix="xsl" />

<!--
  Begin processing of XSLT document

  A document will be output with a generated stylesheet containing the
  boilerplate necessary for dynamically calling each of the functions
  defined therein.
-->
<template match="/xsl:stylesheet|/xsl:transform"
          priority="5">
  <document>
    <out:stylesheet version="2.0">
      <xsl:apply-templates mode="fgen:create" />
    </out:stylesheet>
  </document>
</template>


<!--
  Refuse to process non-XSLT documents

  Hopefully will help to avoid confusion when accidentally processing
  the wrong file.
-->
<template match="/*"
          priority="1">
  <message terminate="yes">
    <text>fatal: unexpected root node `</text>
    <value-of select="name()" />
    <text>'</text>
  </message>
</template>


<!--
  Process function definition
-->
<template mode="fgen:create"
          match="xsl:function"
          priority="5">
  <!-- we need to take care with namespacing; let's remove context
       dependencies and simply specify the full namespace URI -->
  <variable name="name-resolv"
            select="resolve-QName( @name, . )" />
  <variable name="local-name"
            select="substring-after( @name, ':' )" />
  <variable name="ns-prefix"
            select="substring-before( @name, ':' )" />
  <variable name="ns"
            select="namespace-uri-for-prefix(
                      $ns-prefix, . )" />

  <sequence select="fgen:create-func(
                      $name-resolv, $local-name, $ns )" />
</template>


<!--
  Drop irrelevant nodes

  We do not retain any of the original nodes in the document, as the
  result document is intended to be imported into the original.
-->
<template mode="fgen:create"
          match="*|text()"
          priority="1">
  <!-- must not be very important! -->
</template>


<function name="fgen:create-func">
  <param name="name-resolv" as="xs:QName" />
  <param name="local-name"  as="xs:string" />
  <param name="ns"          as="xs:anyURI" />

  <out:function name="{$name-resolv}" as="element()">
    <element name="{$local-name}"
             namespace="{$ns}" />
  </out:function>
</function>

</stylesheet>
