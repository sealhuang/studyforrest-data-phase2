function emotionclips_async1(subjID, whichDesign, condition, cross_num)
%
% Task description:
% -----------------
% Present a series of movie clips to participants. During the task,
% the participant is asked to pay attention to the centered 
% fixation passively, and press button while fixation turns to cross.
% Note: for other experimental condiation (i.e., face identification and 
%       facial emotion recognition tasks), the participant is asked to
%       press the button while target stimuli appears.
%
% Usage:
% ------
% emotionclips_async1(subjID, whichDesign, condition, [cross_num])
% * subjID, i.e. HLJ
% * which design is a number XX such that there is a file
%   designXX.csv which *must* be in the rootDir for this to work!!
% * condition: experiment condition flag, 1 for passive view, 2 for face
%   identity recognition, and 3 for facial emoion recognition.
% * cross_num indicates the number of cross fixation in the passive view
%   runs.
%
% Note:
% -----
% Use MPG videos and monitor resolution 1024x768.
% Boot with minimal extensions to stop printer interruptions, network, etc.
% Quit other programs besides matlab
%
% Coded by Lijie Huang

%warning off;
% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(1);

% key defination
sKey = KbName('s');
rKey = KbName('1!');
escKey = KbName('ESCAPE');

% task description
switch condition
    case 1
        taskDisp = 'Passive Viewing';
    case 2
        taskDisp = 'Face Identity Recognition';
    case 3
        taskDisp = 'Facial Emotion Recognition';
    otherwise
        assert(false, 'Invalid condition parameter!')
end

% ratio between screen size and image size
% distance(D): 105cm, screen width(S): 53cm, angle of view(A): 10 degree
f = 53/2/105/tan(20/2/180*pi);

% fixation spot half size (pixel)
fixSize = 3;

% information for different condiations
onExit='execution halted by experimenter';
onLoadError='missing movie clips';

% directory config
rootDir = pwd;
stimuliDir = char(fullfile(rootDir, 'stimuli'));
dataDir = fullfile(rootDir, 'data');

