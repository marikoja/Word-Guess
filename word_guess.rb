require "random-word"
class UserGuess
  attr_reader :guess
  def initialize
    @guess = gets.chomp.downcase
  end

  def validate_letters (answer)
    until (@guess =~ (/[a-zA-Z]/) && @guess.length == 1) || (@guess.length == answer.length)
      puts "Please enter a single letter of the alphabet"
      @guess = gets.chomp.downcase
    end
  end
end

class Answer
  attr_reader :word, :letters, :length, :correct_array, :wrong_guess, :lives_counter, :blank_array
  def initialize
    @word = RandomWord.adjs.next
    @letters = @word.split(//).uniq
    @length = @word.length
    @correct_array = @word.split(//)
    @blank_array = Array.new(@length, "_")
    @wrong_guess = []
    @lives_counter = @length
  end

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
    @flower_counter =" @ "
  end

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
      print "\#\#\#"
    end
    puts ""
  end

  def display_gameboard(answer)
    puts ""
    lives_counter_display(answer)
    display_stems(answer)
    display_stems(answer)
    display_ground(answer)
    display_ground(answer)
    puts ""
    puts answer.blank_array.join(' ')
    puts ""
    puts "Your incorrect guesses include: #{answer.wrong_guess.join(', ')}"
    puts "==================================="

  end

end


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
      puts "\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
      word_guess_method
    else
      puts "Thanks for playing."
    end
  end
  answer = Answer.new
  # puts "#{answer.word} (118)"
  gameboard = GameBoard.new

  until answer.lives_counter == 0 || answer.blank_array == answer.correct_array ||
    gameboard.display_gameboard(answer)
    print "Please enter your single letter guess: "
    user_guess = UserGuess.new
    user_guess.validate_letters(answer)
    answer.compare_to_answer(user_guess)
    puts "==================================="
    run_once = true
  end

  if answer.blank_array == answer.correct_array
    gameboard.display_gameboard(answer)
    puts "GREAT JOB! You guessed the right word!"
    puts "==================================="
    play_again
  else
    gameboard.display_gameboard(answer)
    puts "BUMMER! Better luck next time!"
    puts "==================================="
    play_again
  end
end

word_guess_method
