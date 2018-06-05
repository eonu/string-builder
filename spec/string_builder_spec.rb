describe String::Builder do
  describe 'without refinement usage' do

    it 'String.build should not exist' do
      expect(String.respond_to? :build).to be(false)
    end

  end

  describe 'with refinement usage' do
    using String::Builder

    it 'String.build should exist' do
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
          result = String.build ?c do |s|
            s.gsub!('',?a)
            s.upcase!
            s << ?b
          end
          expect(result).to eq('cAb')
        end

        it "non-mutating String instance methods shouldn't mutate the result" do
          result = String.build ?c do |s|
            s.gsub('',?a)
            s.upcase
            s.+(?b)
          end
          expect(result).to eq(?c)
        end

        it "block argument reassignment shouldn't mutate the result" do
          result = String.build ?c do |s|
            s.gsub!('',?a)
            s.upcase!
            s << ?b
            s = ''
          end
          expect(result).to eq('cAb')
        end

      end

      context 'where obj is not a string' do

        it "mutating String instance methods should mutate the result" do
          result = String.build 3 do |s|
            s.gsub!('',?a)
            s.upcase!
            s << ?b
          end
          expect(result).to eq('3Ab')
        end

        it "non-mutating String instance methods shouldn't mutate the result" do
          result = String.build 3 do |s|
            s.gsub('',?a)
            s.upcase
            s.+(?b)
          end
          expect(result).to eq(?3)
        end

        it "block argument reassignment shouldn't mutate the result" do
          result = String.build 3 do |s|
            s.gsub!('',?a)
            s.upcase!
            s << ?b
            s = ''
          end
          expect(result).to eq('3Ab')
        end

      end
    end
  end
end
