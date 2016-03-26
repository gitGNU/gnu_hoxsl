<?xml version="1.0" encoding="utf-8"?>
<!--
  Node constructors

  Copyright (C) 2015, 2016 Mike Gerwitz

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
            xmlns:n="http://mikegerwitz.com/hoxsl/node"
            xmlns:R="http://mikegerwitz.com/hoxsl/record"
            xmlns:_R="http://mikegerwitz.com/hoxsl/record/_priv">

<import href="node.xsl" />

<!--
  XML is a document markup language@mdash{}it exists to describe data.
  It may seem odd, then, that Hoxsl defines@mdash{}out of
    necessity@mdash{}another way to represent data that is wholly outside of
    the structure of an XML document.

  A sequence of items in XSLT can represent anything@mdash{}nodes, processor
    directives, primitives, and others;
    some of these data cannot be serialized into an XML document and be
    de-serialized confidently without a great deal of effort and overhead.
  For schema-aware processors, this task is even more daunting, since an
    item can take on even more types.
  In certain cases, the task is impractical:
    consider maintaining the context of an element relative to its source
    document,
    such that axes like @t{ancestor} and @t{preceding-sibling} continue to
    work properly after de-serializing,
    and that the reference to the de-serialized node will continue be
    consistent throughout the entire system where the element may not have
    undergone serialization.
  Consider further using a deserialized element with @t{document-uri}.

  The fool-proof method is to always keep XSLT's representation of its own
    data in memory at all times without having to tamper with it.
  To do so, we must work with how XSLT represents all data:
    as a sequence.
  Sequences are like lists, but are one-dimensional:

  @float Figure, fig:seq-one-dim
  @example
  @xmlcomment{Same as (1, 2, 3, 4)}
  <sequence select="(1, (2, 3), 4)" />
  @end example
  @caption{Sequences are always one-dimensional}
  @end float

  In other words: there is no way to create structured sequences of
    arbtirary data.
  You @emph{can} represent structured data as an XML element, which would be
    a single item in the sequence, but that reintroduces the serialization
    problem.

  Passing large amounts of data on the stack is inherent in any functional
    system, and maintaining the integrity of those data is essential.
  Enter records.


  @menu
  * Design Considerations: Record Design Considerations.
  * Header: Record Header.
  * Polymorphism: Record Polymorphism.
  @end menu


  @node Record Design Considerations
  @section Design Considerations
  Introducing, effectively, a new type system into XSLT should be done
    cautiously and faithfully@c
    @mdash{}it should work @emph{with} the language, not sneak klugily
    around it.
  The main considerations are:

  @enumerate
  @item Records must be able to contain @emph{any number of arbitrary
    key-value pairs};

  @item Value data must be passed @emph{by reference} (consequently,
    unmodified), for both reasons of performance and data integrity;

  @item Templates and functions must be able to @emph{return any number of
    records} as part of a sequence;

  @item Record must be able to @emph{contain sequences as values} and,
    consequently, other records;

  @item Templates must be able to @emph{match on record types} and record
    values must be able to be @emph{queried within XPath expressions},
    so as not to disrupt XSLT conventions; and

  @item Records should incur a nominal performance penalty relative to the
    actual application logic.
  @end enumerate

  Each of these properties will be addressed as they are introduced in the
    sections that follow.
  But the fundamental concept that needs to be considered before even
    beginning an implementation is the viability of sequences.

  Sequences are generally performant:
    when you execute an XPath expression on a document yielding multiple
    matches, each item is returned as part of a sequence.
  These sequences could potentially yield tens of thousands (if
    not more) of results.
  You can then refine those results using further
    XPath expressions, looping constructs, template applications, and
    functions.
  This is important when we consider records, since records could be of
    arbitrary length, recursively.

  A record, then, is nothing more than a slice of a sequence@c
    @mdash{}it must have a defined length to state how many items within the
    sequence ``belong'' to the record,
    but it otherwise does not need to define much else,
    since XSLT's type system handles most of that work for us.@c
  @footnote{Remember: the original goal was to stay as far away from data
    manipulation as possible.}

  Consider some record named @t{Rect} that contains two fields @t{A} and
    @t{B},
    both of type @t{Point},
    where the record @t{Point} contains two fields @t{x} and @t{y}.
  Let @t{x} and @t{y} be represented by @t{xs:integer};
    we could represent two rectangles using the following numbers:

  @float Figure, fig:rect-points
  @verbatim
  (..., 0, 1, 1, 0, 2, 2, 4, 0, ...)
         \/    \/    \/    \/
         A1    B1    A2    B2
           \  /        \  /
            R1          R2
  @end verbatim
  @caption{Representing two @t{Rect}s @t{R1} and @t{R2} as a sequence of
    @t{xs:integer}s}
  @end float

  The goal of a record implementation is to determine how we represent each
    of the records in @ref{fig:rect-points},
    where those items could exist in a sequence of any other arbitrary
    items.
  The implementation will involve adding additional items into the sequence
    in order to provide the needed context.


  @node Record Header
  @section Record Header
  @ref{fig:rect-points} showed how two rectangle records of type @t{Rect}
    may be described using raw @t{xs:integer}s.
  In a language like C, which operates directly on blocks of memory that
    acquire meaning only through interpretation, that raw representation
    would make sense:
    we would interpret it however we please without sprinkling our own
    metadata into the sequence.
  That is not the approach we will be taking here,
    as it disallows certain desirable features discussed in the
    @ref{Record Design Considerations},
    such as the ability to match on records using templates@c
    @mdash{}we can only do so if such metadata were a part of the sequence
    itself.
  That approach would also place the entire onus of interpretation on the
    caller;
    this does not fit well with the philosophy of XSLT which uses pattern
    matching to process data.

  @float Figure, fig:rect-points-delimited
  @verbatim
  (..., |Rect:2|,
          |A:Point:2|, 0, 1,
          |B:Point:2|, 1, 0,
        |Rect:2|,
          |A:Point:2|, 2, 2,
          |B:Point:2|, 4, 0, ...)
  @end verbatim
  @caption{Delimiting records with headers}
  @end float

  @ref{fig:rect-points-delimited} delimits the record data of
    @ref{fig:rect-points} by adding headers describing the type of the
    record and the number of fields that it contains.
  Newlines are added to emphasize the relationship between fields.

  Note how the length of the @t{Rect}@tie{}records describes the number of
    @t{Point}s it contains,
    @emph{not} the number of XSLT @t{item}s.
  This distinction is of great importance if we are to allow generic data in
    any record field.
  Each record is allocated a predetermined number of @dfn{slots},
    each of which may contain zero or more XSLT items depending on how the
    datum is interpreted.
  Each slot is identified by a 1-based index.
  A@tie{}@dfn{field} is the name of a@tie{}slot.
  In @ref{fig:rect-points-delimited}, @t{Rect} has two fields@c
    @mdash{}@t{A}@tie{}assigned to slot@tie{}1,
    and @t{B}@tie{}assigned to slot@tie{}2@c
    @mdash{}both of which are @t{Point}s.
