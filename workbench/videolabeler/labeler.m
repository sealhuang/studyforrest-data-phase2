function labeler(videoFile)
% Video labeler for object categorization.
% Coded by Lijie Huang
%

videoFReader = vision.VideoFileReader(videoFile);
videoInfo = videoFReader.info;
videoPlayer = vision.VideoPlayer;
% hFig = figure('position', [300, 400, 325, 245]);
% hPanel = uipanel('parent', hFig, 'Position', [0 0 1 1], 'Units', 'Normalized');
% vaxis = axes('position', [0 0 1 1], 'Parent', hPanel);

while ~isDone(videoFReader)
    frame = step(videoFReader);
    step(videoPlayer, frame)
    pause(1/25)
%     showFrameOnAxis(vaxis, frame);
end

release(videoPlayer);
release(videoFReader);
