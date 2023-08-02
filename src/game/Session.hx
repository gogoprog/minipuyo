package game;

class Session {
    public var grid:Array<Array<ecs.Entity>>;

    public function new() {
        grid = [];

        for(i in 0...12) {
            grid[i] = [];
        }
    }
}
