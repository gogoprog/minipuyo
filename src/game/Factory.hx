package game;

class Factory {
    static public function createPuyo(color) {
        var e = new ecs.Entity();
        e.add(new math.Transform());
        e.add(new Puyo());
        e.get(Puyo).color = color;
        return e;
    }
}
