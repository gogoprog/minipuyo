package game;

class Factory {
    static public function createPuyo() {
        var e = new ecs.Entity();
        e.add(new math.Transform());
        e.add(new core.Sprite("blob"));
        e.add(new Puyo());
        return e;
    }
}
