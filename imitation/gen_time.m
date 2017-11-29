function timec=gen_time(resolution,r)
    incr=(max(r.stime)-min(r.stime))/(resolution-1);
    timec=min(r.stime):incr:max(r.stime);
end

