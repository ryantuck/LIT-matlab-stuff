function audioGUI

% Audio UI to analyze headband audio data

% ================================================================
% Setup
% ================================================================

% read in global audio data file
audioData = csvread('potNumBrightnessTesting1.csv');

% Column #s in audioData
% ----------------------
% 1 -  pot
% 2 -  brightness
% 3 -  # leds
% 4 -  band 0
% 10 - band 6
% 11 - band 0 stdev
% 17 - band 6 stdev

% define default values
bands           = 0:6;
potVals         = 1:8:121;
brightnessVals  = 0:25:100;
numberVals      = 0:8:32;

% create and then hide the GUI as it is being constructed
f = figure('Visible','off','Position',[360,500,450,285]);

% ================================================================
% Create ui controls
% ================================================================

% options pop-up
%   chooses which two parameters we keep fixed
hOptionsPopUp = uicontrol('Style','popupmenu',...
    'String',{'Pot / Brightness','Pot / Number','Brightness / Number'},...
    'Position',[220 560 200 25],...
    'Callback',@paramSelectCallback);
% options label
%   instructs user what to do
hOptionsLabel = uicontrol('Style','text',...
    'String','Select parameters to fix: ',...
    'Position',[20 560 200 25]);

% sliders
%   control values of 2 fixed parameters
hSliderA = uicontrol('Style','slider',...
    'Max',100,'Min',0,...
    'SliderStep',[0.25 0.25],...
    'Position',[20 520 200 20],...
    'Callback',@sliderACallback);
hSliderB = uicontrol('Style','slider',...
    'Max',121,'Min',1,...
    'Value',1,...
    'SliderStep',[0.067 0.067],...
    'Position',[20 480 200 20],...
    'Callback',@sliderBCallback);

% category labels
%   display parameter name associated with slider
hSliderACategoryLabel = uicontrol('Style','text',...
    'String','Pot value',...
    'Position',[320 520 100 25]);
hSliderBCategoryLabel = uicontrol('Style','text',...
    'String','Brightness',...
    'Position',[320 480 100 25]);

% value labels
%   display parameter value associated with slider
hSliderAValueLabel = uicontrol('Style','text',...
    'String','1',...
    'Position',[220 520 100 25]);
hSliderBValueLabel = uicontrol('Style','text',...
    'String','0',...
    'Position',[220 480 100 25]);

% % description label
% %   describes UI
% hInstructionsLabel = uicontrol('Style','text',...
%     'String','Use sliders to change values of fixed parameters.',...
%     'Position',[480 480 300 100]);

% data choice popup
%   allows user to select either low pot or full range data
hDataSetPopUp = uicontrol('Style','popupmenu',...
    'String',{'1-121','1-9'},...
    'Position',[480 480 100 20],...
    'Callback',@dataSetCallback);

% ================================================================
% Prepare display
% ================================================================

% set up axes
ha = axes('Units','Pixels','Position',[50 50 800 400]);

% initially set up values and graph
potBrCallback;

% turn on figure display
set(f,'Visible','on','Position',[100 100 1000 600]);

% ================================================================






% ================================================================
% Functionality
% ================================================================


% --------------------------------------------------------
% Main Parameter Selections.
%   Calls specific function to set up sliders and graph
%   depending on the main pop-up menu selection.
% --------------------------------------------------------
    function paramSelectCallback(source,eventdata)

        resetAllData;
    end

% --------------------------------------------------------
% Specific callbacks for the three main selections.
%   Each changes the slider settings and re-draws graph.
% --------------------------------------------------------
    function potBrCallback
        setSliderAtoPot;
        setSliderBtoBrightness;
        drawGraph;
    end

    function potNumCallback
        setSliderAtoPot;
        setSliderBtoNumber;
        drawGraph;
    end

    function brNumCallback
        setSliderAtoBrightness;
        setSliderBtoNumber;
        drawGraph;
    end

    
% --------------------------------------------------------
% Slider callbacks.
%   When slider value is changed, this function is triggered.
%   Function gets value of slider, rounds it off to the
%   certain values it's permitted to have, updates the slider,
%   updates the slider's value label, and re-draws the graph.
% --------------------------------------------------------
    function sliderACallback(source,eventdata)
        % get value
        x = get(hSliderA,'Value');
        
        % check state of main pop-up and change value accordingly
        var = 1;
        a = 1;
        if get(hOptionsPopUp,'Value') < 3 % sliderA = pot
            var = 8;
            a = var*round((x-1)/var)+1;
        end
        if get(hOptionsPopUp,'Value') == 3 % sliderA = brightness
            var = 25;
            a = var*round(x/var);
        end

        % update values of slider and value label
        y = num2str(a);
        set(hSliderAValueLabel,'String',y);
        set(hSliderA,'Value',a);
        
        % re-draw graph
        drawGraph;
    end

    function sliderBCallback(source,eventdata)
        % get value
        x = get(hSliderB,'Value');
        
        % check state of main pop-up and change value accordingly
        var = 1;
        a = 1;
        if get(hOptionsPopUp,'Value') == 1 % sliderA = brightness
            var = 25;
        end
        if get(hOptionsPopUp,'Value') > 1 % sliderA = number
            var = 8;
        end
        
        % update values of slider and value label
        a = var*round(x/var);
        y = num2str(a);
        set(hSliderBValueLabel,'String',y);
        set(hSliderB,'Value',a);
        
        % re-draw graph
        drawGraph;
    end


