package melon.system.component.statemachine {

import flash.utils.Dictionary;

import melon.system.IMelonComponent;
import melon.system.MelonComponent;
import melon.system.component.statemachine.lib.State;
import melon.system.component.statemachine.lib.StateMachine;
import melon.system.component.statemachine.lib.StateMachineSignal;

import org.osflash.signals.Signal;

/**
 * Component wrapping a state machine
 * @author ffalcy
 */
public class MelonStateMachineComponent extends MelonComponent implements IMelonComponent {
    public static const ID : String = "stateMachine";

    /**
     * STATE MACHINE CONSTANTES
     */
    private static const STATEM_ID : String = "FOO_STATE_MACHINE_ID";

    public static const STATE_PAUSE : String = "STATE_PAUSE";

    /**
     * State machine
     */
    private var _stateM : StateMachine;

    private var _initialState : String;

    public function MelonStateMachineComponent(name : String, params : Object = null)
    {
        super(name, params);
        _stateM = new StateMachine(STATEM_ID);
    }

    /**
     * Ovveride default implementation to avoir destroy() call
     *
     * @param    poolObjectParams
     */
    override public function reset(poolObjectParams : Object = null) : void
    {
        //update initialState property
        setParams(this, poolObjectParams);
    }

    override public function destroy() : void
    {
        _stateM.dispose();
        super.destroy();
    }

    override public function initialize(poolObjectParams : Object = null) : void
    {
        //addState(STATE_INTERNAL, { enter:null, exit: null});
        super.initialize(poolObjectParams);
    }

    /**
     * Adds a new state
     *
     * addState("idle",{enter:onIdle, from:"attack"})
     * addState("attack",{enter:onAttack, from:"idle"})
     * addState("melee attack",{parent:"atack", enter:onMeleeAttack, from:"attack"})
     * addState("smash",{parent:"melle attack", enter:onSmash})
     * addState("punch",{parent:"melle attack", enter:onPunch})
     * addState("missle attack",{parent:"attack", enter:onMissle})
     * addState("die",{enter:onDead, from:"attack", enter:onDie})
     *
     * @param stateName    The name of the new State
     * @param stateData    A hash containing state enter and exit callbacks and allowed states to transition from
     * The "from" property can be a string or and array with the state names or * to allow any transition
     *
     *
     **/
    public final function addState(stateName : String, stateData : Object = null) : void
    {
        _stateM.addState(stateName, stateData);
    }


    /**
     * Sets the first state, calls enter callback and dispatches TRANSITION_COMPLETE
     * These will only occour if no state is defined
     * @param stateName    The name of the State
     **/
    public final function set initialState(stateName : String) : void
    {
        _initialState = stateName;
    }

    public final function get initialState() : String
    {
        return _initialState;
    }

    /**
     *    Getters for the current state
     */
    public final function get state() : String
    {
        return _stateM.state;
    }

    /**
     *    Getters  for the Dictionary of states
     */
    public final function get states() : Dictionary
    {
        return _stateM.states;
    }

    public final function get stateInstance() : State
    {
        var state : State = _stateM.states[_stateM.state] as State;

        return state;
    }

    public final function getStateByName(name : String) : State
    {
        return _stateM.getStateByName(name);
    }

    /**
     * Verifies if a transition can be made from the current state to the state passed as param
     * @param stateName    The name of the State
     **/
    public final function canChangeStateTo(stateName : String) : Boolean
    {
        return _stateM.canChangeStateTo(stateName);
    }

    /**
     * Discovers the how many "exits" and how many "enters" are there between two
     * given states and returns an array with these two integers
     * @param stateFrom The state to exit
     * @param stateTo The state to enter
     **/
    public final function findPath(stateFrom : String, stateTo : String) : Array
    {
        return _stateM.findPath(stateFrom, stateTo);
    }

    /**
     * Changes the current state
     * This will only be done if the intended state allows the transition from the current state
     * Changing states will call the exit callback for the exiting state and enter callback for the entering state
     * @param stateTo    The name of the state to transition to
     **/
    public final function changeState(stateTo : String) : void
    {
        _stateM.changeState(stateTo);
    }

    public final function get path() : Array
    {
        return _stateM.path;
    }

    public final function get transitionDenied() : Signal
    {
        return _stateM.transitionDenied;
    }

    public final function get id() : String
    {
        return _stateM.id;
    }

    public function get onStateChangeComplete() : Signal
    {
        return _stateM.onStateChangeComplete;
    }

    protected function enterState(signal : StateMachineSignal) : void
    {

    }

    protected function exitState(signal : StateMachineSignal) : void
    {

    }


}

}