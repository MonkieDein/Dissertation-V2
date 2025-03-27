include("../../../utils.jl")
include("../../../riskMeasure.jl")
using Plots
using Distributions

dist = MixtureModel([-50+(70*Beta(5, 2)),Normal(20,2),Normal(30, 3)], [0.03,0.05, 0.92])
dist2 = MixtureModel([-50+(70*Beta(5, 2)),Normal(20,2),Normal(75, 5)], [0.03,0.05, 0.92])
x = range(-50, 100, length=1000)

α = 0.05
d1 = distribution(rand(dist, 1_000_000))
d2 = distribution(rand(dist2, 1_000_000))
VaR_05_1 = VaR(d1,[α])
VaR_05_2 = VaR(d2,[α])
CVaR_05_1 = CVaR(d1,[α])
CVaR_05_2 = CVaR(d2,[α])
[VaR_05_1,VaR_05_2 , CVaR_05_1,CVaR_05_2]
EVaR_05_1 = EVaR(d1,[α])
EVaR_05_2 = EVaR(d2,[α])
[VaR_05_1,VaR_05_2 , CVaR_05_1,CVaR_05_2,EVaR_05_1,EVaR_05_2]
# Plot the PDF curve
plot(x, pdf.(dist, x), label="x̃₁", linewidth=2, color=:darkred,alpha=0.7)

# Fill the area to the left of the 01% quantile
fill_x = x[x .<= VaR_05_1]  # Select x values on the left of the quantile
fill_y = pdf.(dist, fill_x)  # Corresponding PDF values
plot!(fill_x, fill_y, fill=(0, :red), label="", lw=0, alpha=0.7)
vline!([VaR_05_1], linestyle=:dash, color=:red, linewidth=2, label="5% VaR")
vline!([CVaR_05_1], linestyle=:dashdot, color=:tomato2, linewidth=2, label="5% CVaR")
vline!([EVaR_05_1], linestyle=:dashdot, color=:salmon1, linewidth=2, label="5% EVaR")
xlabel!("x (Return)")
ylabel!("Density")
title!("VaR, CVaR and EVaR of Distribution x̃₁")
savefig(check_path("fig/Dissertation/Chapter2/EVaR/j-tail_1.pdf"))

plot(x, pdf.(dist2, x), label="x̃₂", linewidth=2, color=:blue,alpha=0.7)
fill_x = x[x .<= VaR_05_2]  # Select x values on the left of the quantile
fill_y = pdf.(dist2, fill_x)  # Corresponding PDF values
plot!(fill_x, fill_y, fill=(0, :deepskyblue2), label="", lw=0, alpha=0.5)
vline!([VaR_05_2], linestyle=:dash, color=:deepskyblue2, linewidth=2, label="5% VaR")
vline!([CVaR_05_2], linestyle=:dashdot, color=:cyan, linewidth=2, label="5% CVaR")
vline!([EVaR_05_2], linestyle=:dashdot, color=:lime, linewidth=2, label="5% EVaR")
xlabel!("x (Return)")
ylabel!("Density")
title!("VaR, CVaR and EVaR of Distribution x̃₂")
savefig(check_path("fig/Dissertation/Chapter2/EVaR/j-tail_2.pdf"))

# Plot horizontal reference lines
plot(; xlims=(-50, 100),ylims=(-1,4), legend=false, title="Risk of the Distributions", 
xlabel="Value",xticks=[-30,0,30,60,90], yticks=(0:3, ["5% EVaR", "5% CVaR","5% VaR","Mean"]))

# Add points for the distributions
scatter!([E(d1)], [3], markershape=:circle, markersize=6, color=:red, alpha=0.5)
scatter!([E(d2)], [3], markershape=:circle, markersize=6, color=:blue, alpha=0.5)
scatter!([VaR_05_1], [2], markershape=:star, markersize=6, color=:red, alpha=0.5)
scatter!([VaR_05_2], [2], markershape=:star, markersize=6, color=:blue, alpha=0.5)
scatter!([CVaR_05_1], [1], markershape=:diamond, markersize=6, color=:red, alpha=0.5)
scatter!([CVaR_05_2], [1], markershape=:diamond, markersize=6, color=:blue, alpha=0.5)
scatter!([EVaR_05_1], [0], markershape=:square, markersize=6, color=:red, alpha=0.5)
scatter!([EVaR_05_2], [0], markershape=:square, markersize=6, color=:blue, alpha=0.5)

# Add horizontal lines
hline!([0, 1, 2, 3], linestyle=:dot, color=:gray, linewidth=1)

# Manually add legend using annotations
annotate!(90, 3.8, text("x̃₁", :red, :left, 15))
annotate!(90, 3.4, text("x̃₂", :blue, :left, 15))
savefig(check_path("fig/Dissertation/Chapter2/EVaR/j-two_distributions_measures.pdf"))
