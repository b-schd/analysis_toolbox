function [fighandle, r, p]= trendPlot(fignum, x, y, f_title, xlab, ylab, options)
% USAGE: [fighandle, r, p]= trendPlot(fignum, x, y, f_title, xlab, ylab, options) 
% Creates a plot with x vs. y timeseries. Includes trend line and p value.
% Note: also places a vertical red dotted line at  x=50
% INPUTS:
    % fignum: figure number
    % x: Nx1 vector for variable 1 (e.g. seizure outcomes)
    % y: Nx1 vector for variable 2 (e.g. distance measure)
    % f_title: string, title for the figure
    % xlab: string, x axis label
    % ylab: string, y axis label
    % txt: (optional), cell array of text for each data point (like patient ID number)
    % hsp: (optional, default value: 20) increase padding on ends of  x axis
    
% OUTPUTS:
    % fighandle: handle to the figure
    % r: correlation coefficient
    % p: p-value of correlation
    
% Example: y= distance;  x=outcomes; 
%           trendPlot(1, x,y,'charge density and outcomes',...
%           'siezure reduction (%)', 'distance (mm)', {patients.ID})

arguments
    fignum
    x (:,1)
    y (:,1)
    f_title
    xlab
    ylab
    options.txt = []
    options.hsp = 0
end


fighandle = figure(fignum); clf; hold on; 
[r,p]=corr(x, y);
S= polyfit(x, y, 1);
scatter(x, y, 70,[121, 193, 219]./255, 'filled');
set(gca, 'xlim', [min(x)-options.hsp, max(x)+options.hsp]);
%errorbar(x,y,[dists.stdSOZcent],'o')

xs=get(gca, 'xlim'); 
plot(xs, S(2)+xs*S(1), 'black', 'lineWidth', .5)
if ~isempty(options.txt); text(x-1e-3, y-1e-3,options.txt, 'fontSize', 12, 'HandleVisibility','off'); end
ylabel(ylab); xlabel(xlab)
legend(fighandle.Children.Children(1), sprintf('r^2=%0.2f', r^2), 'location', 'best')
title(sprintf('%s, p=%0.3f', f_title, p))



end

