<!---
  Copyright (C) 2014  LoVullo Associates, Inc.
  Copyright (C) 2015  Mike Gerwitz

  Permission is granted to copy, distribute and/or modify this
  document under the terms of the GNU Free Documentation License,
  Version 1.3 or any later version published by the Free Software
  Foundation; with no Invariant Sections, no Front-Cover Texts, and no
  Back-Cover Texts.  A copy of the license is included the file
  COPYING.FDL.
-->
# Higher-Order XSLT
hoxsl is a library for XSLT 2.0, written in pure XSLT, introducing
various types of higher-order logic;  this includes higher-order
functions and XSLT templates that take XSLT as input and produce XSLT
as output.

The system is fully tested---see the test cases for additional
documentation as this project gets under way.  The manual is "woven" from
literate sources; [a compiled version is available online][manual].


## Higher-Order Functions
[Higher-order functions][xslt-30-ho] are a part of XSLT 3.0, but
implementations that support them (such as Saxon) hide it behind
proprietary versions of their software.  Others still may wish to
continue using XSLT 2.0.

There are various approaches/kluges for this problem in earlier
versions of XSLT; the basis of this implementation is motivated by
Dimitre Novatchev's work on [higher-order functions in FXSL][nova-ho].

For example, consider an implementation of a filter function that
accepts a node set and a predicate:

```xml
  <xsl:function name="my:filter" as="xs:element()*">
    <xsl:param name="nodes" as="xs:element()*" />
    <xsl:param name="pred" />

    <xsl:for-each select="$nodes">
      <xsl:if test="f:apply( $pred, . )">
        <xsl:sequence select="." />
      </xsl:if>
    </xsl:for-each>
  </xsl:function>


  <xsl:function name="my:pred" as="xs:boolean">
    <xsl:param name="node" as="element()" />

    <xsl:sequence select="$node/@foo = 'true'" />
  </xsl:function>
```

We could then apply a filter using this predicate like so:

```xml
  <sequence select="my:filter( $nodes, my:pred() )" />
```

hoxsl takes this a step further by providing a stylesheet to generate
the boilerplate necessary for functions to be able to be applied using
`f:apply`, as shown above.  Applying `tranform/apply-gen.xsl` to the
XSL stylesheet containing the above function definitions would produce
output that can be directly imported (as a stylesheet); no additional
work is needed.  This can be included as part of a build process, and
the output included within a distribution.


### Partial Applications
Dynamic function applications using `f:apply` are partially applied if
the number of arguments provided is less than the arity of the target
function.  For convenience, the `apply-gen` stylesheet will also
generate functions to perform partial application without the use of
`f:apply` for the first call, as in the first example below:

```xml
  <!-- produces a new dynamic function of arity 5 - 3 = 2 -->
  <variable name="partial"
            select="my:arity5( 1, 2, 3 )" />

  <!-- does the same, the long way -->
  <variable name="partial-long"
            select="f:apply( my:arity5(), 1, 2, 3 )" />

  <!-- consequently, currying is supported -->
  <variable name="result"
            select="f:apply( f:apply( $partial, 4 ), 5 )" />

  <!-- equiv = true() -->
  <variable name="equiv"
            select="$result
                    = f:apply( my:arity5( 1, 2, 3 ), 4, 5 )
                    = f:apply( my:arity5(), 1, 2, 3, 4, 5 )
                    = my:arity5( 1, 2, 3, 4, 5 )" />
```

The implementation of partial function applications avoids the
complexity and inaccuracies of [Novatchev's approach][nova-ho] by
using only sequences, allowing arguments to retain their type and
context.


## License
This program is free software: you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your option)
any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU General Public License for more details.

[nova-ho]: http://conferences.idealliance.org/extreme/html/2006/Novatchev01/EML2006Novatchev01.html
[xslt-30-ho]: http://www.w3.org/TR/xslt-30/#dt-higher-order-operand
[manual]: https://mikegerwitz.com/hoxsl/manual/

