function [eventPhases, eventsTaken, cycleNums_withSpikes] = DAG_eventPhase(interval_starts, interval_ends, eventTimes)
% eventPhase: This function calculates the phase of the event related to a
% cycle of a cyclic process (e.g. heart beat, or breathing)
%
% Example usage:
% eventPhases = DAG_eventPhase(interval_starts, interval_ends, eventTimes)
%
% Input:
% interval_starts - times of interval starts (e.g. in seconds)
% interval_ends - times of interval ends (the same units as
% interval_starts) - one may provide non-consecutive intervals to the
%   function without problems
% eventTimes - times of the studied events (the same units and time axis as
%   for interval_starts and interval_ends)
% 
% Output:
% eventPhase - phases of events related to the cyclic process in radians
% eventsTaken - indices of events that landed in intervals

% % for debugging
% interval_starts = [0, 1.1, 2.3, 3.6, 4.9, 6.2, 7.5, 8.8, 10.1];
% interval_ends = [1.1, 2.3, 3.6, 4.9, 6.2, 7.5, 8.8, 10.1, 11.4];
% eventTimes = interval_starts + (interval_ends - interval_starts)/2;

% make inputs vertical vectors
if size(interval_starts, 2) > size(interval_starts, 1)
    interval_starts = interval_starts';
end
if size(interval_ends, 2) > size(interval_ends, 1)
    interval_ends = interval_ends';
end
if size(eventTimes, 2) > size(eventTimes, 1)
    eventTimes = eventTimes';
end

% Calculate ECG cycle durations
cycleDurations = interval_ends - interval_starts;

% Normalize event times to the respective ECG cycle durations
cycleNums_withSpikes = arrayfun(@(x) find(x > interval_starts & x < interval_ends), eventTimes, 'UniformOutput', false); % for each event find the corresponding cycle number
events2include = cellfun(@(x) ~isempty(x), cycleNums_withSpikes, 'UniformOutput', false); % find event indices that landed in any interval of the cyclic process
events2include = [events2include{:}];
eventTimes = eventTimes(events2include); % include only events that landed within any interval
cycleNums_withSpikes    = [cycleNums_withSpikes{:}];
eventTimesNorm = (eventTimes - interval_starts(cycleNums_withSpikes)) ./ cycleDurations(cycleNums_withSpikes);
eventPhases = 2*pi*eventTimesNorm;
eventsTaken = single(find(events2include))';
end
