function gui()
close all force;
fig = uifigure();
fig.WindowState = 'maximized';

%% UI menu
m = uimenu(fig, 'Text','File');
mOpen = uimenu(m,'Text','Open');

%% Dashboard
mainG = uigridlayout(fig,[4 1]);
mainG.RowHeight = {40, '6x', '2x', '2x'};
mainG.ColumnWidth = {'1x'};

%% map
gx = geoaxes(mainG);
gx.Layout.Row = 2;
gx.Layout.Column = 1;
geobasemap(gx,'streets');

%% Distance and Speed panel
leftG = uigridlayout(mainG,[1,4]);
leftG.ColumnWidth = {'1x','1x','1x','1x'};
leftG.Layout.Row = 1;
leftG.Layout.Column = 1;

%% Distance
distance = uilabel(leftG);
distance.Text = 'Distance: 0 KM';
distance.FontSize = 14;
distance.HorizontalAlignment = 'center';

%% Average Speed
avgSpeedL = uilabel(leftG);
avgSpeedL.Text = 'Average Speed: 0 KM/H';
avgSpeedL.HorizontalAlignment = 'center';
avgSpeedL.FontSize = 14;

%% Top speed
topSpeedL = uilabel(leftG);
topSpeedL.Text = 'Top Speed: 0 KM/H';
topSpeedL.HorizontalAlignment = 'center';
topSpeedL.FontSize = 14;

%% Duration
durationL = uilabel(leftG);
durationL.Text = 'Duration: hh:mm:ss';
durationL.HorizontalAlignment = 'center';
durationL.FontSize = 14;

%% elevation graph
elevation = uiaxes(mainG, ...
    'XLim', [0 100], ...
    'YLim', [-100 100]);
elevation.Layout.Row = 3;
elevation.Layout.Column = 1;
elevation.YLim = [0 inf];
title(elevation, 'Elevation over time');
grid(elevation,'on');
ylabel(elevation,'Elevation (m)');

%% Speed graph
speedG = uiaxes(mainG, ...
    'XLim', [0 100], ...
    'YLim', [-100 100]);
speedG.Layout.Row = 4;
speedG.Layout.Column = 1;
speedG.YLim = [0 100];
ylabel(speedG,'Speed (KM/H)');
title(speedG, 'Speed over time');
grid(speedG,'on');
linkaxes([elevation, speedG],'x');

%% handlers
[openFileClicked] = uiState();

% Open file clicked
mOpen.MenuSelectedFcn = @(src, event)openFileClicked(elevation,...
    distance, avgSpeedL, topSpeedL, speedG, durationL, gx, fig);
end

function [openFileClicked] = uiState()
openFileClicked = @openFile;

route = [];

    function openFile(elevationPlot, distanceG, avgSpeedL, topSpeedL,speedG,...
            durationL, gx, fig)
        [f,p] = uigetfile('*.gpx');
        if isequal(f,0)
            disp('User selected Cancel');
        else
            d = uiprogressdlg(fig,'Title','Loading GPX file...','Indeterminate','on');
            drawnow
            
            try
                route = loadgpx(fullfile(p,f));
            catch ME
                uialert(fig,ME.message, ME.identifier);
                close(d);
                return;
            end
            
            [count, ~] = size(route);
            if count < 50
                uialert(fig,...
                    'Not enough data for calcualtion and plotting. You need at least 50 points.','Not enough data');
                return;
            end
            
            times = datetime(route(:,7:12));
            
            % elevation
            elevation = route(:,3);
            area(elevationPlot, times', elevation');
            elevationLimits = [min(elevation) max(elevation)];
            if elevationLimits(1) ~= elevationLimits(end)
                elevationPlot.YLim = [elevationLimits(1), elevationLimits(end)];
            end
            
            % distance
            d = distance(route(:,1),route(:,2));
            distanceG.Text = sprintf('Distance: %.2f KM',d/1000);
            
            % average speed
            ms = speed(d, times);
            avgSpeedL.Text = sprintf('Average Speed: %.2f KM/H', msToKmh(ms));
            
            % speed graph
            cumulativeSpeeds = msToKmh(cumSpeed(route(:,1), route(:,2), times));
            speedLimits = [min(cumulativeSpeeds) max(cumulativeSpeeds)];
            if speedLimits(1) ~= speedLimits(end)
                speedG.YLim = [speedLimits(1) speedLimits(end)];
            end
            plot(speedG, times(2:end)', cumulativeSpeeds','-');
            
            % top speed
            topSpeedL.Text = sprintf('Top Speed: %.2f KM/H',...
                max(cumulativeSpeeds));
            
            % duration
            d = abs(times(1) - times(end));
            durationL.Text = sprintf('Duration: %s', string(d,'hh:mm:ss'));
            
            % map
            lats = route(:,4)';
            longs = route(:,5)';
            geoplot(gx,lats,longs,'r-.');
        end
    end

end
