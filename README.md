# ponyfmt

Source Code Formatter for the ponylang programming language

## Status

[![Build Status](https://travis-ci.org/mfelsche/ponyfmt.svg?branch=master)](https://travis-ci.org/mfelsche/ponyfmt)

This project is still in pre-alpha state and might damage your sources.

## Installation

* Install [pony-stable](https://github.com/ponylang/pony-stable)
* Update your `bundle.json`

```json
{ 
  "type": "github",
  "repo": "mfelsche/ponyfmt"
}
```

* `stable fetch` to fetch your dependencies
* `use "ponyfmt"` to include this package
* `stable env ponyc` to compile your application
