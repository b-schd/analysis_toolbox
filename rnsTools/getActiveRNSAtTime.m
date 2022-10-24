function [activeRNS, RNScentroids] = getActiveRNSAtTime(allPts, allPDMS, dates)
% [activeRNS, RNScentroids] = getActiveRNSAtTime(allPts, allPDMS, dates)
%
%  Returns the active electrode configuration for each patient at the specified treatment date. 
%
% INPUTS:
%   allPts- struct of patients (e.g. patients_Penn)
%   allPDMS- PDMS table with patient IDs, dates, and stimulation settings
%   dates- Date of stimulation for each patient.
%
% OUTPUTS: 
%   activeRNS- cell array of 9-element boolean vectors (first 8 are the 4 +
%   4 electrode contacts, 9 is the can)
%   RNScentroids- centroid of active contacts on each electrode
%
% NOTE: If a patient is not found in PDMS, all of their contacts will be
% set to active. 


assert(length(allPts) == length(dates), 'Error: length mismatch between allPts and dates')

activeRNS= cell(length(allPts), 1); 
RNScentroids = cell(length(allPts), 1); 

for i_pt = 1:length(allPts)
    
    pt = allPts(i_pt); 
    inds = find(strcmp(allPts(i_pt).ID, allPDMS.id_code)); 
    
    if isempty(pt.RNS_connected), continue, end
    
    if isempty(inds)
        warning('%s not found in PDMS table, setting all %s contacts to active', pt.ID, pt.ID)
        activeRNS{i_pt} = logical([1,1,1,1,1,1,1,1,0]); 
    else
    
    [~, i_date]= min(abs(dates(1)- allPDMS.Programming_Date(inds))); 
    
    activeRNS{i_pt} = [(allPDMS.Tx1_B1(inds(i_date),:)~=0)+ ...
                      (allPDMS.Tx1_B2(inds(i_date),:)~=0)+ ...
                      (allPDMS.Tx2_B1(inds(i_date),:)~=0)+ ...
                      (allPDMS.Tx2_B2(inds(i_date),:)~=0)+ ...
                      (allPDMS.Tx3_B1(inds(i_date),:)~=0)+ ...
                      (allPDMS.Tx3_B2(inds(i_date),:)~=0)+ ...
                      (allPDMS.Tx4_B1(inds(i_date),:)~=0)+ ...
                      (allPDMS.Tx4_B2(inds(i_date),:)~=0)+ ...
                      (allPDMS.Tx5_B1(inds(i_date),:)~=0)+ ...
                      (allPDMS.Tx5_B2(inds(i_date),:)~=0)] > 0; 
    end
                      
    % Get names of connected, active electrodes
    onNames = pt.RNS_connected(activeRNS{i_pt}(1:8));
    [~, coord_inds] = ismember(lower(onNames), lower(pt.RNS_channels));
    coords = pt.RNS_coords(coord_inds,:);
    
    gp = [1,1,1,1,2,2,2,2];
    group = gp(activeRNS{i_pt}(1:8));
    
    
    if ~isempty(allPts(i_pt).RNS_coords)
        RNScentroids{i_pt} = getCentroid(coords, group);  
    end
    
end

end