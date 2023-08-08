package game;

class Session {
    public var grid:Array<Array<ecs.Entity>>;

    public var colors = ["red", "green", "blue"];

    public function new() {
        grid = [];

        for(i in 0...14) {
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

        return true;
    }

    public function isFree(col, row) {
        if(isValid(col, row)) {
            return grid[row][col] == null;
        }

        return false;
    }

    public function getEntity(col, row) {
        if(isValid(col, row)) {
            return grid[row][col];
        }

        return null;
    }

    public function setGrid(col, row, value) {
        grid[row][col] = value;
    }

    public function getColor(col, row) {
        var e = getEntity(col, row);

        if(e != null) {
            return e.get(Puyo).color;
        }

        return null;
    }
}
