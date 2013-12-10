function audioGUI

% Audio UI to analyze headband audio data

% ================================================================
% Setup
% ================================================================

% create placeholder for audioData
audioData = {0};

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

frequencies = [63,160,400,1000,2500,6250];  % for driving signals
voltages    = [2000,1000,200];

% for different ways data can be plotted
displayOptions = {'spectrum','variable'};

% different combos of fixed parameters
fixedOptions = {...
    'Pot / Brightness',...
    'Pot / Number',...
    'Brightness / Number'};

% options for signal
signalOptions = {'None','Sine Wave'};

% by default, pot and brightness are fixed.
% this variable will be the x-axis label.
variableParameterName = 'Number';   

yAxisHeight = 1000; % default value

% options for y-axis heights
yHeights = {...
    '200',...
    '400',...
    '600',...
    '800',...
    '1000'};

% options for pot range
potRangeOptions = {'1-121','1-9'};

% initially set audioData to silence data (default setting)
createSilenceAudioArray;

% create and then hide the GUI as it is being constructed
f = figure('Visible','off','Position',[360,500,450,285]);

% ================================================================
% Create ui controls
% ================================================================

% fixed parameters popup
%   chooses which two parameters we keep fixed
hFixedParametersPopUp = uicontrol(...
    'Style','popupmenu',...
    'String',fixedOptions,...
    'Position',[220 600 200 20],...
    'Callback',@paramSelectCallback);

% sliders
%   control values of 2 fixed parameters
hSliderA = uicontrol(...
    'Style','slider',...
    'Max',100,'Min',0,...
    'SliderStep',[0.25 0.25],...
    'Position',[220 560 200 20],...
    'Callback',@sliderACallback);

hSliderB = uicontrol(...
    'Style','slider',...
    'Max',121,'Min',1,...
    'Value',1,...
    'SliderStep',[0.067 0.067],...
    'Position',[220 520 200 20],...
    'Callback',@sliderBCallback);

% data choice popup
%   allows user to select either low pot or full range data
hSignalPopUp = uicontrol(...
    'Style','popupmenu',...
    'String',signalOptions,...
    'Position',[220 480 200 20],...
    'Callback',@signalCallback);

% y axis height popup
%   allows user to define y axis height
uicontrol(...
    'Style','popupmenu',...
    'String',yHeights,...
    'Value',5,... % sets default to 1000
    'Position',[680 520 200 20],...
    'Callback',@yAxisCallback);

% data display popup
%   allows user to select how data should be displayed
hDataDisplayPopUp = uicontrol(...
    'Style','popupmenu',...
    'String',displayOptions,...
    'Position',[680 480 200 20],...
    'Callback',@displayOptionsCallback);

% driving signal popups
%   lets the user choose driving frequency and amplitude
hFrequencyPopUp = uicontrol(...
    'Style','popupmenu',...
    'String',frequencies,...
    'Position',[680 600 200 20],...
    'Callback',@frequencyCallback);

hAmplitudePopUp = uicontrol(...
    'Style','popupmenu',...
    'String',voltages,...
    'Position',[680 560 200 20],...
    'Callback',@frequencyCallback);

% pot range popup
%   if silence data selected, lets user choose range of pot values
hPotRangePopUp = uicontrol(...
    'Style','popupmenu',...
    'String',potRangeOptions,...
    'Position',[680 600 200 20],...
    'Callback',@potRangeCallback);

% labels
uicontrol(...   % fixed parameters label
    'Style','text',...            
    'String','Fixed Parameters: ',...
    'Position',[20 600 200 20]);

hPotRangeLabel = uicontrol(...
    'Style','text',...
    'String','Pot Range:',...
    'Position',[480,600,200,20]);

hFrequencyLabel = uicontrol(...
    'Style','text',...
    'String','Signal Frequency (Hz):',...
    'Position',[480 600 200 20]);

