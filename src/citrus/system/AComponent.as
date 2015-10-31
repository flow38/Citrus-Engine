/**
 * Created by Florent on 31/10/2015.
 */
package citrus.system {
    import citrus.core.CitrusObject;
    import citrus.system.IComponent;
    import citrus.system.IComposite;

    public class AComponent extends CitrusObject implements IComponent {

        private var _parent:IComposite;

        public function AComponent(name:String, params:Object = null)
        {
            super(name, params);

            //Abstract class implementation
            if(Object(this).constructor === AComponent)
                throw new Error("AComponent class is abstract, you must instanciate some of its concrete implementations, aka Component or Entity class.");
        }

        public function get parent():IComposite
        {
            return _parent;
        }

        public function set parent(value:IComposite):void
        {
            _parent = value;
        }
    }
}
