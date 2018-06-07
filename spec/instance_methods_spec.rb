require_relative 'spec_helper'
describe "#{String::Builder} instance methods" do
  describe 'without refinement usage' do

    it 'String#build should not exist' do
      expect(String.new.respond_to? :build).to be(false)
    end

    it 'String#build! should not exist' do
      expect(String.new.respond_to? :build!).to be(false)
    end

  end

  describe 'with refinement usage' do
    using String::Builder

    it 'String#build should exist' do
      expect(String.new.respond_to? :build).to be(true)
    end

    it 'String#build! should exist' do
      expect(String.new.respond_to? :build!).to be(true)
    end

    describe 'String#build' do

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

      it "block argument reassignment shouldn't mutate the result" do
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

    describe 'String#build!' do

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
  end
end