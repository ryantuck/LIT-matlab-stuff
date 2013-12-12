function fullSongVisualizerGUI

songData = csvread('beatSamples/ratTrapFullSong.csv');
bands = 0:6;

pauseTime = 0.0245;

% 7472 data points taken total

f = figure('Visible','off','Position',[360,500,450,285]);

hRunButton = uicontrol(...
    'Style','pushbutton',...
    'String','run',...
    'Position',[20 600 200 20],...
    'Callback',@runButtonCallback);

hTotalTimeLabel = uicontrol(...
    'Style','text',...
    'Position',[20 560 200 20],...
    'String','0');

% set shit up
axes('Units','Pixels','Position',[50 50 800 400]);
set(f,'Visible','on','Position',[100 100 1000 800]);

    function runButtonCallback(~,~)
        
        pause(1);
        
        t1 = clock;
        
        for n=1:7472
            
            drawGraph(n);
            
            pause(pauseTime);
            
        end
        
        t2 = clock;
        
        timeElapsed = t2 - t1;
        
        min = timeElapsed(5);
        sec = timeElapsed(6);
        
        timeString = strcat(num2str(min),':',num2str(sec));
        
        set(hTotalTimeLabel,'String',timeString);
        
    end

    function drawGraph(aRow)
        plot(bands,songData(aRow,1:7),'-s');      
        ylim([0 1000]);
    end

end