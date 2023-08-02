package;

import js.Browser.window;
import js.Browser.document;

class Main {
    static function main() {
        window.onload = ()->new Main();
    }

    var canvas :js.html.CanvasElement;
    var keys:Dynamic = {};

    function new() {
        canvas = cast document.getElementById("c");
        canvas.width = canvas.height = 64;
        untyped onkeydown = onkeyup = function(e) {
            keys[e.key] = e.type[3] == 'd';
        }
        function render(time:Float) {
        }
        function loop(time:Float) {
            render(time);
            js.Browser.window.requestAnimationFrame(loop);
        }
        js.Browser.window.requestAnimationFrame(loop);
    }

    function processControls() {
    }
}
