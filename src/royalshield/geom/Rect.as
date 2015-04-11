package royalshield.geom
{
    import flash.geom.Rectangle;

    public class Rect
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        public var x:int;
        public var y:int;
        public var width:int;
        public var height:int;
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function Rect(x:int = 0, y:int = 0, width:int = 0, height:int = 0)
        {
            this.x = x;
            this.y = y;
            this.width = width;
            this.height = height;
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function toString():String
        {
            return "(x:" + this.x + ", y:" + this.y + ", width:" + this.width + ", height:" + this.height + ")";
        }
        
        public function equals(rect:Rect):Boolean
        {
            return (rect.x == this.x && rect.y == this.y && rect.width == this.width && rect.height == this.height);
        }
        
        public function isZero():Boolean
        {
            return (this.x == 0 && this.y == 0 && this.width == 0 && this.height == 0);
        }
        
        public function setTo(x:int, y:int, width:int, height:int):Rect
        {
            this.x = x;
            this.y = y;
            this.width = width;
            this.height = height;
            return this;
        }
        
        public function setFrom(rect:Rect):Rect
        {
            this.x = rect.x;
            this.y = rect.y;
            this.width = rect.width;
            this.height = rect.height;
            return this;
        }
        
        public function setEmpty():Rect
        {
            this.x = 0;
            this.y = 0;
            this.width = 0;
            this.height = 0;
            return this;
        }
        
        public function copyToFlashRectangle(rectangle:Rectangle):Rectangle
        {
            rectangle.setTo(this.x, this.y, this.width, this.height);
            return rectangle;
        }
        
        public function clone():Rect
        {
            return new Rect(this.x, this.y, this.width, this.height);
        }
    }
}
