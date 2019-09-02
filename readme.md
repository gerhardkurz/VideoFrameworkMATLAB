Video Framework for Matlab
==========================

This framework provides the class "VideoFramework" to easily create videos using MATLAB.

Requirements
------------

  * a reasonably recent version of MATLAB
  * [ffmpeg](https://www.ffmpeg.org/)

Features
--------

  * create video with predefined number of frames
  * choose frame rate
  * fw/bw/fwbw (forward, backward, forward-backward) mode to create videos in reverse and videos that loop
  * encode using ffmpeg or MATLAB built-in encoder
  * saves individual frames as PNG
  * supports high resolutions

Example usage
-------------
To preview the example video and create the video files, type the following

	>> e = ExampleVideo
	>> e.preview
	>> e.createVideo

To encode the video without recreating the PNG files, use the command

	>> e.encode

To make your own video, copy the ExampleVideo class and rename it. Implement general settings and precalculations in init() and the code to draw the n-th frame in drawFrame(). The other functions are inherited from the VideoFramework class.

License
-------

VideoFrameworkMATLAB is licensed under the MIT license.

Contact
-------

Author: Gerhard Kurz

Mail: kurz.gerhard (at) gmail (dot) com

Web: [http://www.gerhardkurz.de](http://www.gerhardkurz.de)


