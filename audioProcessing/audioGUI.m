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

dataSets = {'1-121 (no driver)',...
    '1-9 (no driver)',...
    '1-121 (63 Hz) 2V',...
    '1-121 (63 Hz) 1V',...
    '1-121 (63 Hz) 200mV',...
    '1-121 (160 Hz) 2V',...
    '1-121 (160 Hz) 1V',...
    '1-121 (160 Hz) 200mV'};

displayOptions = {'spectrum','variable'};

variableParameterName = 'Number';

yAxisHeight = 1000;

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

% data choice popup
%   allows user to select either low pot or full range data
hDataSetPopUp = uicontrol('Style','popupmenu',...
    'String',dataSets,...
    'Position',[480 480 200 20],...
    'Callback',@dataSetCallback);

% y axis height popup
%   allows user to define y axis height
hYAxisPopUp = uicontrol('Style','popupmenu',...
    'String',{'200','400','600','800','1000'},...
    'Value',5,... % sets default to 1000
    'Position',[480 380 100 20],...
    'Callback',@yAxisCallback);

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
            var = potVals(2)-potVals(1);
            a = var*round((x-1)/var)+1;
        end
        if get(hOptionsPopUp,'Value') == 3 % sliderA = brightness
            var = brightnessVals(2)-brightnessVals(1);
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
            var = brightnessVals(2)-brightnessVals(1);
        end
        if get(hOptionsPopUp,'Value') > 1 % sliderA = number
            var = numberVals(2)-numberVals(1);
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
        
        tmpMax      = max(potVals);
        tmpMin      = min(potVals);
        
        tmpInterval = potVals(2) - potVals(1);
        tmpRange    = tmpMax - tmpMin;
        tmpStep     = tmpInterval / tmpRange;
        
        set(hSliderA,'Value',tmpMin,...
            'Min',tmpMin,'Max',tmpMax,...
            'SliderStep',[tmpStep tmpStep]);
        set(hSliderACategoryLabel,'String','Pot Value');
        set(hSliderAValueLabel,'String',num2str(get(hSliderA,'Value')));
    end

    function setSliderAtoBrightness
        
        tmpMax      = max(brightnessVals);
        tmpMin      = min(brightnessVals);
        
        tmpInterval = brightnessVals(2)-brightnessVals(1);
        tmpRange    = tmpMax - tmpMin;
        tmpStep     = tmpInterval / tmpRange;
        
        set(hSliderA,'Value',tmpMin,...
            'Min',tmpMin,'Max',tmpMax,...
            'SliderStep',[tmpStep tmpStep]);
        set(hSliderACategoryLabel,'String','Brightness');
        set(hSliderAValueLabel,'String',num2str(get(hSliderA,'Value')));
    end

    function setSliderBtoBrightness
        
        tmpMax = max(brightnessVals);
        tmpMin = min(brightnessVals);
        
        tmpInterval = brightnessVals(2)-brightnessVals(1);
        tmpRange    = tmpMax - tmpMin;
        tmpStep     = tmpInterval / tmpRange;
        
        set(hSliderB,'Value',tmpMin,...
            'Min',tmpMin,'Max',tmpMax,...
            'SliderStep',[tmpStep tmpStep]);
        set(hSliderBCategoryLabel,'String','Brightness');
        set(hSliderBValueLabel,'String',num2str(get(hSliderB,'Value')));
    end

    function setSliderBtoNumber
        
        tmpMax      = max(numberVals);
        tmpMin      = min(numberVals);
        
        tmpInterval = numberVals(2) - numberVals(1);
        tmpRange    = tmpMax - tmpMin;
        tmpStep     = tmpInterval / tmpRange;
        
        set(hSliderB,'Value',tmpMin,...
            'Min',tmpMin,'Max',tmpMax,...
            'SliderStep',[tmpStep tmpStep]);
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
        
        totalRows = length(audioData);

        for n=1:totalRows

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
        
        % get column number of non-fixed variable
        % (math just happens to work out this way)
        tmpColumn = 4 - get(hOptionsPopUp,'Value');

        cla reset   % clear plot and reset colors
        hold all    % allows adding multiple functions to plot in for loop
        legendInfo = {0};   % set up legend
        
        % create values to adjust depending on data to display
        forLimit        = 1;
        xVals           = {0};
        yVals           = {0};
        legendVals      = {0};
        xLabelString    = 'asdf';
        
        test = get(hDataDisplayPopUp,'Value');

        switch(test);
            case 1
                % set up bands as x-axis
                forLimit = arrLength;
                xVals = bands;
                yVals = tmpArray(:,4:10);
                legendVals = tmpArray(:,tmpColumn);
                xLabelString = 'Band';
            case 2
                % set up non-fixed variable as x-axis
                forLimit = 7;
                xVals = transpose(tmpArray(:,tmpColumn));
                yVals = transpose(tmpArray(:,4:10));
                legendVals = bands;
                xLabelString = variableParameterName;
        end

        % actually plot! 
        for n=1:forLimit
            
            % plot values
            plot(xVals,yVals(n,:),'-s');
            
            % add legend entry
            legendInfo{n} = num2str(legendVals(n));
        end
        
        legend(legendInfo); % define legend
        legend('Location','NorthEastOutside');
        
        xlabel(xLabelString);
        
        ylim([0 yAxisHeight]);  % set y limits
        
    end

