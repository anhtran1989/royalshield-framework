package royalshield.geom
{
    public class Position
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        public var x:uint;
        public var y:uint;
        public var z:uint;
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function Position(x:uint = 0, y:uint = 0, z:uint = 0)
        {
            this.x = x;
            this.y = y;
            this.z = z;
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function toString():String
        {
            return "(x:" + this.x + ", y:" + this.y + ", z:" + this.z + ")";
        }
        
        public function equals(position:Position):Boolean
        {
            return (position.x == this.x && position.y == this.y && position.z == this.z);
        }
        
        public function isZero():Boolean
        {
            return (this.x == 0 && this.y == 0 && this.z == 0);
        }
        
        public function setTo(x:uint, y:uint, z:uint):Position
        {
            this.x = x;
            this.y = y;
            this.z = z;
            return this;
        }
        
        public function setFrom(position:Position):Position
        {
            this.x = position.x;
            this.y = position.y;
            this.z = position.z;
            return this;
        }
        
        public function setEmpty():Position
        {
            this.x = 0;
            this.y = 0;
            this.z = 0;
            return this;
        }
        
        public function clone():Position
        {
            return new Position(this.x, this.y, this.z);
        }
    }
}
