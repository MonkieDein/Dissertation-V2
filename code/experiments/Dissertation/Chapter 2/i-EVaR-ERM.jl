include("../../../utils.jl")
include("../../../riskMeasure.jl")
using Plots
using Distributions

α = collect(0.005:0.005:.995)
β = 100 * (0.99 .^ (0:2000))

dist = Normal(0, 1)
x = rand(dist, 1_000_000)
d = distribution(x)

min_val = min(d)
mean_val = E(d)
erm_val = ERMs(d, β)
arg_erm = [β[tup[2]] for tup in argmax( (erm_val' .+ log.(α) ./ β' ) ,dims=2)]
# evar_val = clamp.(maximum( (erm_val' .+ log.(α) ./ β' ) ,dims=2),min_val,mean_val)


# Plot the PDF curve
plot( arg_erm,α,label="Risk level mapping", linewidth=2, color=:darkred,alpha=0.7)
xlabel!("ERM's risk level (β)")
ylabel!("EVaR's risk level (α)")
# title!("Risk Parameter from ERM (β) to EVaR (α)")


savefig(check_path("fig/Dissertation/Chapter2/EVaR/risk_level_mapping.pdf"))