-->

<!--
  The namespace to which all records elements are assigned.
-->
<variable name="R:ns" as="xs:anyURI"
          select="resolve-uri( 'http://mikegerwitz.com/hoxsl/record' )" />

<!--
  The namespace for all encapsulated record data.
-->
<variable name="_R:ns" as="xs:anyURI"
          select="resolve-uri(
                    'http://mikegerwitz.com/hoxsl/record/_priv' )" />

<!--
  QName of the record header element.
-->
<variable name="R:qname" as="xs:QName"
          select="QName( $R:ns, 'R:Record' )" />


<!--
  Make a new record header for a record identified by @var{qname} containing
  @var{slots} slots.

  @macro mrhnb{}
  @emph{N.B.:} This does not provide any field names or values@c
    @mdash{}this header should not be used directly within a sequence unless
    the caller is expecting it,
    since it will otherwise consume adjacent sequence items when used with
    the Hoxsl record APIs.
  @end macro

  @mrhnb{}
-->
<function name="R:make-record-header" as="element( R:Record )">
  <param name="qname" as="xs:QName" />
  <param name="slots" as="xs:integer" />

  <sequence select="R:make-record-header( $qname, $slots, () )" />
</function>


<!--
  Make a new record header for a record identified by @var{qname} containing
    @var{slots} slots.
  The record will be a subtype of @var{supertype}.

  @mrhnb{}

  @xref{R:is-a#2}.
-->
<function name="R:make-record-header" as="element( R:Record )">
  <param name="qname"     as="xs:QName" />
  <param name="slots"     as="xs:integer" />
  <param name="Supertype" as="element( R:Record )?" />

  <variable name="super-slots" as="xs:integer"
            select="if ( $Supertype ) then
                        R:slot-count( $Supertype )
                      else 0" />

  <variable name="slot-count" as="xs:integer"
            select="max( ( $slots, $super-slots ) )" />

  <sequence select="n:element( $R:qname,
                               ( n:attr( QName( $_R:ns, 'slots' ),
                                         $slot-count ) ),
                               ( $Supertype/node(),
                                 n:element( $qname ) ) )" />
