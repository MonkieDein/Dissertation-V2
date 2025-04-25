include("../../../utils.jl")
using Plots
using Distributions

dist = MixtureModel([1+Beta(2, 3),3+Beta(3, 2)], [0.7, 0.3])
x = range(0, 5, length=200)

VaR_10 = quantile(dist, 0.1)

# Plot the PDF curve
plot(x, pdf.(dist, x), label="x̃", linewidth=2, color=:black)
# Fill the area to the left of the 10% quantile
fill_x = x[(x .>= 2) .& (x .<= 3)]  # Select x values on the left of the quantile
fill_y = (fill_x*0 .+ 1.2)  # Corresponding PDF values
plot!(fill_x, fill_y, fill=(0, :deepskyblue2), label="", lw=0, alpha=0.5)

# Labels and title
xlabel!("x (Return)")
ylabel!("Density")
title!("Quantile of Atomless Continuous Distribution")
savefig(check_path("fig/Dissertation/Chapter2/VaR/continuous2nonAtom.pdf"))
