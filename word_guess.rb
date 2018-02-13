require "awesome_print"
class UserGuess
  attr_reader :guess
  def initialize
    @guess = gets.chomp.downcase
  end

  def validate_letters
    until @guess =~ (/[a-zA-Z]/) && @guess.length == 1
      puts "Please enter a single letter of the alphabet"
      @guess = gets.chomp.downcase
    end
  end

  # def compare_to_answer(answer_word)
  #   @correct_guess = []
  #   @wrong_guess = []
  #   if answer_word.word.include?(@guess)
  #     @correct_guess << @guess
  #   else
  #     @wrong_guess << @guess
  #   end
  # end

end

class Answer
  attr_reader :word, :letters, :length, :correct_guess, :wrong_guess, :lives_counter
  def initialize
    words = ["testing"]
    @word = words.sample
    @letters = @word.split(//).uniq
    @length = @word.length
    @correct_guess = []
    @wrong_guess = []
    @lives_counter = 6
  end

  def correct_array
    @correct_array = Array.new(@word.length, "_")
  end

  def compare_to_answer(guess)
    if @letters.include?(guess.guess)
      @correct_guess << guess.guess
    else
      @wrong_guess << guess.guess
      @lives_counter -= 1
    end
  end

end

class GameBoard
  attr_reader :lives_counter
  def initialize
    @main_image = display_main_image
    # @lives_counter = 4
    @flower_counter =" @ "
  end

  # def losing_lives(answer)
  #   @lives_counter  (answer.wrong_guess).length
  # end

  def lives_counter_display(answer)
    answer.lives_counter.times do
      print @flower_counter
    end
  end

  def display_gameboard(answer)
    lives_counter_display(answer)
    puts @main_image
    print answer.correct_array
    puts ""
    puts answer.wrong_guess
    puts ""
    # print guess.wrong_guess
  end

  def display_main_image
    return "\n |  |  |  | \n |  |  |  | \n============"
  end


end

# puts test.validate_letters

# puts test.guess
# puts test.compare_to_answer(Answer.new)
# ap test.wrong_guess, color: {string: :cyanish}

def word_guess_method
  answer = Answer.new
  puts answer.letters
  gameboard = GameBoard.new
  gameboard.display_gameboard(answer)
  print "Please enter your single letter guess: "
  user_guess = UserGuess.new
  user_guess.validate_letters
  answer.compare_to_answer(user_guess)
  # gameboard.losing_lives(answer)
  while answer.lives_counter > 0
    gameboard.display_gameboard(answer)
    print "Please enter your single letter guess: "
    user_guess = UserGuess.new
    answer.compare_to_answer(user_guess)
    # gameboard.losing_lives(answer)
  end
  puts "Bummer! you suck."
end

word_guess_method
