include("../../../utils.jl")
include("../../../riskMeasure.jl")
using Plots

dist = [1,1,2,2,3,3,3,3]


quantile_50 = quant(distribution(dist),[0.5])[1]
# Split the data into two parts: left (≤ quantile) and right (> quantile)
dist_left = filter(x -> x <= quantile_50, dist)
dist_right = filter(x -> x > quantile_50, dist)

# Plot histogram of values ≤ quantile (left side)
histogram(dist_left, xlabel="x (Return)", ylabel="Probability mass function", title="Quantile of Discrete Distribution", ylims=(0,6), xlims=(0.5,3.5),bins=0.9:0.2:3.1,
yticks=(0:2:6, ["0", "0.25","0.5","0.75"]), color=:lightblue, edgecolor=:black, label="Left of 50% Quantile")
xticks!(1:3)

annotate!(1.5, 0.5, text("50%", :blue, :center, 12))
annotate!(3, 0.5, text("50%", :red, :left, 12))
# Overlay histogram of values > quantile (right side)
histogram!(dist_right, bins=0.9:0.2:3.1, color=:lightcoral, edgecolor=:black, label="Right of 50% Quantile")

plot!([2.1, 2.9], [0, 0], fill_between=(0, 6), fillalpha=0.4, color=:purple, label="50% Quantile Range")
vline!([2.9], linestyle=:dash, color =:purple, linewidth=3, label="50% VaR")

savefig(check_path("fig/Dissertation/Chapter2/VaR/discrete.pdf"))