hAmplitudeLabel = uicontrol(...
    'Style','text',...
    'String','Signal Amplitude (mV):',...
    'Position',[480 560 200 20]);

uicontrol(...   % driving signal label
    'Style','text',...        
    'String','Driving Signal?',...
    'Position',[20 480 200 20]);

uicontrol(...   % y-axis label
    'Style','text',...        
    'String','Y-Axis Height:',...
    'Position',[480 520 200 20]);

uicontrol(...   % x-axis label
    'Style','text',...        
    'String','X-Axis Data:',...
    'Position',[480 480 200 20]);

% slider category labels
%   display parameter name associated with slider
hSliderACategoryLabel = uicontrol(...
    'Style','text',...
    'String','Pot value',...
    'Position',[20 560 100 20]);

hSliderBCategoryLabel = uicontrol(...
    'Style','text',...
    'String','Brightness',...
    'Position',[20 520 100 20]);

% slider value labels
%   display parameter value associated with slider
hSliderAValueLabel = uicontrol(...
    'Style','text',...
    'String','1',...
    'Position',[120 560 100 20]);
hSliderBValueLabel = uicontrol(...
    'Style','text',...
    'String','0',...
    'Position',[120 520 100 20]);
    

% ================================================================
% Prepare display
% ================================================================

% set up axes
axes('Units','Pixels','Position',[50 50 800 400]);

% initially set up values and graph
potBrCallback;

% hide driving signal pop ups because silence data is default
hideSignalPopUps;

% turn on figure display
set(f,'Visible','on','Position',[100 100 1000 800]);

% ================================================================





% ================================================================
% Functionality
% ================================================================


% --------------------------------------------------------
% Main Parameter Selections.
%   Calls specific function to set up sliders and graph
%   depending on the main pop-up menu selection.
% --------------------------------------------------------
    function paramSelectCallback(~,~)
        resetAllData;
    end

% --------------------------------------------------------
% Reset all data.
%   Changes sliders and graphs depending on current
%   value of main fixed-parameter selection popup.
% --------------------------------------------------------
    function resetAllData
        
        str = get(hFixedParametersPopUp, 'String');
        val = get(hFixedParametersPopUp,'Value');
        
        switch str{val};
            case 'Pot / Brightness'
                potBrCallback;
            case 'Pot / Number'
                potNumCallback;
            case 'Brightness / Number'
                brNumCallback;
        end
        
    end

