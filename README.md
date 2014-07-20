# Tunit
[![Build Status](https://travis-ci.org/teoljungberg/tunit.svg?branch=master)](https://travis-ci.org/teoljungberg/tunitunit)

`tunit` is my take on building a testing framework, it's heavily influenced by
[minitest](https://github.com/seattlerb/minitest).


_NOTE_ This is very unstable and is just a playground for my ideas.

## Credit
Since this is heavily influenced by
[Ryan Davis](https://twitter.com/the_zenspider)' minitest there are a lot of
similarities between the two frameworks.

I wanted to see how much code and effort are needed to build a testing
framework of my own, while looking at the learnings of minitest.

## Usage
### Unit

I personally _love_ TDD frameworks like minitest, so I tried to mimic their
behaviour and patterns as close as I possibly could. As with minitest, this is
just plain ruby.

```ruby
class BlahTest < Tunit::Test
  def setup
    self.blah = Blah.new
  end
  attr_accessor :blah

  def test_the_answer_to_everything
    assert_equal 42, blah.the_ultimate_answer
  end

  def test_packing_list
    assert_includes blah.packing_list, "towel"
  end

  def test_that_will_be_skipped
    skip "test this later"
  end
end
```

What's important to me is that `BlahTest` is just a simple subclass, and
`test_the_answer_to_everything` is a simple method. Assertions and
lazily-loaded variables are just methods, everything is just a simple method
definition away.

I'm a strong believer in that you should only mock and stub things so you can
assert on something else. That's why a `test`-method must have assertions in
`tunit`

```ruby
class EmptyTest < Tunit::Test
  def test_im_going_to_be_skipped
  end

  def test_so_will_i
    1 + 1 == 2
  end
end
```

### Spec
There is also a small Spec DSL that follows along with tunit

```ruby
require 'tunit/autorun'

Example = Class.new

describe Example do
  let(:awesome) { "bacon" }

  describe 'passing tests' do
    it 'is very much even' do
      expect(2.even?).to eq true
    end

    it 'approves of this' do
      expect(awesome).to eq "bacon"
    end

    it 'passed once more' do
      expect([1,2]).to include 2
    end
  end

  describe 'failing tests' do
    it 'fails hard' do
      expect(1.even?).to eq false
    end
  end

  describe 'skipps' do
    it 'skippedy skip' do
      skip
    end

    it 'skips empty tests' do
    end

    it 'skips with a message' do
      skip 'here!'
    end
  end
end
```

That's it, just `it` and `describe` blocks. I sprinkled some `let`'s for a
nicer format

## Expecations, and not only assertions
The expectations maps 1-to-1 with the assertions

### Assertions
```ruby
expect(2).to eq 2
# =>
assert_equal 2, 2
```

```ruby
expect([1,2]).to include 1
# =>
assert_includes [1, 2], 1
```

```ruby
expect(Class).to respond_to :new
# =>
assert_responds_to Class, :new
```

```ruby
expect("foo").to match /oo/
# =>
assert_match /oo/, "foo"
```

### Refutions
```ruby
expect(2).to not_eq 2
# =>
refute_equal 2, 2
```

```ruby
expect([1,2]).to not_include 1
# =>
refute_includes [1, 2], 1
```

```ruby
expect(Class).to not_respond_to :new
# =>
refute_responds_to Class, :new
```

```ruby
expect("foo").to not_match /oo/
# =>
refute_match /oo/, "foo"
```

## Contributing

1. Fork it ( http://github.com/teoljungberg/tunit/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
