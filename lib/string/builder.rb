module String::Builder
  refine String.singleton_class do
    def build(obj = String.new)
      return obj.to_s unless block_given?
      yield builder = self.new
      obj.dup.to_s << builder
    end
    def respond_to?(symbol, include_all = false)
      self.methods(false).dup.<<(:build).include?(symbol)
    end
  end
end