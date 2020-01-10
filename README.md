# Finject

![alt text](https://raw.githubusercontent.com/TomMannson/Finject/master/art/injection.png "Finject Logo")

[![Build Status](https://api.travis-ci.com/TomMannson/Finject.svg?branch=master)](https://travis-ci.com/TomMannson/Finject)
Tool that generates dependency injection Dart code.

Library was inspired by 3 other solution:
1. Spring Framework
2. Dagger 2
3. Angular DI builtin library


## Introduction

FInject provides:

- Easy and Flexible way of declarative DI approach (DI no service locator);
- Compile time code generation with single output (No need to create special part  files every line is in one place);
- Easy scope management.

## Annotations and Contract classes for DI

[![Pub](https://img.shields.io/pub/v/finject.svg)](https://pub.dev/packages/finject)

The core package providing the annotations which describes dependency graph.

No need to import in pubspec. Package finject_flutter using it


## Generator

[![Pub](https://img.shields.io/pub/v/finject_generator.svg)](https://pub.dev/packages/finject_generator)

The package providing the generator for DI code.

Import it into your pubspec `dev_dependencies:` section.


## Flutter glue code

[![Pub](https://img.shields.io/pub/v/finject_flutter.svg)](https://pub.dev/packages/finject_flutter)

The package provides glue code which use injecting code under the hood.

Import it into your pubspec `dependencies:` section.


## Example

Example showing how to setup dependencies is available here:

[Source Code](https://github.com/TomMannson/Finject/tree/master/example)


## License

```
MIT License

Copyright (c) 2020 Tomasz Król

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
