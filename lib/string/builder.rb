module String::Builder
  refine String.singleton_class do

    def build(obj = String.new)
      return obj.to_s unless block_given?
      yield builder = self.new
      obj.dup.to_s << builder
    end

    def respond_to?(id, private = false)
      id.to_sym == :build ? true : super
    end

  end
  refine String do

    def build
      yield builder = String.new
      self.dup << builder
    end

    def build!
      yield builder = String.new
      self << builder
    end

    def respond_to?(id, private = false)
      %i[build build!].include?(id.to_sym) ? true : super
    end

  end
end