package states;

import com.gEngine.display.Sprite;
import com.loading.basicResources.ImageLoader;
import com.framework.utils.Input;
import kha.input.KeyCode;
import com.gEngine.helpers.Screen;
import com.gEngine.display.Text;
import com.loading.basicResources.FontLoader;
import com.loading.basicResources.JoinAtlas;
import com.loading.Resources;
import com.framework.utils.State;

class EndGame extends State{

    var winState:Bool;

    public function new(winState:Bool){
        this.winState=winState;
        super();

    }

    override function load(resources:Resources) {
        var atlas = new JoinAtlas(512,512);
        atlas.add(new FontLoader("Kenney_Thick",20));
        atlas.add(new ImageLoader("gameOver"));
        resources.add(atlas);
    }

    override function init() {
        if(winState){
            var text = new Text("Kenney_Thick");
            text.x=Screen.getWidth()*0.50-50;
            text.y=Screen.getHeight()*0.50;
            text.text="winner";
            stage.addChild(text);
        }else{
            var image = new Sprite("gameOver");
            image.smooth=false;
            image.x=524.5;
            image.y=225;
            stage.addChild(image);
            var text = new Text("Kenney_Thick");
            text.x=440;
            text.y=470;
            text.text="Press R to restart the game";
            stage.addChild(text);
        }
        
    }
    override function update(dt:Float) {
        super.update(dt);
        if(Input.i.isKeyCodePressed(KeyCode.R)){
            this.changeState(new BallShooter());
        }
    }
}