% --------------------------------------------------------
% Specific callbacks for the three main selections.
%   Each changes the slider settings and re-draws graph.
% --------------------------------------------------------
    function potBrCallback
        variableParameterName = 'Number';
        setSliderAtoPot;
        setSliderBtoBrightness;
        drawGraph;
    end

    function potNumCallback
        variableParameterName = 'Brightness';
        setSliderAtoPot;
        setSliderBtoNumber;
        drawGraph;
    end

    function brNumCallback
        variableParameterName = 'Pot Value';
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
    function sliderACallback(~,~)
        
        % get value
        x = get(hSliderA,'Value');
        
        % check state of main pop-up and change value accordingly
        a = 1;
        if get(hFixedParametersPopUp,'Value') < 3 
            % sliderA = pot
            var = potVals(2)-potVals(1);
            a = var*round((x-1)/var)+1;
        end
        if get(hFixedParametersPopUp,'Value') == 3 
            % sliderA = brightness
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

    function sliderBCallback(~,~)
        
        % get value
        x = get(hSliderB,'Value');
        
        % check state of main pop-up and change value accordingly
        var = 1;
        
        if get(hFixedParametersPopUp,'Value') == 1 
            % sliderA = brightness
            var = brightnessVals(2)-brightnessVals(1);
        end
        if get(hFixedParametersPopUp,'Value') > 1 
            % sliderA = number
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
        
        % get max, min and step values for slider
        tmpMax      = max(potVals);
        tmpMin      = min(potVals);
        
        tmpInterval = potVals(2) - potVals(1);
        tmpRange    = tmpMax - tmpMin;
        tmpStep     = tmpInterval / tmpRange;
        
        % set slider's values
        set(hSliderA,...
            'Value',tmpMin,...
            'Min',tmpMin,'Max',tmpMax,...
            'SliderStep',[tmpStep tmpStep]);
        
        % set labels accordingly
        set(hSliderACategoryLabel,'String','Pot Value');
        set(hSliderAValueLabel,'String',num2str(get(hSliderA,'Value')));
    end

    function setSliderAtoBrightness
        
        % get max, min and step values for slider
        tmpMax      = max(brightnessVals);
        tmpMin      = min(brightnessVals);
        
        tmpInterval = brightnessVals(2)-brightnessVals(1);
        tmpRange    = tmpMax - tmpMin;
        tmpStep     = tmpInterval / tmpRange;
        
        % set slider's values
        set(hSliderA,...
            'Value',tmpMin,...
            'Min',tmpMin,'Max',tmpMax,...
            'SliderStep',[tmpStep tmpStep]);
        
        % set labels accordingly
        set(hSliderACategoryLabel,'String','Brightness');
        set(hSliderAValueLabel,'String',num2str(get(hSliderA,'Value')));
    end

    function setSliderBtoBrightness
        
        % get max, min and step values for slider
        tmpMax = max(brightnessVals);
        tmpMin = min(brightnessVals);
        
        tmpInterval = brightnessVals(2)-brightnessVals(1);
        tmpRange    = tmpMax - tmpMin;
        tmpStep     = tmpInterval / tmpRange;
        
        % set slider's values
        set(hSliderB,...
            'Value',tmpMin,...
            'Min',tmpMin,'Max',tmpMax,...
            'SliderStep',[tmpStep tmpStep]);
        
        % set labels accordingly
        set(hSliderBCategoryLabel,'String','Brightness');
        set(hSliderBValueLabel,'String',num2str(get(hSliderB,'Value')));
    end

    function setSliderBtoNumber
        
        % get max, min and step values for slider
        tmpMax      = max(numberVals);
        tmpMin      = min(numberVals);
        
        tmpInterval = numberVals(2) - numberVals(1);
        tmpRange    = tmpMax - tmpMin;
        tmpStep     = tmpInterval / tmpRange;
        
        % set slider's values
        set(hSliderB,...
            'Value',tmpMin,...
            'Min',tmpMin,'Max',tmpMax,...
            'SliderStep',[tmpStep tmpStep]);
        
        % set labels accordingly
        set(hSliderBCategoryLabel,'String','Number');
        set(hSliderBValueLabel,'String',num2str(get(hSliderB,'Value')));
    end


