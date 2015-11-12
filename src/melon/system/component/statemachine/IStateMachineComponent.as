package melon.system.component.statemachine {

import flash.utils.Dictionary;

import melon.system.IMelonComponent;
import melon.system.component.statemachine.lib.State;

import org.osflash.signals.Signal;

/**
 * Describe a state machine component interface
 * @author ffalcy
 */
public interface IStateMachineComponent extends IMelonComponent {

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
    function addState(stateName : String, stateData : Object = null) : void;


    /**
     * Sets the first state, calls enter callback and dispatches TRANSITION_COMPLETE
     * These will only occour if no state is defined
     * @param stateName    The name of the State
     **/
    function set initialState(stateName : String) : void;

    function get initialState() : String;

    /**
     *    Getters for the current state and for the Dictionary of states
     */
    function get state() : String;

    /**
     *    Getters for the current state and for the Dictionary of states
     */
    function get stateInstance() : State;

    function get states() : Dictionary;

    /**
     * States user can set via component's UI configuration
     * By default all states are settables except AbstractStateMachine's STATE_PAUSE and its parent state STATE_INTERNAL
     *
     * @return settable states's names
     * */
    function get settableStates() : Array;

    /**
     * Get a state named name
     * @param    name
     * @return State|null
     */
    function getStateByName(name : String) : State;

    /**
     * Verifies if a transition can be made from the current state to the state passed as param
     * @param stateName    The name of the State
     * @return boolean
     **/
    function canChangeStateTo(stateName : String) : Boolean;

    /**
     * Discovers the how many "exits" and how many "enters" are there between two
     * given states and returns an array with these two integers
     *
     * @param  stateFrom The state to exit
     * @param  stateTo The state to enter
     * @return Array States 's path
     **/
    function findPath(stateFrom : String, stateTo : String) : Array;

    /**
     * Changes the current state
     * This will only be done if the intended state allows the transition from the current state
     * Changing states will call the exit callback for the exiting state and enter callback for the entering state
     * @param stateTo    The name of the state to transition to
     **/
    function changeState(stateTo : String) : void;

    function get path() : Array;

    function get id() : String;

    /**
     * Signal emettant un StateMachineSignal à chaque fin de changement d'etat
     * @see StateMachineSignal
     */
    function get onStateChangeComplete() : Signal;
}

}