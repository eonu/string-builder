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

  describe 'with refinement usage' do
    using String::Builder

    describe "String.build" do

      it 'should exist' do
        expect(String.respond_to? :build).to be(true)
      end

      context 'with no arguments given' do
        it 'should generate a new (empty) string' do
          expect(String.build).to eq(String.new)
        end
      end

      context 'with only object argument given' do
        context 'should generate a new string equal to obj.to_s' do

          it 'when given a string' do
            expect(String.build ?-).to eq(?-)
          end

          it 'when given a non-string object' do
            expect(String.build 3).to eq(?3)
          end

        end

        it "should not mutate a variable" do
          result = ?a
          v = String.build result
          v = ?b
          expect(result).to eq(?a)
        end

      end

      context 'with only block argument given' do

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

        it "block argument reassignment shouldn't mutate the result" do
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
        context 'where obj is a string' do

          it "mutating String instance methods should mutate the result" do
            result = String.build ?a do |s|
              s.gsub!(?a,?b)
              s << ?c
              s.gsub!(?c,?b)
              s.upcase!
              s << ?b
            end
            expect(result).to eq('aBb')
          end

          it "non-mutating String instance methods shouldn't mutate the result" do
            result = String.build ?a do |s|
              s.gsub(?a,?b)
              s << ?c
              s.gsub(?c,?b)
              s.upcase
              s.+(?b)
            end
            expect(result).to eq('ac')
          end

          it "block argument reassignment shouldn't mutate the result" do
            result = String.build ?a do |s|
              s.gsub!(?a,?b)
              s << ?c
              s.gsub!(?c,?b)
              s.upcase!
              s << ?b
              s = ''
            end
            expect(result).to eq('aBb')
          end

          it "should not mutate a variable" do
            result = ?a
            String.build result do |s|
              s << ?b
              s.gsub!(?b,?c)
            end
            expect(result).to eq(?a)
          end

        end

        context 'where obj is not a string' do

          it "mutating String instance methods should mutate the result" do
            result = String.build 3 do |s|
              s.gsub!(?3,?b)
              s << ?c
              s.gsub!(?c,?b)
              s.upcase!
              s << ?b
            end
            expect(result).to eq('3Bb')
          end

          it "non-mutating String instance methods shouldn't mutate the result" do
            result = String.build 3 do |s|
              s.gsub(?3,?b)
              s << ?c
              s.gsub(?c,?b)
              s.upcase
              s.+(?b)
            end
            expect(result).to eq('3c')
          end

          it "block argument reassignment shouldn't mutate the result" do
            result = String.build 3 do |s|
              s.gsub!(?a,?b)
              s << ?c
              s.gsub!(?c,?b)
              s.upcase!
              s << ?b
              s = ''
            end
            expect(result).to eq('3Bb')
          end

        end
      end

    end

    describe "String.[]" do

      it 'should exist' do
        expect(String.respond_to? :[]).to be(true)
      end

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
end