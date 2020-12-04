function gui()
close all force;

%% Grid Layout
fig = uifigure('Position',[100 100 637 517]);
mainG = uigridlayout(fig,[3 2]);
mainG.RowHeight = {'8x','2x', 30};
mainG.ColumnWidth = {'2x' ,'8x'};

%% map
gx = geoaxes(mainG);
gx.Layout.Row = 1;
gx.Layout.Column = 2;
latSeattle = 47.62;
lonSeattle = -122.33;
latAnchorage = 61.20;
lonAnchorage = -149.9;
geoplot(gx,[latSeattle latAnchorage],[lonSeattle lonAnchorage],'g-*')
geobasemap(gx,'streets')

%% left panel
leftG = uigridlayout(mainG,[6 1]);
leftG.RowHeight = {'1x',30,'fit','1x','fit','1x'}; 
leftG.Layout.Row = 1;
leftG.Layout.Column = 1;

%% Speed
speed = uigauge(leftG,'semicircular');
speed.Limits = [0 50];
speedL = uilabel(leftG);
speedL.Text = 'Speed: KM/H';
speedL.HorizontalAlignment = 'center';
speedL.FontSize = 14;



%% elevation
elevation = uiaxes(mainG, ...
    'XLim', [0 100], ...
    'YLim', [-100 100]);
elevation.Layout.Row = 2;
elevation.Layout.Column = [1, 2];
elevationL = uilabel(mainG);
elevationL.FontSize = 14;
elevationL.HorizontalAlignment = 'center';
elevationL.Layout.Column = [1 2];
%% handlers

end