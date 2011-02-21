class String
  def unindent
    arr = respond_to?(:lines) ? lines : self
    min = arr.map {|line| line =~ /^(\s*)\S/; $1 && $1.length }.compact.min
    arr.map {|line| line.sub(/^\s{#{min}}/, '')}.join
  end
end

class ConfigObj
  def initialize(data = {})
    @data = {}
    update!(data)
  end

  def update!(data)
    data.each {|key, value| self[key.downcase] = value}
  end

  def [](key)
    @data[key.downcase.to_sym]
  end

  def []=(key, value)
    @data[key.downcase.to_sym] = if value.class == Hash
      self.class.new(value)
    else
      value
    end
  end

  def to_hash
    @data
  end

  def method_missing(name, *args)
    if name.to_s =~ /(.+)=$/
      self[$1] = args.first
    else
      self[name]
    end
  end

  def respond_to?(name)
    @data.has_key?(name)
  end
end