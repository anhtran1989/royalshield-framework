package royalshield.animators
{
    import royalshield.animators.utils.FrameDuration;
    import royalshield.graphics.IUpdatable;
    
    public class Animator implements IUpdatable
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        private var m_frameCount:uint;
        private var m_loopCount:int;
        private var m_startFrame:uint;
        private var m_durations:Vector.<FrameDuration>;
        private var m_currentFrame:uint;
        private var m_currentLoop:uint;
        private var m_currentDirection:uint;
        private var m_currentFrameDuration:uint;
        private var m_lastTime:Number;
        private var m_isComplete:Boolean;
        
        //--------------------------------------
        // Getters / Setters 
        //--------------------------------------
        
        public function get frameCount():uint { return m_frameCount; }
        public function get loopCount():uint { return m_loopCount; }
        public function get startFrame():uint { return m_startFrame; }
        public function get currentFrame():uint { return m_currentFrame; }
        public function get currentLoop():uint { return m_currentLoop; }
        public function get currentDirection():uint { return m_currentDirection; }
        public function get isPingPongAnimation():Boolean { return (m_loopCount == -1); }
        public function get isComplete():Boolean { return m_isComplete; }
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function Animator(frameCount:uint, loopCount:int, startFrame:uint, durations:Vector.<FrameDuration>)
        {
            m_frameCount = frameCount;
            m_loopCount = loopCount;
            m_startFrame = startFrame;
            m_durations = durations;
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function update(time:Number):Boolean
        {
            if (time != m_lastTime && !m_isComplete) {
                var elapsed:Number = time - m_lastTime;
                if (elapsed >= m_currentFrameDuration) {
                    var frame:uint = (m_loopCount == -1) ? getPingPongFrame() : getLoopFrame();
                    if (m_currentFrame != frame) {
                        var duration:int = m_durations[frame].duration - (elapsed - m_currentFrameDuration);
                        m_currentFrame = frame;
                        m_currentFrameDuration = duration < 0 ? 0 : duration;
                    } else
                        m_isComplete = true;
                } else
                    m_currentFrameDuration = m_currentFrameDuration - elapsed;
                
                m_lastTime = time;
            }
            return false;
        }
        
        public function reset():void
        {
            m_currentFrame = m_startFrame;
            m_currentLoop = 0;
            m_currentDirection = FORWARD;
            m_isComplete = false;
        }
        
        public function clone():Animator
        {
            var durations:Vector.<FrameDuration> = new Vector.<FrameDuration>(m_frameCount, true);
            for (var i:uint = 0; i < m_frameCount; i++)
                durations[i] = m_durations[i].clone();
            
            return new Animator(m_frameCount, m_loopCount, m_startFrame, durations);
        }
        
        //--------------------------------------
        // Private
        //--------------------------------------
        
        private function getLoopFrame():uint
        {
            var nextFrame:uint = (m_currentFrame + 1);
            if (nextFrame < m_frameCount)
                return nextFrame;
            
            if (loopCount == 0)
                return 0;
            
            if (m_currentLoop < (loopCount - 1)) {
                m_currentLoop++;
                return 0;
            }
            return m_currentFrame;
        }
        
        private function getPingPongFrame():uint
        {
            var count:int = m_currentDirection == FORWARD ? 1 : -1;
            var nextFrame:int = m_currentFrame + count;
            if (m_currentFrame + count < 0 || nextFrame >= m_frameCount) {
                m_currentDirection = m_currentDirection == FORWARD ? BACKWARD : FORWARD;
                count *= -1;
            }
            return m_currentFrame + count;
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        static public const FORWARD:uint = 0;
        static public const BACKWARD:uint = 1;
    }
}
