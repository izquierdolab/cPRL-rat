function draw_targets(w,leftTarget,rightTarget,coords,varargin)
% Draw target objects on left and right screens
%   w: windowId
%   leftTarget: indicates left target shape
%   rightTarget: indicates right target shape
%   coords: contain position and size information
%   vargin: 1 or 2 (left or right only), 0 or 1 (wrong or right)

global setup

% Determine which targets to draw
if isempty(varargin)
    drawLeft = 1; drawRight = 1;
elseif varargin{1} == 1    % left only
    drawLeft = 1; drawRight = 0;
elseif varargin{1} == 2    % right only
    drawLeft = 0; drawRight = 1;
end

% Determine what color to draw
if isempty(varargin)
    color = setup.centerFeedback;   % white
elseif varargin{2} == 1
    color = setup.correctFeedback;
elseif varargin{2} == 0
    color = setup.wrongFeedback;
end

% Black background
Screen('FillRect',w,setup.bgdColor);

if drawLeft == 1
    switch leftTarget % left target
        case 2
            Screen('FillPoly',w,setup.targetColor(leftTarget,:),coords.diamondL,1);
        case 1
            Screen('FillRect',w,setup.targetColor(leftTarget,:),coords.targRect(1,:));
        case 4
            Screen('FillPoly',w,setup.targetColor(leftTarget,:),coords.diamondL,1);
        case 3
            Screen('FillRect',w,setup.targetColor(leftTarget,:),coords.targRect(1,:));
        case 5 % dot
            radius = setup.targRadius;
            targetRect = CenterRectOnPoint([-radius -radius,radius,radius],coords.objCoordsL(1),coords.objCoordsL(2));
            Screen('FillOval',w,color,targetRect);
        case 6
            radius = setup.targRadius;
            targetRect = CenterRectOnPoint([-radius -radius,radius,radius],coords.objCoordsU(1),coords.objCoordsU(2));
            Screen('FillOval',w,color,targetRect);
    end
end

if drawRight == 1
    switch rightTarget  % right target
        case 2
            Screen('FillPoly',w,setup.targetColor(rightTarget,:),coords.diamondR,1);
        case 1
            Screen('FillRect',w,setup.targetColor(rightTarget,:),coords.targRect(2,:));
        case 4
            Screen('FillPoly',w,setup.targetColor(rightTarget,:),coords.diamondR,1);
        case 3
            Screen('FillRect',w,setup.targetColor(rightTarget,:),coords.targRect(2,:));
        case 5 %dot
            radius = setup.targRadius;
            targetRect = CenterRectOnPoint([-radius -radius,radius,radius],coords.objCoordsR(1),coords.objCoordsR(2));
            Screen('FillOval',w,color,targetRect);
        case 6
            radius = setup.targRadius;
            targetRect = CenterRectOnPoint([-radius -radius,radius,radius],coords.objCoordsD(1),coords.objCoordsD(2));
            Screen('FillOval',w,color,targetRect);
    end
end

end