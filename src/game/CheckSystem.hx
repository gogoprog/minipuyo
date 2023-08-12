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

            var did_match = false;

            for(match in matches) {
                var size = Lambda.count(match);

                if(size >= 4) {
                    did_match = true;

                    for(e in match.keys()) {
                        var puyo = e.get(Puyo);
                        Main.instance.session.setGrid(puyo.col, puyo.row, null);
                        engine.removeEntity(e);
                    }
                }
            }

            if(did_match) {
                var es = engine.getMatchingEntities(Puyo);

                for(e in es) {
                    var puyo = e.get(Puyo);
                    Main.instance.session.setGrid(puyo.col, puyo.row, null);
                    e.add(new Fall());
                }
            }
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
