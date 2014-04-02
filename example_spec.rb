$:<< File.join(File.dirname(__FILE__), 'lib')
require 'rtest/autorun'

Example = Class.new

describe Example do
  describe 'passing tests' do
    it 'even' do
      assert 2.even?
    end

    it 'passed once more' do
      assert_includes [1, 2], 2
    end
  end

  describe 'failing tests' do
    it 'fails on empty tests' do
    end

    it 'fails hard' do
      refute 2.even?
    end
  end

  describe 'skipps' do
    it 'skippedy skip' do
      skip
    end

    it 'skips with a message' do
      skip 'here!'
    end
  end
end
