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

  def correct_array
    @correct_array = Array.new(@word.length, "_")
  end
end

class GameBoard
  attr_accessor :lives_counter
  def initialize
    @main_image = "some main image that doesn't change"
    @lives_counter = 4
  end

  def losing_lives(guess)
    @lives_counter = @lives_counter - (guess.wrong_guess).length
  end

  def lives_counter_display
    @lives_counter.times do
      print "some image"
    end
  end

  def starting_display(answer)
    lives_counter_display
    puts @main_image
    print answer.correct_array
    puts ""
  end

  def display_gameboard(answer, guess)
    puts "some image counter"
    puts @main_image
    print answer.correct_array
    puts ""
    print guess.wrong_guess
  end
end

# puts test.validate_letters

# puts test.guess
# puts test.compare_to_answer(Answer.new)
# ap test.wrong_guess, color: {string: :cyanish}

def word_guess_method
  answer = Answer.new
  gameboard = GameBoard.new
  gameboard.starting_display(answer)
  print "Please enter your single letter guess:"
  user_guess = UserGuess.new
  user_guess.compare_to_answer(answer)
  gameboard.losing_lives(user_guess)
  while gameboard.lives_counter > 0
    gameboard.display_gameboard(answer, user_guess)
    print "Please enter your single letter guess:"
    user_guess = UserGuess.new
    user_guess.compare_to_answer(answer)
    gameboard.losing_lives(user_guess)
  end
end


word_guess_method
