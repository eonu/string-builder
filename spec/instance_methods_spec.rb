require_relative 'spec_helper'
describe "#{String::Builder} instance methods" do
  describe 'without refinement usage' do

    context 'String#build' do
      it 'should not exist' do
        expect(String.new.respond_to? :build).to be(false)
      end
    end

    context 'String#build!' do
      it 'should not exist' do
        expect(String.new.respond_to? :build!).to be(false)
      end
    end

  end

  using String::Builder

  describe 'with refinement usage' do

    context 'String#build' do
      it 'should exist' do
        expect(String.new.respond_to? :build).to be(true)
      end
    end

    context 'String#build!' do
      it 'should exist' do
        expect(String.new.respond_to? :build!).to be(true)
      end
    end

  end

  describe 'String#build' do

    context 'with no arguments given' do
      it 'should return itself' do
        result = ?a.build
        expect(result).to eq(result)
      end
    end

    context 'with object argument given' do
      it "should not mutate a variable" do
        result = ?a
        v = String.new.build result
        v = ?b
        expect(result).to eq(?a)
      end

      it 'should concatenate string objects' do
        expect(?a.build *%w[b c d e]).to eq('abcde')
      end

      it 'should concatenate non-string objects' do
        expect(?0.build *[1, :"2", 3, 4r]).to eq('01234/1')
      end
    end

    context 'with block argument given' do
      it "mutating String instance methods should mutate the result" do
        result = ?a.build do |s|
          s.gsub!(?a,?b)
          s << ?c
          s.gsub!(?c,?b)
          s.upcase!
          s << ?b
        end
        expect(result).to eq('aBb')
      end

      it "non-mutating String instance methods shouldn't mutate the result" do
        result = ?a.build do |s|
          s.gsub(?a,?b)
          s << ?c
          s.gsub(?c,?b)
          s.upcase
          s.+(?b)
        end
        expect(result).to eq('ac')
      end

      it "builder string reassignment shouldn't mutate the result" do
        result = ?a.build do |s|
          s.gsub!(?a,?b)
          s << ?c
          s.gsub!(?c,?b)
          s.upcase!
          s << ?b
          s = ''
        end
        expect(result).to eq('aBb')
      end
    end

    context 'with object and block arguments given' do
      it 'should concatenate objects and append the builder string' do
        result = String.new.build(*%w[a b c]) do |s|
          s << ?q
          s << ?e
          s.gsub!(?q,?d)
        end
        expect(result).to eq('abcde')
      end
    end

  end

  describe 'String#build!' do

    context 'with no arguments given' do
      it 'should return itself' do
        result = ?a
        result.build!
        expect(result).to eq(?a)
      end
    end

    context 'with object argument given' do
      it 'should concatenate string objects' do
        result = ?a
        result.build!(*%w[b c d e])
        expect(result).to eq('abcde')
      end

      it 'should concatenate non-string objects' do
        result = ?0
        result.build!(*[1, :"2", 3, 4r])
        expect(result).to eq('01234/1')
      end
    end

    context 'with block argument given' do
      it "mutating String instance methods should mutate the result" do
        result = ?a
        result.build! do |s|
          s.gsub!(?a,?b)
          s << ?c
          s.gsub!(?c,?b)
          s.upcase!
          s << ?b
        end
        expect(result).to eq('aBb')
      end

      it "non-mutating String instance methods shouldn't mutate the result" do
        result = ?a
        result.build! do |s|
          s.gsub(?a,?b)
          s << ?c
          s.gsub(?c,?b)
          s.upcase
          s.+(?b)
        end
        expect(result).to eq('ac')
      end

      it "block argument reassignment shouldn't mutate the result" do
        result = ?a
        result.build! do |s|
          s.gsub!(?a,?b)
          s << ?c
          s.gsub!(?c,?b)
          s.upcase!
          s << ?b
          s = ''
        end
        expect(result).to eq('aBb')
      end
    end

    context 'with object and block arguments given' do
      it 'should concatenate objects and append the builder string' do
        result = ?a
        result.build!(*%w[b c]) do |s|
          s << ?q
          s << ?e
          s.gsub!(?q,?d)
        end
        expect(result).to eq('abcde')
      end
    end

  end
end