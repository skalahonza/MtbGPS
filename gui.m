function gui()
close all force;
fig = uifigure();
fig.WindowState = 'maximized';

%% UI menu
m = uimenu(fig, 'Text','File');
mOpen = uimenu(m,'Text','Open');

%% Dashboard
mainG = uigridlayout(fig,[3 2]);
mainG.RowHeight = {'7x','3x', 30};
mainG.ColumnWidth = {150 ,'1x'};

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

%% Distance
distance = uilabel(leftG);
distance.Text = '0.00';
distance.FontSize = 28;
distance.HorizontalAlignment = 'center';
distanceL = uilabel(leftG);
distanceL.Text = 'Distance: KM';
distanceL.FontSize = 14;
distanceL.HorizontalAlignment = 'center';

%% Speed
speed = uigauge(leftG,'semicircular');
speed.Limits = [0 50];
speedL = uilabel(leftG);
speedL.Text = 'Speed: KM/H';
speedL.HorizontalAlignment = 'center';
speedL.FontSize = 14;

%% Fitness
fitness = uilabel(leftG);
fitness.Text = '0';
fitness.FontSize = 28;
fitness.HorizontalAlignment = 'center';
fitnessL = uilabel(leftG);
fitnessL.Text = 'Energy: kcal';
fitnessL.FontSize = 14;
fitnessL.HorizontalAlignment = 'center';

%% elevation
elevation = uiaxes(mainG, ...
    'XLim', [0 100], ...
    'YLim', [-100 100]);
elevation.Layout.Row = 2;
elevation.Layout.Column = [1, 2];
elevation.YLim = [0 inf];

elevationL = uilabel(mainG);
elevationL.FontSize = 14;
elevationL.HorizontalAlignment = 'center';
elevationL.Text = 'Elevation: m';
elevationL.Layout.Column = [1 2];

%% handlers
[openFileClicked] = uiState();

% Open file clicked
mOpen.MenuSelectedFcn = @(src, event)openFileClicked(elevation);
end

function [openFileClicked] = uiState()
openFileClicked = @openFile;

distance = 0;
speed = 0;
calories = 0;
elevation = [];

function openFile(elevationPlot)
    [f,p] = uigetfile('*.gpx');
    if isequal(f,0)
       disp('User selected Cancel');
    else
       route = loadgpx(fullfile(p,f),'ElevationUnits','meters');
       elevation = route(:,3);       
       plot(elevationPlot, elevation' ,'-x');
       elevationPlot.YLim = [min(elevation) max(elevation)];
    end
end

end
