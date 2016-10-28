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
>> TJSON.parse('{"s:foo":"s:bar"}')
=> {"foo"=>"bar"}
```

The following describes how TJSON types map onto Ruby types during parsing:

 * **UTF-8 Strings**: parsed as Ruby `String` with `Encoding::UTF_8`
 * **Binary Data**: parsed as Ruby `String` with `Encoding::ASCII_8BIT` (a.k.a. `Encoding::BINARY`)
 * **Integers**: parsed as Ruby `Integer` (Fixnum or Bignum)
 * **Floats** (i.e. JSON number literals): parsed as Ruby `Float`
 * **Timestamps**: parsed as Ruby `Time`
 * **Arrays**: parsed as `TJSON::Array` (a subclass of `::Array`)
 * **Objects**: parsed as `TJSON::Object` (a subclass of `::Hash`)

### Generating

To generate TJSON from Ruby objects, use the `TJSON.generate` method:

```ruby
>> puts TJSON.generate({"foo" => "bar" })
{"s:foo":"s:bar"}
```

The `TJSON.generate` method will call `#to_tjson` on any objects which are not
one of Ruby's core types. You can implement this method on classes you wish to
serialize as TJSON, although it MUST output tagged strings for encoding TJSON
types such as UTF-8 strings or binary data.

### TJSON::Binary

The `TJSON::Binary` module contains a set of helper methods for serializing
binary data in various different encodings:

```ruby
>> TJSON::Binary.base16("Hello, world!")
=> "b16:48656c6c6f2c20776f726c6421"
>> TJSON::Binary.base32("Hello, world!")
=> "b32:jbswy3dpfqqho33snrscc"
>> TJSON::Binary.base64("Hello, world!")
=> "b64:SGVsbG8sIHdvcmxkIQ"
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tjson/tjson-ruby

