package game;

class PuyoSystem extends ecs.System {
    public function new() {
        super();
        addComponentClass(math.Transform);
        addComponentClass(Puyo);
    }

    override public function updateSingle(dt:Float, e:ecs.Entity) {
        var puyo = e.get(Puyo);
        var pos = e.get(math.Transform).position;
        pos.x = 2 + 4*puyo.col;
        pos.y = 64 - 11 - 4- 4*puyo.row;
        puyo.time -= dt;

        if(puyo.time < 0) {
            puyo.eyeFlip = Std.random(2) == 1;
            puyo.time = 0.5 + Std.random(3);
        }

        {
            var ctx = Main.instance.ctx;
            //body
            ctx.fillStyle = puyo.color;
            ctx.fillRect(pos.x + 1, pos.y, 2, 4);
            ctx.fillRect(pos.x, pos.y+1, 4, 2);

            if(e.get(Fall) == null) {
                var session = Main.instance.session;

                if(session.getColor(puyo.col - 1, puyo.row) == puyo.color) {
                    ctx.fillRect(pos.x, pos.y, 1, 4);
                }

                if(session.getColor(puyo.col + 1, puyo.row) == puyo.color) {
                    ctx.fillRect(pos.x + 3, pos.y, 1, 4);
                }

                if(session.getColor(puyo.col, puyo.row + 1) == puyo.color) {
                    ctx.fillRect(pos.x, pos.y, 4, 1);
                }

                if(session.getColor(puyo.col, puyo.row - 1) == puyo.color) {
                    ctx.fillRect(pos.x, pos.y + 3, 4, 1);
                }
            }

            //eye
            ctx.fillStyle = puyo.eyeFlip ? "#55a" : "#fff";
            ctx.fillRect(pos.x+1, pos.y+1, 1, 1);
            ctx.fillStyle = !puyo.eyeFlip ? "#55a" : "#fff";
            ctx.fillRect(pos.x+2, pos.y+1, 1, 1);
        }
    }
}
