package citrus.system {

import citrus.view.ISpriteView;

/**
	 * A game entity is compound by components. The entity serves as a link to communicate between components.
	 * It extends the CitrusObject class to enjoy its params setter.
	 *
	 * Entity implements IEntity and therefor can be composed by IComponent AND IEntity.
	 *
	 * Entity is responsible for calling to all its components the basic game loop method as initialize, update,
	 * destroy ...
	 *
	 * State instance only store (via its objects property) a reference to the entity and not to its components. But
	 * State 's view store a reference to all components and sub components implementing ISpriteView interface.
	 */
	public class Entity extends AComponent implements IEntity{

		public function Entity(name:String, params:Object = null) {

			updateCallEnabled = true;

			if (params == null)
				params = {type:"entity"};
			else
				params["type"] = "entity";

			super(name, params);

			_components = new Vector.<IComponent>();
		}

		protected var _components:Vector.<IComponent>;

		public function get components():Vector.<IComponent>
		{
			return _components;
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

    	public function add(component:IComponent):IEntity {

			doAddComponent(component);

			return this;
		}

		public function remove(component:IComponent):void {

			var indexOfComponent:int = _components.indexOf(component);
			if (indexOfComponent != -1)
				_components.splice(indexOfComponent,1)[0].destroy();
		}

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
		
		public function lookupComponentsByType(componentType:Class):Vector.<IComponent>
		{
			var filteredComponents : Vector.<IComponent> = _components.filter(function(item:IComponent, index:int, vector:Vector.<IComponent>):Boolean{
				return item is componentType;
			});

			return filteredComponents;
		}
		
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
		
		public function getViews():Vector.<ISpriteView> {
			var views : Vector.<ISpriteView> = new Vector.<ISpriteView>();

			for each (var component:IComponent in _components) {
				if (component is ISpriteView) {
					views.push(component);
				}else if (component is IEntity) {
					views.concat(IEntity(component).getViews());
				}
			}

			return views;
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

    }
}
