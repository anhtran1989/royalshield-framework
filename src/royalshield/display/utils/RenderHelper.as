package royalshield.display.utils
{
    import royalshield.entities.GameObject;
    
    public class RenderHelper
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        public var object:GameObject;
        public var offsetX:int;
        public var offsetY:int;
        public var x:int;
        public var y:int;
        public var z:int;
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function RenderHelper(object:GameObject = null, offsetX:int = 0, offsetY:int = 0, x:int = 0, y:int = 0, z:int = 0)
        {
            this.object = object;
            this.offsetX = offsetX;
            this.offsetY = offsetY;
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
        
        public function update(object:GameObject = null, offsetX:int = 0, offsetY:int = 0, x:int = 0, y:int = 0):RenderHelper
        {
            this.object = object;
            this.offsetX = offsetX;
            this.offsetY = offsetY;
            this.x = x;
            this.y = y;
            this.z = z;
            return this;
        }
        
        public function setFrom(input:RenderHelper):RenderHelper
        {
            this.object = input.object;
            this.offsetX = input.offsetX;
            this.offsetY = input.offsetY;
            this.x = input.x;
            this.y = input.y;
            this.z = input.z;
            return this;
        }
    }
}
