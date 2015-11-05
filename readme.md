Video Framework for Matlab
==========================

This framwork provides the class "VideoFramework" to easily create videos using MATLAB.

Requirements
------------

  * a reasonably recent version of MATLAB
  * [ffmpeg](https://www.ffmpeg.org/)

Features
--------

  * create video with predefined number of frames
  * choose framerate
  * fw/bw/fwbw (forward, backward, forward-backward) mode to create videos in reverse and videos that loop
  * encode using ffmpeg or MATLAB builtin encoder
  * saves individual frames as PNG
  * supports high resolutions

Example usage
-------------
Preview example video and create video files:

	e = ExampleVideo
	e.preview
	e.createVideo

To encode the video without recreating the frames, use 

	e.encode

To make your own video, copy the ExampleVideo class and rename it. Implement general settings and precalculations in init() and the code to draw the n-th frame in drawFrame(). 

License
-------

VideoFrameworkMATLAB is licensed under the GPLv3 license.

Contact
-------

Author: Gerhard Kurz

Mail: gerhard.kurz (at) kit (dot) edu

Web: [http://isas.uka.de/User:Kurz](http://isas.uka.de/User:Kurz)

