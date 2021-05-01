function Save_Data
%
%
%
%

%% --- Initialize ---------------------------------------------------------
%--------------------------------------------------------------------------
global GUI_opt;
global my_DB;


GUI_opt.filename_cell = [ GUI_opt.path_DIR ,'/' , GUI_opt.exp_name , '_3_Cell.txt'];
GUI_opt.filename_foci = [ GUI_opt.path_DIR ,'/' , GUI_opt.exp_name , '_3_Foci.txt'];

file_C = fopen(GUI_opt.filename_cell, 'w+');
fprintf( file_C, 'Cell Length \t Number Foci \t Abs tot Foci_A in Membr_A \t Abs tot Foci_A in Cyto_A \t ' );
fprintf( file_C, 'Rel Foci_A in Membr_A \t Rel Foci_A in Cyto_A \t Avg Foci eccentricity \t ' );
fprintf( file_C, 'Avg Foci Area \t Avg Foci distance \t Area Membr \t Area Cyto \t ' );
fprintf( file_C, 'Area Cell \t Avg Int Membr \t Avg Int Cyto \t Avg Int Cell \t\n' );

file_F = fopen(GUI_opt.filename_foci, 'w+');
fprintf( file_F, 'Foci area \t Abs Foci_A in Membr_A \t Abs Foci_A in Cyto_A \t Avg Int signal \t ' );
fprintf( file_F, 'Eccentricity \t Distance from cell Center \t Length cell it belongs \t \n' );

