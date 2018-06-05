[![Build Status](https://travis-ci.org/eonu/string-builder.svg?branch=master)](https://travis-ci.org/eonu/string-builder)
![Gem](https://img.shields.io/gem/v/string-builder.svg)
[![License](https://img.shields.io/github/license/eonu/string-builder.svg)](https://github.com/eonu/string-builder/blob/master/LICENSE)

# String::Builder

Modified port of the [String::Builder IO initializer](https://crystal-lang.org/api/0.20.3/String/Builder.html#build%28capacity%3AInt%3D64%2C%26block%29%3AString-class-method) for the String class of the Crystal programming language.

## Limitations of string building in Ruby and Crystal

The [String::Builder](https://crystal-lang.org/api/0.20.3/String/Builder.html) class of the Crystal programming language provides an initializer method for the `String` class called `build` which is essentially an optimized version of Ruby's `StringIO`.

Ruby's `StringIO` and Crystal's `String::Builder` are great because it essentially turns strings into IO objects, allowing you to pass a block into the constructor (yielding `self`) which leads to nice chaining such as:

```ruby
# Ruby - StringIO
test = StringIO.open do |s|
  s << 'Hello '
  s << 'World!'
  s.string
end
#=> "Hello World!"
```

Note the necessary `StringIO#string` method call. Since we are yielding a `StringIO` object, we must convert it to a `String` at the end. This is a bit cleaner in Crystal:

```ruby
# Crystal - String::Builder
test = String.build do |s|
  s << "Hello "
  s << "World!"
end
#=> "Hello World!"
```

---

However, since neither of these two implementations yield a `String` object, you can't use `String` methods to mutate the object:

```ruby
# Ruby - StringIO
test = StringIO.open do |s|
  s << 'Hello '
  s << 'World!'
  s.upcase!
  s.string
end
#=> ... undefined method `upcase!' for #<StringIO:0x00007fe0bc09d810> (NoMethodError)
```

```ruby
# Crystal - String::Builder
test = String.build do |s|
  s << "Hello "
  s << "World!"
  s.gsub!("!", "?")
end
#=> ... undefined method 'gsub!' for String::Builder
```

**That's where this gem comes in!**

## Example

This example shows how to make a simple logger by constructing log messages with `String::Builder`.

> **NOTE**:
> - You can pass an optional argument before the block, specifying what the starting string (or any object that has a working `to_s` method) should be.
> - Since the block `yield`s a `String` object, `String::Builder` allows you to mutate the string itself as seen in this example with the `String#gsub!` method.

```ruby
class Logger
  using String::Builder
  %i[error success info warning].each do |severity|
    define_method(severity) do |message|
      String.build Time.now.strftime("[%H:%M:%Ss] ") do |s|
        s << "(#{__FILE__}) "
        s << "#{severity.to_s.upcase} » #{message}"
        s.gsub! '?', '!'
      end
    end
  end
end

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

This monkey-patch is in the form of a `refinement`. This means that you will have to call the following `using` directive within the scope that you want the `String.build` class method to be monkey-patched into the `String` class:

```ruby
require 'string/builder'
using String::Builder
```

Though you should typically avoid doing this in the global scope (unless you really need to), and instead only use the monkey-patch where you need it - inside your specific modules or classes:

```ruby
require 'string/builder'

class A
  using String::Builder
  # CAN use String.build in this class
end

module B
  # CANNOT use String.build in this module
end

# CANNOT use String.build in the global scope
```