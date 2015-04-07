package royalshield.graphics
{
    import flash.display.BitmapData;
    import flash.filters.BitmapFilterQuality;
    import flash.filters.GlowFilter;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    
    import royalshield.core.RoyalShield;
    import royalshield.display.GameCanvas;
    
    public class TextualEffect extends Effect
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        protected var m_text:String;
        protected var m_color:uint;
        protected var m_lastChange:Number;
        protected var m_bitmap:BitmapData;
        protected var m_width:uint;
        protected var m_height:uint;
        
        //--------------------------------------
        // Getters / Setters
        //--------------------------------------
        
        public function get text():String { return m_text; }
        public function get color():uint { return m_color; }
        public function get width():uint { return m_width; }
        public function get height():uint { return m_height; }
        public function get bitmap():BitmapData { return m_bitmap; }
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function TextualEffect()
        {
            super(null);
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function drawText():void
        {
            s_format.color = m_color;
            s_field.text = m_text;
            s_field.setTextFormat(s_format);
            
            m_width = s_field.width;
            m_height = s_field.height;
            
            if (!m_bitmap || m_bitmap.width != m_width || m_bitmap.height != m_height) {
                if (m_bitmap)
                    m_bitmap.dispose();
                
                m_bitmap = new BitmapData(m_width, m_height, true, 0);
            }
            m_bitmap.draw(s_field);
        }
        
        public function merge(effect:TextualEffect):Boolean
        {
            if (effect && effect.m_frame <= 0 && m_frame <= 0 && effect.m_color == m_color) {
                m_text += effect.text;
                drawText();
                return true;
            }
            return false;
        }
        
        public function setProperties(color:int, value:String):void
        {
            m_color = color;
            m_text = value;
            m_lastChange = RoyalShield.getElapsedTime();
            m_frame = 0;
            drawText();
        }
        
        //--------------------------------------
        // Override Public
        //--------------------------------------
        
        override public function update(elapsedTime:Number):Boolean
        {
            var timeDiff:Number = elapsedTime - m_lastChange;
            timeDiff = timeDiff < 0 ? -timeDiff : timeDiff;
            
            var elapsed:int = int(timeDiff / FRAME_DURATION);
            m_frame += elapsed;
            m_lastChange += elapsed * FRAME_DURATION;
            return (m_frame >= TICKS);
        }
        
        override public function render(canvas:GameCanvas, pointX:int, pointY:int, patternX:int = 0, patternY:int = 0, patternZ:int = 0):void
        {
            // Unused
        }
        
        override public function destroy():void
        {
            super.destroy();
            
            if (m_bitmap)
                m_bitmap.dispose();
            
            m_bitmap = null;
        }
        
        //--------------------------------------
        // Override Internal
        //--------------------------------------
        
        override internal function setGraphicType(type:GraphicType):void
        {
            ////
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        static protected const FRAME_DURATION:uint = 100;
        static protected const TICKS:int = 10;
        
        static private var s_format:TextFormat;
        static private var s_field:TextField;
        
        static private function initializeTextField():void
        {
            s_format = new TextFormat("Arial", 12, 0, true);
            s_field = new TextField();
            s_field.autoSize = TextFieldAutoSize.LEFT;
            s_field.defaultTextFormat = s_format;
            s_field.filters = [new GlowFilter(0, 1, 2, 2, 4, BitmapFilterQuality.MEDIUM, false, false)];
        }
        
        initializeTextField();
    }
}
