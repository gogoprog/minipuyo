package game;

class ControlSystem extends ecs.System {
    public function new() {
        super();
        addComponentClass(math.Transform);
        addComponentClass(Puyo);
        addComponentClass(Control);
    }

    override public function update(dt) {
        super.update(dt);
        var es = engine.getMatchingEntities(Control);

        if(es.length == 2) {
            var p1 = es[0].get(Puyo);
            var p2 = es[1].get(Puyo);

            if(p1.desiredCol != p2.desiredCol || p1.desiredRow != p2.desiredRow) {
                p1.col = p1.desiredCol;
                p2.col = p2.desiredCol;
                p1.row = p1.desiredRow;
                p2.row = p2.desiredRow;
                p1.desiredRow = null;
                p2.desiredRow = null;
                p1.desiredCol = null;
                p2.desiredCol = null;
            }
        }
    }

    override public function updateSingle(dt:Float, e:ecs.Entity) {
        var puyo = e.get(Puyo);
        var control = e.get(Control);
        var offset_col = 0;
        var offset_row = 0;
        control.time += dt;

        if(Main.instance.isJustPressed('ArrowLeft')) {
            offset_col -=1;
            control.time = 1;
        } else if(Main.instance.isJustPressed('ArrowRight')) {
            offset_col +=1;
            control.time = 1;
        } else if(Main.instance.isPressed('ArrowLeft')) {
            offset_col -=1;
        } else if(Main.instance.isPressed('ArrowRight')) {
            offset_col +=1;
        }

        if(Main.instance.isJustPressed('ArrowDown')) {
            offset_row -=1;
            control.time2 = 1;
        } else if(Main.instance.isPressed('ArrowDown')) {
            offset_row -=1;
        }

        if(Main.instance.session.isValid(puyo.col + offset_col, puyo.row) && control.time >= 0.2) {
            // puyo.col += offset_col;
            puyo.desiredCol = puyo.col + offset_col;
            control.time = 0.0;
        } else {
            puyo.desiredCol = puyo.col;
        }

        if(Main.instance.session.isValid(puyo.col, puyo.row + offset_row) && control.time2 >= 0.2) {
            // puyo.row += offset_row;
            puyo.desiredRow = puyo.row + offset_row;
            control.time2 = 0.0;
        } else {
            puyo.desiredRow = puyo.row;
        }
    }
}
