# globalize3-validations

[![Build Status](https://travis-ci.org/emjot/globalize3-validations.png?branch=rails4)](https://travis-ci.org/emjot/globalize3-validations)

## Maintainance State of This Gem

Since we do not use this gem in active projects any more, further development of this gem is unlikely. If anyone wants to submit a PR, we will of course still try to review + merge.

## Rails 4

**globalize >= 4.0.1 already provides uniqueness validation support for translated models via the regular 
UniquenessValidator. This makes this gem obsolete when using rails 4 - as such it has been discontinued** 
(i.e. the version of the gem in the rails4 branch does absolutely nothing). 

Compared to what this gem used to do, globalize just has one restriction (checked with globalize 4.0.2): 
Uniqueness validation is always scoped by locale. This is what you usually want. 
If not, you should submit an issue and/or pull request to globalize.

## Rails 3

For rails 3.x, please see master branch (versions 0.1.x).
