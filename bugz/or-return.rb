module Some
  def self.start v
    puts "exit now" or return unless "nothing" and f(v)
    puts "I'm not dead yet"
  end
  class << self
    private
    def f(v)
   	 return v
    end
  end
end

Some.start true
Some.start false
