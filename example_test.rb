$:<< File.join(File.dirname(__FILE__), 'lib')
require 'rtest/autorun'

class ExampleTest < Rtest::Test
  def test_pass
    assert 2.even?
  end

  def test_pass_one_more
    assert_includes [1, 2], 2
  end

  def test_empty
  end

  def test_skip
    skip
  end

  def test_skip_with_message
    skip 'here!'
  end
end
