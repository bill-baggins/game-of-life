# gosu-gameoflife.rb:
# Conway's Game of Life implementation in Ruby using the Gosu game library.
# Written by: Bill Baggins

# 1. Any live cell with fewer than two live neighbours dies, as if by underpopulation.
# 2. Any live cell with two or three live neighbours lives on to the next generation.
# 3. Any live cell with more than three live neighbours dies, as if by overpopulation.
# 4. Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
require 'gosu'

class Game < Gosu::Window
  def initialize(width, height)
    super(width, height, true)
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

    # Arrays for holding both dead and alive cells
    @initial_grid   = Array.new(@grid_x * @grid_y, 0)
    @output_grid    = Array.new(@grid_x * @grid_y, 0)

    @cell_gpos  = -> (x, y) {return @initial_grid[y * @grid_x + x]}

    # The cell's x and y positions on the window.
    @cell_ax = @alive_cell.width
    @cell_ay = @alive_cell.height

    # Refresh rate of the screen.
    @refresh_rate = 0.050
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
      num_of_controls = 6
      controls = "Spacebar: Pause/Unpause\nE: Erase the current board. \
                  \nUp/Down Arrows: Update faster/slower\nR: Reset update frequency \
                  \nLeft Mouse Button: Turn cell on/off\nEsc: Close window"
      @font.draw_text("Paused",   0, 0, 1, 1, 1, Gosu::Color::YELLOW)
      @font.draw_text("Controls:",0, @w_height - (num_of_controls + 1) * 20, 1, 1, 1, Gosu::Color::YELLOW)
      @font.draw_text(controls,   0, @w_height - num_of_controls * 20, 1, 1, 1, Gosu::Color::YELLOW)
    end
  end

  def update
    if !@pause
      # Loop through the initial_grid array and determine each of the cell's states.
      (1..@grid_x-2).each do |x|
        (1..@grid_y-2).each do |y|
          top = @cell_gpos.call(x-1, y-1) + @cell_gpos.call(x+0, y-1) + @cell_gpos.call(x+1, y-1)
          mid = @cell_gpos.call(x-1, y+0) +              0            + @cell_gpos.call(x+1, y+0)
          btm = @cell_gpos.call(x-1, y+1) + @cell_gpos.call(x+0, y+1) + @cell_gpos.call(x+1, y+1)
          total = top + mid + btm
          
          # Core logic of Conway's Game of Life, which follows these rules:
          current_cell  = @initial_grid[y * @grid_x + x]
          if current_cell == 1 && total == 2 || total == 3
            @output_grid[y * @grid_x + x] = 1
          elsif current_cell == 0 && total == 3
            @output_grid[y * @grid_x + x] = 1
          end
        end
      end

      @initial_grid   = @output_grid
      @output_grid    = Array.new(@grid_x * @grid_y, 0)
      sleep(@refresh_rate)
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
    
    if id == Gosu::KB_UP && @refresh_rate > 0.010  
      @refresh_rate -= 0.010
    elsif id == Gosu::KB_DOWN && @refresh_rate < 1.000
      @refresh_rate += 0.010
    elsif id == Gosu::KB_R
      @refresh_rate = 0.050
    end
    
  end
end

if __FILE__ == $0
  Game.new(1920, 1080).show
end