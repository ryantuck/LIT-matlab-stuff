function beatSampleGUI

% runs through beat samples

% create and then hide the GUI as it is being constructed
f = figure('Visible','off','Position',[360,500,450,285]);

currentData = 0;

bands = 0:6;

dataSets = {...
    'snap',...
    'tap',...
    'thats all',...
    'lift off',...
    'bombo tiempo'};

hDataSetPopUp = uicontrol(...
    'Style','popupmenu',...
    'String',dataSets,...
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
    'Min',1,'Max',30,...
    'Value',1,...
    'Sliderstep',[1/29 1/29],...
    'Callback',@frameSliderCallback);

hFrameSliderLabel = uicontrol(...
    'Style','text',...
    'Position',[220 520 50 20],...
    'String','0');
    

% set shit up
axes('Units','Pixels','Position',[50 50 800 400]);
set(f,'Visible','on','Position',[100 100 1000 800]);
setCurrentData;


    function dataSetCallback(~,~)
        
        setCurrentData;
        
    end

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
        end
        
        drawGraph(1);
    end

    function drawGraph(aRow)
        
        plot(bands,currentData(aRow,1:7),'-s');
        
        ylim([0 1000]);
        
    end

    function runThroughData(~,~)
        
        for n=1:30
            drawGraph(n);
            pause(0.05);
        end
    end

    function frameSliderCallback(source,~)
        val = get(source,'Value');
        val = round(val);
        set(hFrameSliderLabel,'String',num2str(val));
        set(source,'Value',val);
        
        drawGraph(val);
    end




end




















