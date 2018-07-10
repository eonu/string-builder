module String::Builder

  refine String.singleton_class do
    def [](*objs) objs.map(&:to_s)*self.new end

    def build(*objs)
      content = self.[](*objs)
      return content unless block_given?
      yield builder = self.new
      content << builder
    end

    def respond_to?(id, private = false)
      %i[[] build].include?(id.to_sym) ? true : super
    end
  end

  refine String do
    def build(*objs)
      content = String[*objs]
      return self.dup << content unless block_given?
      yield builder = String.new
      self.dup << content << builder
    end

    def build!(*objs)
      content = String[*objs]
      return self << content unless block_given?
      yield builder = String.new
      self << content << builder
    end

    def respond_to?(id, private = false)
      %i[build build!].include?(id.to_sym) ? true : super
    end
  end

end