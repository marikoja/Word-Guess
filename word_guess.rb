require "random-word"
require "colorize"

# user guess class will accept and validate user inputs
class UserGuess
  attr_reader :guess
  def initialize
    @guess = gets.chomp.downcase
  end

  def validate_letters (answer)
    until (@guess =~ (/[a-zA-Z]/) && @guess.length == 1) || (@guess.length == answer.length)
      puts "Please enter a single letter of the alphabet or guess a better word"
      @guess = gets.chomp.downcase
    end
  end
end

# answer class generates word and checks if user guess is correct
class Answer
  attr_reader :word, :letters, :length, :correct_array, :wrong_guess, :lives_counter, :blank_array
  def initialize
    @word = RandomWord.adjs(not_shorter_than: 4, not_longer_than: 8).next
    @letters = @word.split(//).uniq
    @length = @word.length
    @correct_array = @word.split(//)
    @blank_array = Array.new(@length, "_")
    @wrong_guess = []
    @lives_counter = @length
  end

# compares guess to answer and updates lives counter
  def compare_to_answer(guess)
    if @letters.include?(guess.guess)
      update_blank_array(guess)
    elsif @word == guess.guess
      @blank_array = @correct_array
    elsif !@wrong_guess.include?(guess.guess)
      @wrong_guess << guess.guess
      @lives_counter -= 1
    else
      puts "You already guessed that. Try again."
    end
  end

# when correct guess is made blank array is updated for display
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

# gameboard class contains and manages all visuals for game
class GameBoard
  attr_reader :lives_counter
  def initialize
    @flower_counter = " ^ "
  end

  def lives_counter_display(answer)
    answer.lives_counter.times do
      print @flower_counter.light_yellow.blink
    end
    puts ""
  end

  def display_stems(answer)
    stem = ""
    answer.length.times do
      stem << " | "
    end
    return stem
  end

  def display_ground(answer)
    ground = ""
    answer.length.times do
      ground << "\#\#\#"
    end
    return ground
  end

# brings together all gameboard pieces and adds color
  def display_gameboard(answer)
    puts ""
    lives_counter_display(answer)
    puts display_stems(answer).green
    puts display_stems(answer).light_green
    puts display_ground(answer).light_cyan
    puts display_ground(answer).light_blue
    puts display_ground(answer).light_cyan
    puts ""
    puts answer.blank_array.join(' ')
    puts ""
    puts "==================================="
    puts "Your incorrect letters: #{answer.wrong_guess.join(', ')}"
    puts ""

  end
end

# starts game and loops until game completion
def word_guess_method
# enables player to begin again
  def play_again
    puts "Type yes to play again or anything else to quit"
    yes_or_no = gets.chomp.downcase
    if yes_or_no == "yes"
      puts "\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
      word_guess_method
    else
      puts "Thanks for playing."
    end
  end
# initializes new word and game board at game start
  answer = Answer.new
  gameboard = GameBoard.new

# FOR TESTING puts "#{answer.word} #{answer.length}"

# main loop reprints board and prompts for new input
  until answer.lives_counter == 0 || answer.blank_array == answer.correct_array ||
    gameboard.display_gameboard(answer)
    print "Please enter your single letter guess: "
    user_guess = UserGuess.new
    user_guess.validate_letters(answer)
    answer.compare_to_answer(user_guess)
    puts "==================================="
  end

# runs on completion of game and prompts for starting over
  if answer.blank_array == answer.correct_array
    gameboard.display_gameboard(answer)
    puts "GREAT JOB! You guessed the right word!"
    puts "Enjoy your cake!"
    puts "==================================="
    play_again
  else
    gameboard.display_gameboard(answer)
    puts "BUMMER!!!"
    puts "The answer was: #{answer.word}"
    puts "Sorry, no cake for you!!"
    puts "==================================="
    play_again
  end
end

# Opening prompt will only run at game start
puts ""
puts "Welcome to Word Guess!"
puts ""
puts "Guess the word one letter at time but choose wisely."
puts "When your candles have all gone out, the game will end."
puts "Guess them all and you can have your cake and eat it too!"
word_guess_method
