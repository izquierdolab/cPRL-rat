function setup_eyelink(setup,coords)

% Remove previous drawing
Eyelink('command','clear_screen %d', 0);

% Draw a cross in the middle
Eyelink('command', 'draw_cross %d %d 15', coords.x0, coords.y0);
objLcoords = coords.objLcoords;
objRcoords = coords.objRcoords;
objUcoords = coords.objUcoords;
objDcoords = coords.objDcoords;
pxErr = setup.pxErr;   % fixation window radius in pixels

% syntax: draw_box x1,y1,x2,y2 (corner of the boxes only)
Eyelink('command', 'draw_box %d %d %d %d 15', round(coords.x0-pxErr), round(coords.y0-pxErr),round(coords.x0+pxErr), round(coords.y0+pxErr));
Eyelink('command', 'draw_box %d %d %d %d 15',...
    round(objLcoords(1)-pxErr),round(objLcoords(2)-pxErr), round(objLcoords(1)+pxErr),round(objLcoords(2)+pxErr));
Eyelink('command', 'draw_box %d %d %d %d 15',...
    round(objRcoords(1)-pxErr),round(objRcoords(2)-pxErr), round(objRcoords(1)+pxErr),round(objRcoords(2)+pxErr));
Eyelink('command', 'draw_box %d %d %d %d 15',...
    round(objUcoords(1)-pxErr),round(objUcoords(2)-pxErr), round(objUcoords(1)+pxErr),round(objUcoords(2)+pxErr));
Eyelink('command', 'draw_box %d %d %d %d 15',...
    round(objDcoords(1)-pxErr),round(objDcoords(2)-pxErr), round(objDcoords(1)+pxErr),round(objDcoords(2)+pxErr));

end