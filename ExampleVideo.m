classdef ExampleVideo < VideoFramework   
    properties
    end
    
    methods
        function init(this)
            this.totalFrames = 50;
        end
        
        function drawFrame(this, nr)
            x=0:0.1:10;
            plot(x, sin(0.1*nr+x));
            xlabel('x')
            ylabel('f(x)')
            drawnow
        end
    end
    
end

