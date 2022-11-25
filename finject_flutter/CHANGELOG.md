# CHANGELOG.md

## (0.3.2)

Features:

  - Fixes in injection process. Custom scope is processing properly now

## (0.3.1)

Features:

  - Added FInject class which allow for inline injections if you really need it. In this case variants of same type has to be selected manually
  - Added DiState class which extends State class for translarent injection inside state class
    IMPORTANT You need do keep State class public. In that way fields can be accessed be generated code


## (0.3.0)

Features:

  - Added disposability for

## (0.2.0)

Breaking Changes:

  - Added new method of injecting class which are annotated with @immutable. Now you can use manualInjecting in context of buildMethod

## (0.1.4)

Breaking Changes:

  - Use FinjectHost class instead of InjectHost class.

Features:

  - Separation of scoping and injection


## (0.1.2)

Features:

  - Injecting with constructor
  - Injecting with fields
  - Injecting with factory class
  - Scoped Singleton
  - Custom scopes
  - Hierarchcal Search down the tree of widgets
  - Named injections