function baselines_out = DAG_arrange_baselines(baselines_in,stimulated)
baselines_out={};
for k=1:numel(stimulated)
    baselines_out{k}={};
    for m=1:numel(baselines_in)
        if strcmp(baselines_in{m}{1,1},stimulated{k}{1,1})
            baselines_out{k}=baselines_in{m};
        end
    end
end
end