% --------------------------------------------------------
% Y axis callback
%   Changes y-axis height on graph.
% --------------------------------------------------------

    function yAxisCallback(source,eventdata)
        str = get(source,'String');
        val = get(source,'Value');
        
        % sets y-axis height to literal value from popup
        yAxisHeight = str2num(str{val});
        
        %re-draws graph
        drawGraph;
    end

% --------------------------------------------------------
% Display options callback
%   Changes x-axis values between variable parameter and
%   the different spectrum bands.
% --------------------------------------------------------

    function displayOptionsCallback(source,eventdata)
        
        % since drawGraph queries this popup's value, 
        % we don't really need to do anything except
        % re-draw the graph.
        drawGraph;
    end


% --------------------------------------------------------
% Data Set Callback
%   Changes general audio data set depending on user choice.
% --------------------------------------------------------

    function dataSetCallback(source,eventdata)
        str = get(source, 'String');
        val = get(source,'Value');
        
        switch str{val};
            case '1-121 (no driver)'
                setUpAllPotNoSignal;
            case '1-9 (no driver)'
                setUpLowPotNoSignal;
            case '1-121 (63 Hz) 2V'
                setUpAllPot63HzSignal2V;
            case '1-121 (63 Hz) 1V'
                setUpAllPot63HzSignal1V;
            case '1-121 (160 Hz) 2V'
                setUpAllPot160HzSignal2V;
            case '1-121 (160 Hz) 1V'
                setUpAllPot160HzSignal1V;
            case '1-121 (63 Hz) 200mV'
                setUpAllPot63HzSignal200mV;
            case '1-121 (160 Hz) 200mV'
                setUpAllPot160HzSignal200mV;
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

    function setUpAllPot63HzSignal2V
        audioData = csvread('allPot63.csv');
        potVals = 1:8:121;
        resetAllData;
    end

    function setUpAllPot63HzSignal1V
        audioData = csvread('allPot63Low.csv');
        potVals = 1:8:121;
        resetAllData;
    end

    function setUpAllPot160HzSignal2V
        audioData = csvread('allPot160.csv');
        potVals = 1:8:121;
        resetAllData;
    end

    function setUpAllPot160HzSignal1V
        audioData = csvread('allPot160Low.csv');
        potVals = 1:8:121;
        resetAllData;
    end

    function setUpAllPot63HzSignal200mV
        audioData = csvread('allPot63Hz200mV.csv');
        potVals = 1:8:121;
        resetAllData;
    end

    function setUpAllPot160HzSignal200mV
        audioData = csvread('allPot160Hz200mV.csv');
        potVals = 1:8:121;
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










