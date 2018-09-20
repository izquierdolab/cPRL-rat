load('RigEnvSpecifications.mat', 'env');
[tMain, tImm] = setup_touchscreen(env);

objCoords1 = [161,2.925714285714286e+02]; %coords.objLcoords;
objCoords2 = [607,2.925714285714286e+02]; %coords.objRcoords;

while 1
    [responseOut,whichOut] = check_response_2AFC(objCoords1, objCoords2);
    if responseOut
        if whichOut == 1  
            disp('left chosen')
        elseif whichOut == 2
            disp('right chosen')
        end
    end
end