module String::Builder
  refine String.singleton_class do
    def build(obj = String.new)
      if block_given?
        yield builder = self.new
        obj.dup.to_s << builder
      else
        obj.to_s
      end
    end
    def respond_to?(symbol, include_all=false)
      ((list = self.methods(false).dup) << :build).include? symbol
    end
  end
end