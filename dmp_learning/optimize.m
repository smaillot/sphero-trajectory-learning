function [param, cost, graph, param_log] = optimize(data, start, n)    
    param = start;
    cost = -1;
    graph = [];
    param_log = [];
    w = waitbar(0);
    for i=1:n
        waitbar(i/n, w, strcat(num2str(param.K), ', ', num2str(param.D), ', ', num2str(param.as)));
        [param, cost] = iteration(data, param, cost, 1 - i/(n+1));
        graph = [graph cost];
        param_log = [param_log [param.K ; param.D ; param.as]];
    end
    close(w)
end
    
function cost = trajectory_cost(result, data)
    cost = 0;
    for i=1:length(data.times)
        cost = cost + norm([result.y_xr; result.y_yr] - [data.x; data.y]);
    end
end

function out = randomize(start, lr)
    param = cell2mat(struct2cell(start));
    var = lr * param;
    vec = param + rand(size(param)).*var;
    
    out.K=round(vec(1));
    out.D=round(vec(2));
    out.ng=param(3);
    out.as=vec(4);
    out.s=param(5);
end

function [best, cost] = iteration(data, param, init_cost, i)
    if init_cost == -1
        r = dmpTrain(data, param);
        r = dmpReplay(r);
        init_cost = trajectory_cost(r,data);
    end
    lr = 0.01 * i;
    new_param = randomize(param, lr);
    r = dmpTrain(data, new_param);
    r = dmpReplay(r);
    new_cost = trajectory_cost(r, data);
    if new_cost < init_cost
        best = new_param;
        cost = new_cost;
    else
        best = param;
        cost = init_cost;
    end    
end

function res = weighted_norm(vec, weights)
    res = vec.*weights;
    res = norm(res);
end