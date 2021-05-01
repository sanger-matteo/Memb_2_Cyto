function Retrive_Cells(  )
%
%
%
%

global GUI_opt ;    global my_DB ;

%%-------------------------Declerad fields--------------------------------
% Takes cells contour, identified by microTracker and extract the
% informatio of the fluorescent signal near the cell contour.
%
% ---Definition of "info" struct--------------------------
d_info  = struct( 'date', [] ,...       % date, in formt YYMMDD
                  'exp_title', [], ...  % experiment folder title
                  'sub_title', [] ,...  % relative subfolder/movie tittle
                  'rel_ID', [] ...     % cell ID, relative to subfolder/movie
                   );
               
% ---Definition of "geom" struct--------------------------
d_geom = struct( 'length',[] ,...       % [pixel] , cell length
                 'area',[] ...       
                  );

% ---Definition of "my_cells" struct------------------------           
% Defining our main data structure, constituent of the database
def_cells = struct('coord', {} ,...      % x and y contour coordinates
                   'geom',  d_geom ...
                   );  
                              
%% --------------------- Retrive raw Data from tracks -------------------------
% Initiate a temporary handle where to store data; retrive data as raw contour
% coordinates from cellList.mat file generated by microbeTracker (Tracks.mat)
global GUI_opt;
load(GUI_opt.microTrack) ;
if GUI_opt.DB_source == 0                               % input is from Oufti
    temp_DB = Retrive_mesh_Oufti(cellList.meshData) ;
elseif GUI_opt.DB_source == 1                           % input is  from microbeTracker
    temp_DB = Retrive_mesh_microTrack(cellList) ;
end

% temp_DB = Retrive_BF_mesh(cellList.meshData) ;          % input is from Oufti

%% ------------ SAVE my_DB.mat -------------------------

my_DB = temp_DB;           % in DB the ultimate variable is named my_cells, 
save([GUI_opt.path_DIR , '/' , GUI_opt.exp_name , '_1_DB'] , 'my_DB');    % thus we need to rename before saving in DB



end
