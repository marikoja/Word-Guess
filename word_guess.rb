
class UserGuess
  def initialize
    @guess = gets.chomp.downcase
  end

  attr_accessor :guess

  def validate_letters
    until @guess =~ (/[a-zA-Z]/) && @guess.length == 1
      puts "Please enter a single letter of the alphabet"
      @guess = gets.chomp.downcase
    end
  end

end

test = UserGuess.new
puts test.validate_letters

puts test.guess
