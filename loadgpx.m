function route = loadgpx(fileName)
%LOADGPX Loads route points from a GPS interchange file
% ROUTE = LOADGPX(FILENAME) Loads route point information from a .GPX
%   GPS interchange file.  This utility is not a general-purpose
%   implementation of GPX reading and is intended mostly for reading the
%   files output by the "gmap pedometer" tool.
%
% ROUTE is a Nx6 array where each row is a route point.
%   Columns 1-3 are the X, Y, and Z coordinates.
%   Columns 4-5 are latitude and longitude
%   Column  6 is cumulative route length.
%
% Note that the mapping of latitude/longitude assumes an approximate spherical
% transformation to rectangular coordinates.
%
%
%   For more information on the gmap pedometer and GPX output:
%     http://www.gmap-pedometer.com/
%     http://www.elsewhere.org/journal/gmaptogpx/
%
% See also xmlread

%Column identifiers
COL_X   = 1;
COL_Y   = 2;
COL_Z   = 3;
COL_LAT = 4;
COL_LNG = 5;

d = xmlread(fileName);

if ~strcmp(d.getDocumentElement.getTagName,'gpx')
    ME = MException('loadgpx:formaterror','File is not a GPX format');
    throw(ME);
end

COL_TIMEVEC = 7:12;

ptList = d.getElementsByTagName('trkpt');
ptCt = ptList.getLength;

if ptCt == 0
    ME = MException('loadgpx:no_records',...
        'There are no records in the given file.');
    throw(ME);
end

route = nan(ptCt,5);
for i=1:ptCt
    pt = ptList.item(i-1);
    tim = pt.getElementsByTagName('time') ;
    timChar = char(tim.item(0).getTextContent) ;
    route(i,COL_TIMEVEC) = datevec([timChar(1:10) ' ' timChar(12:19)]) ;
    try
        route(i,COL_LAT) = assertdouble(pt.getAttribute('lat'), ...
            'loadgpx:bad_latitude', ...
            'Latitude is not a number.');
    catch Ex
        ME = MException('loadgpx:bad_latitude','Malformed latitutude in point %i.  (%s)', i, Ex.message);
        throw(ME);
    end
    try
        route(i,COL_LNG) = assertdouble(pt.getAttribute('lon'), ...
            'loadgpx:bad_longitude', ...
            'Longtitude is not a number.');
    catch Ex
        ME = MException('loadgpx:bad_longitude',...
            'Malformed longitude in point %i.  (%s)', i, Ex.message);
        throw(ME);
    end
    
    ele = pt.getElementsByTagName('ele');
    if ele.getLength>0
        try 
            route(i,COL_Z) = assertdouble(ele.item(0).getTextContent,...
                'loadgpx:bad_elevation',...
                'Elevation is not a number');
        catch Ex
            ME = MException('loadgpx:bad_elevation',...
                'Malformed elevation in point %i.  (%s)', i, Ex.message);
            throw(ME);
        end
    end
end

route(:,[COL_Y,COL_X]) = route(:,[COL_LAT,COL_LNG]) - ones(ptCt,1)*route(1,COL_LAT:COL_LNG);

lat_mean=mean(route(:,COL_LAT));
% compute route in meters
KM_PER_ARCMINUTE = 1.852;
route(:,COL_X:COL_Y) = KM_PER_ARCMINUTE*1000*60*route(:,COL_X:COL_Y);
route(:,COL_X) = route(:,COL_X)*cos(lat_mean/180*pi);
end