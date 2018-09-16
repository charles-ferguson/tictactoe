module TicTacToe
  class Game
    def initialize(player1 = "X", player2 = "O")
      @board = Board.new
      @players = [player1, player2]
    end

    def play
      player = @players.sample
      loop do
        play_turn(player)
        if @board.won?(player)
          puts "Player #{player} won"
          break
        end
        if @board.draw?
          puts "Draw"
          break
        end
        player = (@players - [player])[0]
      end
      @board.print
    end

    def play_turn(player)
      moved = false
      while(moved == false)
        begin
          move = get_move(player)
          @board.move(*move, player)
          moved = true
        rescue ArgumentError => e
          puts e.message
        end
      end
    end

    def get_move(player)
      @board.print
      puts "Player #{player} where do you want to move? (row, column)"
      answer = gets.chomp
      matches = answer.match(/\(*(?<row>\d+),\s*(?<column>\d+)\)*/)
      raise ArgumentError.new("Did not understand move. It must be of the form (row, column)") if matches.nil?
      [matches[:row].to_i, matches[:column].to_i]
    end
  end

  class Board
    EMPTY = ' '
    attr_reader :board
    def initialize
      @board =
        [
          Array.new(3, EMPTY),
          Array.new(3, EMPTY),
          Array.new(3, EMPTY)
        ]
    end

    def move(row, column, player)
      raise ArgumentError.new("row #{row} is out of bounds (min: 0, max: 2)") if row > 2 || row < 0
      raise ArgumentError.new("column #{column} is out of bounds (min: 0, max: 2)") if column > 2 || column < 0
      raise ArgumentError.new("row #{row} column #{column} has already been played") if board[row][column] != EMPTY
      board[row][column] = player.to_s
    end

    def won?(player)
      possible_wins = rows + columns + diagonals
      possible_wins.any? { |win| win == Array.new(3, player) }
    end

    def draw?
      !@board.flatten.any? { |space| space == EMPTY }
    end

    def rows
      board
    end

    def columns
      [0, 1, 2].map { |col_i| [board[0][col_i], board[1][col_i], board[2][col_i]] }
    end

    def diagonals
     [
      [board[0][0], board[1][1], board[2][2]],
      [board[0][2], board[1][1], board[2][0]]
     ]
    end


    def print
     puts " #{board[0].join(" | ")} "
     puts "-----------"
     puts " #{board[1].join(" | ")} "
     puts "-----------"
     puts " #{board[2].join(" | ")} "
    end
  end
end
