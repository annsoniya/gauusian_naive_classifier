all_h = [];
for n = 1:length(q)
    neuron_num = q(n);
  h_arr = hvals(neuron_num,:);
  h1_arr = find(h_arr == 1);

  if isempty(h1_arr)
      continue;
  end
  disp(neuron_num)
  h1_segment = h1_arr(1);
  h1_time_start = (h1_segment - 1)*300 + 1;
    h1_time_end = h1_time_start + 299;


    % get me periodic rates
    per_res = data_per_3(neuron_num,:);
    per_res_cat = cat(1, per_res{1,:});
    per_res_cat1 = per_res_cat(:, 500+h1_time_start:500+h1_time_end);
    periodic_n  = zeros(size(per_res_cat1,1),1);
    for i = 1:size(per_res_cat1,1)
        periodic_n(i) = mean(per_res_cat1(i,:))/mean(per_res_cat(i, 501:800));
    end

    per_res = data_aper_3(neuron_num,:);
    per_res_cat = cat(1, per_res{1,:});
    per_res_cat1 = per_res_cat(:, 500+h1_time_start:500+h1_time_end);
    aperiodic_n  = zeros(size(per_res_cat1,1),1);
    for i = 1:size(per_res_cat1,1)
        aperiodic_n(i) = mean(per_res_cat1(i,:))/mean(per_res_cat(i, 501:800));
    end



    % do tttest and display
    % filter nan and inf
    periodic_n = periodic_n(isfinite(periodic_n));
    aperiodic_n = aperiodic_n(isfinite(aperiodic_n));
    periodic_n = periodic_n(~isnan(periodic_n));
    aperiodic_n = aperiodic_n(~isnan(aperiodic_n));
    
[h,~] = ttest2(periodic_n, aperiodic_n);   

    % TODO
    all_h = [all_h h];

    
end