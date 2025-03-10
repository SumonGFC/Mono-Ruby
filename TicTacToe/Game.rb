require './Grid.rb'

class Game
    attr_reader :grid, :player_symbol, :computer_symbol
    def initialize(grid)
        @grid = grid
        @player_symbol = ""
        @computer_symbol = "X"
    end

    def play_the_game()
        prepare_the_game
        while !is_end_of_game do
            get_player_turn
            if !is_end_of_game
                get_computer_turn     
            end 
            if check_for_victory(@player_symbol)
                puts "You won, congratulations"
                break
            elsif check_for_victory(@computer_symbol)
                puts "You lose, too bad"
                break
            end
        end
    end

    #private
    def prepare_the_game()
        self.get_symbol_for_player
        self.check_for_player_symbol_and_computer_symbol_inequality
    end

    

    def get_symbol_for_player()
        puts "Choose your symbol!"
        player_symbol = gets.chomp()

        if player_symbol.length == 0
            @player_symbol = "O"

        elsif player_symbol.length < 1
            puts "Too long, we're gonna take the first character, sorry..."
            @player_symbol += player_symbol[0]
        else
            @player_symbol += player_symbol
        end

    end

    def check_for_player_symbol_and_computer_symbol_inequality()
        if @computer_symbol == @player_symbol
            @computer_symbol = "O"
        end
    end
    

    def asking_for_input_for_player()
        puts "\nGrid is currently like this:"
        @grid.display_grid
        puts "\nPlease enter the row of the cell you want to play"
        row = gets.chomp
        puts "Please enter the column of the cell you want to play"
        col = gets.chomp

        case is_input_valid_for_player(row, col)
        when "No method Error"
            puts "Enter a number between 1 and #{@grid.width} please"
            asking_for_input_for_player
        when "NaN value"
            puts "Enter a number between 1 and #{@grid.width} please"
            asking_for_input_for_player
        when "Invalid value"
            puts "Enter a number between 1 and #{@grid.width} please"
            asking_for_input_for_player
        when false
            puts "Sorry cell is already used"
            asking_for_input_for_player
        else
            return "#{row.to_i - 1},#{col.to_i - 1}"
        end
    end

    def is_input_valid_for_player(row, col)
        begin
            if !!Float(row) && !!Float(col)
                if row.to_i == 0 || col.to_i == 0 || col.to_i < 0 || row.to_i < 0
                    return "Invalid value"
                end                
                return grid.get_cell(row.to_i, col.to_i).content == "."
                
            end
        rescue NoMethodError
            return "No method Error"
        rescue ArgumentError
            return "NaN value"
        end
    end

    def edit_the_grid_using_player_input()
        string_to_split = asking_for_input_for_player
        coords_array = string_to_split.split(",")
        row = coords_array[0].to_i
        col = coords_array[1].to_i
        @grid.edit_the_grid(row, col, @player_symbol)        
    end

    def get_player_turn()
        self.edit_the_grid_using_player_input
        self.grid.display_grid
    end

    def get_computer_turn()
        empty_cells_array = @grid.get_empty_cells
        cell_to_edit = empty_cells_array.sample
        cell_to_edit.change_content(@computer_symbol)
    end
    

    def is_end_of_game()
        @grid.is_grid_full
    end

    def check_for_victory(symbol)
        grid.get_rows.each do |row|            
            if row.map{|cell| cell.get_content}.all?(symbol)
                return true
            end
        end

        
        grid.get_cols.each do |col|            
            if col.map{|cell| cell.get_content}.all?(symbol)
              return true
            end
        end

        grid.get_diagonals.each do |diagonal|  
            if diagonal.map{|cell| cell.get_content}.all?(symbol)
                return true
            else
                return false
            end
        end
        
    end

    

end

game = Game.new(Grid.new(3))
game.play_the_game
