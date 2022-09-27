function h = brainPlot4Angles(coords, labels, options)

arguments
    coords
    labels = []
    options.color = 'blue'; 
    options.size = 100
    options.MNI= false
    options.surfaceAlpha = 0.2
end

v_idx = [[90,0]; [270, 0]; [180,0]; [180, 90]];

for i = (1:4)

    subplot(2,2,i); hold on
    if options.color
        scatter3(coords(:,1), coords(:,2), coords(:,3), options.size, options.color, 'filled')
    else
        scatter3(coords(:,1), coords(:,2), coords(:,3), options.size, 'filled')
    end
    if ~isempty(labels)
        textscatter3(coords(:,1), coords(:,2), coords(:,3), labels, 'fontsize', 10, 'TextDensityPercentage', 100)
    end
      
    if options.MNI
        plotMNISurface(options.surfaceAlpha, '', caxis);
    else
        set(gca, 'minorGridAlpha', .6)
        grid minor
    end

      view(v_idx(i,:))

end

set(gcf, 'position',[783   237   898   610])

h = get(gcf); 

end

