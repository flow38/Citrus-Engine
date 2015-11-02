package citrus.core {
/**
 * ICitrusObject is simple. Too simple. Despite its simplicity, it is the foundational object that should
 * be used for all game objects logic you create, such as spaceships, enemies, coins, bosses.
 * ICitrusObject is basically an abstract class that gets added to a State instance.
 * The current State calls update on all CitrusObjects. Also, CitrusObjects are useful because they can be
 * initialized with a params object, which can be created via an object parser/factory.
 */
public class CitrusObject implements ICitrusObject{
    /**
     * data used internally
     */
    citrus_internal var data:Object = {ID: 0};
    citrus_internal static var last_id:uint = 0;

    public static var hideParamWarnings:Boolean = false;

    /**
     * A name to identify easily an objet. You may use duplicate name if you wish.
     */
    private var _name:String;

    /**
     * Set it to true if you want to remove, clean and destroy the object.
     */
    private var _kill:Boolean = false;

    /**
     * This property prevent the <code>update</code> method to be called by the enter frame, it will save performances.
     * Set it to true if you want to execute code in the <code>update</code> method.
     */
    private var _updateCallEnabled:Boolean = false;

    /**
     * Added to the CE's render list via the State and the add method.
     */
    private var _type:String = "classicObject";

    protected var _initialized:Boolean = false;
    private var _postInitialized:Boolean = false;
    protected var _ce:CitrusEngine;

    protected var _params:Object;

    /**
     * The time elasped between two update call.
     */
    protected var _timeDelta:Number;

    /**
     * Every Citrus Object needs a name. It helps if it's unique, but it won't blow up if it's not.
     * Also, you can pass parameters into the constructor as well. Hopefully you'll commonly be
     * creating CitrusObjects via an editor, which will parse your shit and create the params object for you.
     * @param name Name your object.
     * @param params Any public properties or setters can be assigned values via this object.
     *
     */
    public function CitrusObject(name:String, params:Object = null)
    {
        this.name = name;

        _ce = CitrusEngine.getInstance();

        _params = params;

        if (params) {
            if (type == "classicObject" && !params["type"])
                initialize();
        } else
            initialize();

        citrus_internal::data.ID = citrus_internal::last_id += 1;
    }

    /**
     * Call in the constructor if the Object is added via the State and the add method.
     * <p>If it's a pool object or an entity initialize it yourself.</p>
     * <p>If it's a component, it should be call by the entity.</p>
     */
    public function initialize(poolObjectParams:Object = null):void
    {

        if (poolObjectParams)
            _params = poolObjectParams;

        if (_params)
            setParams(this, _params);
        else
            _initialized = true;

    }

    /**
     * Post initialization
     * Allow to target specific components or entities without worries about their existence and initialisation state
     *
     * As CitrusObject is not handle via State's add methods, you are responsible for calling postInitialize on all
     * added CitrusObject after having initialized them all !! ;)
     *
     * @param	poolObjectParams
     */
    public function postInitialize(poolObjectParams:Object = null):void
    {
        if(!_initialized){
            throw(new Error('Cannot perform a post initialization on a non initialized object !'));
        }else if(!_postInitialized){
            //do some stuff, get ref to other citrusObject etc...
        }
    }

    /**
     * Clean object in order to reset it with new properties (kind of reboot)
     *
     * Seriously, don't forget to here release your listeners, signals, and physics objects here. Either that or don't ever destroy anything.
     * Your choice.
     *
     * @see destroy
     * @see reset
     */
    protected function clean():void
    {
        _initialized =  false;
        _postInitialized = false;
        _params = null;
    }

    /**
     * Final cause user can do whatever he want via dedicated clean() method.
     *
     * @see clean
     */
    final public function destroy():void
    {
        citrus_internal::data = null;
        clean();
    }

    public function reset(poolObjectParams:Object = null):void
    {
        clean();
        initialize(poolObjectParams);
    }

    /**
     * The current state calls update every tick. This is where all your per-frame logic should go. Set velocities,
     * determine animations, change properties, etc.
     * @param timeDelta This is a ratio explaining the amount of time that passed in relation to the amount of time that
     * was supposed to pass. Multiply your stuff by this value to keep your speeds consistent no matter the frame rate.
     */
    public function update(timeDelta:Number):void
    {
        _timeDelta = timeDelta;
    }

    /**
     * Preprocessing on citrusObject's parameter object
     *
     * Override this method in a child class to handle specific use case relative
     * to its parameters.
     *
     * Example: view component texture is dynamicly created using parameters, texture must created in
     * preprocessParams method
     *
     * @param	params
     * @return  A preprocessed clone of params
     */
    public function preProcessParams(params:Object):Object
    {

    }

    /**
     * The initialize method usually calls this.
     *
     * Note that when CitrusObject's property is an Array, object params relative property can be a String. String will
     * be split using "|"
     */
    protected function setParams(object:Object, params:Object):void
    {
        preProcessParams(params);

        for (var param:String in params)
        {
            try
            {
                if (params[param] == "true")
                    object[param] = true;
                else if (params[param] == "false")
                    object[param] = false;
                else if (object[param] is Array)
                    if(params[param] is String)
                        object[param] = String(params[param]).split('|');
                    else if(params[param] is Array)
                        object[param] = params[param];
                    else
                        throw(new Error("Parameter " + param + "must be an Array or a String (ie: 'valueA|valueB|valueC') !!"));
                else
                    object[param] = params[param];
            }
            catch (e:Error)
            {
                if (!hideParamWarnings)
                    trace("Warning: The parameter " + param + " does not exist on " + this);
            }
        }
        _initialized = true;
    }

    public function get ID():uint
    {
        return citrus_internal::data.ID;
    }

    public function toString():String
    {
        use namespace citrus_internal;

        return String(Object(this).constructor) + " ID:" + (data && data["ID"] ? data.ID : "null") + " name:" + String(name) + " type:" + String(type);
    }

    public function get name():String
    {
        return _name;
    }

    public function set name(value:String):void
    {
        _name = value;
    }

    public function get kill():Boolean
    {
        return _kill;
    }

    public function set kill(value:Boolean):void
    {
        _kill = value;
    }

    public function get updateCallEnabled():Boolean
    {
        return _updateCallEnabled;
    }

    public function set updateCallEnabled(value:Boolean):void
    {
        _updateCallEnabled = value;
    }

    public function get type():String
    {
        return _type;
    }

    public function set type(value:String):void
    {
        _type = value;
    }
}
}