try
    % Largest screen number is most likely correct display
    screenNum = max(Screen('Screens'));
    theFrameRate = FrameRate(screenNum);
    % find the color values which correspond to white and black
    white=WhiteIndex(screenNum);
    black=BlackIndex(screenNum);
    %gray=round((white+black)/2);
    
    % open window
    [window, rect] = Screen('OpenWindow', screenNum, black);
    % sets Center for screenRect (x,y)
    [x0, y0] = RectCenter(rect);
    % set fixation spot rect
    fixRect = [x0-fixSize y0-fixSize x0+fixSize y0+fixSize];
    % text settings
    Screen('TextSize', window, 48);
    Screen('TextFont', window, 'Arial');
    
    % check OpenGL status
    AssertOpenGL;
    % measure the vertical refresh rate of the monitor
    ifi = Screen('GetFlipInterval', window);
    
    % load movie clip info from design
    df = fopen(['design' num2str(whichDesign) '.csv']);
    info = textscan(df, '%s %f %*[^\n]', 'delimiter', ',');
    fclose(df);
    fileList = info{1};
    movDur = info{2};
    % check existence of clips
    for i=1:length(fileList)
        if ~exist(fullfile(stimuliDir, fileList{i}), 'file')
            disp(['ERROR: Missing clip - ' fileList{i}]);
            assert(false, onLoadError);
        else
            fileList{i} = fullfile(stimuliDir, fileList{i});
        end
    end
    
    % create 10s dummy movie
    i = length(fileList);
    count = 0;
    clipIdx = 1:length(fileList);
    while i>0
        count = count + movDur(i);
        clipIdx = [i clipIdx];
        if count > 10
            break;
        end
        i = i - 1;
    end
    % program running costs ~1s, thus...
    playTime = count - 10;
    
    % Load first movie. This is a synchronous (blocking) load:
    %tempT = GetSecs;
    [clip, dur, ~, imgw, imgh] = Screen('OpenMovie', window, ...
                                        fileList{clipIdx(1)}, 4, [], 2);
    % for test
    %disp(['Loading cost: ' fileList{clipIdx(1)} num2str(GetSecs - tempT)]);
    % display size config
    if imgw/imgh<x0/y0
        mag = f * imgh / rect(4);
    else
        mag = f * imgw / rect(3);
    end
    dispSize = [x0-imgw/mag/2 y0-imgh/mag/2 x0+imgw/mag/2 y0+imgh/mag/2];
    % ready for playback
    %Screen('SetMovieTimeIndex', clip, playTime);
    Screen('PlayMovie', clip, 1, 0, 0);
 
    % ready for beginning
    HideCursor; 								
    % Cue word to remind task and check screen orientation
    DrawFormattedText(window, [taskDisp '\n\n Ready to begin'], ...
                      'center', 'center', white);
    Screen('Flip', window);
    
    % display movie clips
    % clear keyboard queue
    while KbCheck; end
    % get triggered by the fMRI
    while 1
        [keyIsDown, ~, keyCode] = KbCheck;
        if keyIsDown && keyCode(sKey)
            % start only when "s" key is pressed
            break;
        end
    end
    
    % response collection
    % for passive view, the subjects should press button once the 
    % cross fixation appears.
    if ~(condition-1)
        cross_interval = 585 / cross_num;
        cross_time = 5:cross_interval:590;
        if length(cross_time) > cross_num
            cross_time = cross_time(1:cross_num);
        end
        cross_time = cross_time + 10 .* rand(1, length(cross_time));
        if cross_time(end) > 600
            cross_time(end) = 595;
        end
    end
    key = [];
    rt = [];
    lastrt = 0;
    
    % experiment start
    expStart = GetSecs;
    prefetched=0;
    newClip = -1;
    cross_fix_idx = 1;
    cross_fix_flag = 0;
    for i=1:length(clipIdx)
    	start = 0;
        while 1
            if i==1 && ~start
                Screen('SetMovieTimeIndex', clip, playTime);
                start = 1;
	        elseif ~start
		        Screen('SetMovieTimeIndex', clip, 0);
		        start = 1;
            end
            [tex, pts] = Screen('GetMovieImage', window, clip, 1);
            % A negative value means end of movie reached:
            if tex<=0
                break
            end
            Screen('DrawTexture', window, tex, [], dispSize);
            % the color of fixation spot changes 3 times per sec
            t = GetSecs;
            % fixation settings
            if condition==1
                if cross_fix_idx<=length(cross_time)
                    if ~cross_fix_flag && (t-expStart)>cross_time(cross_fix_idx)
                        cross_fix_flag = 1;
                        Screen('FillOval', window, white, CenterRect([0 0 8 8], rect));
                    elseif cross_fix_flag && ((t-expStart)<=cross_time(cross_fix_idx)+0.5)
                        Screen('FillOval', window, white, CenterRect([0 0 8 8], rect));
                    elseif cross_fix_flag && ((t-expStart)>cross_time(cross_fix_idx)+0.5)
                        cross_fix_flag = 0;
                        cross_fix_idx = cross_fix_idx + 1;
                    end
                end
            end
            % Move this part into above if-end section for displaying
            % fixation in condition 1 only.
            if ~cross_fix_flag
                t = (t) - fix(t);
                if t > 2/3
                    Screen('FillRect', window, [255 0 0], fixRect);
                elseif t > 1/3
                    Screen('FillRect', window, [0 255 0], fixRect);
                else
                    Screen('FillRect', window, [0 0 255], fixRect);
                end
            end
            Screen('Flip', window);
            Screen('Close', tex);
            % record response
            [keyIsDown, ~, keyCode] = KbCheck;
            if keyIsDown && keyCode(rKey)
                newrt = GetSecs - expStart;
                if (newrt-lastrt)>0.5
                    key = [key; 1];
                    rt = [rt; newrt];
                    lastrt = newrt;
                end
            elseif keyIsDown && keyCode(escKey)
                % press esc and exit
                assert(false, onExit);
            end
            
            % We start background loading of the next movie 0.2 seconds
            % after start of playback of the current movie:
            if prefetched==0 && (pts > 0) && ~(i==length(clipIdx))
                % Initiate background async load operation:
    		disp(['Loading ' fileList{clipIdx(i+1)}]);
                Screen('OpenMovie', window, fileList{clipIdx(i+1)}, 1+4, 1, 2);
                prefetched = 1;
            end;
            
            % Less than 0.5 seconds until end of current movie. Try to
            % start playback for next movie:
            if (dur-pts < 0.5) && prefetched==1
                [newClip, newDur, ~, ~, ~] = Screen('OpenMovie', window, ...
                                                    fileList{clipIdx(i+1)}, 4);
                Screen('PlayMovie', newClip, 1, 0, 0);
                prefetched = 2;
            end
        end
        % for test
        %disp([num2str(i) ' iter costs ' num2str(GetSecs-expStart)])
        Screen('PlayMovie', clip, 0);
        Screen('CloseMovie', clip);
        if prefetched==2
            clip = newClip;
            dur = newDur;
            prefetched = 0;
            %Screen('SetMovieTimeIndex', clip, 0);
        end
    end
    experimentDuration = GetSecs - expStart;
    fprintf('actual run time: %3.5f\n', experimentDuration)
    fprintf('Total response number: %f\n', length(rt))
    
    cd(rootDir);
    Screen('CloseAll');
    ShowCursor;
    c = clock;
    timestr = [num2str(c(1)), num2str(c(2), '%02d'), ...
               num2str(c(3), '%02d'), num2str(c(4), '%02d'), ...
               num2str(c(5), '%02d')];
    outMat = fullfile(dataDir, [subjID '_' num2str(condition) '_' num2str(whichDesign) '_' timestr '.mat']);
    if condition > 1
        save(outMat, 'key', 'rt', 'ifi', 'whichDesign', 'subjID', ...
             'theFrameRate', 'rect', 'experimentDuration');
    else
        save(outMat, 'key', 'rt', 'cross_time', 'ifi', 'whichDesign', ...
             'subjID', 'theFrameRate', 'rect', 'experimentDuration');
    end
catch
    cd(rootDir);
    ShowCursor;
    Screen('CloseAll');
    psychrethrow(psychlasterror);
end
