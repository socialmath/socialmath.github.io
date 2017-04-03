---
title: Category Theory
published: false
---

The following version is addressed to an audience that knows something
about math and doesn't just equate it with the bullshit done in
school.  There are some mathematical examples that aren't developed
much, but a reader who doesn't know about them can just ignore them
and get the points anyway.

### Category Theory

There was a revolution in mathematics in the 20th Century.  Here is a
highly idealized and probably inaccurate sketch of the history of the
conceptual steps involved:

1. **Constructivism.** Mathematical objects must be defined in terms of
   a small set of "primitive concepts" in order to be known.  Our
   intuition of how they behave is not enough.  The essence of a
   mathematical object is its construction.  For example, the real
   numbers are constructed by Dedekind cuts.
   
2. **Structuralism** But there are often many different constructions
   that embody the same intuition!  The real numbers, for instance,
   didn't have to be constructed with Dedekind cuts.  Cauchy sequences
   could also have been used!  How do we know which to choose?
   Really, it is not the particular way we constructed an object that
   is important, but rather its internal _structure_.  The essence of
   a mathematical object is its structure.
   
    1. **Universal Algebra** How do we define a structure?  We use a
       set of axioms that are satisfied by it.  For example, the real
       numbers are the unique complete ordered field (each of these
       words, "complete", "ordered", and "field", indicates a set of
       axioms satisfied by the real numbers).  The essence of a
       mathematical object is the axioms that are satisfied by it.
	   
	2. **Category Theory** But we could have used different axioms.
       The real numbers are also the unique Archimedean ordered field.
       How can the set of axioms that an object uniquely satisfies be
       its essence when it uniquely satisfies multiple distinct sets
       of axioms?  The reason that these axiom sets are equivalent is
       that the object satisfying them _interacts the same way with
       other objects_.  In category theory, the essence of an object
       is how it interacts with other objects.  (I don't think I have
       fully justified this.  I will edit it as I learn more.)  (I'm
       not sure how to do a categorical analysis of the real
       numbers.
       [Apparently](http://math.stackexchange.com/questions/839848/category-theoretic-description-of-the-real-numbers) others
       aren't either.)
	   
In category theory, there is a natural shift of focus from the
structures of individual objects to the structures of the networks of
interactions between objects.  These networks are called _categories_.
Categories themselves can be studied in general, and they go through
the same conceptual progression detailed above.  They are first
axiomatized, and then it turns out that really their interactions with
each other is what is important.  So we end up talking about the
category of categories.  The category theorist Lawvere talked about
the foundations of mathematics through the category of categories.

I don't know much about this, so I kind of feel embarrassed that I am
writing this publicly, but I will revise it later and I suppose its
good that everybody can looka at the version history and see that I'm
revising things and not just innately an expert.  For my thinking on
this
see
[here](https://bandanablog.wordpress.com/2015/07/10/rolequeers-write-bad-books/).

### Social Sciences

We can go through an analogous dialectic to attain a social conception
of self:

1. People are just physical matter.  Someone's identity is simply the
   collection of matter that makes up their body.  How could it be
   anything else?  This matter determines the person commpletely in
   the sense that two people cannot share the same physical matter.
   
2. But the matter comprising us changes with time!  We are constantly
   admitting new matter into our bodies (e.g. food, drink, air) and
   expelling old matter from our bodies (e.g. excrement, dead skin
   cells, air).  It seems like our bodies are really just a structure
   that matter cascades in and out of.  The particular atoms that make
   up our body at a particular time are no more essential to ourselves
   than the place we happen to be located at that time.  Really, a
   person's essence is the structure of their body.
   
    1.  Well, how do we define someone's structure?

In 1992, one of the founders of category theory, William
Lawvere,
[wrote](https://ncatlab.org/nlab/show/William+Lawvere#Lawvere92):

> It is my belief that in the next decade and in the next century the
> technical advances forged by category theorists will be of value to
> dialectical philosophy, lending precise form with disputable
> mathematical models to ancient philosophical distinctions such as
> general vs. particular, objective vs. subjective, being
> vs. becoming, space vs. quantity, equality vs. difference,
> quantitative vs. qualitative etc. In turn the explicit attention by
> mathematicians to such philosophical questions is necessary to
> achieve the goal of making mathematics (and hence other sciences)
> more widely learnable and useable. Of course this will require that
> philosophers learn mathematics and that mathematicians learn
> philosophy.

