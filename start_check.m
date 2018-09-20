function vbl = start_check(w)
KbName('UnifyKeyNames');
gKey = KbName('g');   % go key

% Display start of task instruction
DrawFormattedText(w,'Press G to begin/continue','center','center',256);
disp('Press G to begin/continue');

% Display background
vbl = Screen('Flip', w);

% Remove events from the system event queue
FlushEvents('keyDown');
key_capture();

% Check if 'G' is pressed to continue
[~, ~, keyCode] = KbCheck;
while ~keyCode(gKey)
    [~, ~, keyCode] = KbCheck;
    key_capture();
end

end