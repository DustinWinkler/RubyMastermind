CODE_POSSIBILITIES = ['blue', 'red', 'green', 'yellow', 'white', 'purple']
CODEREGEXP = Regexp.union(CODE_POSSIBILITIES)
module Answer
  def check_answer(guess, code)
      if guess == code
        puts "correct"
      end
      correct_colors = code.split.intersection(guess.split).length
      spaces_correct = 0
      if code.split[0] == guess.split[0] then spaces_correct += 1 end
      if code.split[1] == guess.split[1] then spaces_correct += 1 end
      if code.split[2] == guess.split[2] then spaces_correct += 1 end
      if code.split[3] == guess.split[3] then spaces_correct += 1 end
      puts "#{correct_colors} colors are correct"
      puts "#{spaces_correct} of those colors were in the correct place"
  end
end
class Game
  @@blue = "\e[44m    \e[0m"
  @@red = "\e[41m    \e[0m"
  @@green = "\e[42m    \e[0m"
  @@yellow = "\e[103m    \e[0m"
  @@white = "\e[107m    \e[0m"
  @@purple = "\e[45m    \e[0m"
  # Initialize with turn count 0 and code stored
  attr_accessor :turns
  def initialize
    @turns = 1

  end

  def self.check(choice)
    if choice.split.length != 4
      false
    elsif choice.split.all? {|color| CODEREGEXP.match?(color)}
      true
    else
      false
    end
  end
  # Method for storing turn count and ending if turn > 12
  def display_input(choice)
    string = ""
    string2 = ""

    choice.split().each do |color|
      if color == 'blue'
        string.concat(@@blue + ' ')
        string2.concat(@@blue + ' ')
      elsif color == 'red'
        string.concat(@@red + ' ')
        string2.concat(@@red + ' ')
      elsif color == 'green'
        string.concat(@@green + ' ')
        string2.concat(@@green + ' ')
      elsif color == 'yellow'
        string.concat(@@yellow + ' ')
        string2.concat(@@yellow + ' ')
      elsif color == 'white'
        string.concat(@@white + ' ')
        string2.concat(@@white + ' ')
      elsif color == 'purple'
        string.concat(@@purple + ' ')
        string2.concat(@@purple + ' ')
      end
    end
    puts string
    puts string2
  end
end

class Player
  include Answer
  attr_accessor :code
  def initialize(code)
    @code = code
  end
end
class Computer
  include Answer
  attr_accessor :code
  def initialize(code)
    @code = code
    @correct_colors = []
  end

  def guess
    x = []
    4.times do
      x.push(CODE_POSSIBILITIES.sample)
    end
    x = x.join(' ')
  end
end

puts "What game type? Choose 1-3"
puts "1) Computer guesses your code"
puts "2) You guess computer's code"
puts "3) You and another player play against each other"
game_type = gets.chomp.to_i
until (1..3).include?(game_type)
  puts "That\'s not a valid option" 
  game_type = gets.chomp.to_i
end
# method for initializing game with game_type

if game_type == 1
  puts "What's your code? (Example: red green blue yellow) Colors are blue, red, green, white, yellow, purple"
  code = gets.chomp
  until Game.check(code)
    puts "Invalid code, try again"
    code = gets.chomp
  end
  player = Player.new(code)
  game = Game.new
  puts "Your code is: \n"
  game.display_input(player.code)
  computer = Computer.new('')
  while game.turns <= 12 
    sleep(3)
    puts "Turn: #{game.turns}"
    puts 'Computer guesses: '
    guess = computer.guess
    puts guess
    game.display_input(guess)
    computer.check_answer(guess, player.code) # Improve computer logic to incorporate correct colors
    if guess == player.code
      puts "Computer guessed your code. You lose."
      break
    end
    game.turns += 1
    sleep(3)
  end
  if game.turns == 13
    "The computer could not guess your code within 12 turns. You win!"
  end
elsif game_type == 2
  game = Game.new
  player = Player.new('')
  computer = Computer.new('')
  computer.code = computer.guess
  puts "The computer has generated it's code."
  while game.turns <= 12 
    puts "#Turn #{game.turns}: What is your guess? Example (red green blue yellow) Colors are blue, red, green, white, yellow, purple"
    guess = gets.chomp
    until Game.check(guess)
      puts "Invalid code, try again"
      guess = gets.chomp
    end
    game.display_input(guess)
    player.check_answer(guess, computer.code)
    if guess == computer.code
      puts "You guessed the computer's code! You win!"
      break
    end
    game.turns += 1
  end  
  if game.turns == 13
    puts "You did not guess the computer's code within 12 turns. You lose! :("
    puts "The computer's code was #{computer.code}"
    game.display_input(computer.code)
  end
elsif game_type == 3
  puts "What is the codemaker's code?"
  code = gets.chomp
  until Game.check(code)
    puts "Invalid code, try again"
    code = gets.chomp
  end
  codemaker = Player.new(code) 
  codebreaker = Player.new('')
  game = Game.new
  while game.turns <= 12
    puts "Turn #{game.turns}: What is the codebreaker's guess? Example (red green blue yellow) Colors are blue, red, green, white, yellow, purple"
    guess = gets.chomp
    until Game.check(guess)
      puts "Invalid code, try again"
      guess = gets.chomp
    end
    game.display_input(guess)
    codebreaker.check_answer(guess, codemaker.code)
    if guess == codemaker.code
      puts "You guessed the codemaker's code! You win!"
      break
    end
    game.turns += 1
  end
  if game.turns == 13
    puts "You did not guess correctly within 12 turns. Codemaker wins!"
  end
end

