function P_fexakt=DAG_fisher_exakt_scalars(n_par1_grp1,n_par0_grp1,n_par1_grp2,n_par0_grp2)

n_pars_group1_binary=[ones(n_par1_grp1,1); zeros(n_par0_grp1,1)];
n_pars_group2_binary=[ones(n_par1_grp2,1); zeros(n_par0_grp2,1)];

Status=[ones(numel(n_pars_group1_binary),1); zeros(numel(n_pars_group2_binary),1)];
Binary_data=[n_pars_group1_binary; n_pars_group2_binary];
P_fexakt = fexact(Binary_data,Status);

end