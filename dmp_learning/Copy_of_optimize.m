function [param, cost, graph, param_log] = optimize(data, start, n)    
    param = start;
    cost = -1;
    graph = [];
    param_log = [];
    w = waitbar(0);
    grad = 0.1 * [param.K ; param.D; param.as];
    last_diff = 1;
    weights = [0.001 0.00001 100]; 
    grad_norm = weighted_norm(grad, weights);
    for i=1:n
        waitbar(i/n, w, strcat(num2str(param.K), ', ', num2str(param.D), ', ', num2str(param.as)));
        if size(param_log, 2) > 1
            if param_log(:,end) ~= param_log(:,end-1)
                last_diff = i-2;
            end
            grad = param_log(:,end) - param_log(:,last_diff);
            grad_norm = weighted_norm(grad, weights)
        end
        [param, cost] = iteration(data, param, cost, grad, grad_norm);
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

function [best, cost] = iteration(data, param, init_cost, grad, grad_norm)
    if init_cost == -1
        r = dmpTrain(data, param);
        r = dmpReplay(r);
        init_cost = trajectory_cost(r,data);
    end
    lr = 0.1 * grad_norm;
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
    res = norm(res) * 1e-4;
end