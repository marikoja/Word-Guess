require "random-word"
require "colorize"


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

class Answer
  attr_reader :word, :letters, :length, :correct_array, :wrong_guess, :lives_counter, :blank_array
  def initialize
    @word = RandomWord.adjs(not_shorter_than: 4, not_longer_than: 10).next
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
  puts "#{answer.word} #{answer.length}(118)"
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
