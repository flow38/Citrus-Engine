package melon.system.component.physics.nape {


import citrus.core.CitrusEngine;
import citrus.physics.PhysicsCollisionCategories;
import citrus.physics.nape.INapePhysicsObject;
import citrus.physics.nape.Nape;

import flash.geom.Point;
import flash.utils.Dictionary;

import melon.physics.nape.service.CbTypesManager;
import melon.physics.nape.service.ICbTypesManager;
import melon.physics.nape.service.IMaterialManager;
import melon.physics.nape.service.MaterialManager;
import melon.system.AMelonComponent;

import nape.callbacks.BodyCallback;
import nape.callbacks.InteractionCallback;
import nape.callbacks.PreCallback;
import nape.callbacks.PreFlag;
import nape.constraint.Constraint;
import nape.dynamics.InteractionFilter;
import nape.geom.GeomPoly;
import nape.geom.GeomPolyList;
import nape.geom.Vec2;
import nape.geom.Vec2List;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.phys.Material;
import nape.shape.Circle;
import nape.shape.Polygon;
import nape.shape.Shape;
import nape.shape.ValidationResult;

import org.osflash.signals.Signal;

import starling.utils.deg2rad;
import starling.utils.rad2deg;

/**
 * Mother class of all entities in game
 * @author ffalcy
 */
public class PhysicComponent extends AMelonComponent implements INapePhysicsObject {

    public static const BODY_TYPE_STATIC : String = "STATIC";
    public static const BODY_TYPE_KINEMATIC : String = "KINEMATIC";
    public static const BODY_TYPE_DYNAMIC : String = "DYNAMIC";

    public function PhysicComponent(name : String, params : Object = null)
    {
        _nape = CitrusEngine.getInstance().state.getFirstObjectByType(Nape) as Nape;
        super(name, params);
        sleeping = new Signal(PhysicComponent);
    }

    /**
     * Used to define vertices' x and y points.
     */
    public var points : Vector.<Point>;
    /**
     * Signal dispatch when body is sleeping
     *
     * On Ball Entity, is listen by:
     * - BasePhysicComponent
     * - PhysicDragcomponent
     * - BallStateMachine
     */
    public var sleeping : Signal;
    /**
     * Components dictionary
     */
    public var components : Dictionary;
    protected var _nape : Nape;
    protected var _bodyType : BodyType;
    protected var _shape : Shape;
    protected var _cbTypesManager : ICbTypesManager;
    protected var _materialManager : IMaterialManager;

    protected var _body : Body;

    /**
     * A direct reference to the Nape body associated with this object.
     */
    public function get body() : Body
    {
        return _body;
    }

    public function set body(body : Body) : void
    {
        _body = body;
    }

    protected var _material : Material;

    public function set material(materialID : String) : void
    {
        _material = _materialManager.getMaterial(materialID);
    }

    protected var _density : Number = 1;

    public function get density() : Number
    {
        return _density;
    }

    public function set density(value : Number) : void
    {
        _density = value;
    }

    protected var _cbTypes : Array = [];

    public function get cbTypes() : Array
    {
        return _cbTypes;
    }

    public function set cbTypes(value : Array) : void
    {
        var cbtypes : Array = new Array();
        value.forEach(function (item : *, index : int, array : Array) : void
        {
            cbtypes.push(_cbTypesManager.cbTypesByName(item as String));
        });
        _cbTypes = _cbTypes.concat(cbtypes);
    }

    protected var _x : Number = 0;

    public function get x() : Number
    {
        if (_body) {
            return _body.position.x;
        } else {
            return _x;
        }
    }

    public function set x(value : Number) : void
    {
        _x = value;

        if (_body) {
            var pos : Vec2 = _body.position;
            pos.x = _x;
            _body.position = pos;
        }
    }

    protected var _y : Number = 0;

    public function get y() : Number
    {
        if (_body) {
            return _body.position.y;
        } else {
            return _y;
        }
    }

    public function set y(value : Number) : void
    {
        _y = value;

        if (_body) {
            var pos : Vec2 = _body.position;
            pos.y = _y;
            _body.position = pos;
        }
    }

    /**
     * Physic body rotation un radian
     **/
    protected var _rotation : Number = 0;

    /**
     * @return Physic body rotation in degree
     */
    public function get rotation() : Number
    {
        if (_body) {
            return rad2deg(_body.rotation);
        } else {
            return rad2deg(_rotation);
        }
    }

    /**
     * @param rotation Degree angle
     */
    public function set rotation(value : Number) : void
    {
        _rotation = deg2rad(value % 360);

        if (_body) {
            _body.rotate(new Vec2(_x, _y), _rotation);
        }
    }

    protected var _width : Number = 1;

    /**
     * This can only be set in the constructor parameters.
     */
    public function get width() : Number
    {
        return _width;
    }

    public function set width(value : Number) : void
    {
        _width = value;

        if (_initialized) {
            injector.log.warning(this, "You cannot set " + this + " width after it has been created. Please set it in the constructor.");
        }
    }

    protected var _height : Number = 1;

    /**
     * This can only be set in the constructor parameters.
     */
    public function get height() : Number
    {
        return _height;
    }

    public function set height(value : Number) : void
    {
        _height = value;

        if (_initialized) {
            injector.log.warning(this, "You cannot set " + this + " height after it has been created. Please set it in the constructor.");
        }
    }

    protected var _radius : Number = 0;

    /**
     * This can only be set in the constructor parameters.
     */
    public function get radius() : Number
    {
        return _radius;
    }

    /**
     * The object has a radius or a width and height. It can't have both.
     */
    [Inspectable(defaultValue="0")]
    public function set radius(value : Number) : void
    {
        _radius = value;

        if (_initialized) {
            injector.log.warning(this, "Warning: You cannot set " + this + " radius after it has been created. Please set it in the constructor.");
        }
    }

    /**
     * Collision Interaction mask filter
     * Example:
     * ["Level", "GoodGuys", ...]
     * */
    protected var _collisionGroup : Array = [];

    /**
     * Collision Interaction group filter (to which group body's shape belong)
     * Array's values should be part of AcrossPhysicsCollisionCategories enumeration
     * Example:
     * ["Level", "GoodGuys", ...]
     * */
    public function get collisionGroup() : Array
    {
        return _collisionGroup;
    }

    /**
     * @private
     */
    public function set collisionGroup(value : Array) : void
    {
        _collisionGroup = value;
    }

    protected var _collisionMask : Array = [];

    public function get collisionMask() : Array
    {
        return _collisionMask;
    }

    public function set collisionMask(value : Array) : void
    {
        _collisionMask = value;
    }

    protected var _sensorGroup : Array = [];

    public function get sensorGroup() : Array
    {
        return _sensorGroup;
    }

    public function set sensorGroup(value : Array) : void
    {
        _sensorGroup = value;
    }

    protected var _sensorMask : Array = [];

    /**
     * Sensor Interaction mask filter
     * Array's values should be part of AcrossPhysicsCollisionCategories enumeration
     * Example:
     * ["Level", "GoodGuys", ...]
     * */
    public function get sensorMask() : Array
    {
        return _sensorMask;
    }

    /**
     * @private
     */
    public function set sensorMask(value : Array) : void
    {
        _sensorMask = value;
    }

    protected var _fluidGroup : Array = [];

    public function get fluidGroup() : Array
    {
        return _fluidGroup;
    }

    public function set fluidGroup(value : Array) : void
    {
        _fluidGroup = value;
    }

    protected var _fluidMask : Array = [];

    /**
     * Fluid Interaction mask filter
     * Array's values should be part of AcrossPhysicsCollisionCategories enumeration
     * Example:
     * ["Level", "GoodGuys", ...]
     * */
    public function get fluidMask() : Array
    {
        return _fluidMask;
    }

    /**
     * @private
     */
    public function set fluidMask(value : Array) : void
    {
        _fluidMask = value;
    }

    protected var _allowRotation : Boolean = true;

    public function get allowRotation() : Boolean
    {
        return _allowRotation;
    }

    public function set allowRotation(value : Boolean) : void
    {
        _allowRotation = value;
    }

    protected var _allowMovement : Boolean = true;

    public function get allowMovement() : Boolean
    {
        return _allowMovement;
    }

    public function set allowMovement(value : Boolean) : void
    {
        _allowMovement = value;
    }

    protected var _beginContactCallEnabled : Boolean = false;

    /**
     * This flag determines if the <code>handleBeginContact</code> method is called or not. Default is false, it saves some performances.
     */
    public function get beginContactCallEnabled() : Boolean
    {
        return _beginContactCallEnabled;
    }

    /**
     * Enable or disable the <code>handleBeginContact</code> method to be called. It doesn't change physics behavior.
     */
    public function set beginContactCallEnabled(beginContactCallEnabled : Boolean) : void
    {
        _beginContactCallEnabled = beginContactCallEnabled;
    }

    protected var _endContactCallEnabled : Boolean = false;

    /**
     * This flag determines if the <code>handleEndContact</code> method is called or not. Default is false, it saves some performances.
     */
    public function get endContactCallEnabled() : Boolean
    {
        return _endContactCallEnabled;
    }

    /**
     * Enable or disable the <code>handleEndContact</code> method to be called. It doesn't change physics behavior.
     */
    public function set endContactCallEnabled(endContactCallEnabled : Boolean) : void
    {
        _endContactCallEnabled = endContactCallEnabled;
    }

    /**
     * Entity body's type
     * STATIC| KINEMATIC | DYNAMIC
     */
    protected var _bodyTypeStr : String = BODY_TYPE_STATIC;

    public function get bodyTypeStr() : String
    {
        return _bodyTypeStr;
    }

    public function set bodyTypeStr(value : String) : void
    {
        _bodyTypeStr = value;
    }

    public function get z() : Number
    {
        return 0;
    }

    /**
     * No depth in a 2D Physics world.
     */
    public function get depth() : Number
    {
        return 0;
    }

    public function get velocity() : Array
    {
        return [_body.velocity.x, _body.velocity.y, 0];
    }

    public function set velocity(value : Array) : void
    {
        _body.velocity.setxy(value[0], value[1]);
    }

    override public function initialize(poolObjectParams : Object = null) : void
    {

        super.initialize(poolObjectParams);
        _cbTypesManager = injector.service(CbTypesManager.NAME) as ICbTypesManager;
        _materialManager = injector.service(MaterialManager.NAME) as MaterialManager
        if (!_nape) {
            throw new Error("Cannot create a NapePhysicsObject when a Nape object has not been added to the state.");
        }

        //Override these to customize your Nape initialization. Things must be done in this order.
        defineBody();
        createBody();
        createMaterial();
        createShape();
        createFilter();
        createConstraint();
    }

    /**
     * Override default behavior to avoid sleeping Signal destroy
     **/
    override protected function clean() : void
    {
        //Keep reference to original sleeping Signal instance
        var sleepingBackup : Signal = sleeping;
        //Replace sleeping with a new Signal(on which destroy will apply a removeAllListener
        sleeping = new Signal();
        super.clean();
        //Restore original sleeping Signal instance
        sleeping = sleepingBackup;
    }

    override public function destroy() : void
    {
        killBody();
        cbTypes.splice(0, cbTypes.length);
        if (points) {
            points.splice(0, points.length);
        }
        sleeping.removeAll();
        super.destroy();
    }

    override public function setParams(object : Object, params : Object) : void
    {
        super.setParams(object, params);

        if (_radius != 0) {
            _width = _height = _radius * 2;
        } else {
            _width = _width;
            _height = _height;
        }
    }

    /**
     * This method doesn't depend of your application enter frame. Ideally, the time between two calls never change.
     * In this method you will apply any velocity/force logic.
     */
    public function fixedUpdate() : void
    {

    }

    /**
     * Used for abstraction on body. There is also a getter on the body defined by each engine to keep body's type.
     */
    public function getBody() : *
    {
        return null;
    }

    /**
     * Nape Sleeping event handler
     */
    public function handleSleep(callback : BodyCallback) : void
    {
        sleeping.dispatch(this);
    }

    /**
     *
     *    Methods introduce in CitrusEngine 3.7....not use in Across but keep
     * theme to futur ce analyzis
     *
     **/

    public function handlePreContact(callback : PreCallback) : PreFlag
    {
        return PreFlag.ACCEPT;
    }

    /**
     * Override this method to handle the begin contact collision.
     */
    public function handleBeginContact(callback : InteractionCallback) : void
    {
    }

    /**
     * Override this method to handle the end contact collision.
     */
    public function handleEndContact(callback : InteractionCallback) : void
    {
    }

    /**
     * This method will often need to be overriden to provide additional definition to the Nape body object.
     */
    protected function defineBody() : void
    {
        switch (this._bodyTypeStr) {
            case BODY_TYPE_DYNAMIC:
                _bodyType = BodyType.DYNAMIC;
                break;
            case BODY_TYPE_KINEMATIC:
                _bodyType = BodyType.KINEMATIC;
                break;
            case BODY_TYPE_STATIC :
                _bodyType = BodyType.STATIC;
                break;
            default:
                throw new Error("Unknown Nape Body Type " + this._bodyTypeStr + " !!");
        }
    }

    /**
     * Nape Body instanciation
     */
    protected function createBody() : void
    {
        var pos : Vec2 = new Vec2(_x, _y);
        _body = new Body(_bodyType, pos);
        injector.log.info(this, "******createBody******* >>" + _body.id + " " + parent.name);
        _body.rotate(pos, _rotation);
        _body.userData.myData = this;
        _body.allowMovement = _allowMovement;
        _body.allowRotation = _allowRotation;
    }

    /**
     * This method will often need to be overriden to customize the Nape material object.
     */
    protected function createMaterial() : void
    {
        if (!_material) {
            _material = new Material(0.85, 1, 2, _density, 0.005);
        }
        //_material = new Material(0.2,0.57,0.74,7.8,0.0005);
        //throw new Error("Material must be set at concrete object !!");
        //_material = new Material(0.2, 1, 1, 1, 0);
    }

    /**
     * This method will often need to be overriden to customize the Nape shape object.
     * The PhysicsObject creates a rectangle by default if the radius it not defined, but you can replace this method's
     * definition and instead create a custom shape, such as a line or circle.
     */
    protected function createShape() : void
    {
        if (points && points.length > 1) {

            var verts : Vec2List = new Vec2List();

            for each (var point : Object in points)
                verts.push(new Vec2(point.x as Number, point.y as Number));

            var polygon : Polygon = new Polygon(verts, _material);
            var validation : ValidationResult = polygon.validity();

            if (validation == ValidationResult.VALID) {
                _shape = polygon;
                _body.shapes.add(_shape);
            } else if (validation == ValidationResult.CONCAVE) {

                var concave : GeomPoly = new GeomPoly(verts);
                var convex : GeomPolyList = concave.convexDecomposition();
                convex.foreach(function (p : GeomPoly) : void
                {
                    _body.shapes.add(new Polygon(p));
                });
                return;

            } else {
                throw new Error("Invalid polygon/polyline");
            }

        } else {

            if (_radius != 0) {
                _shape = new Circle(_radius, null, _material);
            } else {
                _shape = new Polygon(Polygon.box(_width, _height), _material);
            }

            _body.shapes.add(_shape);
        }

    }

    /**
     * This method will often need to be overriden to customize the Nape filter object.
     */
    protected function createFilter() : void
    {
        var collisionGroup : uint = PhysicsCollisionCategories.Get.apply(null, _collisionGroup);
        var collisionMask : uint = _collisionMask.length != 0 ? PhysicsCollisionCategories.Get.apply(null, _collisionMask) : PhysicsCollisionCategories.GetAll();

        var sensorGroup : uint = PhysicsCollisionCategories.Get.apply(null, _sensorGroup);
        var sensorMask : uint = _sensorMask.length != 0 ? PhysicsCollisionCategories.Get.apply(null, _sensorMask) : PhysicsCollisionCategories.GetAll();

        var fluidGroup : uint = PhysicsCollisionCategories.Get.apply(null, _fluidGroup);
        var fluidMask : uint = _fluidMask.length != 0 ? PhysicsCollisionCategories.Get.apply(null, _fluidMask) : PhysicsCollisionCategories.GetAll();

        _body.setShapeFilters(new InteractionFilter(collisionGroup, collisionMask, sensorGroup, sensorMask, fluidGroup, fluidMask));
    }

    /**
     * Method to handle body's cbTypes
     *
     * cbTypes entities setting are handle via AcrossEntityFactotry.setNapeCBTypes method.
     * TileMapRenderer's Tile cbTypes is set via its MacroEntity, see WallMap example
     *
     * params.physics.cbTypes = CbTypesEnum.PHYSICS_OBJECT + '|' + CbTypesEnum.BREAKABLE_OBJECT;
     **/
    protected function createConstraint() : void
    {
        _body.space = _nape.space;
        //Store nape'space to handle enable/disable physic by component's entity
        _body.userData.space = _nape.space;
        var _l : Number = _cbTypes.length;
        for (var i : int = 0; i < _l; i++) {
            //trace("		Add CbType ", _cbTypes[i].id);
            _body.cbTypes.add(_cbTypes[i]);
        }
    }

    /**
     * Destroy Nape body
     *
     * No need to check if body exist before calling this method
     */
    private function killBody() : void
    {
        if (body != null) {
            //Clear all body's cbTypes to avoid any futur collision detection
            if (_body.cbTypes.length > 0) {
                _body.cbTypes.clear();
            }
            //disable all existant constraint on body
            _body.constraints.foreach(function (obj : Constraint) : void
            {
                obj.active = false;
                obj.space = null;
            });
            delete _body.userData.myData;
            delete _body.userData.space;
            _nape.space.bodies.remove(_body);
        }

    }


}

}