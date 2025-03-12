
function grad_quantile_loss(δ , α)
    return ifelse(δ > 0 , α, -(1-α) )
end

x = 0
for j in 1:10000
    for i in 1:10
        grad = grad_quantile_loss( i-x , 0.3)/j
        x = x + grad
    end
end
x

# loss function illustration
using LaTeXStrings
using Plots
include("../../utils.jl")

function quantile_loss(δ , α)
    return max(α*δ,(α-1)*δ)
end

function soft_quantile_loss(δ , α, κ)
    if δ < -κ
        return (1-α)*κ/2*((δ+κ)^2-(2*δ/κ)-1)
    elseif δ < 0
        return (1-α)*(δ^2)/(2*κ)
    elseif δ < κ
        return (α)*(δ^2)/(2*κ)
    else
        return (α*κ/2)*((δ-κ)^2+(2*δ/κ)-1)
    end
end

X = [-1,1]
p = [0.5,0.5]

function m_val(m,X,p)
    return sum(p .* [quantile_loss(x-m,0.5) for x in X])
end 

function soft_m_val(m,X,p,κ)
    return sum(p .* [soft_quantile_loss(x-m,0.5,κ) for x in X])
end 

M = range(-5, 5, length=1000)
plot(M, [m_val(m,X,p) for m in M],ylim=(0,4), title="Mean of Soft Quantile Loss",label=L"\lim_{\kappa \to 0^+} \kappa",xlabel=L"m",ylabel=L"\mathbb{E}[l_{0.5}^{\kappa}(\tilde{x}-m)]", linewidth=3, color=:red,alpha=0.7)
plot!(M, [soft_m_val(m,X,p,0.01) for m in M], label=L"\kappa = 0.01", linewidth=3, color=:purple,alpha=0.7)
plot!(M, [soft_m_val(m,X,p,0.1) for m in M],label=L"\kappa = 0.1",linewidth=3, color=:blue,alpha=0.7)
plot!(M, [soft_m_val(m,X,p,0.5) for m in M],label=L"\kappa = 0.5", linewidth=3, color=:teal,alpha=0.7)
savefig(check_path("fig/Dissertation/ppt/mean_soft_quantile_loss.pdf"))
savefig(check_path("fig/Dissertation/ppt/mean_soft_quantile_loss.png"))

δs = range(-5, 5, length=1000)
plot(δs, [quantile_loss(δ,0.5) for δ in δs],ylim=(0,4), title="Soft Quantile Loss Function",label=L"\lim_{\kappa \to 0^+} \kappa",xlabel=L"\delta",ylabel=L"l_{0.5}^{\kappa}(\delta)", linewidth=3, color=:red,alpha=0.7)
plot!(δs, [soft_quantile_loss(δ,0.5,0.01) for δ in δs],label=L"\kappa = 0.01", linewidth=3, color=:purple,alpha=0.7)
plot!(δs, [soft_quantile_loss(δ,0.5,0.1) for δ in δs],label=L"\kappa = 0.1", linewidth=3, color=:blue,alpha=0.7)
plot!(δs, [soft_quantile_loss(δ,0.5,0.5) for δ in δs],label=L"\kappa = 0.5",linewidth=3, color=:teal,alpha=0.7)
savefig(check_path("fig/Dissertation/ppt/soft_quantile_loss.pdf"))
savefig(check_path("fig/Dissertation/ppt/soft_quantile_loss.png"))

plot(M, [m_val(m,X,p) for m in M],ylim=(0,4), title="Mean of Quantile Loss",label="",xlabel=L"m",ylabel=L"\mathbb{E}[l_{0.5}(\tilde{x}-m)]", linewidth=3, color=:red,alpha=0.7)
savefig(check_path("fig/Dissertation/ppt/mean_quantile_loss.png"))
plot(δs, [quantile_loss(δ,0.5) for δ in δs],ylim=(0,4), title="Quantile Loss Function",label="",xlabel=L"\delta",ylabel=L"l_{0.5}(\delta)", linewidth=3, color=:red,alpha=0.7)
savefig(check_path("fig/Dissertation/ppt/quantile_loss.png"))


M = range(-0.1, 0.1, length=1000)
plot(M, [m_val(m,X,p) for m in M], title="Mean of Soft Quantile Loss",label=L"\lim_{\kappa \to 0^+} \kappa",xlabel=L"m",ylabel=L"\mathbb{E}[l_{0.5}^{\kappa}(\tilde{x}-m)]", linewidth=3, color=:red,alpha=0.7)
plot!(M, [soft_m_val(m,X,p,0.01) for m in M], label=L"\kappa = 0.01", linewidth=3, color=:purple,alpha=0.7)
savefig(check_path("fig/Dissertation/ppt/mean_soft_quantile_loss_zoom.pdf"))
savefig(check_path("fig/Dissertation/ppt/mean_soft_quantile_loss_zoom.png"))

