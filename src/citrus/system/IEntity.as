/**
 * Created by Florent on 31/10/2015.
 */
package citrus.system {
import citrus.view.ISpriteView;

public interface IEntity extends IComponent{

        /**
         * Add a child component to the IEntity.
         */
        function add(component:IComponent):IEntity;

        /**
         * Remove a child component from the IEntity.
         */
        function remove(component:IComponent):void;

        /**
         * Search and return first componentType's instance found in children components
         *
         * @param    componentType  Component instance class we're looking for
         * @return    IComponent
         */
        function lookupComponentByType(componentType:Class):IComponent;

        /**
         * Search and return all componentType's instance found in components
         *
         * @param    componentType  IComponent instance class we're looking for
         */
        function lookupComponentsByType(componentType:Class):Vector.<IComponent>;

        /**
         * Search and return a component using its name
         *
         * @param    name Component's name we're looking for
         * @return   IComponent
         */
        function lookupComponentByName(name:String):IComponent;

        /**
         * Look recursively for all existing ISpriteView through components
         *
         *
         * @return  Composite's views
         */
        function getViews():Vector.<ISpriteView>;
    }
}