% --------------------------------------------------------
% Slider setups.
%   Changes slider value and its labels based on category.
% --------------------------------------------------------
    function setSliderAtoPot
        set(hSliderA,'Value',1,...
            'Min',1,'Max',121,...
            'SliderStep',[0.067 0.067]);
        set(hSliderACategoryLabel,'String','Pot Value');
        set(hSliderAValueLabel,'String',num2str(get(hSliderA,'Value')));
    end
    function setSliderAtoBrightness
        set(hSliderA,'Value',0,...
            'Min',0,'Max',100,...
            'SliderStep',[0.25 0.25]);
        set(hSliderACategoryLabel,'String','Brightness');
        set(hSliderAValueLabel,'String',num2str(get(hSliderA,'Value')));
    end
    function setSliderBtoBrightness
        set(hSliderB,'Value',0,...
            'Min',0,'Max',100,...
            'SliderStep',[0.25 0.25]);
        set(hSliderBCategoryLabel,'String','Brightness');
        set(hSliderBValueLabel,'String',num2str(get(hSliderB,'Value')));
    end
    function setSliderBtoNumber
        set(hSliderB,'Value',0,...
            'Min',0,'Max',32,...
            'SliderStep',[0.25 0.25]);
        set(hSliderBCategoryLabel,'String','Number');
        set(hSliderBValueLabel,'String',num2str(get(hSliderB,'Value')));
    end


% --------------------------------------------------------
% Draw Graph.
%   Plots spectrum based on current fixed values.
% --------------------------------------------------------
    function drawGraph
        
        % get numeric values for current fixed parameters
        val1 = get(hSliderA,'Value');
        val2 = get(hSliderB,'Value');
        
        % check the set parameters
        col1 = 1;
        col2 = 1;
        
        if get(hOptionsPopUp,'Value') == 1
            col1 = 1; % pot column
            col2 = 2; % br  column
        end
        if get(hOptionsPopUp,'Value') == 2
            col1 = 1; % pot column
            col2 = 3; % num column
        end
        if get(hOptionsPopUp,'Value') == 3
            col1 = 2; % br  column
            col2 = 3; % num column
        end
   
        % filter main array down depending on fixed values
        tmpArray = zeros(1,18);

        for n=1:400

            tmpRow = audioData(n,:);

            if tmpRow(1,col1) == val1
                if tmpRow(1,col2) == val2
                    tmpArray = cat(1,tmpArray,tmpRow);
                end
            end
        end

        % chop off top all-zeros row of tmpArray
        tmpArray = tmpArray([2:end],:);
        
        arrLength = length(tmpArray(:,1));  % get # of rows in tmpArray

        cla reset   % clear plot and reset colors
        hold all    % allows adding multiple functions to plot in for loop
        legendInfo = {0};   % set up legend
        
        % actually plot! 
        for n=1:arrLength
            
            % plot 7 band values for a given non-fixed value
            plot(bands,tmpArray(n,4:10),'-s');
            
            % get column number of non-fixed variable
            % (math just happens to work out this way)
            tmpVal = 4 - get(hOptionsPopUp,'Value');
            
            % add a legend indicator for this certain non-fixed value
            legendInfo{n} = num2str(tmpArray(n,tmpVal));
        end
        
        legend(legendInfo); % define legend
        legend('Location','NorthEastOutside');
        
        ylim([0 300]);  % set y limits
        
    end
end

% --------------------------------------------------------
% Data Set Callback
%   Changes general audio data set depending on user choice.
% --------------------------------------------------------

    function dataSetCallback(source,eventdata)
        str = get(source, 'String');
        val = get(source,'Value');
        
        switch str{val};
            case '1-121'
                setUpAllPotNoSignal;
            case '1-9'
                setUpLowPotNoSignal;
        end
    end

% --------------------------------------------------------
% Data set setups.
%   Changes general audio data set depending on pop up menu choice.
% --------------------------------------------------------

    function setUpAllPotNoSignal
        audioData = csvread('potNumBrightnessTesting1.csv');
        potVals = 1:8:121;
        resetAllData;
    end

    function setUpLowPotNoSignal
        audioData = csvread('pot1to9.csv');
        potVals = 1:9;
        resetAllData;
    end

% --------------------------------------------------------
% Reset all data.
%   Changes sliders and graphs depending on current
%   value of main fixed-parameter selection popup.
% --------------------------------------------------------


    function resetAllData
        
        str = get(hOptionsPopUp, 'String');
        val = get(hOptionsPopUp,'Value');
        
        switch str{val};
            case 'Pot / Brightness'
                potBrCallback;
            case 'Pot / Number'
                potNumCallback;
            case 'Brightness / Number'
                brNumCallback;
        end
        
    end


end











