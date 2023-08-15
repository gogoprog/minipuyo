package game;

class Session {
    public var grids:Array<Array<Array<ecs.Entity>>>;
    public var width = 6;
    public var height = 12;
    public var garbages = [10, 10];

    public var colors = ["red", "green", "blue"];

    public function new() {
        grids = [];

        for(g in 0...2) {
            var grid = [];

            for(i in 0...14) {
                grid[i] = [];
            }

            grids[g] = grid;
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

    public function isFree(team, col, row) {
        if(isValid(col, row)) {
            return grids[team][row][col] == null;
        }

        return false;
    }

    public function getEntity(team, col, row) {
        if(isValid(col, row)) {
            return grids[team][row][col];
        }

        return null;
    }

    public function setGrid(team, col, row, value) {
        grids[team][row][col] = value;
    }

    public function getColor(team, col, row) {
        var e = getEntity(team, col, row);

        if(e != null) {
            return e.get(Puyo).color;
        }

        return null;
    }
}
