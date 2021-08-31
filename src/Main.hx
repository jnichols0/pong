import hxd.Key in K;
import Random;
import Sys;

class Main extends hxd.App {
    var paddle_left : h2d.Bitmap;
    var paddle_right: h2d.Bitmap;

    static var PADDLE_WIDTH : Int = 25;
    static var PADDLE_HEIGHT : Int = 150;
    static var BALL_SIZE : Int = 25;
    static var BALL_SPEED : Int = 7;

    var ball : h2d.Bitmap;
    var ball_angle : Int;

    var score_right : h2d.Text;
    var score_left : h2d.Text;

    var score_right_value : Int;
    var score_left_value : Int;

    function degrees_to_radians(degrees: Int) {
        return Math.PI * degrees / 180;
    }

    function reset_ball() {
        ball.x = Std.int(s2d.width / 2 - BALL_SIZE / 2);
        ball.y = Std.int(s2d.height / 2 - BALL_SIZE / 2);
        ball_angle = 0;
        var random_direction : Int = Random.int(0, 1);
        if (random_direction == 1)  // 50% left 50% right
            ball_angle = 180;
        ball_angle += Random.int(-45, 45); 
    }

    override function init() {
        var font : h2d.Font = hxd.res.DefaultFont.get();
        score_right = new h2d.Text(font);
        score_right.text = "0";
        score_right.x = Std.int(s2d.width * .75);
        score_right_value = 0;

        score_left = new h2d.Text(font);
        score_left.text = "0";
        score_left.x = Std.int(s2d.width * .25);
        score_left_value = 0;

        s2d.addChild(score_left);
        s2d.addChild(score_right);

        paddle_left = new h2d.Bitmap(h2d.Tile.fromColor(0xFFFFFF, PADDLE_WIDTH, PADDLE_HEIGHT, 1), s2d);
        paddle_left.x = Std.int(50);
        paddle_left.y = Std.int(s2d.height / 2 - 75);

        paddle_right = new h2d.Bitmap(h2d.Tile.fromColor(0xFFFFFF, PADDLE_WIDTH, PADDLE_HEIGHT, 1), s2d);
        paddle_right.x = Std.int(s2d.width - 100);
        paddle_right.y = Std.int(s2d.height / 2 - 75);

        ball = new h2d.Bitmap(h2d.Tile.fromColor(0xFFFFFF, BALL_SIZE, BALL_SIZE, 1), s2d);
        reset_ball();
    }

    override function update(dt : Float) {
        // update the ball pos based on current angle and speed
        ball.x += Math.cos(degrees_to_radians(ball_angle % 360)) * BALL_SPEED;
        ball.y += Math.sin(degrees_to_radians(ball_angle % 360)) * BALL_SPEED;

        // Right scores a point
        if (ball.x + BALL_SIZE >= s2d.width){
            reset_ball();
            score_left_value += 1;
            score_left.text = Std.string(score_left_value);
        }

        // Left scores a point
        if ( ball.x <= 0) { 
            reset_ball();
            score_right_value += 1;
            score_right.text = Std.string(score_right_value);
        }
        
        // Ball hits ceiling 
        if (ball.y +BALL_SIZE >= s2d.height || ball.y <= 0) {
            ball_angle = 360 - ball_angle;
        }

        // Ball hits one of the paddles
        if (ball.x <= paddle_left.x + BALL_SIZE &&
            ball.x + BALL_SIZE >= paddle_left.x &&
            ball.y <= paddle_left.y + 150 &&
            ball.y + BALL_SIZE >= paddle_left.y){ 
                ball_angle += 180 + Random.int(-30,30);
        }
        if (ball.x <= paddle_right.x + BALL_SIZE &&
            ball.x + BALL_SIZE >= paddle_right.x &&
            ball.y <= paddle_right.y + 150 &&
            ball.y + BALL_SIZE >= paddle_right.y) { 
                ball_angle += 180 + Random.int(-30,30);
        }

        if ( K.isDown(K.W) )
            if (paddle_left.y - 5 <= 0)
                paddle_left.y = 0;
            else
                paddle_left.y -= 5;
        if ( K.isDown(K.S) )
            if (paddle_left.y + 5 >= s2d.height - PADDLE_HEIGHT)
                paddle_left.y = s2d.height - PADDLE_HEIGHT;
            else
                paddle_left.y += 5;

        if ( K.isDown(K.UP) )
            if (paddle_right.y - 5 <= 0)
                paddle_right.y = 0;
            else
                paddle_right.y -= 5;
        if ( K.isDown(K.DOWN) )
            if (paddle_right.y + 5 >= s2d.height - PADDLE_HEIGHT)
                paddle_right.y = s2d.height - PADDLE_HEIGHT;
            else
                paddle_right.y += 5;

        if ( K.isDown(K.ESCAPE) )
            Sys.exit(0);
    }

    static function main() {
        hxd.Res.initEmbed();
        new Main();
    }
}
