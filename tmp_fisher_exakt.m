function P_fexakt=tmp_fisher_exakt(n_par1_grp1,n_par0_grp1,n_par1_grp2,n_par0_grp2)
idx=0;
for k=1:numel(n_par1_grp1)
    idx=idx+1;
    n_pars_group1_binary{idx}=[ones(n_par1_grp1(k),1); zeros(n_par0_grp1(k),1)];
    n_pars_group2_binary{idx}=[ones(n_par1_grp2(k),1); zeros(n_par0_grp2(k),1)];
end

for comparison=1:numel(n_par1_grp1)
    
    Status=[ones(numel(n_pars_group1_binary{comparison}),1); zeros(numel(n_pars_group2_binary{comparison}),1)];
    Binary_data=[n_pars_group1_binary{comparison}; n_pars_group2_binary{comparison}];
    P_fexakt(comparison) = fexact(Binary_data,Status);
end

end