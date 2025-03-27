include("../../../utils.jl")

using ProgressBars
using Plots
using Distributions, QuadGK
using LaTeXStrings
# Function to compute E[max(α(x - m), -(1 - α)(x - m))]
function mean_max_alpha(α::Float64, m::Float64,dist)

    # Define the integrand based on simplified cases
    integrand(x) = begin
        shifted_x = x - m
        val = shifted_x ≥ 0 ? α * shifted_x : -(1 - α) * shifted_x
        val * pdf(dist, x)
    end

    # Numerically integrate over the real line
    result, _ = quadgk(integrand, -Inf, Inf)
    return result
end

# Example usage
m = 1.0
dist = Normal(0, 1)
x = range(-5, 5, length=1000)

risk_levels = vcat(collect(0.005:0.005:0.995),collect(0.995:-0.005:0.005))
video = @animate for α in ProgressBar(risk_levels)
    mean_val = [mean_max_alpha(α, m,dist) for m in x]
    plt1 = plot(x,ylim=(0,5), mean_val,title="Mean of Loss Function",lw=2, ylabel="", xlabel="y", label="α = $(round(α*100, digits=1))%", linewidth=2, legend=:topright, color=:darkred,alpha=0.7)
    opt = argmin(mean_val)
    vline!(plt1,[x[opt]], linestyle=:dash, linewidth=2,label="argmin",lw=2) 
    optimal_m = mean_val[opt]
    annotate!(plt1,x[opt], optimal_m, text("$(round(x[opt], digits=2))", :bottom, pointsize=8))
    
    plt2 = plot(x, pdf.(dist,x),title="Distribution", ylabel="", xlabel="x̃", label="pdf", linewidth=2, color=:black,alpha=0.7,lw=2)
    quatile = quantile(dist, α)
    fill_x = x[x .<= quatile]  # Select x values on the left of the quantile
    fill_y = pdf.(dist, fill_x)  # Corresponding PDF values
    plot!(plt2,fill_x, fill_y, fill=(0, :deepskyblue2), label="", lw=0, alpha=0.5)
    vline!(plt2,[quatile], linestyle=:dash, color=:blue, linewidth=2, label="q(s,a,$(round(α*100, digits=1))%)",lw=2)
    annotate!(plt2,quatile, -0.035, text("$(round(x[opt], digits=2))", color=:blue, :bottom, pointsize=8))
    
    plot( plt1, plt2,layout = @layout([a; b]),size = (800,1000))
end 

gif(video,check_path("fig/Dissertation/SGD/normal.gif"),fps=60)
1

