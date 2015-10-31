/**
 *  @author Florent Falcy
 */
package citrus.system {
    import citrus.core.ICitrusObject;
    import citrus.system.IComposite;

    public interface IComponent extends ICitrusObject {

        /**
         * Get IComponent's parent if exist one
         */
        function get parent():IComposite;

        /**
         * Set IComponent's parent
         * @param value
         */
        function set parent(value:IComposite):void;

    }
}