% --------------------------------------------------------
% Draw Graph.
%   Plots spectrum based on current fixed values.
% --------------------------------------------------------
    function drawGraph
        
        % get numeric values for current fixed parameters from sliders
        val1 = get(hSliderA,'Value');
        val2 = get(hSliderB,'Value');

        % check fixed parameters and
        % select appropriate column values accordingly
        fixedVal = get(hFixedParametersPopUp,'Value');
        
        col1 = 1;
        col2 = 1;
        
        switch fixedVal;
            case 1
                col1 = 1; % pot column
                col2 = 2; % br  column
            case 2
                col1 = 1; % pot column
                col2 = 3; % num column
            case 3
                col1 = 2; % br  column
                col2 = 3; % num column
        end

        
        % filter main array down depending on fixed values
        
        % get dimensions of audioData array
        totalColumns    = length(audioData(1,:));
        totalRows       = length(audioData(:,1));
        
        % create 1-row array that we'll use for concatenating rows
        % that fit our desired parameters
        tmpArray = zeros(1,totalColumns);
        
        % check whether we have a driving signal or not
        drivingSignalCheck = get(hSignalPopUp,'Value');

        % sort through data
        for n=1:totalRows
            
            tmpRow = audioData(n,:);
            
            if tmpRow(1,col1) == val1
                if tmpRow(1,col2) == val2
                    
                    switch drivingSignalCheck;
                        
                        case 1
                            % no driving signal, treat as silence data
                            potRange = get(hPotRangePopUp,'Value');
                            colP = 18;
                            
                            switch potRange;
                                
                                case 1
                                    % pot range 1-121
                                    if tmpRow(1,colP) == 121
                                        tmpArray = cat(1,tmpArray,tmpRow);
                                    end
                                    
                                case 2
                                    % pot range 1-9
                                    if tmpRow(1,colP) == 9
                                        tmpArray = cat(1,tmpArray,tmpRow);
                                    end
                            end
                            
                        case 2
                            % driving signal
                            
                            valF = get(hFrequencyPopUp,'Value');
                            valA = get(hAmplitudePopUp,'Value');
                            colF = 18;
                            colA = 19;
                            
                            % check frequency and amplitude columns
                            % to see if they match our parameters
                            if tmpRow(1,colF) == frequencies(valF)
                                if tmpRow(1,colA) == voltages(valA)
                                    tmpArray = cat(1,tmpArray,tmpRow);
                                end
                            end
                    end 
                    
                end
            end
            
        end

        % chop off top all-zeros row of tmpArray
        tmpArray = tmpArray(2:end,:);
        
        % get number of rows in resulting tmpArray
        arrLength = length(tmpArray(:,1));
        
        % get column number of non-fixed variable
        % (math just happens to work out this way)
        tmpColumn = 4 - get(hFixedParametersPopUp,'Value');

        cla reset   % clear plot and reset colors
        hold all    % allows adding multiple functions to plot in for loop
        legendInfo = {0};   % set up legend
        
        % create values to adjust depending on data to display
        forLimit        = 1;
        xVals           = {0};
        yVals           = {0};
        legendVals      = {0};
        xLabelString    = 'asdf';
        
        % depending on display settings, set up plotting parameters
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

        % actually plot our data! 
        for n=1:forLimit
            
            % plot values
            plot(xVals,yVals(n,:),'-s');
            
            % add legend entry
            legendInfo{n} = num2str(legendVals(n));
        end
        
        legend(legendInfo); % define legend
        legend('Location','NorthEastOutside');
        
        xlabel(xLabelString);   % set x label
        
        ylim([0 yAxisHeight]);  % set y limits
        
    end

% --------------------------------------------------------
% Y axis callback
%   Changes y-axis height on graph.
% --------------------------------------------------------

    function yAxisCallback(source,~)
        str = get(source,'String');
        val = get(source,'Value');
        
        % sets y-axis height to literal value from popup
        yAxisHeight = str2double(str{val});
        
        %re-draws graph
        drawGraph;
    end

% --------------------------------------------------------
% Display options callback
%   Changes x-axis values between variable parameter and
%   the different spectrum bands.
% --------------------------------------------------------

    function displayOptionsCallback(~,~)
        
        % since drawGraph queries this popup's value, 
        % we don't really need to do anything except
        % re-draw the graph.
        drawGraph;
    end


% --------------------------------------------------------
% Signal callback.
%   Changes general audio data set depending on user choice.
%   Shows/hides appropriate popup menus.
% --------------------------------------------------------

    function signalCallback(source,~)
        str = get(source, 'String');
        val = get(source,'Value');
        
        switch str{val};
            case 'None'
                hideSignalPopUps;
                showPotRangePopUp;
                createSilenceAudioArray;
                drawGraph;
            case 'Sine Wave'
                showSignalPopUps;
                hidePotRangePopUp;
                createDrivingSignalsArray;
                drawGraph;
        end
    end

