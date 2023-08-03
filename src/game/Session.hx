package game;

class Session {
    public var grid:Array<Array<ecs.Entity>>;

    public function new() {
        grid = [];

        for(i in 0...13) {
            grid[i] = [];
        }
    }

    public function isValid(col, row) {
        if(col<0 || col>5) {
            return false;
        }

        if(row<0) {
            return false;
        }

        if(grid[row][col] == null) {
            return true;
        }

        return false;
    }

    public function setGrid(col, row, value) {
        grid[row][col] = value;
    }
}
