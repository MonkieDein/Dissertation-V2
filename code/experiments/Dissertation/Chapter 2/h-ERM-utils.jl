using Plots
using LaTeXStrings
include("../../../utils.jl")

u1(x) = (1 .- exp.((-1) .* x))/1
u2(x) = (1 .- exp.((-.1) .* x))/.1
u3(x) = (1 .- exp.((-.01) .* x))/.01
g(x) = x

plot(u1, LinRange(-42, 42, 1000), legendfontsize=16, size=(600, 600),color=:orangered2,legend = :topleft, linewidth = 2,xlims = (-42,42),ylims = (-42,42), label = "β=1")
vline!([0], color = :black, linewidth = 2, label = "")
hline!([0], color = :black, linewidth = 2, label = "")
plot!(u2, LinRange(-42, 42, 1000),color=:darkorange2, linewidth = 2,xlims = (-42,42),ylims = (-42,42), label = "β=0.1")
plot!(u3, LinRange(-42, 42, 1000),color=:orange2, linewidth = 2,xlims = (-42,42),ylims = (-42,42), label = "β=0.01")
plot!(g, LinRange(-42, 42, 1000),color=:goldenrod1, linewidth = 2,xlims = (-42,42),ylims = (-42,42), label = "β=0") 

xlabel!("x (Return)")
ylabel!(L"U_{\beta}"*"(x)")

savefig(check_path("fig/Dissertation/Chapter2/ERM/exp_util.pdf"))

