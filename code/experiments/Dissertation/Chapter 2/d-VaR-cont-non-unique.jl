include("../../../utils.jl")
include("../../../riskMeasure.jl")
using Plots
using Distributions

dist = MixtureModel([(1+Beta(3, 2)),3+(Beta(2,3))], [0.5,0.5])
VaR_10 = quantile(dist, 0.1)
x = range(0.5, 4.5, length=200)

# Plot the PDF curve
plot(x, pdf.(dist, x), label="x̃", linewidth=2, color=:black)
# Fill the area to the left of the 10% quantile
fill_x = x[x .<= VaR_10]  # Select x values on the left of the quantile
fill_y = pdf.(dist, fill_x)  # Corresponding PDF values
plot!(fill_x, fill_y, fill=(0, :deepskyblue2), label="", lw=0, alpha=0.5)

# Add vertical dashed line at the 10% quantile
vline!([VaR_10], linestyle=:dash, color=:deepskyblue2, linewidth=2, label="10% Quantile")
annotate!(-3.5, 0.02, text("10%", :blue, :left, 12))
annotate!(0, 0.02, text("90%", :black, :left, 12))

# Labels and title
xlabel!("x (Return)")
ylabel!("Density")
title!("Quantile of Absolutely Continuous Distribution")
savefig(check_path("fig/Dissertation/Chapter2/VaR/continuous.pdf"))