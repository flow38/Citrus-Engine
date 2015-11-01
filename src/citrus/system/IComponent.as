/**
 *  @author Florent Falcy
 */
package citrus.system {
    import citrus.core.ICitrusObject;

    public interface IComponent extends ICitrusObject {

        /**
         * Get IComponent's parent if exist one
         */
        function get parent():IEntity;

        /**
         * Set IComponent's parent
         * @param value
         */
        function set parent(value:IEntity):void;

    }
}
