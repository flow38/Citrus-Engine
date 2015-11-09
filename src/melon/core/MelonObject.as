package melon.core {
import citrus.core.CitrusObject;

import melon.injector.IDepenciesInjector;

public class MelonObject extends CitrusObject implements IMelonObject {

    public function MelonObject(name : String, params : Object = null)
    {
        super(name, params);
    }

    private var _postInitialized : Boolean = false;

    private var _injector : IDepenciesInjector;

    public function get injector() : IDepenciesInjector
    {
        return _injector;
    }

    public function set injector(value : IDepenciesInjector) : void
    {
        _injector = value;
    }

    /**
     * Should never be override except for in composite pattern(IEntity), instead you can do whatever you want via clean() method.
     *
     * @see clean
     */
    override public function destroy() : void
    {
        data = null;
        clean();
    }

    /**
     * The current state calls update every tick. This is where all your per-frame logic should go. Set velocities,
     * determine animations, change properties, etc.
     * @param timeDelta This is a ratio explaining the amount of time that passed in relation to the amount of time that
     * was supposed to pass. Multiply your stuff by this value to keep your speeds consistent no matter the frame rate.
     */
    override public function update(timeDelta : Number) : void
    {
        _timeDelta = timeDelta;
    }

    /**
     * The initialize method usually calls this.
     *
     * Note that when CitrusObject's property is an Array, object params relative property can be a String. String will
     * be split using "|"
     */
    override public function setParams(object : Object, params : Object) : void
    {
        preProcessParams(params);

        for (var param : String in params) {
            try {
                if (params[param] == "true") {
                    object[param] = true;
                } else if (params[param] == "false") {
                    object[param] = false;
                } else if (object[param] is Array) {
                    if (params[param] is String) {
                        object[param] = String(params[param]).split('|');
                    } else if (params[param] is Array) {
                        object[param] = params[param];
                    } else {
                        throw(new Error("Parameter " + param + "must be an Array or a String (ie: 'valueA|valueB|valueC') !!"));
                    }
                } else {
                    object[param] = params[param];
                }
            }
            catch (e : Error) {
                if (!hideParamWarnings) {
                    trace("Warning: The parameter " + param + " does not exist on " + this);
                }
            }
        }
        _initialized = true;
    }

    /**
     * Post initialization
     *
     * Call on all citrusObject added to current citrusEngine's state on state comit.
     *
     * Allow to target specific components or entities without worries about their existence and initialisation state
     *
     * As CitrusObject is not handle via State's add methods, you are responsible for calling postInitialize on all
     * added CitrusObject after having initialized them all !! ;)
     *
     * @param    poolObjectParams
     */
    public function postInitialize(poolObjectParams : Object = null) : void
    {
        if (!_initialized) {
            throw(new Error('Cannot perform a post initialization on a non initialized object !'));
        } else if (!_postInitialized) {
            //First post initialization, do some stuff, get ref to other citrusObject etc...
        } else {
            //Not first initialization
        }
    }

    /**
     *  Should never be override (you could broke object life cycle handling)
     * @param poolObjectParams
     */
    public function reset(poolObjectParams : Object = null) : void
    {
        clean();
        initialize(poolObjectParams);
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
     * @param    params
     * @return  A preprocessed clone of params
     */
    public function preProcessParams(params : Object) : Object
    {
        return params;
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
    protected function clean() : void
    {
        _initialized = false;
        _postInitialized = false;
        _params = null;
        _injector = null;
    }
}
}
