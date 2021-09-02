function width = findEventWidth(event)
    %threshold = mean + 2std
    threshold = mean(event) + 2*(std(event));
    width = length(find(event>threshold));
end