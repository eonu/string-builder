require_relative 'spec_helper'
describe "#{String::Builder} class methods" do
  describe 'without refinement usage' do

    context 'String.build' do
      it 'should not exist' do
        expect(String.respond_to? :build).to be(false)
      end
    end

    context 'String.[]' do
      it 'should not exist' do
        expect(String.respond_to? :[]).to be(false)
      end
    end

  end

  using String::Builder

  describe 'with refinement usage' do

    context 'String.build' do
      it 'should exist' do
        expect(String.respond_to? :build).to be(true)
      end
    end

    context 'String.[]' do
      it 'should exist' do
        expect(String.respond_to? :[]).to be(true)
      end
    end

  end

  describe "String.build" do

    context 'with no arguments given' do
      it 'should generate a new (empty) string' do
        expect(String.build).to eq(String.new)
      end
    end

    context 'with object argument given' do
      it "should not mutate a variable" do
        result = ?a
        v = String.build result
        v = ?b
        expect(result).to eq(?a)
      end

      it 'should concatenate string objects' do
        expect(String.build *%w[a b c d e]).to eq('abcde')
      end

      it 'should concatenate non-string objects' do
        expect(String.build *[0, 1, :"2", 3, 4r]).to eq('01234/1')
      end
    end

    context 'with block argument given' do
      it "mutating String instance methods should mutate the result" do
        result = String.build do |s|
          s.gsub!('',?a)
          s.upcase!
          s << ?b
        end
        expect(result).to eq('Ab')
      end

      it "non-mutating String instance methods shouldn't mutate the result" do
        result = String.build do |s|
          s.gsub('',?a)
          s.upcase
          s.+(?b)
        end
        expect(result).to eq(String.new)
      end

      it "builder string reassignment shouldn't mutate the result" do
        result = String.build do |s|
          s.gsub!('',?a)
          s.upcase!
          s << ?b
          s = ''
        end
        expect(result).to eq('Ab')
      end
    end

    context 'with object and block arguments given' do
      it "mutating String instance methods should mutate the result" do
        result = String.build *[3, 5, 7] do |s|
          s.gsub!(?3,?b)
          s << ?c
          s.gsub!(?c,?b)
          s.upcase!
          s << ?b
        end
        expect(result).to eq('357Bb')
      end

      it "non-mutating String instance methods shouldn't mutate the result" do
        result = String.build *[3, 5, 7] do |s|
          s.gsub(?3,?b)
          s << ?c
          s.gsub(?c,?b)
          s.upcase
          s.+(?b)
        end
        expect(result).to eq('357c')
      end

      it "builder string reassignment shouldn't mutate the result" do
        result = String.build *[3, 5, 7] do |s|
          s.gsub!(?a,?b)
          s << ?c
          s.gsub!(?c,?b)
          s.upcase!
          s << ?b
          s = ''
        end
        expect(result).to eq('357Bb')
      end
    end

  end

  describe "String.[]" do

    context 'with no arguments given' do
      it 'should generate a new (empty) string' do
        expect(String[]).to eq(String.new)
      end
    end

    context 'with arguments given' do

      it 'should convert non-string arguments to strings' do
        expect(String[1,2,3]).to eq('123')
        expect(String[[1,2,3],:test]).to eq("[1, 2, 3]test")
      end

      it 'should join strings' do
        expect(String['a','b','c']).to eq('abc')
      end

      it 'should work with splats' do
        expect(String[*%i[a b c]]).to eq('abc')
      end

    end

  end
end