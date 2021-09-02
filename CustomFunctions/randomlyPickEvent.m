%Written by Kambadur Ananthamurthy
%Randomly picks out an eventIndex from a vector of options
function [selectedEventIndex, eventStartIndex] = randomlyPickEvent(eventIndices, eventLibrary_2D, cell)
idx = randperm(length(eventIndices), 1);
selectedEventIndex = eventIndices(idx);
eventStartIndex = eventLibrary_2D(cell).eventStartIndices(selectedEventIndex);
end