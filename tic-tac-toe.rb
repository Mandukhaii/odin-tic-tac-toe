class Player
  
  attr_accessor :name, :option

  def initialize(name, option)
    @name = name
    @option = option
  end

end

class Board

  attr_accessor :board, :players

  def initialize(players)
    #draw board
    @board = Array.new(3) {Array.new(3, "-")}
    @players = players
    @curr_player = 0
  end

  def display_board()
    #display as 3x3
    @board.each do |row|
      puts row.join(" ")
    end
  end

  def make_move(row, col)
    if @board[row][col] == "-"
      @board[row][col] = @players[@curr_player].option
    else
      puts "Cell occupied"
    end
  end
  
  def start_game()
    until game_end
      display_board
      puts "#{@players[@curr_player].name}, make a move in format of [row,col]: "
      move = gets.chomp.split(',').map(&:to_i)
      make_move(move[0], move[1])
      @curr_player = (@curr_player + 1) % 2
    end
    display_board
    #the player that didn't make the last
    puts "Game Over! Winner is " + @players[@curr_player == 0 ? 1 : 0].name
  end

  def game_end
    if row_win? || col_win? || diag_win?
      true
    else
      false
    end
  end

  private

  def row_win?
    # |row| represents each element of board, which is a row in this context
    # row.uniq returns a new array with duplicates removed, if length is 1 then all were duplicates
    # row.first != "-" checks the row is not filled with "-"
    @board.any? { |row| row.uniq.length == 1 && row.first != "-" }
  end

  def col_win?
    #iterated over column indices of 0,1,2
    #then collects the column elements 
    #by extracting each cell from each row at index 'col'
    #ex:  [0,0] -> [1,0] -> [2,0]
    #then [0,1] -> [1,1] -> [2,1]
    (0..2).any? do |col|
      column = @board.map { |row| row[col] }
      column.uniq.length == 1 && column.first != "-"
    end
  end

  def diag_win?
    # [0,0] -> [1,1] -> [2,2]
    left_diag = (0..2).map { |i| @board[i][i] }
    # board[0][2 - 0] -> [0,2]
    # board[1][2 - 1] -> [1,1]
    # board[2][2 - 2] -> [2,0]
    right_diag = (0..2).map { |i| @board[i][2 - i] }

    (left_diag.uniq.length == 1 && left_diag.first != "-") ||
    (right_diag.uniq.length == 1 && right_diag.first != "-")
  end
end

class Game
  def initialize
    @players = []
    set_player
    @board = Board.new(@players)
    @board.start_game
  end

  def set_player
    2.times do |i|
      puts "Player #{i + 1}, what is your name?"
      name = gets.chomp
      puts "Hello #{name}, do you want to play X or O?"
      option = gets.chomp
      @players << Player.new(name, option)
    end
  end
end

Game.new