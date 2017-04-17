# TJSON for Ruby [![Gem Version][gem-image]][gem-link] [![Build Status][build-image]][build-link] [![Code Climate][codeclimate-image]][codeclimate-link] [![MIT licensed][license-image]][license-link]

A Ruby implementation of TJSON: Tagged JSON with Rich Types.

https://www.tjson.org

[gem-image]: https://badge.fury.io/rb/tjson.svg
[gem-link]: https://rubygems.org/gems/tjson
[build-image]: https://secure.travis-ci.org/tjson/tjson-ruby.svg?branch=master
[build-link]: https://travis-ci.org/tjson/tjson-ruby
[codeclimate-image]: https://codeclimate.com/github/tjson/tjson-ruby.svg?branch=master
[codeclimate-link]: https://codeclimate.com/github/tjson/tjson-ruby
[license-image]: https://img.shields.io/badge/license-MIT-blue.svg
[license-link]: https://github.com/tjson/tjson-ruby/blob/master/LICENSE.txt

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tjson'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tjson

## Usage

### Parsing

To parse a TJSON document, use the `TJSON.parse` method:

```ruby
>> TJSON.parse('{"foo:s":"bar"}')
=> {"foo"=>"bar"}
```

The following describes how TJSON types map onto Ruby types during parsing:

 * **Unicode Strings**: parsed as Ruby `String` with `Encoding::UTF_8`
 * **Binary Data**: parsed as Ruby `String` with `Encoding::ASCII_8BIT` (a.k.a. `Encoding::BINARY`)
 * **Integers**: parsed as Ruby `Integer` (Fixnum or Bignum)
 * **Floats** (i.e. JSON number literals): parsed as Ruby `Float`
 * **Boolean Values**: parsed as Ruby `true` and `false`
 * **Timestamps**: parsed as Ruby `Time`
 * **Arrays**: parsed as Ruby `Array`
 * **Sets**: parsed as Ruby `Set`
 * **Objects**: parsed as `TJSON::Object` (a subclass of `::Hash`)

### Generating

To generate TJSON from Ruby objects, use the `TJSON.generate` method:

```ruby
puts TJSON.generate({"foo" => "bar"})
{"foo:s:"bar"}
```

For better formatting, use the `TJSON.pretty_generate` method:

```ruby
puts TJSON.pretty_generate({"array-example" => [{"string-example" => "foobar", "binary-example" => "BINARY".encode(Encoding::BINARY), "float-example" => 0.42, "int-example" => 42, "timestamp-example" => Time.now}]})
{
  "array-example:A<O>": [
    {
      "string-example:s": "foobar",
      "binary-example:b64": "QklOQVJZ",
      "float-example:f": 0.42,
      "int-example:i": "42",
      "timestamp-example:t": "2016-11-06T22:27:34Z"
    }
  ]
}
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tjson/tjson-ruby

