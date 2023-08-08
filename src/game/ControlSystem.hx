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
            var all_valid = true;

            for(e in es) {
                var puyo = e.get(Puyo);

                if(puyo.desiredCol == null || puyo.desiredRow == null || !Main.instance.session.isFree(puyo.desiredCol, puyo.desiredRow)) {
                    all_valid = false;
                    break;
                }
            }

            if(all_valid) {
                for(e in es) {
                    var puyo = e.get(Puyo);
                    puyo.col = puyo.desiredCol;
                    puyo.row = puyo.desiredRow;
                }
            }
        }
    }

    override public function updateSingle(dt:Float, e:ecs.Entity) {
        var puyo = e.get(Puyo);
        var control = e.get(Control);
        var offset_col = 0;
        var offset_row = 0;
        control.time += dt;
        var main = Main.instance;

        if(main.isJustPressed('ArrowLeft') || main.isJustPressed('a')) {
            offset_col -=1;
            control.time = 1;
        } else if(main.isJustPressed('ArrowRight') || main.isJustPressed('d')) {
            offset_col +=1;
            control.time = 1;
        } else if(main.isPressed('ArrowLeft') || main.isJustPressed('a')) {
            offset_col -=1;
        } else if(main.isPressed('ArrowRight') || main.isJustPressed('d')) {
            offset_col +=1;
        }

        if(main.isJustPressed('ArrowDown') || main.isJustPressed('w')) {
            offset_row -=1;
            control.time2 = 1;
        } else if(main.isPressed('ArrowDown') || main.isJustPressed('s')) {
            offset_row -=1;
        }

        if(control.time >= 0.2) {
            puyo.desiredCol = puyo.col + offset_col;
            control.time = 0.0;
        } else {
            puyo.desiredCol = puyo.col;
        }

        if(control.time2 >= 0.2) {
            puyo.desiredRow = puyo.row + offset_row;
            control.time2 = 0.0;
        } else {
            puyo.desiredRow = puyo.row;
        }

        if(control.second) {
            var es = engine.getMatchingEntities(Control);
            var other:Puyo = null;

            for(e2 in es) {
                if(!e2.get(Control).second) {
                    other = e2.get(Puyo);
                }
            }

            if(main.isJustPressed('o')) {
                if(other.col == puyo.col) {
                    if(other.row == puyo.row + 1) {
                        puyo.desiredCol = puyo.col - 1;
                        puyo.desiredRow = other.row;
                    } else {
                        puyo.desiredCol = puyo.col + 1;
                        puyo.desiredRow = other.row;
                    }
                }
            }
        }
    }
}
