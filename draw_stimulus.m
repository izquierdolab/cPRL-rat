function draw_stimulus(w, tilt, coords)
% Draw a center gabor filter
%   w: the windowId
%   tilt: angle of the gabor filter
%   coords: contain position and size information

global setup
nonsymmetric = 0;

% Octave's new plotting backend 'fltk' interferes with Screen(),
% due to internal use of OpenGL. Problem is it changes the
% bound OpenGL rendering context behind our back and we
% don't protect ourselves against this yet. Switch plotting backend
% to good'ol gnuplot to work around this issue until we fix it properly
% inside Screen():
if IsOctave && exist('graphics_toolkit')
    graphics_toolkit ('gnuplot');
end

% Default settings, and unit color range:
PsychDefaultSetup(2);

% Fill proper background color
Screen('FillRect',w,setup.bgdColor);

% Initial stimulus parameters for the gabor patch
% nDiameter = 323;                 % size of patch
nDiameter = setup.gaborSize;
res = 1*[nDiameter nDiameter];     % [width,height]
phase = 0;                         % no effect?
sig = 20.0;                        % size of Gaussian blur
freq = .04;                        % number of cycles per pixel?
contrast = 100.0; 
aspectratio = 2.0;                 % no effect
modulatecolor = [];   % [255 0 0]; % red

% Width of gabor
tw = res(1);
% Height of gabor
th = res(2);

% Build a procedural gabor texture for a gabor with a support of tw x th
% pixels, and a RGB color offset of 0.5 -- a 50% gray.
bgdcoloroffset = [];
[gaborID, gaborRect] = CreateProceduralGabor(w, tw, th, nonsymmetric, bgdcoloroffset);

% Draw the gabor once, just to make sure the gfx-hardware is ready for the
% benchmark run below and doesn't do one time setup work inside the
% benchmark loop: See below for explanation of parameters...

% Draw in center
%dstRect = [];
% Draw offcenter
dstRect = OffsetRect(gaborRect, coords.x0-tw/2, coords.y0-th/2);
% Make sure it has the size of gaborRect to avoid spatial distortions!

Screen('DrawTexture', w, gaborID, gaborRect, dstRect, 90+tilt, [], [], ...
    modulatecolor, [], kPsychDontDoRotation, [phase+180, freq, sig,...
    contrast, aspectratio, 0, 0, 0]);

% Screen('DrawTexture', windowPtr, gaborid, [], dstRect, Angle, [], [],
% modulateColor, [], kPsychDontDoRotation, [phase+180, freq, sc,
% contrast, aspectratio, 0, 0, 0]); % gaborid is created from
% CreateProceduralGabor

vbl = Screen('Flip', w);   

end
