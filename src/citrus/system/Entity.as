package citrus.system {

	import citrus.core.CitrusObject;
	import citrus.system.IComposite;
	import citrus.system.AComponent;

	/**
	 * A game entity is compound by components. The entity serves as a link to communicate between components.
	 * It extends the CitrusObject class to enjoy its params setter.
	 */
	public class Entity extends AComponent implements IComposite{

		protected var _components:Vector.<IComponent>;

		public function Entity(name:String, params:Object = null) {
			
			updateCallEnabled = true;
			
			if (params == null)
				params = {type:"entity"};
			else
				params["type"] = "entity";
			
			super(name, params);

			_components = new Vector.<IComponent>();
		}
		
		/**
		 * Add a component to the entity.
		 */
		public function add(component:IComponent):IComposite {
			
			doAddComponent(component);
			
			return this;
		}
		
		protected function doAddComponent(component:IComponent):Boolean
		{
			if(component.name == "")
			{
				trace("A component name was not specified. This might cause problems later.");
			}
			
			if(lookupComponentByName(component.name))
				throw Error("A component with name '" + component.name + "' already exists on this entity.");
 
			if(component.parent)
			{
				if(component.parent == this)
				{
					trace("Component with name '" + component.name + "' already has entity ('" + this.name + "') defined. Manually defining components is no longer needed");
					_components.push(component);
					return true;
				}
 
				throw Error("The component '" + component.name + "' already has an owner. ('" + component.parent.name + "')");
			}
 
			component.parent = this;
			_components.push(component);
			return true;
		}
		
		/**
		 * Remove a component from the entity.
		 */
		public function remove(component:IComponent):void {
			
			var indexOfComponent:int = _components.indexOf(component);
			if (indexOfComponent != -1)
				_components.splice(indexOfComponent,1)[0].destroy();
		}
		
		/**
		 * Search and return first componentType's instance found in components
		 *
		 * @param 	componentType  Component instance class we're looking for
		 * @return 	Component
		 */
		public function lookupComponentByType(componentType:Class):IComponent
		{
			var component:IComponent = null;
			var filteredComponents:Vector.<IComponent> = _components.filter(function(item:IComponent, index:int, vector:Vector.<IComponent>):Boolean{
				return item is componentType;
			});
 
			if (filteredComponents.length != 0) {
				component =  filteredComponents[0];
			}
 
			return component;
		}
		
		/**
		 * Search and return all componentType's instance found in components
		 *
		 * @param 	componentType  Component instance class we're looking for
		 */
		public function lookupComponentsByType(componentType:Class):Vector.<IComponent>
		{
			var filteredComponents : Vector.<IComponent> = _components.filter(function(item:IComponent, index:int, vector:Vector.<IComponent>):Boolean{
				return item is componentType;
			});
 
			return filteredComponents;
		}
		
		/**
		 * Search and return a component using its name
		 *
		 * @param 	name Component's name we're looking for
		 * @return 	Component
		 */
		public function lookupComponentByName(name:String):IComponent
		{
			var component : IComponent = null;
			var filteredComponents : Vector.<IComponent> = _components.filter(function(item:IComponent, index:int, vector:Vector.<IComponent>):Boolean{
				return item.name == name;
			});
 
			if (filteredComponents.length != 0) {
				component =  filteredComponents[0];
			}
 
			return component;
		}
		
		/**
		 * After all the components have been added call this function to perform an init on them.
		 * Mostly used if you want to access to other components through the entity.
		 * Components initialization will be perform according order in which components
		 * has been add to entity
		 */
		override public function initialize(poolObjectParams:Object = null):void {
			
			super.initialize();
			
			_components.forEach(function(item:IComponent, index:int, vector:Vector.<IComponent>):void{
				item.initialize();
			});
		}
		
		/**
		 * Destroy the entity and its components.
		 * Components destruction will be perform according order in which components
		 * has been add to entity
		 */
		override public function destroy():void {
			
			_components.forEach(function(item : IComponent, index:int, vector:Vector.<IComponent>):void{
				item.destroy();
			});
			_components = null;
			
			super.destroy();
		}
		
		/**
		 * Perform an update on all entity's components.
		 * Components update will be perform according order in which components
		 * has been add to entity
		 */
		override public function update(timeDelta:Number):void {
			
			_components.forEach(function(item : IComponent, index:int, vector:Vector.<IComponent>):void{
				item.update(timeDelta);
			},this);
		}
		
		public function get components():Vector.<IComponent>
		{
			return _components;
		}

    }
}
