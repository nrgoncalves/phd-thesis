clc, clear all;

dataFile = 'felleman_connectivity.csv';

cmap = [0, 0, 0;
        128,177,211;
        141,211,199;
        240,240,240;
        255,255,255;
        251,128,114;
        253,180,98;
        179,222,105]/255;

fid = fopen(dataFile, 'r');
thisRow = fgetl(fid);

ind = 0;
while ~isempty(ind)
    
    ind = strfind(thisRow, ',');
    if ~isempty(ind)
        tmp = thisRow(1:ind-1);
        thisRow = thisRow(ind+1:end);
    else
        tmp = thisRow;
    end
    if j > 0
        labels{j} = tmp;
    end
    j = j + 1;
end
disp(labels)
data = zeros(numel(labels), numel(labels));


done = 0;
i = 1;
while (done==0)
    
    thisRow = fgetl(fid);
    if (thisRow == -1)
        done = 1;
    end
    
    j = 0;
    ind = 0;
    while ~isempty(ind)
        
        
        ind = strfind(thisRow, ',');
        if ~isempty(ind)
            tmp = thisRow(1:ind-1);
            thisRow = thisRow(ind+1:end);
        else
            tmp = thisRow;
        end
        
        if j > 0
            switch tmp
                case 'x'
                    val = 0; % self
                case '2'
                    val = 1; % strongly connected
                case '1'
                    val = 2; % connected
                case '.'
                    val = 4; % tested and absent
                case 'NR'
                    val = 5; % non-reciprocal
                case 'NR?'
                    val = 6; % non-reciprocal, controversial
                case '?'
                    val = 7; % controversial
                otherwise
                    val = 3; % unknown
            end        
            % disp(tmp)
            data(i, j) = val;
        end
        j = j + 1;
    end
        
    i = i + 1; 
end

fclose(fid);

imagesc(data);
colormap(cmap);
colorbar();

set(gca, 'xtick', 1:numel(labels))
set(gca, 'xticklabels', labels)
set(gca, 'ytick', 1:numel(labels))
set(gca, 'yticklabels', labels)
axis square
