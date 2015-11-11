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
            % Runs the video, but does not save anything
            this.projectName = class(this);
            this.init();
            this.runVideo(false);
        end
        
        function createVideo(this)
            % Runs the video, saves frames as PNG, and encodes them as video files
            this.projectName = class(this);
            this.init();
            [~,~,~] = mkdir(this.projectName);
            this.runVideo(true);
            this.encode();
        end
        
        function encode(this)
            % Encodes the PNG frames as a video.
            this.projectName = class(this);
            cd(this.projectName)
            try
                % MATLAB encoder
                this.encodeMatlab();
                
                % ffmpeg
                % -y 
                %   Overwrite output files without asking. 
                % -f image2 -framerate %i -i %%06d.png 
                %   read consecutively numbered images with 6 digits, use
                %   user-defined framerate
                % -vf crop=in_w-1:in_h-1
                %   crop 1 pixel because PNGs have odd number of pixels
                % -b 2000k
                %   bitrate (2000k = 2MBit/s)
                % -qscale 1
                %   highest quality
                
                % best version (h264)
                system(sprintf('ffmpeg -y -f image2 -framerate %i -i %%06d.png -vcodec libx264 -vf crop=in_w-1:in_h-1 output.mp4', this.framerate));
                
                % h264 for Powerpoint
                % https://msdn.microsoft.com/de-de/library/windows/desktop/dd797815%28v=vs.85%29.aspx
                % maximum resolution is 1920 x 1088 pixels, thus we use 720p
                % only supports yuv420p pixel format
                system(sprintf('ffmpeg -y -f image2 -framerate %i -i %%06d.png -vcodec libx264 -pix_fmt yuv420p -vf crop="in_w-1:in_h-1, scale=-1:720" output-ppt.mp4', this.framerate));
                
                % wmv for Powerpoint, different resolutions, needs higher
                % bitrate than h264
                system(sprintf('ffmpeg -y -f image2 -framerate %i -i %%06d.png -vf crop=in_w-1:in_h-1 -b 3000k -qscale 1 output.wmv', this.framerate));
                system(sprintf('ffmpeg -y -f image2 -framerate %i -i %%06d.png -vf crop="in_w-1:in_h-1, scale=-1:720" -b 2000k -qscale 1 output-720p.wmv', this.framerate));
                system(sprintf('ffmpeg -y -f image2 -framerate %i -i %%06d.png -vf crop="in_w-1:in_h-1, scale=-1:480" -b 1500k -qscale 1 output-480p.wmv', this.framerate));
            catch ex
                ex
            end
            cd('..')
        end
        
    end
    
	methods (Access = private)
        function encodeMatlab(this)
            if ispc || ismac
                vw = VideoWriter('output-matlab','MPEG-4');
            else
                % MATLAB on Linux does not support MPEG-4
                vw = VideoWriter('output-matlab.avi');
            end
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

