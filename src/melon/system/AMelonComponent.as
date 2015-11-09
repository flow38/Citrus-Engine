/**
 * Created by Florent on 31/10/2015.
 */
package melon.system {
import citrus.system.*;

import melon.core.MelonObject;

public class AMelonComponent extends MelonObject implements IMelonComponent {

    public function AMelonComponent(name : String, params : Object = null)
    {
        super(name, params);

        //Abstract class implementation
        if (Object(this).constructor === AComponent) {
            throw new Error("AMelonComponent class is abstract, you must instanciate some of its concrete implementations, aka MelonComponent or MelonEntity class.");
        }
    }

    private var _parent : IEntity;

    public function get parent() : IEntity
    {
        return _parent;
    }

    public function set parent(value : IEntity) : void
    {
        _parent = value;
    }


    override protected function clean() : void
    {
        _parent = null;
        super.clean();
    }
}
}
