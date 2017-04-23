# TJSON for Ruby [![Gem Version][gem-image]][gem-link] [![Build Status][build-image]][build-link] [![Code Climate][codeclimate-image]][codeclimate-link] [![MIT licensed][license-image]][license-link]

A Ruby implementation of [TJSON]: Tagged JSON with Rich Types.

[TJSON]: https://www.tjson.org

```json
{
  "array-example:A<O>": [
    {
      "string-example:s": "foobar",
      "binary-data-example:d": "QklOQVJZ",
      "float-example:f": 0.42,
      "int-example:i": "42",
      "timestamp-example:t": "2016-11-06T22:27:34Z",
      "boolean-example:b": true
    }
  ],
  "set-example:S<i>": [1, 2, 3]
}
```

[gem-image]: https://badge.fury.io/rb/tjson.svg
[gem-link]: https://rubygems.org/gems/tjson
[build-image]: https://secure.travis-ci.org/tjson/tjson-ruby.svg?branch=master
[build-link]: https://travis-ci.org/tjson/tjson-ruby
[codeclimate-image]: https://codeclimate.com/github/tjson/tjson-ruby.svg?branch=master
[codeclimate-link]: https://codeclimate.com/github/tjson/tjson-ruby
[license-image]: https://img.shields.io/badge/license-MIT-blue.svg
[license-link]: https://github.com/tjson/tjson-ruby/blob/master/LICENSE.txt

## Help and Discussion

Have questions? Want to suggest a feature or change?

* [TJSON Gitter]: web-based chat
* [TJSON Google Group]: join via web or email ([tjson+subscribe@googlegroups.com])

[TJSON Gitter]: https://gitter.im/tjson/Lobby
[TJSON Google Group]: https://groups.google.com/forum/#!forum/tjson
[tjson+subscribe@googlegroups.com]: mailto:tjson+subscribe@googlegroups.com

## Requirements

This library is tested against the following Ruby versions:

- 2.0
- 2.1
- 2.2
- 2.3
- 2.4
- jruby 9.1

Other Ruby versions may work, but are not officially supported.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tjson'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tjson

## API

### TJSON.parse

To parse a TJSON document, use the `TJSON.parse` method:

```ruby
>> TJSON.parse('{"foo:s":"bar"}')
=> {"foo"=>"bar"}
```

### TJSON.generate

To generate TJSON from Ruby objects, use the `TJSON.generate` method:

```ruby
TJSON.generate({"foo" => "bar"})
# {"foo:s:"bar"}
```

For better formatting, use the `TJSON.pretty_generate` method:

```ruby
TJSON.pretty_generate({"array-example" => [{"string-example" => "foobar", "binary-example" => "BINARY".b, "float-example" => 0.42, "int-example" => 42, "timestamp-example" => Time.now}]})
# {
#  "array-example:A<O>": [
#    {
#      "string-example:s": "foobar",
#      "binary-example:b64": "QklOQVJZ",
#      "float-example:f": 0.42,
#      "int-example:i": "42",
#      "timestamp-example:t": "2016-11-06T22:27:34Z"
#    }
#  ]
#}
```

## Type Conversions

The table below shows how TJSON tags map to Ruby types:

| Tag | Ruby Type                                                        |
|-----|------------------------------------------------------------------|
| `b` | `true` or `false`                                                |
| `d` | `String` with `Encoding::ASCII_8BIT` (a.k.a. `Encoding::BINARY`) |
| `f` | `Float`                                                          |
| `i` | `Integer` (`Fixnum` or `Bignum` on Ruby <2.4 )                   |
| `u` | `Integer` (`Fixnum` or `Bignum` on Ruby <2.4 )                   |
| `s` | `String` with `Encoding::UTF_8`                                  |
| `t` | `Time`                                                           |
| `A` | `Array`                                                          |
| `O` | `TJSON::Object` (a subclass of `::Hash`)                         |
| `S` | `Set`                                                            |

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tjson/tjson-ruby

## License

Copyright (c) 2017 Tony Arcieri. Distributed under the MIT License. See
[LICENSE.txt](https://github.com/tjson/tjson-ruby/blob/master/LICENSE.txt)
for further details.
