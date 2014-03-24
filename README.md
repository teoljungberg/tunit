# Rtest

`rtest` is my take on building a testing framework, it's heavily influenced by
[minitest](https://github.com/seattlerb/minitest).


_NOTE_ This is very unstable and is just a playground for my ideas.

## Credit
Since this is heavily influenced by
[Ryan Davis](https://twitter.com/the_zenspider)' minitest there are a lot of
similarities between the two frameworks.

I wanted to see how much code and effort are needed to build a testing
framework of my own, while looking at the learnings of minitest.

## Usage

I personally _love_ TDD frameworks like minitest, so I tried to mimic their
behaviour and patterns as close as I possibly could. As with minitest, this is
just plain ruby.

```ruby
class BlahTest < Rtest::Test
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
`rtest`

```ruby
class EmptyTest < Rtest::Test
  def test_im_going_to_fail
  end

  def test_so_will_i
    1 + 1 == 2
  end
end
```

## Contributing

1. Fork it ( http://github.com/teoljungberg/rtest/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
