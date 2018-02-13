require "awesome_print"
class UserGuess
  def initialize
    @guess = gets.chomp.downcase
  end

  attr_accessor :guess, :correct_guess, :wrong_guess

  def validate_letters
    until @guess =~ (/[a-zA-Z]/) && @guess.length == 1
      puts "Please enter a single letter of the alphabet"
      @guess = gets.chomp.downcase
    end
  end

  def compare_to_answer(answer_word)
    @correct_guess = []
    @wrong_guess = []
    if answer_word.word.include?(@guess)
      @correct_guess << @guess
    else
      @wrong_guess << @guess
    end
  end

end

class Answer
  attr_accessor :word, :letters, :length
  def initialize
    words = ["testing"]
    @word = words.sample
    @letters = @word.split(//).uniq
    @length = @word.length
  end
end

test = UserGuess.new
puts test.validate_letters

puts test.guess
puts test.compare_to_answer(Answer.new)
ap test.wrong_guess, color: {string: :cyanish}
