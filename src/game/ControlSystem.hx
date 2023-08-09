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

            var o_pressed = main.isJustPressed('o');
            var p_pressed = main.isJustPressed('p');

            if(o_pressed || p_pressed) {
                var dir = o_pressed ? 1 : -1;

                if(other.col == puyo.col) {
                    puyo.desiredRow = other.row;

                    if(other.row == puyo.row + 1) {
                        puyo.desiredCol = puyo.col - dir;
                    } else {
                        puyo.desiredCol = puyo.col + dir;
                    }
                } else {
                    puyo.desiredCol= other.col;

                    if(other.col == puyo.col + 1) {
                        puyo.desiredRow= puyo.row + dir;
                    } else {
                        puyo.desiredRow= puyo.row - dir;
                    }
                }
            }
        }
    }
}
