function gui()
close all force;
fig = uifigure();
fig.WindowState = 'maximized';

%% UI menu
m = uimenu(fig, 'Text','File');
mOpen = uimenu(m,'Text','Open');

%% Dashboard
mainG = uigridlayout(fig,[4 1]);
mainG.RowHeight = {'7x', 60,'3x', 30};
mainG.ColumnWidth = {'1x'};

%% map
gx = geoaxes(mainG);
gx.Layout.Row = 1;
gx.Layout.Column = 1;
geobasemap(gx,'streets');

%% speed, distance and fitness panel
leftG = uigridlayout(mainG,[1,5]);
leftG.ColumnWidth = {'1x','1x','1x','1x','1x'}; 
leftG.Layout.Row = 2;
leftG.Layout.Column = 1;

%% Distance
distance = uilabel(leftG);
distance.Text = '0.00';
distance.FontSize = 28;
distance.HorizontalAlignment = 'center';

%% Speed
speed = uigauge(leftG,'semicircular');
speed.Limits = [0 50];
speedL = uilabel(leftG);
speedL.Text = 'Average Speed: 0 KM/H';
speedL.HorizontalAlignment = 'center';
speedL.FontSize = 28;

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
elevation.Layout.Row = 3;
elevation.Layout.Column = 1;
elevation.YLim = [0 inf];

elevationL = uilabel(mainG);
elevationL.FontSize = 14;
elevationL.HorizontalAlignment = 'center';
elevationL.Text = 'Elevation: m';
elevationL.Layout.Row = 4;
elevationL.Layout.Column = 1;

%% handlers
[openFileClicked] = uiState();

% Open file clicked
mOpen.MenuSelectedFcn = @(src, event)openFileClicked(elevation,...
    distance, speed, speedL, gx, fig);
end

function [openFileClicked] = uiState()
openFileClicked = @openFile;

route = [];

function openFile(elevationPlot, distanceG, speedG, speedL, gx, fig)
    [f,p] = uigetfile('*.gpx');
    if isequal(f,0)
       disp('User selected Cancel');
    else
       cla(elevationPlot);
       cla(gx);
       
       d = uiprogressdlg(fig,'Title','Loading GPX file...','Indeterminate','on');
       drawnow
              
       try
        route = loadgpx(fullfile(p,f),'ElevationUnits','meters');
       catch
        uialert(fig,'Error parsing GPX file.','Invalid File');
        route = [];
        close(d);
       end
       
       % elevation
       elevation = route(:,3);       
       plot(elevationPlot, elevation' ,'-x');
       elevationPlot.YLim = [min(elevation) max(elevation)];
       
       % distance
       d = distance(route(:,1),route(:,2));
       distanceG.Text = sprintf('Distance: %.2f KM',d/1000);
       
       % speed
       s = speed(d, route(:,10:12));
       speedG.Value = s*3.6;
       speedL.Text = sprintf('Average Speed: %.2f KM/H', s*3.6);
       
       % map
       lats = route(:,4)';
       longs = route(:,5)';
       geoplot(gx,lats,longs,'g-*');
    end
end

end
