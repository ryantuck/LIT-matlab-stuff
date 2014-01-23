function beatSampleGUI

% runs through beat samples

% ========================================================
% Set up shit
% ========================================================

% create and then hide the GUI as it is being constructed
f = figure('Visible','off','Position',[360,500,450,285]);

% initialize values we'll need
currentData = 0;
bands = 0:6;
numDataPoints = 120;

% various data sets to choose from
dataSets = {...
    'snap',...
    'tap',...
    'thats all',...
    'lift off',...
    'bombo tiempo',...
    'the motto'};

dataSets60 = {...
    'rock n roll',...
    'wild for the night',...
    'late night hour',...
    'breakin a sweat',...
    'one',...
    'louder than boom',...
    'bonfire'};

dataSets120 = {...
    'ratTrapHigh120',...
    'ratTrapLow120',...
    'freakyGirl120',...
    'cascade120-1',...
    'cascade120-2',...
    'epic120',...
    'epic120-drop',...
    'silence120',...
    'serialWriting120',...
    'serialMinusSilence',...
    'unison100',...
    'unison100-2',...
    'blessed100',...
    'blessed100-2',...
    'serial57600'};

% ========================================================
% UI objects
% ========================================================

hDataSetPopUp = uicontrol(...
    'Style','popupmenu',...
    'String',dataSets120,...
    'Position',[20 600 200 20],...
    'Callback',@dataSetCallback);

hRunButton = uicontrol(...
    'Style','pushbutton',...
    'String','run',...
    'Position',[20 560 100 20],...
    'Callback',@runThroughData);

hFrameSlider = uicontrol(...
    'Style','slider',...
    'Position',[20 520 200 20],...
    'Min',1,'Max',numDataPoints,...
    'Value',1,...
    'Sliderstep',[1/(numDataPoints-1) 1/(numDataPoints-1)],...
    'Callback',@frameSliderCallback);

hFrameSliderLabel = uicontrol(...
    'Style','text',...
    'Position',[220 520 50 20],...
    'String','1');
    
% ========================================================
% Show GUI
% ========================================================

% set shit up
axes('Units','Pixels','Position',[50 50 800 400]);
set(f,'Visible','on','Position',[100 100 1000 800]);
setCurrent120Data;

% ========================================================







% Functions

% ========================================================
    
    function dataSetCallback(~,~)
        
        setCurrent120Data;
        
    end

% ========================================================

% changes currentData array based on user selection in popup menu

    function setCurrentData
        str = get(hDataSetPopUp,'String');
        val = get(hDataSetPopUp,'Value');
        
        switch str{val};
            case 'snap'
                currentData = csvread('beatSamples/snap.csv');
            case 'tap'
                currentData = csvread('beatSamples/tap.csv');
            case 'thats all'
                currentData = csvread('beatSamples/thatsAll1.csv');
            case 'lift off'
                currentData = csvread('beatSamples/liftOff1.csv');
            case 'bombo tiempo'
                currentData = csvread('beatSamples/bomboTiempo1.csv');
            case 'the motto'
                currentData = csvread('beatSamples/theMotto1.csv');
        end
        
        drawGraph(1);
    end

% ========================================================

% changes currentData array based on user selection in popup menu

    function setCurrent60Data
        str = get(hDataSetPopUp,'String');
        val = get(hDataSetPopUp,'Value');
        
        switch str{val};
            case 'rock n roll'
                currentData = csvread('beatSamples/rockNRoll60.csv');
            case 'wild for the night'
                currentData = csvread('beatSamples/wildForTheNight60.csv');
            case 'late night hour'
                currentData = csvread('beatSamples/lateNightHour60.csv');
            case 'breakin a sweat'
                currentData = csvread('beatSamples/breakinASweat60.csv');
            case 'one'
                currentData = csvread('beatSamples/oneSHM60.csv');
            case 'louder than boom'
                currentData = csvread('beatSamples/louderThanBoom60.csv');
            case 'bonfire'
                currentData = csvread('beatSamples/bonfire60.csv');
        end
        
        
        drawGraph(1);
    end

% ========================================================

% changes currentData array based on user selection in popup menu

    function setCurrent120Data
        str = get(hDataSetPopUp,'String');
        val = get(hDataSetPopUp,'Value');
        
        fileName = strcat('beatSamples/',str{val},'.csv');
        
        currentData = csvread(fileName);

        if length(currentData) < 120
            
            diff = 120 - length(currentData);
            
            tmpArray = zeros(diff,8);
            
            currentData = cat(1,currentData,tmpArray);
            
        end
        
        drawGraph(1);
    end

% ========================================================

% changes plot based on which row is selected

    function drawGraph(aRow)
        
        plot(bands,currentData(aRow,1:7),'-s');
        
        ylim([0 100]);
        
    end

% ========================================================

% runs through all 30 rows of data to animate the beat

    function runThroughData(~,~)
        
        for n=1:numDataPoints
            drawGraph(n);
            pause(0.02);
        end
    end

% ========================================================

% slider value change updates slider label and graph

    function frameSliderCallback(source,~)
        val = get(source,'Value');
        val = round(val);
        set(hFrameSliderLabel,'String',num2str(val));
        set(source,'Value',val);
        
        drawGraph(val);
    end




end




















