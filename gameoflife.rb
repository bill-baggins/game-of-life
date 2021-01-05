# gameoflife.rb:
# Conway's Game of Life implementation in Ruby using the Gosu game library.
# Written by: Bill Baggins

# 1. Any live cell with fewer than two live neighbours dies, as if by underpopulation.
# 2. Any live cell with two or three live neighbours lives on to the next generation.
# 3. Any live cell with more than three live neighbours dies, as if by overpopulation.
# 4. Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
require 'gosu'

class Game < Gosu::Window
  def initialize(width, height)
    super(width, height, false)
    @w_width = width
    @w_height = height
    @pause = true
    self.caption = "Conway's Game of Life"

    # Cell images, font, and iteration count.
    @alive_cell = Gosu::Image.new("images/blue_cell.bmp")
    @dead_cell  = Gosu::Image.new("images/dead_cell.bmp")
    @font       = Gosu::Font.new(20)
  
    # Grid_x and grid_y evenely divide the grid based on the cell's size
    @grid_x = (width / @alive_cell.width) + 2
    @grid_y = (height / @alive_cell.height) + 2

    # Arrays for holding both dead and alive cells.
    @initial_grid = Array.new(@grid_x * @grid_y, 0)
    @output_grid  = Array.new(@grid_x * @grid_y, 0)

    # Gets the cell's position within the grid array.
    @cell_gpos  = -> (x, y) {return @initial_grid[y * @grid_x + x]}

    # The cell's x and y positions on the window.
    @cell_ax = @alive_cell.width
    @cell_ay = @alive_cell.height
  end

  def draw
    # Display the cells in the window.
    (1..@grid_x-2).each do |x|
      (1..@grid_y-2).each do |y|
        if @initial_grid[y * @grid_x + x] == 1
          @alive_cell.draw((x-1)*@cell_ax, (y-1)*@cell_ay, 1)
        else
          @dead_cell.draw((x-1)*@cell_ax, (y-1)*@cell_ay, 1)
        end
      end
    end

    # Draw "Paused" so that the user knows when it is paused.
    if @pause
<<<<<<< HEAD
      controls = "Spacebar: Pause/Unpaused\nE: Erase the current board.\nLeft Mouse Button: Turn cell on/off\nEsc: Close window"
=======
      controls = "Spacebar: Pause/Unpause\nE: Erase the current board.\nLeft Mouse Button: Turn cell on/off\nEsc: Close window"
>>>>>>> 75fb2c5419aa46d723b05b92adf345ded7bb449e
      @font.draw_text("Paused",   0, 0, 1, 1, 1, Gosu::Color::YELLOW)
      @font.draw_text("Controls:",0, @w_height-100, 1, 1, 1, Gosu::Color::YELLOW)
      @font.draw_text(controls,   0, @w_height-80, 1, 1, 1, Gosu::Color::YELLOW)
    end
  end

  def update
    if @pause
      # do nothing (prevent grid from updating)
    else
      # Loop through the initial_grid array and determine each of the cell's states.
      (1..@grid_x-2).each do |x|
        (1..@grid_y-2).each do |y|
          top = @cell_gpos.call(x-1, y-1) + @cell_gpos.call(x+0, y-1) + @cell_gpos.call(x+1, y-1)
          mid = @cell_gpos.call(x-1, y+0) +              0            + @cell_gpos.call(x+1, y+0)
          btm = @cell_gpos.call(x-1, y+1) + @cell_gpos.call(x+0, y+1) + @cell_gpos.call(x+1, y+1)
          sum = top + mid + btm

          # Core logic of Conway's Game of Life, which follows these rules:
          
          current_cell = @initial_grid[y * @grid_x + x]
          if current_cell == 1 && sum == 2 || sum == 3
            @output_grid[y * @grid_x + x] = 1
          elsif current_cell == 0 && sum == 3
            @output_grid[y * @grid_x + x] = 1
          end

        end
      end

      @initial_grid = @output_grid
      @output_grid  = Array.new(@grid_x * @grid_y, 0)
      sleep(0.100)
    end
  end

  def button_down(id)
    close if id == Gosu::KB_ESCAPE

    # Space key pauses and unpauses the screen
    if id == Gosu::KB_SPACE
      @pause = !@pause
    end

    # Get user click, which turns a cell on or off.
    if id == Gosu::MS_LEFT && @pause
      # Turns raw mouse coordinates to array indices.
      mx = ((self::mouse_x-7) / 20).round + 1
      my = ((self::mouse_y-10) / 20).round + 1

      # Map mouse coordinates to the grid holding the cells.
      if @initial_grid[my * @grid_x + mx] == 0
        @initial_grid[my * @grid_x + mx] = 1
      else
        @initial_grid[my * @grid_x + mx] = 0
      end

    end

    # Clear the board when the user presses E
    if id == Gosu::KB_E && @pause
      @initial_grid = Array.new(@grid_x * @grid_y, 0)
      @output_grid  = Array.new(@grid_x * @grid_y, 0)
    end
  end
end

if __FILE__ == $0
  width, height = 0, 0
  loop do
    # Get user input.
    puts "Enter in the width of your window (800-1800)"
    width = gets.chomp.to_i
    puts "Enter in the height of your window (500-1000)"
    height = gets.chomp.to_i

    if width < 800 || width > 1800 || height < 500 || height > 1000
      puts "One of your inputs was invalid. Try again."
      redo
    end

    # Start the game.
    Game.new(width, height).show
    break
  end
end
