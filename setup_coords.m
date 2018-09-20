function coords = setup_coords
global setup env

% Define center of the view screen
if setup.windowedMode
    x0 = setup.windowWidth/2;
    y0 = setup.windowHeight/2;
else
    x0 = env.resolution.width/2;
    y0 = env.resolution.height/3.5;   % slightly below top half of screen
end

targRectN(1,:)=CenterRectOnPoint([0 0 setup.targSizeN/1.5 setup.targSizeN/1.5],x0-setup.targDist,y0);  % left side
targRectN(2,:)=CenterRectOnPoint([0 0 setup.targSizeN/1.5 setup.targSizeN/1.5],x0+setup.targDist,y0);  % right side
targRectN(3,:)=CenterRectOnPoint([0 0 setup.targSizeN/1.5 setup.targSizeN/1.5],x0-setup.targDist,y0);  % left side
targRectN(4,:)=CenterRectOnPoint([0 0 setup.targSizeN/1.5 setup.targSizeN/1.5],x0+setup.targDist,y0);  % right side

coords.targRectN = targRectN; % for the feedback oval

% CenterRectOnPoint(rect,x,y) centers original coords around a new point

fixRadius = setup.fixRadius;
fixCoords = [[x0,y0]-fixRadius,[x0,y0]+fixRadius];
fixCompleteCoords = [[x0,y0]-0.75*fixRadius,[x0,y0]+0.75*fixRadius];

objCoordsL = [x0-setup.targDist,y0]; % left
objCoordsR = [x0+setup.targDist,y0]; % right
objCoordsU = [x0,y0-setup.targDist]; % up
objCoordsD = [x0,y0+setup.targDist]; % down

coords.x0 = x0;
coords.y0 = y0;
coords.center = [x0, y0];
coords.fixCoords = fixCoords;
coords.fixCompleteCoords = fixCompleteCoords;
coords.objCoordsL = objCoordsL;
coords.objCoordsR = objCoordsR;
coords.objCoordsU = objCoordsU;
coords.objCoordsD = objCoordsD;

end