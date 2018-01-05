function [ g ] = basis_function( r, rec )
addpath('../DMP-LWR')
    g = [];
    for j=1:length(rec.times)
        g = cat(3, g, basis_function_time(r, rec, j));
    end
end

function [ g ] = basis_function_time( r, rec, j )
%BASIS_FUNCTION_TIME return p sampled approximation of f given its related
% DMP r, as defined in dmpTrain and its states rec (x;y;t) according to
% time sample j
    state = [rec.x;rec.y];
    psum_x=[]; 
    pdiv_x=0;
    psum_y=[]; 
    pdiv_y=0;
    for i=1:r.ng
        psum_x(i)=psiF(r.h, r.c, r.stime(j)/r.d1,i)*r.w_x(i);
        pdiv_x=pdiv_x+psiF(r.h, r.c, r.stime(j)/r.d1,i);
        psum_y(i)=psiF(r.h, r.c, r.stime(j)/r.d1,i)*r.w_y(i);
        pdiv_y=pdiv_y+psiF(r.h, r.c, r.stime(j)/r.d1,i);
    end
    g = [(psum_x/pdiv_x)*r.stime(j)*(r.gx-r.x0);(psum_y/pdiv_y)*r.stime(j)*(r.gy-r.y0)]; 
end

function r=psiF(h, c, s, i)
    r=exp(-h(i)*(s-c(i))^2); 
end