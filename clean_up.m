function clean_up()

global setup tMain tImm

if strcmp(setup.deviceName,'eye')
    % Receive eyetracker file and clean up after experiment is done
    try
        if Eyelink('IsConnected')
            Eyelink('StopRecording');
            Eyelink('CloseFile');
            Eyelink('command','clear_screen %d', 0); % removes previous drawing
            %{
            try
                sprintf('%s','Receiving data file ');
                status=Eyelink('ReceiveFile');
                if status > 0
                    fprintf('ReceiveFile status %d\n', status);
                end
            catch rdf
                sprintf('%s','Problem receiving data file ');
                rdf;
            end
            %}
        end
        Eyelink('Shutdown');
        Screen('CloseAll');
    end
    
elseif strcmp(setup.deviceName, 'touch')
    % Reliquish all lines
    fprintf(tImm, 'LineSetState Feeder off');
    fprintf(tImm, 'LineSetState TrayLight off');
    fprintf(tImm, 'LineRelinquishAll');
    
    % Relinquish display
    fprintf(tImm, 'DisplayClearBackgroundEvent touchscreen');
    fprintf(tImm, 'DisplayRelinquishAll');
    
    % Close sockets
    fclose(tImm);
    delete(tImm);
    fclose(tMain);
    delete(tMain);
    
end

end