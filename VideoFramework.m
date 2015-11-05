classdef VideoFramework < handle
    % Framework for creating videos.
    %
    % Gerhard Kurz, GPLv3
    %
    % Example usage: 
    %   e = ExampleVideo
    %   e.preview
    %   e.createVideo
    
    properties
        totalFrames = 100;
        framerate = 30;
        projectName = '';
        mode = 'fw' %supported modes are fw, bw and fwbw
    end
    
    methods
        function preview(this)
            this.projectName = class(this);
            this.init();
            this.runVideo(false);
        end
        
        function createVideo(this)
            this.projectName = class(this);
            this.init();
            [~,~,~] = mkdir(this.projectName);
            this.runVideo(true);
            this.encode();
        end
        
        function encode(this)
            this.projectName = class(this);
            cd(this.projectName)
            this.encodeMatlab();
            system(sprintf('ffmpeg -y -f image2 -framerate %i -i %%06d.png -vcodec libx264 -vf crop=in_w-1:in_h output.mp4', this.framerate));
            system(sprintf('ffmpeg -y -f image2 -framerate %i -i %%06d.png -vf crop=in_w-1:in_h -b 3000k -qscale 1 output.wmv', this.framerate));
            system(sprintf('ffmpeg -y -f image2 -framerate %i -i %%06d.png -vf crop="in_w-1:in_h, scale=-1:720" -b 2000k -qscale 1 output-720p.wmv', this.framerate));
            system(sprintf('ffmpeg -y -f image2 -framerate %i -i %%06d.png -vf crop="in_w-1:in_h, scale=-1:480" -b 1500k -qscale 1 output-480p.wmv', this.framerate));
            cd('..')
        end
        
    end
    
	methods (Access = private)
        function encodeMatlab(this)
            vw = VideoWriter('output-matlab','MPEG-4');
            vw.Quality = 100;
            vw.FrameRate = this.framerate;
            vw.open()
            n = 1;
            while true
                filename = sprintf('%06d.png', n);
                if ~exist(filename,'file')
                    break
                end
                img1 = imread(filename);
                img2 = imresize(img1, min(1088/size(img1,1),1920/size(img1,2)) ); %resize image to be no larger than 1088 x 1920
                img3 = padarray(img2, mod([size(img2,1), size(img2,2)] ,4), 'replicate', 'post'); % pad to make size divisble by four
                vw.writeVideo(img3);
                n = n+1;
            end
            vw.close()
        end
        
        function runVideo(this, saveImages)
            n=0;
            if strcmp(this.mode,'fw') || strcmp(this.mode,'fwbw')
                for i=1:this.totalFrames
                    fprintf('frame %06d/%06d\n', i, this.totalFrames);
                    f1 = figure(1);
                    this.drawFrame(i);
                    if saveImages
                        n=n+1;
                        VideoFramework.saveFigure(f1, [this.projectName sprintf('/%06d', n)]);
                    end
                end            
            end
            if strcmp(this.mode,'bw') || strcmp(this.mode,'fwbw')
                for i=this.totalFrames:-1:1
                    fprintf('frame %06d/%06d\n', i, this.totalFrames);
                    f1 = figure(1);
                    this.drawFrame(i);
                    if saveImages
                        n=n+1;
                        VideoFramework.saveFigure(f1, [this.projectName sprintf('/%06d', n)]);
                    end
                end            
            end
        end
    end
        
    methods (Abstract)
        init(this)
        drawFrame(this, nr)
    end
    
    methods (Static)
        %saves the given figure as a PNG/EPS files
        function saveFigure(fig, filename)
            %preserve old settings
            oldscreenunits = get(fig,'Units');
            oldpaperunits = get(fig,'PaperUnits');
            oldpaperpos = get(fig,'PaperPosition');

            %change settings before saving
            set(fig,'Units','pixels');
            scrpos = get(fig,'Position');
            newpos = scrpos/110;
            set(fig,'PaperUnits','inches',...
            'PaperPosition',newpos)

            %save file
            %print(fig,'-dpng', [filename '.png'], '-r300', '-painters');
            print(fig,'-dpng', [filename '.png'], '-r300');

            %restore old settings
            set(fig,'Units',oldscreenunits,...
            'PaperUnits',oldpaperunits,...
            'PaperPosition',oldpaperpos)
        end
        
    end
end