% --------------------------------------------------------
% Data set setups.
%   Changes general audio data set depending on pop up menu choice.
% --------------------------------------------------------

    function showSignalPopUps
        set(hFrequencyPopUp,'Visible','on');
        set(hAmplitudePopUp,'Visible','on');
        
        set(hFrequencyLabel,'Visible','on');
        set(hAmplitudeLabel,'Visible','on');
    end
    
    function hideSignalPopUps
        set(hFrequencyPopUp,'Visible','off');
        set(hAmplitudePopUp,'Visible','off');
        
        set(hFrequencyLabel,'Visible','off');
        set(hAmplitudeLabel,'Visible','off');
    end

    function showPotRangePopUp
        set(hPotRangePopUp,'Visible','on');
        set(hPotRangeLabel,'Visible','on');
    end

    function hidePotRangePopUp
        set(hPotRangePopUp,'Visible','off');
        set(hPotRangeLabel,'Visible','off');
    end




% --------------------------------------------------------
% Create huge audio array.
%   creates a massive audio array by concatenating
%   multiple different files.
% --------------------------------------------------------

    function createDrivingSignalsArray
        
        % read in all separate audio data files
        
        f63Hz2V         = csvread('allPot63.csv');
        f63Hz1V         = csvread('allPot63Low.csv');
        f63Hz200mV      = csvread('allPot63Hz200mV.csv');
        
        f160Hz2V        = csvread('allPot160.csv');
        f160Hz1V        = csvread('allPot160Low.csv');
        f160Hz200mV     = csvread('allPot160Hz200mV.csv');
        
        f400Hz2V        = csvread('allPot400.csv');
        f400Hz1V        = csvread('allPot400Low.csv');
        f400Hz200mV     = csvread('allPot400Hz200mV.csv');
        
        f1kHz2V         = csvread('allPot1k.csv');
        f1kHz1V         = csvread('allPot1kLow.csv');
        f1kHz200mV      = csvread('allPot1kHz200mV.csv');
        
        f2500Hz2V       = csvread('allPot2500.csv');
        f2500Hz1V       = csvread('allPot2500Low.csv');
        f2500Hz200mV    = csvread('allPot2500Hz200mV.csv');
        
        f6250Hz2V       = csvread('allPot6250.csv');
        f6250Hz1V       = csvread('allPot6250Low.csv');
        f6250Hz200mV    = csvread('allPot6250Hz200mV.csv');
        
        % concatenate them all
        audioData = cat(1,...
            f63Hz2V,f63Hz1V,f63Hz200mV,...
            f160Hz2V,f160Hz1V,f160Hz200mV,...
            f400Hz2V,f400Hz1V,f400Hz200mV,...
            f1kHz2V,f1kHz1V,f1kHz200mV,...
            f2500Hz2V,f2500Hz1V,f2500Hz200mV,...
            f6250Hz2V,f6250Hz1V,f6250Hz200mV);
    
        % add in frequency and amplitude values to last columns
        for band = 1:6
            for amp = 1:3
                for r = 1:400
                    
                    currentRow = 400*(3*band+amp-4)+r;
                    
                    audioData(currentRow,18) = frequencies(band);
                    audioData(currentRow,19) = voltages(amp);

                end
            end
        end
       
    end

% --------------------------------------------------------
% Create silence array.
%   creates audio array of all silence files.
% --------------------------------------------------------

    function createSilenceAudioArray
        
        % read in silence data files
        allPot = csvread('potNumBrightnessTesting1.csv');
        lowPot = csvread('pot1to9.csv');
        
        % set value of last column equal to max pot value
        for n=1:400
            allPot(n,18) = 121;
            lowPot(n,18) = 9;
        end
        
        % set audioData by concatenating arrays
        audioData = cat(1,allPot,lowPot);
    end



    function frequencyCallback(~,~)
        drawGraph;
    end

% --------------------------------------------------------
% Pot range callback.
%   changes pot range depending on popup value.
% --------------------------------------------------------

    function potRangeCallback(source,~)
        str = get(source, 'String');
        val = get(source,'Value');
        
        switch str{val};
            case '1-121'
                potVals = 1:8:121;
            case '1-9'
                potVals = 1:9;
        end
        
        resetAllData;
    end


end