</function>

<!--
  @ref{R:make-record-header#2} provides the most generic definition of a
    record possible.
  All records are identifiable by a@tie{}@t{R:Record} header node,
    containing also the number of slots that the record will consume.
  Notice that these slots are not provided names@c
    @mdash{}this is unnecessary for their use.

  Within the @t{R:Record} node is a node identified by the provided
    @var{qname},
    which provides record typing (@pxref{R:make-record-header#3}).
  A@tie{}@dfn{supertype} may optionally be provided to produce type
    hierarchies@mdash{}all records are of type @t{R:Record},
    but could be be further subtyped for particular applications and used
    polymorphically.@c
  @footnote{Consider how subtyping might be performed:
    rather than creating a new record header listing all parent types,
    it would be useful to be able to reference an existing record header,
    which would in turn implicitly reference each of its supertypes.}
  @xref{Record Polymorphism}.

  An accessor function is provided to retrieve the slot count of a record;
    this should always be used,
    as the record implementation could change in the future:
-->

<!--
  Determine the number of slots available in the record @var{Record}.
-->
<function name="R:slot-count" as="xs:integer">
  <param name="Record" as="element( R:Record )" />

  <sequence select="$Record/@_R:slots" />
</function>


<!--
  @node Record Polymorphism
  @section Record Polymorphism

  Record @dfn{polymorphism} is achieved through @dfn{subtyping}:
  Two records @var{R} and @var{S} are @dfn{compatible} if the slot count
    @var{#S} ≥ @var{#R}.
  When @var{S} is compatible with@tie{}@var{R},
    then @var{S}@tie{}may be declared a@tie{}@dfn{subtype} of@tie{}@var{R};
    @var{R}@tie{} is referred to as the @dfn{supertype} of@tie{}@var{S}.
  No record may have more than one supertype,
    but any record may have more than one subtype.
  Any subtype@tie{}@var{T} of@tie{}@var{S} is also a subtype
    of@tie{}@var{R}.

  Compatibility ensures that,
    when a record@tie{}@var{S} is provided in place of another
    record@tie{}@var{R},
    that the callee is able to extract at least the amount of information
    that it expects to be available from@tie{}@var{R}.
  Explicit subtyping declares @emph{intent}@c
    @mdash{}it provides context that is important API documentation and
    helps to catch logic errors.
  For example,
    even though a record named @t{Withdrawl} and @t{Deposit} may both have
    two slot values
    (representing a monetary value for a bank transaction on a given
    account),
    their intents are vastly different,
    and using one where another should be used indicates a logic error:
      the system began initiating a withdrawl but invoked a deposit
      function, for example.

  @menu
  * Checking Compatibility: Checking Record Compatibility.
  * Type Predicates: Record Type Predicates.
  @end menu
-->


<!--
  @node Checking Record Compatibility
  @subsection Checking Compatibility

  When considering compatibility,
    we introduce a potential point of failure during header creation;
    but the @ref{Record Header,,record header functions} are primitive
    operations that,
    in order to simplify the system,
    should ideally guarantee success.
  @ref{R:make-record-header#3} will silently upgrade the slot count as
    necessary to ensure record compatibility;
    it is up to the caller to perform necessary validations and decide
    whether to fail.
-->

<!--
  Determine whether record @var{Sub} is compatible with a supertype
  @var{Supet}.
-->
<function name="R:is-compatible" as="xs:boolean">
  <param name="Sub"   as="element( R:Record )" />
  <param name="Super" as="element( R:Record )" />

  <sequence select="R:slot-count( $Sub ) &gt;= R:slot-count( $Super )" />
</function>


<!--
  @node Record Type Predicates
  @subsection Type Predicates
-->

<!--
  Predicate to determine whether @var{record} or any of its supertypes is of
    type @var{type}.

  All records are of type @t{R:Record}.
-->
<function name="R:is-a" as="xs:boolean">
  <param name="type"   as="xs:QName" />
  <param name="Record" as="element( R:Record )" />

  <sequence select="$type = $R:qname
                    or exists(
                         $Record/element()[
                           node-name( . ) = $type ] )" />
</function>

</stylesheet>
