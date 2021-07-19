export predict

function predict(d::ModelClosure, post::Vector{NamedTuple{N,T}}) where {N,T}
    args = argvals(d)
    m = d.model
    pred = predictive(m, keys(post[1])...)
    map(nt -> rand(pred(merge(args,nt))), post)
end

function predict(m::DAGModel, post::Vector{NamedTuple{N,T}}) where {N,T}
    pred = predictive(m, keys(post[1])...)
    map(nt -> rand(pred(nt)), post)
end


# TODO: These don't yet work properly t on particles

function predict(d::ModelClosure, post::NamedTuple{N,T}) where {N,T}
    args = argvals(d)
    m = Model(d)
    pred = predictive(m, keys(post)...)
    rand(pred(merge(args,post)))
end

function predict(m::DAGModel, post::NamedTuple{N,T}) where {N,T}
    pred = predictive(m, keys(post)...)
    rand(pred(post))
end

predict(m::DAGModel; kwargs...) = predict(m,(;kwargs...))

predict(d,x) = x

function predict(d, s::AbstractVector)
    [predict(d, sj) for sj in s]
end
