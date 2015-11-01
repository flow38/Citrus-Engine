/**
 * Created by Florent on 31/10/2015.
 */
package citrus.system {
    import citrus.core.CitrusObject;

    public class AComponent extends CitrusObject implements IComponent {

        private var _parent:IEntity;

        public function AComponent(name:String, params:Object = null)
        {
            super(name, params);

            //Abstract class implementation
            if(Object(this).constructor === AComponent)
                throw new Error("AComponent class is abstract, you must instanciate some of its concrete implementations, aka Component or Entity class.");
        }

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
