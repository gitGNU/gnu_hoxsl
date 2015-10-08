<?xml version="1.0" encoding="utf-8"?>
<!--@comment
  Node constructors

  Copyright (C) 2015 Mike Gerwitz

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
            xmlns:n="http://www.lovullo.com/hoxsl/node"
            xmlns:_n="http://www.lovullo.com/hoxsl/node/_priv">

<!--
  Function composition becomes a frustrating endeavor if nodes cannot be
  constructed within an expression.  For example, to create an element
  to pass to a function @code{foo}, the only option with vanilla XSLT is to
  use a variable to hold that element:

  @example
    <variable name="element" as="element( bar )">
      <bar baz="quux" />
    </variable>

    <sequence select="foo( $element )" />
  @end example

  This easily interrupts pipelines or results in functions whose sole
  purpose is to create specific nodes for the sake of composition.

  Hoxsl provides constructors for nodes that fit cleanly into a
  functional system.

  @menu
  * Primitive Constructors::  Functional equivalents of XSLT node primitives
  * Private Functions:Node Private Functions.  Internal details
  @end menu


  @node Primitive Constructors
  @section Primitive Constructors
  The constructors in this section can be thought of as primitives
  corresponding to their XSLT node-based counterparts: @code{xsl:element},
  @code{xsl:text}, and @code{xsl:comment}.  They can be arbitrarily nested
  to create tree structures.

  @float Figure, fig:node-primitive
  @verbatim
    <sequence select="n:element( QName( 'ns', 'foo' ),
                                 ( QName( 'ns', 'attr1' ), 'value1',
                                   QName( 'ns', 'attr2' ), 'value2' ),
                                 ( n:text( 'Nest to create trees' ),
                                   n:comment( 'functional nodes' ),
                                   n:element( QName( 'ns', 'bar' ) ) ) )" />
  @end verbatim
  @caption{Generating an XML tree using the primitive constructors}
  @end float

  Consider @ref{fig:node-primitive}, which will output the following tree:

  @example
  <foo attr1="value1" attr2="value2">@c
  Nest to create trees@c
  @xmlcomment{functional nodes}@c
  <bar />@c
  </foo>
  @end example

  Newlines are not automatically added.
-->

<!--
  Construct an element named @var{qname} with attributes defined by
  the QName-value pairs @var{attr-pairs} and child nodes @var{children}.  An
  empty sequence may be provided if no attributes or children are desired
  (see also the @ref{n:element#1,,unary} and @ref{n:element#2,,binary}
  overloads).

  For QName-value pair @var{attr-pairs}, @math{2n} will always be considered
  to be a QName and @math{2n+1} its associated value.  If the final value in
  the attribute pair sequence is missing, then it will result in an
  attribute with an empty string as its value.
-->
<function name="n:element" as="element()">
  <param name="qname"       as="xs:QName" />
  <param name="attr-pairs"  as="item()*" />
  <param name="child-nodes" as="node()*" />

  <variable name="element" as="element()">
    <element name="{$qname}"
             namespace="{namespace-uri-from-QName( $qname ) }">
      <sequence select="_n:attr-from-pair( $attr-pairs ),
                        $child-nodes" />
    </element>
  </variable>

  <sequence select="$element" />
</function>


<!--
  Construct an element named @var{qname} with attributes defined by
  the QName-value pairs @var{attr-pairs} and no child nodes.  An empty
  sequence may be provided if no attributes are desired (see also the
  @ref{n:element#1,,unary} overload).

  This is equivalent to @code{n:element( $qname, $attr-pairs, () )}; see
  @ref{n:element#3}.
-->
<function name="n:element" as="element()">
  <param name="qname"      as="xs:QName" />
  <param name="attr-pairs" as="item()*" />

  <sequence select="n:element( $qname, $attr-pairs, () )" />
</function>


<!--
  Construct an element named @var{qname} with no attributes or children.

  This is equivalent to @code{n:element( $qname, (), () )}; see
  @ref{n:element#3}.
-->
<function name="n:element" as="element()">
  <param name="qname" as="xs:QName" />

  <sequence select="n:element( $qname, () )" />
</function>

<!--
  Create a text node with the given @var{text}.  The @var{text} will be
  output verbatim without any whitespace processing.
-->
<function name="n:text" as="text()">
  <param name="text" as="xs:string" />

  <variable name="text-node" as="text()">
    <value-of select="$text" />
  </variable>

  <sequence select="$text-node" />
</function>


<!--
  Create a comment node with the given @var{text}.  The @var{text} will be
  output verbatim without any whitespace processing.
-->
<function name="n:comment" as="comment()">
  <param name="text" as="xs:string" />

  <variable name="comment" as="comment()">
    <comment select="$text" />
  </variable>

  <sequence select="$comment" />
</function>


<!--
  @node Node Private Functions
  @section Private Functions
  These functions support the various node functions, but should not be used
  outside of Hoxsl itself.
-->

<!--
  Construct attributes from a list of QName-value pairs.

  For more information on the pair format, see @ref{n:element#3}.
-->
<function name="_n:attr-from-pair" as="attribute()*">
  <param name="attr-pairs" as="item()*" />

  <variable name="attribute" as="attribute()">
    <variable name="qname" as="xs:QName"
              select="$attr-pairs[ 1 ]" />
    <variable name="value" as="xs:anyAtomicType?"
              select="$attr-pairs[ 2 ]" />

    <attribute name="{$qname}"
               namespace="{namespace-uri-from-QName( $qname ) }"
               select="$value" />
  </variable>

  <sequence select="if ( exists( $attr-pairs ) ) then
                      ( $attribute,
                        _n:attr-from-pair(
                          subsequence( $attr-pairs, 3 ) ) )
                    else
                      ()" />
</function>

</stylesheet>
