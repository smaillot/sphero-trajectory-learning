function value=weigh_sum_basis_func(r,k,timec)
    value=[];
    c=gen_time(r.ng,r);
    d=diff(c);
    for j=1:length(r.w_x)
       value=[value; psiF(r.h,r.c,timec(k)/d(1),j)];
    end
    value
end