function h = brainPlot4Angles(coords, labels, options)
% h = brainPlot4Angles(coords, labels, options)
%
% options:
%     coords
%     labels = []
%     options.views = [1:4]
%     options.color = 'blue'; 
%     options.size = 100
%     options.MNI= false
%     options.surfaceAlpha = 0.2
%     options.orientationLabels = false

arguments
    coords
    labels = []
    options.views = [1:4]
    options.color = 'blue'; 
    options.size = 100
    options.MNI= false
    options.surfaceAlpha = 0.2
    options.orientationLabels = true
end

v_idx = [[90,0]; [270, 0]; [180,0]; [180, 90]];

if length(options.views) == 1
    m = 1; n = 1; 
elseif length(options.views) == 2
    m=1; n = 2; 
else
    m = 2; n= 2; 
end

for i = options.views

    subplot(m,n,i); hold on
    if options.color
        scatter3(coords(:,1), coords(:,2), coords(:,3), options.size, options.color, 'filled')
    else
        scatter3(coords(:,1), coords(:,2), coords(:,3), options.size, 'filled')
    end
    if ~isempty(labels)
        text(coords(:,1), coords(:,2), coords(:,3), labels, 'fontsize', 10)
    end
      
    if options.MNI
        plotMNISurface(options.surfaceAlpha, '', caxis);

        if options.orientationLabels
            if i ~=4
                text(0,0,80, 'S', 'FontSize',13)
                text(0,0,-60, 'I', 'FontSize',13)
            end
    
            if i ~=3
                text(0,80, 0, 'A', 'FontSize',13)
                text(0,-120, 0, 'P', 'FontSize',13)
            end
    
            if i ~= [1,2]
                text(90,0,0, 'R', 'FontSize',13)
                text(-90,0,0,'L', 'FontSize',13)
            end
        end

    else
        set(gca, 'minorGridAlpha', .6)
        grid minor
    end

      view(v_idx(i,:))

end

set(gcf, 'position',[783   237   898   610])

h = get(gcf); 

end

