/**
 * Created by Florent on 31/10/2015.
 */
package citrus.system {
    import citrus.system.IComponent;

    public interface IComposite extends IComponent{

        /**
         * Add a child component to the IComponent.
         */
        function add(component:IComponent):IComposite;

        /**
         * Remove a child component from the IComponent.
         */
        function remove(component:IComponent):void;

        /**
         * Search and return first componentType's instance found in children components
         *
         * @param    componentType  Component instance class we're looking for
         * @return    Component
         */
        function lookupComponentByType(componentType:Class):IComponent;

        /**
         * Search and return all componentType's instance found in components
         *
         * @param    componentType  Component instance class we're looking for
         */
        function lookupComponentsByType(componentType:Class):Vector.<IComponent>;

        /**
         * Search and return a component using its name
         *
         * @param    name Component's name we're looking for
         * @return    Component
         */
        function lookupComponentByName(name:String):IComponent;
    }
}