%% --- Data Extraction ----------------------------------------------------
%--------------------------------------------------------------------------   
for f = 1 : length(my_DB)                   % go through all frames
for c = 1 : length(my_DB(f).cell)           % go through each cell
t_C = [];              % temporary matrices to handle and store data 
t_F = [0 0 0 0];       % before saving all in correscponding files.    
if ~isempty(my_DB(1,f).cell(1,c).coord)                 % if it is not empty
    t_C( 1) =  my_DB(1,f).cell(1,c).geom.length ;
    t_C( 2) =  length( my_DB(1,f).cell(1,c).Foci );
    
    % Fraction of Foci pixel area in Mem and Cyt
    t_C( 3) =  sum(sum(my_DB(1, f).cell(1, c).M_Foci .* my_DB(1, f).cell(1, c).M_Mem)) / sum(sum( my_DB(1, f).cell(1, c).M_Foci)) ;
    t_C( 4) =  sum(sum(my_DB(1, f).cell(1, c).M_Foci .* my_DB(1, f).cell(1, c).M_Cyt)) / sum(sum( my_DB(1, f).cell(1, c).M_Foci)) ;
    
    % Fraction of Foci pixel area in Mem and Cyt in respect ro Cell area
    t_C( 5) =  sum(sum(my_DB(1, f).cell(1, c).M_Foci .* my_DB(1, f).cell(1, c).M_Mem)) / sum(sum( my_DB(1, f).cell(1, c).M_Cel)) ;
    t_C( 6) =  sum(sum(my_DB(1, f).cell(1, c).M_Foci .* my_DB(1, f).cell(1, c).M_Cyt)) / sum(sum( my_DB(1, f).cell(1, c).M_Cel)) ;
    
    % Average Foci Eccentricity, pixel Area and Distance from cell centroid
    if ~ isempty( fieldnames(my_DB(1,f).cell(1,c).Foci ))     % if there are no fields, there are no Foci
    t_epsl = [];  t_area = [];  t_dist = [];
    for k = 1 : length( my_DB(1,f).cell(1,c).Foci )
        F_C = [];   C_C = [];
        t_epsl(k) =  my_DB(1,f).cell(1,c).Foci(1, k).Epsilon ;
        t_area(k) =  my_DB(1,f).cell(1,c).Foci(1, k).Area ;
        F_C = my_DB(1,f).cell(1,c).geom.C ;
        C_C = my_DB(1,f).cell(1,c).Foci(1, k).C ; 
        t_dist(k) = sqrt( (F_C(1)-C_C(1))^2 - (F_C(2)-C_C(2))^2 );  % in pixel
    end
    end
    t_C( 7) =  mean(t_epsl) ;
    t_C( 8) =  mean(t_area) ;
    t_C( 9) =  mean(t_dist) ;
    
    % Pixel Area Membrane and Cytosol and Cell
    t_C( 10) =  sum(sum( my_DB(1, f).cell(1, c).M_Mem ));
    t_C( 11) =  sum(sum( my_DB(1, f).cell(1, c).M_Cyt ));
    t_C( 12) =  sum(sum( my_DB(1, f).cell(1, c).M_Cel )); 
    
    % Average Pixel signal of Membrane and Cytosol and Cell: Absolute
    t_C( 13) =  mean(my_DB(1, f).cell(1, c).IC( my_DB(1, f).cell(1, c).M_Mem ));
    t_C( 14) =  mean(my_DB(1, f).cell(1, c).IC( my_DB(1, f).cell(1, c).M_Cyt ));
    t_C( 15) =  mean(my_DB(1, f).cell(1, c).IC( my_DB(1, f).cell(1, c).M_Cel ));

    % Parse the foci to collect info about them
    if ~ isempty( fieldnames(my_DB(1,f).cell(1,c).Foci))      % if there are no fields, there are no Foci
    for k = 1 : length( my_DB(1,f).cell(1,c).Foci )
        t_F = [0 0 0 0];    
        int_sig = [] ;
        F_C = [];   C_C = [];
        t_F( 1) =  my_DB(1,f).cell(1,c).Foci(k).Area ;
        
        
        % Go through Pixel list to gather data on intensity and location
        for i = 1 : length( my_DB(1, f).cell(1, c).Foci(k).PixList )
        %if the Pixel of Foci are 1 in the Mask, the area in that layer increases by one
        [row,col] = size(my_DB(1, f).cell(1, c).M_Foci);
        for k =  1 : length( my_DB(1, f).cell(1, c).Foci )      % go throught each Focii
            mask = zeros(row,col);
            for i = 1 : length( my_DB(1, f).cell(1, c).Foci(k).PixList )
                mask( my_DB(1, f).cell(1, c).Foci(k).PixList(i,2) , ...
                      my_DB(1, f).cell(1, c).Foci(k).PixList(i,1) ) = 1 ;
            end
            t_F( 2) =  sum(sum(mask .* my_DB(1, f).cell(1, c).M_Mem)) / sum(sum(mask)) ;
            t_F( 3) =  sum(sum(mask .* my_DB(1, f).cell(1, c).M_Cyt)) / sum(sum(mask)) ;

            end
            int_sig =  [ int_sig , my_DB(1, f).cell(1, c).IC( my_DB(1, f).cell(1, c).Foci(k).PixList(i,2) , ...
                                                              my_DB(1, f).cell(1, c).Foci(k).PixList(i,1) ) ];
            t_F( 4) =  mean(int_sig) ;
        end  
        
        
        % go throught each Focii again, but now we are outside PixelList for
        for k =  1 : length( my_DB(1, f).cell(1, c).Foci )      
            t_F( 5) =  my_DB(1,f).cell(1,c).Foci(k).Epsilon ;
            F_C = my_DB(1,f).cell(1,c).geom.C ;
            C_C = my_DB(1,f).cell(1,c).Foci(k).C ; 
            t_F( 6) =  sqrt( (F_C(1)-C_C(1))^2 - (F_C(2)-C_C(2))^2 );  % in pixel
            t_F( 7) =  my_DB(1,f).cell(1,c).geom.length ;

            t_F_Prof_Line =  my_DB(1,f).cell(1,c).Foci(k).Prof_line;        
            % Max length Prof_Line = 25. Add zeros left-right in order to center the profiles 
            % in the middle of array. In such way all profiles of all cells are comparable
            % NB: when comparing keep in mind the cell width variation 
            Z = 25 - length(t_F_Prof_Line);
            if mod(Z,2) == 0
                plus = zeros(1, (Z/2));
                t_F_Prof_Line = [plus, (t_F_Prof_Line) , plus];
            else
                plus = zeros(1, fix(Z/2));      % fix(), division returning integer
                t_F_Prof_Line = [plus, (t_F_Prof_Line) , plus, 0];
            end
            % Save a single Foci entry        
            fprintf( file_F , '%f\t', t_F(:));
            fprintf( file_F , '\t');
            fprintf( file_F , '%f\t', t_F_Prof_Line);
            fprintf( file_F , '\n' );
        end
     
        
    end
    end
    % Save a single Cell entry
    fprintf( file_C , '%f\t', t_C(:) );
    fprintf( file_C , '\n' );
end
end
end
fclose(file_C) ;
fclose(file_F) ;

end

