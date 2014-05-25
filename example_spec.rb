$:<< File.join(File.dirname(__FILE__), 'lib')
require 'tunit/autorun'

Example = Class.new

describe Example do
  let(:number) { 2 }

  describe 'passing tests' do
    it 'even' do
      assert number.even?
    end

    it 'passed once more' do
      assert_includes [1, 2], number
    end
  end

  describe 'failing tests' do
    it 'fails on empty tests' do
    end

    it 'fails hard' do
      refute number.even?
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
