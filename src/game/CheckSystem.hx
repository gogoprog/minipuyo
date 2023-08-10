package game;

typedef Match = Map<ecs.Entity, Bool>;

class CheckSystem extends ecs.System {
    public function new() {
        super();
    }

    override public function onResume() {
    }

    override public function update(dt) {
        var es = engine.getMatchingEntities(Fall);

        if(es.length == 0) {
            var main = Main.instance;
            var session = main.session;
            var matches = new Array<Match>();

            for(x in 0...session.width) {
                for(y in 0...session.height) {
                    var e = session.getEntity(x, y);

                    if(e != null) {
                        var match:Match = null;

                        for(m in matches) {
                            if(m[e]) {
                                match = m;
                            }
                        }

                        if(match == null) {
                            match = new Match();
                            matches.push(match);
                            var current = e.get(Puyo).getPosition();
                            match[e] = true;
                            visit(match, current, e.get(Puyo).color);
                        }
                    }
                }
            }

            trace(matches);
        }
    }

    function visit(match:Match, position:math.Point, color) {
        var deltas:Array<math.Point> = [ [0, 1], [0, -1], [1, 0], [-1, 0]];

        for(delta in deltas) {
            var new_pos = position + delta;
            var e = Main.instance.session.getEntity(Std.int(new_pos.x), Std.int(new_pos.y));

            if(e != null) {
                if(e.get(Puyo).color == color) {
                    if(!match[e]) {
                        match[e] = true;
                        visit(match, new_pos, color);
                    }
                }
            }
        }
    }
}
