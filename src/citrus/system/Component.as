package citrus.system {

	/**
	 * A component is an object dedicate to a (single) task for an entity : physics, collision, inputs, view, movement... management.
	 * You will use an entity when your object become too much complex to manage into a single class.
	 * Preferably if you use a physics engine, create at first the entity's physics component.
	 * It extends the CitrusObject class to enjoy its params setter.
	 */
	public class Component extends AComponent {

		public function Component(name:String, params:Object = null) {
			
			if (params == null)
				params = {type:"component"};
			else
				params["type"] = "component";
			
			super(name, params);
		}
    }
}
