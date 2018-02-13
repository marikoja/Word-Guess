require "random-word"
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
  attr_reader :word, :letters, :length, :correct_array, :wrong_guess, :lives_counter, :blank_array
  def initialize
    # words = ["testing"]
    # @word = words.sample
    @word = RandomWord.adjs.next
    @letters = @word.split(//).uniq
    @length = @word.length
    @correct_array = @word.split(//)
    @blank_array = Array.new(@length, "__")
    # @correct_guess = []
    @wrong_guess = []
    @lives_counter = @length
  end

  def compare_to_answer(guess)
    if @letters.include?(guess.guess)
      # @correct_guess << guess.guess
      update_blank_array(guess)
    else
      @wrong_guess << guess.guess
      @lives_counter -= 1
    end
  end

  def update_blank_array(guess)
    i = 0
    @correct_array.each do |correct_letter|
      if correct_letter.include?(guess.guess)
        @blank_array[i] = correct_letter
      end
      i += 1
    end
  end

end

class GameBoard
  attr_reader :lives_counter
  def initialize
    # @main_image = display_main_image
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
    puts ""
  end

  def display_stems(answer)
    answer.length.times do
      print " | "
    end
    puts ""
  end

  def display_ground(answer)
    answer.length.times do
      print "==="
    end
    puts ""
  end

  def display_gameboard(answer)
    lives_counter_display(answer)
    display_stems(answer)
    display_stems(answer)
    display_ground(answer)
    puts answer.blank_array.join(' ')
    puts "Your incorrect guesses include: #{answer.wrong_guess.join(', ')}"

  end

end

# puts test.validate_letters

# puts test.guess
# puts test.compare_to_answer(Answer.new)
# ap test.wrong_guess, color: {string: :cyanish}

run_once = false
if !run_once
  puts "Welcome to Word Guess!"
  puts "Guess the word one letter at time but choose wisely."
  puts "When your flowers are gone, you lose!"
  puts "Guess them all and smell the virtual roses."
end

def word_guess_method
  def play_again
    puts "Would you like to play again?"
    yes_or_no = gets.chomp.downcase
    if yes_or_no == "yes"
      word_guess_method
    else
      puts "Thanks for playing."
    end
  end
  answer = Answer.new
  puts answer.word
  gameboard = GameBoard.new

  until answer.lives_counter == 0 || answer.blank_array == answer.correct_array
    gameboard.display_gameboard(answer)
    print "Please enter your single letter guess: "
    user_guess = UserGuess.new
    user_guess.validate_letters
    answer.compare_to_answer(user_guess)
    run_once = true
  end

  if answer.blank_array == answer.correct_array
    puts "GREAT JOB! You guessed the right word!"
    gameboard.display_gameboard(answer)
    play_again
  else
    puts "BUMMER! Better luck next time!"
    gameboard.display_gameboard(answer)
    play_again
  end
end

word_guess_method
