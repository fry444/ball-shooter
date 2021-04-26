package states;

import js.html.Console;
import gameObjects.Bullet;
import com.collision.platformer.ICollider;
import com.collision.platformer.CollisionEngine;
import com.framework.utils.Input;
import gameObjects.Ball;
import kha.input.KeyCode;
import com.loading.basicResources.ImageLoader;
import com.loading.Resources;
import com.gEngine.helpers.Screen;
import gameObjects.Cannon;
import states.GlobalGameData;
import com.gEngine.display.Layer;
import com.collision.platformer.CollisionGroup;
import com.framework.utils.State;

class BallShooter extends State{
    var simulationLayer:Layer;
    var cannon:Cannon;
    var ballsCollision:CollisionGroup = new CollisionGroup();
    var cannonInitialX=(Screen.getWidth()/2)-20;
    var cannonInitialY=Screen.getHeight()-20;

    override function load(resources:Resources) {
        resources.add(new ImageLoader("ball"));
    }

    override function init() {
        simulationLayer = new Layer();
        stage.addChild(simulationLayer);

        GlobalGameData.simulationLayer = simulationLayer;

        cannon = new Cannon(cannonInitialX, cannonInitialY);
        addChild(cannon);
        GlobalGameData.cannon=cannon;
        
        super.init();
    }

    override function update(dt:Float) {

        if(Input.i.isKeyCodePressed(KeyCode.B)){
            addBall(100,100,3);
        }

        CollisionEngine.overlap(cannon.collision, ballsCollision, cannonVsBall);
        CollisionEngine.overlap(cannon.bulletsCollision, ballsCollision, bulletVsBall);

        super.update(dt);
    }

    function addBall(x:Float, y:Float, ballType:Int){
        var ball = new Ball(x,y,ballType,ballsCollision);
        addChild(ball);
    }

    function cannonVsBall(cannonCollision:ICollider, ballCollision:ICollider){
        changeState(new EndGame(false));
    }

    function bulletVsBall(bulletCollision: ICollider, ballCollision:ICollider){
        var ball:Ball = cast ballCollision.userData;
        var newBallType = ball.getType() -1;   
        Console.log(newBallType);
        if(newBallType>0){
            addBall(100,100,newBallType);
        }     
        ball.die();        
        var bullet:Bullet = cast bulletCollision.userData;
		bullet.die();
    }
}