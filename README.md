[![Build Status](https://travis-ci.org/eonu/string-builder.svg?branch=master)](https://travis-ci.org/eonu/string-builder)
![Gem](https://img.shields.io/gem/v/string-builder.svg)
[![License](https://img.shields.io/github/license/eonu/string-builder.svg)](https://github.com/eonu/string-builder/blob/master/LICENSE)

# String::Builder

Modified and extended port of the [String::Builder](https://crystal-lang.org/api/0.20.3/String/Builder.html#build%28capacity%3AInt%3D64%2C%26block%29%3AString-class-method) IO-style initializer for the `String` class of the Crystal programming language in the form of a Ruby gem refinement module.

## Methods

There are four new methods in this extension of the `String` class:

### Instance methods

#### `String#build`

Takes a block yielding a new builder string, and appends the builder string to a duplicate of the original `String` object, `self`.

##### Examples

```ruby
foobar = 'foo'.build do |s|
  s << 'bop'
  s.gsub!('op','ar')
end

foobar #=> "foobar"
```

```ruby
foo = 'foo'

foobar = foo.build do |s|
  s << 'bop'
  s.gsub!('op','ar')
end

foobar #=> "foobar"
```

#### `String#build!`

Takes a block yielding a new builder string, and appends the builder string to the original `String` object, `self`.

**NOTE**: This mutates the original string, as indicated by the bang `!`.

##### Example

```ruby
foobar = 'foo'

foobar.build! do |s|
  s << 'bop'
  s.gsub!('op','ar')
end

foobar #=> "foobar"
```

### Class methods

#### `String.build`

Takes an arbitrary object and a block yielding a new string builder, and appends the builder string to a duplicate of the object parameter converted to a string (with `to_s`).

If no block is given, then the object converted to a string (with `to_s`) is returned.

##### Examples

```ruby
foobar = String.build do |s|
  s << 'fii'
  s.gsub!('ii','oo')
  s << 'bar'
end

foobar #=> "foobar"
```

```ruby
foobar = String.build 'foo' do |s|
  s << 'bop'
  s.gsub!('op','ar')
end

foobar #=> "foobar"
```

```ruby
foobar = String.build 3 do |s|
  s << 'bop'
  s.gsub!('op','ar')
end

foobar #=> "3bar"
```

```ruby
foo = 'foo'

foobar = String.build foo do |s|
  s << 'bop'
  s.gsub!('op','ar')
end

foobar #=> "foobar"
foo #=> "foo"
```

#### `String.[]`

Takes arbitrarily many objects (with splat), converts them to strings and contatenates them (takes the product with the empty string).

##### Examples

```ruby
String[]                       #=> ""
String[3]                      #=> "3"
String['Hello','World','!']    #=> "HelloWorld!"
String[{k: 'v'}, 3, %i[a b c]] #=> "{:k=>\"v\"}3[:a, :b, :c]"
String[*['a', 2, :z]]          #=> "a2z"
```

## Detailed example

This example shows how to make a simple logger by constructing log messages with `String::Builder`.

Suppose we want a `Logger` class that allows us to do the following:

```ruby
logger = Logger.new

logger.error 'String::Builder is good?'
#=> [03:54:53s] (lib/string-builder.rb) ERROR » String::Builder is good!
logger.success 'String::Builder is good?'
#=> [03:54:55s] (lib/string-builder.rb) SUCCESS » String::Builder is good!
logger.info 'String::Builder is good?'
#=> [03:54:57s] (lib/string-builder.rb) INFO » String::Builder is good!
logger.warning 'String::Builder is good?'
#=> [03:54:59s] (lib/string-builder.rb) WARNING » String::Builder is good!
```

### Class method - `String.build`

```ruby
require 'string/builder'

class Logger
  using String::Builder
  %i[error success info warning].each do |severity|
    define_method(severity) do |message|
      time = Time.now.strftime("[%H:%M:%Ss]")
      String.build time do |s|
        s << " (#{__FILE__})"
        s << " #{severity.to_s.upcase} » #{message}"
        s.gsub!('?','!')
      end
    end
  end
end
```

### Instance method - `String#build`

The class shown above can use the `String#build` instance method to achieve the same functionality.

```ruby
require 'string/builder'

class Logger
  using String::Builder
  %i[error success info warning].each do |severity|
    define_method(severity) do |message|
      time = Time.now.strftime("[%H:%M:%Ss]")
      time.build do |s|
        s << " (#{__FILE__})"
        s << " #{severity.to_s.upcase} » #{message}"
        s.gsub!('?','!')
      end
    end
  end
end
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'string-builder'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install string-builder

## Usage

This extension is in the form of a `refinement`. This means that you will have to call the following `using` directive within the scope that you want the `String` class to be extended with `String::Builder` methods:

```ruby
require 'string/builder'
using String::Builder
```

Though you should typically avoid doing this in the global scope (unless you really need to), and instead only use the extension where you need it - inside your specific modules or classes:

```ruby
require 'string/builder'

class A
  using String::Builder
  # CAN use String::Builder methods in this class
end

module B
  # CANNOT use String::Builder methods in this module
end

# CANNOT use String::Builder methods in the global scope
```

## Further information

For more information about string-building in Ruby and Crystal, [read this blog post](https://www.eonuonga.com/posts/2018/06/07/limitations-of-string-building).