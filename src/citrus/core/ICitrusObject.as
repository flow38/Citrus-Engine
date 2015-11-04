package citrus.core {
    /**
     * ICitrusObject is simple. Too simple. Despite its simplicity, it is the foundational object that should
     * be used for all game objects logic you create, such as spaceships, enemies, coins, bosses.
     * ICitrusObject is basically an abstract class that gets added to a State instance.
     * The current State calls update on all CitrusObjects. Also, CitrusObjects are useful because they can be
     * initialized with a params object, which can be created via an object parser/factory.
     */
    public interface ICitrusObject {


        /**
         * Call in the constructor if the Object is added via the State and the add method.
         * <p>If it's a pool object or an entity initialize it yourself.</p>
         * <p>If it's a component, it should be call by the entity.</p>
         */
        function initialize(poolObjectParams:Object = null):void;

        /**
         * Seriously, dont' forget to release your listeners, signals, and physics objects here. Either that or don't ever destroy anything.
         * Your choice.
         */
        function destroy():void;

        /**
         * The current state calls update every tick. This is where all your per-frame logic should go. Set velocities,
         * determine animations, change properties, etc.
         * @param timeDelta This is a ratio explaining the amount of time that passed in relation to the amount of time that
         * was supposed to pass. Multiply your stuff by this value to keep your speeds consistent no matter the frame rate.
         */
        function update(timeDelta:Number):void;

        function get ID():uint;

        function toString():String;

        function get name():String;

        function set name(value:String):void;

        function get kill():Boolean;

        function set kill(value:Boolean):void;

        function get updateCallEnabled():Boolean;

        function set updateCallEnabled(value:Boolean):void;

        function get type():String;

        function set type(value:String):void;
    }
}