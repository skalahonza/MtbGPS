function gui()
close all force;
fig = uifigure();
fig.WindowState = 'maximized';

%% UI menu
m = uimenu(fig, 'Text','File');
mOpen = uimenu(m,'Text','Open');

%% Dashboard
mainG = uigridlayout(fig,[6 1]);
mainG.RowHeight = {'8x', 60, 30,'1x', 30,'1x'};
mainG.ColumnWidth = {'1x'};

%% map
gx = geoaxes(mainG);
gx.Layout.Row = 1;
gx.Layout.Column = 1;
geobasemap(gx,'streets');

%% speed, distance and fitness panel
leftG = uigridlayout(mainG,[1,2]);
leftG.ColumnWidth = {'1x','1x'}; 
leftG.Layout.Row = 2;
leftG.Layout.Column = 1;

%% Distance
distance = uilabel(leftG);
distance.Text = 'Distance: 0 KM';
distance.FontSize = 28;
distance.HorizontalAlignment = 'center';

%% Speed
avgSpeedL = uilabel(leftG);
avgSpeedL.Text = 'Average Speed: 0 KM/H';
avgSpeedL.HorizontalAlignment = 'center';
avgSpeedL.FontSize = 28;

%% elevation graph
elevationL = uilabel(mainG);
elevationL.FontSize = 28;
elevationL.HorizontalAlignment = 'center';
elevationL.Text = 'Elevation (meters)';
elevationL.Layout.Row = 3;
elevationL.Layout.Column = 1;

elevation = uiaxes(mainG, ...
    'XLim', [0 100], ...
    'YLim', [-100 100]);
elevation.Layout.Row = 4;
elevation.Layout.Column = 1;
elevation.YLim = [0 inf];
ylabel(elevation,'Elevation (meters)');

%% Speed graph
speedL = uilabel(mainG);
speedL.FontSize = 28;
speedL.HorizontalAlignment = 'center';
speedL.Text = 'Speed KM/H';
speedL.Layout.Row = 5;
speedL.Layout.Column = 1;

speedG = uiaxes(mainG, ...
    'XLim', [0 100], ...
    'YLim', [-100 100]);
speedG.Layout.Row = 6;
speedG.Layout.Column = 1;
speedG.YLim = [0 100];
ylabel(speedG,'Speed KM/H');

%% handlers
[openFileClicked] = uiState();

% Open file clicked
mOpen.MenuSelectedFcn = @(src, event)openFileClicked(elevation,...
    distance, avgSpeedL, speedG, gx, fig);
end

function [openFileClicked] = uiState()
openFileClicked = @openFile;

route = [];

function openFile(elevationPlot, distanceG, avgSpeedL, speedG, gx, fig)
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
        close(d);
        return;
       end
       
       % elevation
       elevation = route(:,3);       
       plot(elevationPlot, elevation' ,'-x');
       elevationPlot.YLim = [min(elevation) max(elevation)];
       
       % distance
       d = distance(route(:,1),route(:,2));
       distanceG.Text = sprintf('Distance: %.2f KM',d/1000);
       
       % average speed
       ms = speed(d, route(:,10:12));
       avgSpeedL.Text = sprintf('Average Speed: %.2f KM/H', msToKmh(ms));
       
       % speed graph
       cumulativeSpeeds = msToKmh(cumSpeed(route(:,1),route(:,2),route(:,10:12)));
       speedG.YLim = [min(cumulativeSpeeds) max(cumulativeSpeeds)];
       plot(speedG, cumulativeSpeeds','-x');
       
       % map
       lats = route(:,4)';
       longs = route(:,5)';
       geoplot(gx,lats,longs,'g-*');
    end
end

end
