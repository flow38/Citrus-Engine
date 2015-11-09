/**
 * Created by Florent on 31/10/2015.
 */
package citrus.system {
import citrus.core.CitrusObject;

public class AComponent extends CitrusObject implements IComponent {

        public function AComponent(name:String, params:Object = null)
        {
            super(name, params);

            //Abstract class implementation
            if (Object(this).constructor === AComponent) {
                throw new Error("AMelonComponent class is abstract, you must instanciate some of its concrete implementations, aka MelonComponent or Entity class.");
            }
        }

    private var _parent : IEntity;

        public function get parent():IEntity
        {
            return _parent;
        }

        public function set parent(value:IEntity):void
        {
            _parent = value;
        }
    }
}
