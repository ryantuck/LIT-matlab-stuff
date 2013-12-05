function audioGUI

% Audio UI to analyze headband audio data

%  Create and then hide the GUI as it is being constructed.
f = figure('Visible','off','Position',[360,500,450,285]);

% create radio buttons
hpot = uicontrol('Style','radiobutton',...
            'String','pot value',...
            'Position',[315,220,150,25]);
hnum = uicontrol('Style','radiobutton',...
            'String','number',...
            'Position',[315,180,150,25]);
hbr = uicontrol('Style','radiobutton',...
            'String','brightness',...
            'Position',[315,140,150,25]);

set(f,'Visible','on');



end
