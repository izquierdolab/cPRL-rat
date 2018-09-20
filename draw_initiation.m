function draw_initiation(w,color,fixCoords,varargin)
% Draw a center fixation object
%   w: the windowId
%   color: contains color information
%   coords: contain position and size information

global setup

if isempty(varargin)
    shape = 'dot';    % default
else
    shape = varargin{1};
end

% Fill proper background color
Screen('FillRect',w,setup.bgdColor);

switch shape
    case 'dot'
        Screen('FillOval',w,color,fixCoords);
        % Screen('FillOval', windowPtr [,color] [,rect] [,perfectUpToMaxDiameter]);
        % rect is a 4 rows by n columns matrix, where each column is one ov
    case 'cross'
        % fixCoords(:,1) =  [x0-setup.bigSize,y0-setup.smallSize,x0+setup.bigSize,y0+setup.smallSize] ;
        % fixCoords(:,2) =  [x0-setup.smallSize,y0-setup.bigSize,x0+setup.smallSize,y0+setup.bigSize]
        Screen('FillRect',w,color,fixCoords);
end

vbl = Screen('Flip', w);

end