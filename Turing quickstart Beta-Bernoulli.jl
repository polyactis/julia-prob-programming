### A Pluto.jl notebook ###
# v0.19.40

using Markdown
using InteractiveUtils

# ╔═╡ ff1dc8d2-ecbc-11ee-022e-653b5473f25a
begin
	using Markdown
	using InteractiveUtils
	using Pkg, DrWatson, PlutoUI
end

# ╔═╡ 5c25b00d-5c84-498d-b439-de3a59198ef2
begin
	using Distributions
	using FillArrays
	using StatsPlots
	
	using LinearAlgebra
	using Random
	using Turing

	# Import all libraries.
	using Turing, Distributions, DataFrames
	#DirichletProcess, ChineseRestaurantProcess, StickBreakingProcess
	using Turing.RandomMeasures
	# DocStringExtensions provides $(SIGNATURES)
	using DocStringExtensions
	# Set a random seed.
	Random.seed!(3)
end

# ╔═╡ 660853b1-0c41-466d-aa5d-49422ff076a8
begin
	x = "foo"
	println("$x $(x) ",  "haha")
	using Printf
	@sprintf("%s %s", "foo", "bar")
end

# ╔═╡ 8849387c-f4b0-47f3-9061-e286e23edbde
using Plots

# Plot the cluster assignments over time

# ╔═╡ c1836feb-ce9d-4e26-aa25-7e28dd55506e
md"# Turing quickstart Beta-Bernoulli"

# ╔═╡ 36c62876-1ab7-438b-8d5e-16ee391a11eb
#    margin-left: 1%;
#    margin-right: 5%;
html"""<style>
main {
	margin: 0 auto;
    max-width: 90%;
	padding-left: max(50px, 1%);
    padding-right: max(253px, 10%);
	# 253px to accomodate TableOfContents(aside=true)
}
"""

# ╔═╡ 49d67176-6130-4bc0-bd99-2f5a43e20b5d
begin
  PlutoUI.TableOfContents()
end

# ╔═╡ ea83b213-db5e-4a18-a274-51aeb86c14a8
versioninfo()

# ╔═╡ 5964c6e8-ad85-4f20-8eee-85b1b6673546
md"## Turing.jl
- https://turinglang.org/
- https://github.com/TuringLang/Turing.jl"


# ╔═╡ 132e9d0f-06fb-4b23-bdc3-3577c90dabbc
md"## 2. The Problem: Coin flipping

Flip a coin. A random variable x = 1 if the coin is head up. x=0 if the coin is tail up.

### 2.1 Question
- Input: a sequence of observed x.
- Output: what is the p(head up) of the coin?"

# ╔═╡ e027a63d-c856-4299-b1ca-4124864884de
md"### 2.2 Input: flip 100 times"

# ╔═╡ ed092bf4-4b9a-4e1d-b65d-f1d245eb7f3f
begin
	# Set the true probability of heads in a coin.
	p_true = 0.5
	
	# Iterate from having seen 0 observations to 100 observations.
	Ns = 0:100
	
	# Fix the seed and draw data from a Bernoulli distribution, i.e. draw heads or tails.
	Random.seed!(12)
	data = rand(Bernoulli(p_true), last(Ns))
	
	println("The number of ups is $(sum(data))/$(length(data))." ); 
	histogram(data, bins=20)
end

# ╔═╡ 3109f2ae-54ad-45b7-b260-3ffcc025bdaf
md"## 3 Frequentist/Likelihood approach

p is an unknown parameter to be solved.


$x_i \sim Bernoulli(p)$


The MLE (maximum likelihood estimator) is $\hat p=\frac{\sum_{i=1}^{i=N} x_i }{N}$ and why?

- What is the difference between likelihood and probability? What is MLE?
- Why most estimators we know/use are MLE estimators?
- Analytic/closed-form （解析） solution vs Monte Carlo solution vs Brute force solution?
  - https://en.wikipedia.org/wiki/Closed-form_expression"

# ╔═╡ e9e7cf2b-a241-44a7-916d-1b5929edcb2e
md"For any model (Likelihood or Bayesian):
- Is there an analytic solution? No for most real-world problems.
- Is there a monte carlo solution? Yes for most real-world problems.
- Is there a brute-force solution? Yes. But may take hundreds of years.
"

# ╔═╡ 79851d71-69e1-4e57-9e2c-fb646a026f80
md"### 3.1 The MLE (maximum likelihood estimator) is  $\hat p=\frac{\sum_{i=1}^{i=N} x_i }{N}$ and why?


- https://stats.stackexchange.com/questions/275380/maximum-likelihood-estimation-for-bernoulli-distribution

![image.png](attachment:f0a44559-d8a5-4842-8ffa-fb2a6d31481f.png)"

# ╔═╡ b11ee357-4212-4b54-8d2b-74eb48c967a7
md"## 4 Bayesian

p is a random variable with a prior distribution.

$p \sim Beta(\alpha, \beta)$

$x_i \sim Bernoulli(p)$

Note: x is Bernoulli, 0 or 1, not Binomial.

Question: derive the posterior distribution of $p$, AKA (Also Known As), $Prob(p|x_1, ... x_N)$."

# ╔═╡ 054d552e-7a21-4f1f-b0c4-322bf3c12cdb
md"- Is there an analytic solution to this? Yes, Beta-Binomial.

  - https://en.wikipedia.org/wiki/Beta-binomial_distribution
  
  ![image.png](attachment:1b636623-11fb-48e8-a301-80dbea1e8184.png)

- Is there a monte carlo solution? Yes, we will talk about this today."

# ╔═╡ 42ed313f-2919-4463-8c76-1a15363ebd60
md"### 4.1 Declare our Bayesian model and Monte Carlo with a HMC sampler"

# ╔═╡ 70fcc963-418a-4899-a91c-495ff27a7c27
md"#### 4.1.1 The posterior of p is max at $ p=0.4311$, almost same as MLE. Not 0.5!
Because:
1) the data is 43% up;
2) we used a flat prior (uniform $\in [0,1]$). "

# ╔═╡ a8961089-08a8-4d27-b1b2-117811ea7731
md"### 4.2 Input is 10X more data."

# ╔═╡ 3d962581-bbab-490c-9b39-088b0608070f
begin
	# Fix the seed and draw data from a Bernoulli distribution, i.e. draw heads or tails.
	Random.seed!(7)
	data2 = rand(Bernoulli(p_true), 1000)
	println("The number of ups is $(sum(data2))/$(length(data2)) "); 
	histogram(data2, bins=20)
end

# ╔═╡ 4ca651ec-4586-49f2-a834-c6b0eb40ecbf
md"### 4.2.1 sample using the same model but with 10X iterations"

# ╔═╡ 7479b86b-bdad-45ea-a593-417a59cbb834
md"### 4.2.2 same model, but using the NUTS sampler (default parameters)"

# ╔═╡ 08163980-3f63-4c40-8bc8-677b00f66010
md"### 4.3 Modify the prior to alter the posterior"

# ╔═╡ bcf0fb30-a7c1-42b4-a600-1d22d1337bd2
md"### 4.3.1 Conclusion
- With a Strong prior beta(100,100) around 0.5, we can obtain a posterior estimate around 0.48, instead of 0.43."

# ╔═╡ 445f820a-d728-40d9-8931-c57d68e73465
md"## 5 Test two different Negative Binomial models
1. with a beta prior for p and Uniform prior for r
1. with a beta prior for p and Gamma prior for r "

# ╔═╡ a08f37fe-8b91-473c-86e6-5f6bc3dc2654
begin	
	# Generate synthetic data with known parameters
	Random.seed!(28)
	n = 1000
	r = 3
	p = 0.2
	y = rand(NegativeBinomial(r, p), n)
	
	# Bayesian Negative binomial model
	@model nb_bayes(y) = begin
	    # Defining variables
	    r ~ Uniform(0, 100)
	    p ~ Beta(2, 2)
	    
	    # Likelihood function
	    y_dist = NegativeBinomial(r, p)
	    y ~ y_dist
	end
	
	
	# Define the negative binomial likelihood
	@model function negative_binomial_model(y)
	    # Prior distribution for the success probability
	    p ~ Beta(1, 1)
	    # Prior distribution for the dispersion parameter
	    r ~ Gamma(1, 1)
	    y_dist = NegativeBinomial(r, p)
	    # Likelihood
	    for i in eachindex(y)
	        y[i] ~ y_dist
	    end
	end
	
end

# ╔═╡ 6bfce2a4-838e-47eb-86a9-35559594ea90
# Declare our Bayesian model，p ~ beta(1,1)， x ~ Bernoilli(p)
@model function coinflip(x)
    # Our prior belief about the probability of heads in a coin.
    p ~ Beta(1, 1)

    # The number of observations.
    N = length(x)
    for n in 1:N
        # Heads or tails of a coin are drawn from a Bernoulli distribution.
        x[n] ~ Bernoulli(p)
    end
end

# ╔═╡ 0bcb19ff-193b-49d1-a7f2-1225288ee7ec
begin
	# Settings of the Hamiltonian Monte Carlo (HMC) sampler.
	iterations = 1000
	ϵ = 0.05
	τ = 10
	
	# Start sampling.
	@time chain = sample(coinflip(data), HMC(ϵ, τ), iterations)
	display(chain)
	# Plot a summary of the sampling process for the parameter p, i.e. the probability of heads in a coin.
	histogram(chain[:p])
end

# ╔═╡ c343aeb9-4fad-46ec-8df5-ad47ea3737fc
begin
	# Using NUTS as sampler
	@time chain_NUTS = sample(coinflip(data), NUTS(), iterations)
	display(chain_NUTS)
	# Plot a summary of the sampling process for the parameter p, i.e. the probability of heads in a coin.
	histogram(chain_NUTS[:p])
end

# ╔═╡ 81f972c6-ce66-4ab5-915a-4b1c6501f672
begin
	# sampling using the same model but more iterations
	#ϵ=0.05, τ=10
	@time chain_10X_HMC = sample(coinflip(data2), HMC(0.05, 10), 10_000)
	display(chain_10X_HMC)
	# Plot a summary of the sampling process for the parameter p, i.e. the probability of heads in a coin.
	histogram(chain_10X_HMC[:p])
end

# ╔═╡ 92251c31-7c79-4916-a192-1400f5225ea3
begin
	# Start sampling.
	@time chain_10X_NUTS = sample(coinflip(data2), NUTS(), 10_000)
	display(chain_10X_NUTS)
	# Plot a summary of the sampling process for the parameter p, i.e. the probability of heads in a coin.
	histogram(chain_10X_NUTS[:p])
end

# ╔═╡ 89f3522f-7b26-4880-9645-d3ad66f4838b
# Declare our Bayesian model，p ~ beta， x ~ Bernoilli(p)
# But let's modify the \alpha and \beta of the prior distribution.

@model function coinflip_prior_around_0_5(x)
    # Our prior belief about the probability of heads in a coin.
    p ~ Beta(100, 100)

    # The number of observations.
    N = length(x)
    for n in 1:N
        # Heads or tails of a coin are drawn from a Bernoulli distribution.
        x[n] ~ Bernoulli(p)
    end
end

# ╔═╡ 96c363fd-7b02-4f56-b80b-64ae4eba2b7d
begin
	# Start sampling.
	@time chain_strong_beta_NUTS = sample(coinflip_prior_around_0_5(data), NUTS(), 10_000)
	display(chain_strong_beta_NUTS)
	# Plot a summary of the sampling process for the parameter p, i.e. the probability of heads in a coin.
	histogram(chain_strong_beta_NUTS[:p])
end

# ╔═╡ 8c594c78-3936-421f-9c2a-3d5cf7360459
size(y)

# ╔═╡ f21edd05-313d-4b86-8d32-efeec20563e7
md"### 5.1 NB with a beta prior for p and Uniform prior for r"

# ╔═╡ 057bff58-80b8-47d0-be1c-d8f29ae5af61
begin
	# Sampling from the posterior distribution
	@time chain_w_uniform_and_beta_prior = sample(nb_bayes(y), NUTS(), 1_000)
	display(chain_w_uniform_and_beta_prior)
end

# ╔═╡ eaed7dc5-0030-440b-966f-8c54b4b5b880
# Summarizing posterior distribution
@time describe(chain_w_uniform_and_beta_prior)

# ╔═╡ 31c0b694-d44d-4671-b599-9dc8c10c22b3
@time describe(DataFrame(chain_w_uniform_and_beta_prior))

# ╔═╡ 0b0bd243-a01b-41e0-b463-ad88ccbd6d32
histogram(chain_w_uniform_and_beta_prior[:r], xlabel="r", legend=false)

# ╔═╡ 1fd59165-56b9-4359-b1be-b310c07ec37d
histogram(chain_w_uniform_and_beta_prior[:p], xlabel="p", legend=false)

# ╔═╡ 773aeb7c-7384-48a5-9f15-8ceb886e68de
md"### 5.2 NB with a beta prior for p and Gamma prior for r"

# ╔═╡ 8eeeb415-843d-4e02-a0d2-ed8c2e68f83b
@time chain_with_gamma_and_beta_prior = sample(negative_binomial_model(y), NUTS(0.65), 1000)

# ╔═╡ 08c4eca9-5486-4375-b9f7-68b5d38a40d2
histogram(chain_with_gamma_and_beta_prior[:r])

# ╔═╡ d765047a-4d2a-494d-82c3-5f226b91ca40
histogram(chain_with_gamma_and_beta_prior[:p])

# ╔═╡ 89043a50-6e28-4a86-ae96-95723ca8a86f
md"## 6 Estimate p of Binomial(N, p) from Binomial data with different Ns"

# ╔═╡ 7323e6f8-963c-4758-b94f-2e44859f6db4
function simulate_data(p::Float64, cov_mean::Int=4000, cov_std::Int=700, no_of_samples::Int=500)
    # Generate synthetic data with known parameters
    # cov_mean, cov_std are the parameters for the normal distribution.
    
    # fix the seed
    Random.seed!(10)
    # Create a normal distribution centered around 4000
    cov_dist = Normal(cov_mean, cov_std)

    # Sample an integer coverage vector from the distribution
    N_v = round.(rand(cov_dist, no_of_samples))

    x_v = zeros(Int, length(N_v))
    for (i, N) in enumerate(N_v)
        x_v[i] = rand(Binomial(N, p) )
    end
    vaf_v = x_v./N_v
    return N_v, x_v, vaf_v
end

# ╔═╡ 912b142f-d5e8-454c-a920-36957188f045
begin
	@time N_v, x_v, vaf_v = simulate_data(0.0005)
	@time N_v_005, x_v_005, vaf_v_005 = simulate_data(0.005)
	@time N_v_00001, x_v_00001, vaf_v_00001 = simulate_data(0.00001)
	
	@time println("The number of samples with VAF=0: $(sum(vaf_v_00001.==0) ).");
end

# ╔═╡ 8ac0c6dc-a58e-40da-bd53-00dfa00e56bf
typeof(vaf_v)

# ╔═╡ 2d4030bc-edeb-4604-bd97-a1f1e8dcbaf8
function plot_histogram(N_v::Vector{Float64}, x_v::Vector{Int64}, vaf_v::Vector{Float64}, p::Float64)
    @time h1 = histogram(N_v, title="Histogram of N", xaxis="N")
    @time h2 = histogram(x_v, title="Histogram of x", xaxis="x")
    @time h_of_vaf_v = histogram(vaf_v, xaxis="VAF", bins=30, legend=false)
    @time plot(h1, h2, h_of_vaf_v, layout=(2,2), left_margin=5*Plots.mm, 
        bottom_margin=5*Plots.mm, size=(1000,830) )
end

# ╔═╡ 83a126e4-ad88-4bf3-acaf-2e61aa3b2e4f
plot_histogram(N_v_005, x_v_005, vaf_v_005, 0.005)

# ╔═╡ 9fb6cdfc-42af-4c9a-834d-cf6ab843dd6d
plot_histogram(N_v, x_v, vaf_v, 0.0005)

# ╔═╡ 2e892a96-6791-406c-a2b2-c463a9d7bf5f
plot_histogram(N_v_00001, x_v_00001, vaf_v_00001, 0.00001)

# ╔═╡ 05862f61-8ba2-4f37-bcd7-968f8c7356c6
# Define the model
@model binomial_w_beta_prior(N, x) = begin
    # Prior distribution for the success probability
    p ~ Beta(1, 5)
    # Prior distribution for the dispersion parameter, for the NB distribution
    # r ~ Gamma(1, 1)
    #y_dist = NegativeBinomial(r, p)
    # Likelihood
    for i in eachindex(N)
        x[i] ~ Binomial(N[i], p)
    end
end

# ╔═╡ f5c08e91-c9ec-4bad-8503-46d8585672fa
md"### 6.1 Estimate if true p is 0.0005"

# ╔═╡ 9f398fd0-0ff4-4cce-bbca-a6ce9457d241
begin
	# Sampling from the posterior distribution
	@time chain_binomial_w_beta_prior = sample(binomial_w_beta_prior(N_v, x_v), NUTS(), 2000)
	display(chain_binomial_w_beta_prior)
end

# ╔═╡ 1822008e-27a8-4806-aa16-d324fd189d96
function plot_estimates(vaf_v, estimated_p)
    h_of_vaf_v = histogram(vaf_v, xaxis="VAF", bins=30, legend=false)
    h_of_p_bin = histogram(estimated_p, xaxis="estimated p", legend=false)
    plot(h_of_vaf_v, h_of_p_bin, layout=(1,2), left_margin=5*Plots.mm, bottom_margin=5*Plots.mm, size=(1000,430) )
end

# ╔═╡ 2a047555-c821-4e81-a795-12d295cc383f
plot_estimates(vaf_v, chain_binomial_w_beta_prior[:p])

# ╔═╡ cd430d83-7b9a-4b69-90e6-87292df06e20
md"### 6.2 Estimate if true p is 0.005"

# ╔═╡ cca5db8c-d7f9-4087-9fb3-c304b34c3095
begin
	# Sampling from the posterior distribution
	@time chain_binomial_w_beta_prior_005 = sample(binomial_w_beta_prior(N_v_005, x_v_005), NUTS(), 2000)
	display(chain_binomial_w_beta_prior_005)
end

# ╔═╡ 2a57727a-8289-4555-969c-16e84d1b34aa
plot_estimates(vaf_v_005, chain_binomial_w_beta_prior_005[:p])

# ╔═╡ c586376a-67f3-4576-88bc-b40d78562435
md"### 8.3 Estmate if true p is 0.00001"

# ╔═╡ dafdd5da-7d0d-492a-ade5-a9e50abfedf2
begin
	# Sampling from the posterior distribution
	@time chain_binomial_w_beta_prior_00001 = sample(binomial_w_beta_prior(N_v_00001, x_v_00001), NUTS(), 2000)
	display(chain_binomial_w_beta_prior_00001)
end

# ╔═╡ bbbd86fe-376d-470c-943f-d2ca8d38b08a
plot_estimates(vaf_v_00001, chain_binomial_w_beta_prior_00001[:p])

# ╔═╡ e81f7ba7-3596-4960-9368-5836929c8ce0
md"## 7 Estimate p of NegativeBinomial(r, p) from Binomial data with different Ns"

# ╔═╡ c1ca8939-99e0-4cb4-ac8f-94a6f28c529e
# Define the model
@model negbin_w_beta_prior(N, x) = begin
    # Prior distribution for the success probability
    p ~ Beta(1, 5)
    # Prior distribution for the dispersion parameter, for the NB distribution
    # r ~ Gamma(1, 1)
    #y_dist = NegativeBinomial(r, p)
    # Likelihood
    for i in eachindex(N)
        x[i] ~ NegativeBinomial(N[i]-x[i], p)
    end
end

# ╔═╡ 0f4bfb27-0483-45ca-b8bb-d21fa5231c9c
begin
	# Sampling from the posterior distribution
	@time chain_negbin_w_beta_prior = sample(negbin_w_beta_prior(N_v, x_v), NUTS(), 2000)
	display(chain_negbin_w_beta_prior)
end

# ╔═╡ 6b77e7f2-d1d9-4b63-9705-507122fd5fe3
begin
	h_of_p_bin = histogram(chain_binomial_w_beta_prior[:p], 
	    xaxis="estimated p via Binomial", legend=false)
	h_of_p_negbin = histogram(-(chain_negbin_w_beta_prior[:p].-1), 
	    xaxis="estimated p via NegBinomial", legend=false)
	plot(h_of_p_bin, h_of_p_negbin, layout=(1,2), left_margin=5*Plots.mm, 
	    bottom_margin=5*Plots.mm, size=(1000,430) ) 
end

# ╔═╡ 67bd9e57-e37c-4407-9ee3-0e22deeb25b0
md"### 7.1 ̂p of Beta+Binomial is similar to ̂p of Beta+NegativeBinomial."

# ╔═╡ 44fcbd22-cc6f-4c09-b749-406cff1aeced
begin
	p̂₁ = median(chain_binomial_w_beta_prior[:p])
	p̂₂ = median(-(chain_negbin_w_beta_prior[:p].-1))
	" ̂p of Beta+Binomial, $(@sprintf("%0.6f", p̂₁)) is similar to ̂p of Beta+NegativeBinomial, $(@sprintf("%0.6f", p̂₂))."
end

# ╔═╡ 1a090beb-8c1b-4a0d-aad3-d85a846ae323
md"## 8 Multinomial"

# ╔═╡ 51d7a213-2ba0-4d09-8ee2-0e91002ea915
begin
	Random.seed!(250)
	# Generate some dummy data
	data_mn = rand(Multinomial(40000, [0.0001, 0.0004, 0.0001, 0.9994]), 1000)
end

# ╔═╡ 27458d34-0b45-4463-bdde-19f07fd7d7c7
# Define the model
@model function multinomial_model(data)
    no_of_alleles, no_of_samples = size(data)

    # Prior for the parameters (Dirichlet distribution)
    α = ones(no_of_alleles)  # Prior concentration parameters
    
    # Parameters (probabilities of the categories)
    ϵ ~ Dirichlet(α)
    # Likelihood (multinomial distribution)
    for j in 1:no_of_samples
        data[:, j] ~ Multinomial(sum(data[:,j]), ϵ)
    end
end

# ╔═╡ 298edd25-30eb-47ab-b8a6-26064168e76d
begin
	# Compile the model
	model = multinomial_model(data_mn)
	# Run the model
	@time chain_mn = sample(model, NUTS(), 1_000)
	# Summarize the results
	summary(chain_mn)
end

# ╔═╡ 439a26f2-be2f-43f2-a947-5f1e00e43d27
chain_mn

# ╔═╡ 8b71b6d6-ab79-4a02-af29-3a7d2a963f51
propertynames(chain_mn)

# ╔═╡ 03b37ea3-24f5-442b-b9ec-cc7178def82b
chain_mn.value

# ╔═╡ 778927a5-e149-4512-9475-895d45e4095b
chain_mn.logevidence

# ╔═╡ 14fd3f37-cf8b-4867-903f-36aa505b7683
chain_mn.info

# ╔═╡ 706bb0da-9dff-47c8-bd42-6096fa7e0025
chain_mn.name_map

# ╔═╡ 5e68050f-758f-4380-9fbe-f4cae31e0754
begin
	h_of_p1 = histogram(chain_mn[:"ϵ[1]"], xaxis="ϵ for A", legend=false)
	h_of_p2 = histogram(chain_mn[:"ϵ[2]"], xaxis="ϵ for C", legend=false)
	h_of_p3 = histogram(chain_mn[:"ϵ[3]"], xaxis="ϵ for G", legend=false)
	h_of_p4 = histogram(chain_mn[:"ϵ[4]"], xaxis="ϵ for T", legend=false)
	
	plot(h_of_p1, h_of_p2, h_of_p3, h_of_p4, layout=(2,2), left_margin=5*Plots.mm, 
	    bottom_margin=10*Plots.mm, size=(2000,930) ) 
end

# ╔═╡ 8f428c07-e87e-4642-be5e-2347a25a86f4
md"## 9 Mixture model"

# ╔═╡ c4065dfe-55c5-42a0-88bc-9231125757b9
md"### 9.1 Two-component mixture model
- https://turinglang.org/dev/tutorials/06-infinite-mixture-model/"

# ╔═╡ af8227a8-3249-43dd-8bc6-0f08a05e81ef
md"### 9.2  Finite Mixture Model

If we have more than two components, this model can elegantly be extended using a Dirichlet distribution as prior for the mixing weights. Note that the Dirichlet distribution is the multivariate generalization of the beta distribution. The resulting model can be written as:

 

which resembles the model in the Gaussian mixture model tutorial with a slightly different notation."

# ╔═╡ 4756ab6b-fc05-40ca-9759-c6f1d0b78ff7
md"### 9.3 Infinite Mixture Model

The question now arises, is there a generalization of a Dirichlet distribution for which the dimensionality is infinite, i.e. 

But first, to implement an infinite Gaussian mixture model in Turing, we first need to load the Turing.RandomMeasures module. RandomMeasures contains a variety of tools useful in nonparametrics."

# ╔═╡ 9975d122-59e6-4513-ad82-7f5a7c37bbe4
md"We now will utilize the fact that one can integrate out the mixing weights in a Gaussian mixture model allowing us to arrive at the Chinese restaurant process construction. See Carl E. Rasmussen: The Infinite Gaussian Mixture Model, NIPS (2000) for details.

In fact, if the mixing weights are integrated out, the conditional prior for the latent variable is given by:
 
$p(z_i=k|z_{\neg i}, \alpha) = \frac{n_k + \alpha K}{ N - 1 + \alpha}$


where $z_{-i}$ are the latent assignments of all observations except observation $i$. Note that we use $n_k$ to denote the number of observations at component $k$ excluding observation $i$. The parameter $\alpha$ is the concentration parameter of the Dirichlet distribution used as prior over the mixing weights."

# ╔═╡ d72cab2e-7c27-471e-af55-2c575230ca93
md"### 9.3.1 Chinese Restaurant Process

To obtain the Chinese restaurant process construction, we can now derive the conditional prior if $K \rightarrow \infty$.

For $n_k>0$, we obtain:

$p(z_i=k|z_{\neg i}, \alpha) = \frac{n_k }{ N - 1 + \alpha}$

and for all infinitely many clusters that are empty (combined) we get:

$p(z_i=k|z_{\neg i}, \alpha) = \frac{ \alpha }{ N - 1 + \alpha}$
 

Those equations show that the conditional prior for component assignments is proportional to the number of such observations, meaning that the Chinese restaurant process has a rich get richer property.

To get a better understanding of this property, we can plot the cluster choosen by for each new observation drawn from the conditional prior."

# ╔═╡ 0813082a-36b3-4d9f-867a-5324281f244b
begin
	@show parentmodule(DirichletProcess)
	@show parentmodule(ChineseRestaurantProcess)
	@show parentmodule(StickBreakingProcess)
end

# ╔═╡ 0d525767-52eb-490c-b628-1a7db9ecea21
md"### 9.3.1.1 Visualize the cluster growth given the growing data points"

# ╔═╡ cff0108b-b745-4f2e-9f27-48e3624bbf0e
begin
	# Concentration parameter.
	α = 1.0
	
	# Random measure, e.g. Dirichlet process.
	rpm = DirichletProcess(α)
	
	# Cluster assignments for each observation.
	z = Vector{Int}()
	
	# Maximum number of observations we observe.
	Nmax = 500
	
	for i in 1:Nmax
	    # Number of observations per cluster.
	    K = isempty(z) ? 0 : maximum(z)
	    nk = Vector{Int}(map(k -> sum(z .== k), 1:K))
	
	    # Draw new assignment.
	    push!(z, rand(ChineseRestaurantProcess(rpm, nk)))
	end
end

# ╔═╡ b6cf9057-1f2a-42cc-9233-6692806ee419
@model function two_comp_mixture(x)
    # Hyper-parameters
    μ0 = 0.0
    σ0 = 1.0

    # Draw weights.
    π1 ~ Beta(1, 1)
    π2 = 1 - π1

    # Draw locations of the components.
    μ1 ~ Normal(μ0, σ0)
    μ2 ~ Normal(μ0, σ0)

    # Draw latent assignment.
    z ~ Categorical([π1, π2])

    # Draw observation from selected component.
    if z == 1
        x ~ Normal(μ1, σ0)
    else
        x ~ Normal(μ2, σ0)
    end
end

# ╔═╡ c5c9bdaa-6e3b-46d9-b537-791a7c1739bf
@gif for i in 1:Nmax
    scatter(
        collect(1:i),
        z[1:i];
        markersize=2,
        xlabel="observation (i)",
        ylabel="cluster (k)",
        legend=false,
    )
end

# ╔═╡ 28cbcd7a-bfb3-4f59-86fc-d5e84829da01
nk=Vector{Int}(map(k -> sum(z .==k), 1:maximum(z) ))

# ╔═╡ 65f761e5-5b59-4d87-89ae-a763591e63d9
maximum(z)

# ╔═╡ 4ef1c808-bc54-459e-a0c4-4928714eaa0b
rand(ChineseRestaurantProcess(rpm, nk))

# ╔═╡ a8393424-e097-4dd5-be88-24886798ffb0
md"Further, we can see that the number of clusters is logarithmic in the number of observations and data points. This is a side-effect of the `rich-get-richer` phenomenon, i.e. we expect large clusters and thus the number of clusters has to be smaller than the number of observations.

$E[K|N] \approx \alpha * log(1+\frac{N}{\alpha})$

We can see from the equation that the concentration parameter $\alpha$ allows us to control the number of clusters formed *a priori*.

In Turing we can implement an infinite Gaussian mixture model using the Chinese restaurant process construction of a Dirichlet process as follows:"

# ╔═╡ 7c0c50dc-e376-4365-b2ec-eeb7f26722fd
md"### 9.3.1.2 Test CRP on a infinite Gaussian Mixture Model"

# ╔═╡ 48477352-5850-4291-8b99-e4a688811246
@model function infiniteGMM(x, warn=true)
    # Hyper-parameters, i.e. concentration parameter and parameters of H.
    α = 0.5  # the smaller α is, the less clusters a priori.
    μ0 = 0.0  # μ of Prior to draw Gaussian cluster mean
    σ0 = 1.0  # σ of Prior to draw Gaussian cluster mean
    σ1 = 1.0  # σ for each Gaussian cluster

    # Define random measure, e.g. Dirichlet process.
    rpm = DirichletProcess(α)

    # The base distribution, to draw the mean value of all Gaussian distributions in the Dirichlet process.
    H = Normal(μ0, σ0)

    # Latent assignment.
    z = zeros(Int, length(x)) # tzeros() = zeros()

    # Locations of the infinitely many Gaussian clusters.
    μ = zeros(Float64, 0)
    # Number of clusters.
    K = 0

    for i in 1:length(x)

        # Number of clusters.
        #K = maximum(z)
        nk = Vector{Int}(map(k -> sum(z .== k), 1:K))

        # Draw the latent assignment.
        z[i] ~ ChineseRestaurantProcess(rpm, nk)

        # Create a new cluster?
        if z[i] > K
            K += 1
            push!(μ, 0.0)

            # Draw location of new cluster.
            μ[z[i]] ~ H
        end

        # An observation that follows this distribution
        x[i] ~ Normal(μ[z[i]], σ1)
    end
end


# ╔═╡ 41a0c3b8-8975-4d69-88cf-6d076f5ad5f2
tzeros(Int, 3)

# ╔═╡ baf60493-ff2f-4e17-8314-7c7ebdfaf536
md"We can now use Turing to infer the assignments of some data points. First, we will create some random data that comes from three clusters, with means of 0, -10, and 10, which is a bit easier than to infer 0, -5, 10."

# ╔═╡ df4c8aa3-9961-44ca-b24f-0bf3f7e26d39
begin 
	# Generate some test data.
	Random.seed!(1)
	csize=100
	data_gmm = vcat(randn(csize), randn(csize) .- 10, randn(csize) .+ 10)
	@show size(data_gmm)
	@show mean(data_gmm)
	data_gmm .-= mean(data_gmm)
	data_gmm /= std(data_gmm);
	histogram(data_gmm, bins=20)
end

# ╔═╡ f3027ecf-4b95-4a76-b5cf-b572ca3eb050
scatter(1:csize*3, data_gmm)

# ╔═╡ 245f4489-1320-4502-a956-5f922e4fcf8e
begin
	# MCMC sampling
	Random.seed!(2)
	@time model_infini_GMM_CRP = infiniteGMM(data_gmm);
	@time chain_infini_GMM_CRP = sample(model_infini_GMM_CRP, SMC(), 1500);
end

# ╔═╡ b551b54c-ab60-473a-89df-c7e9388cecd0
begin
	@time chain_infini_GMM_CRP_DF = DataFrame(chain_infini_GMM_CRP)
	#@show first(chain_infini_GMM_CRP_DF,5)
	last(chain_infini_GMM_CRP_DF, 5)
end

# ╔═╡ f6870036-a104-41a0-8b4f-a23d38b119d4
begin
	z_estimated = vec(chain_infini_GMM_CRP[1500, MCMCChains.namesingroup(chain_infini_GMM_CRP, :z),:].value)
	scatter(1:csize*3, z_estimated)
end

# ╔═╡ ac4a1de3-8ac4-4acb-9a0e-d7f517253e50
unique(z_estimated)

# ╔═╡ d832417b-151f-4a0f-8084-6c9007c8614a
function draw_cluster_no_in_chain(chain; burnin_iter=1, iterations=1000)    
    # Extract the number of clusters for each sample of the Markov chain.
    K = map(
        t -> length(unique(vec(chain[t, MCMCChains.namesingroup(chain, :z), :].value))),
        burnin_iter:iterations,
    );

    # Visualize the number of clusters.
    s_of_K = scatter(burnin_iter:iterations, K; xlabel="Iteration", 
        ylabel="Number of clusters", label="Chain 1")
    h_of_K = histogram(K; xlabel="Number of clusters", legend=false)

    plot(s_of_K, h_of_K, layout=(1,2), left_margin=5*Plots.mm, 
        bottom_margin=5*Plots.mm, size=(1200,430) ) 
end


# ╔═╡ f875202b-5c14-4800-8624-af904d1b19a3
@time draw_cluster_no_in_chain(chain_infini_GMM_CRP; burnin_iter=1, iterations=1500)

# ╔═╡ a1198545-4cc6-420e-bc85-ddde4ba8ab3c
md"### 9.3.2 Stick-breaking process


$\beta_k \sim Beta(1,\alpha)$
 
$\pi_k = \beta_k \Pi_{l=1}^{k-1} (1-\beta_{l})$
 
$\theta^*_k \sim H$
 
$G = \Sigma_{k=1}^{\infty}\pi_k \delta_{\theta_k^*}$
 
"

# ╔═╡ 8d269347-42a0-4ce6-8b07-1d065780eda1
md"### 9.3.3 Size biased sampling"

# ╔═╡ 3c6f3a86-84c2-4ef8-b520-a5804d053d86

"""
$(SIGNATURES)
Arguments:
- x: 1D data.
- rpm: is a Random process measure. e.g. Dirichlet process.

```julia
rpm = DirichletProcess(0.5)
```

- Hyper-parameters, i.e. concentration parameter and parameters of H.

"""
@model function infiniteGMM_size_biased(x, rpm)
	# The base distribution, to draw the mean value of all Gaussian distributions in the Dirichlet process.
	H = Normal(0.0, 2)
	
	N = length(x)
	# Latent assignment.
	z = zeros(Int, N)  #was tzeros()

	# Locations of the infinitely many clusters.
	μ = zeros(Float64, 0)
	
	# probability weights for each class
	J = zeros(Float64, N)

	K = 0 
	surplus=1.0
	for i in 1:N
		ps = vcat(J[1:K], surplus)
		z[i] ~ Categorical(ps)

		# Create a new cluster?
		if z[i] > K
			K += 1
			push!(μ, 0.0)
			# Assign a weight
			J[K] ~ SizeBiasedSamplingProcess(rpm, surplus)
			μ[K] ~ H
			surplus -= J[K]
		end

		# An observation that follows this distribution
		x[i] ~ Normal(μ[z[i]], 1)
	end
end


# ╔═╡ c37b709c-bcf5-4229-a421-5b40cbda24f8

begin
	# MCMC sampling
	Random.seed!(2)
	@time model_size_biased = infiniteGMM_size_biased(data_gmm, DirichletProcess(0.5));
	@time chain_infini_GMM_size_biased = sample(model_size_biased, SMC(), 1000);
end

# ╔═╡ dd7592d0-0031-4978-8392-80d31d672f21
draw_cluster_no_in_chain(chain_infini_GMM_size_biased)

# ╔═╡ 4d22ab2c-88af-4349-8a10-fd48e83c835d
begin
	z_estimated_2 = vec(chain_infini_GMM_size_biased[1000, MCMCChains.namesingroup(chain_infini_GMM_size_biased, :z),:].value)
	scatter(1:300, z_estimated_2)
end

# ╔═╡ fc893fa0-77f0-44fb-8071-b5b3c5d64697


# ╔═╡ cc9b2c50-e5d0-4764-8089-95804c5a1dc7
md"## 10 Visualize beta distributions"

# ╔═╡ 4a05157d-1792-4f01-8b80-0639aac47998
plot(x -> pdf(Beta(1, 5), x), 
	minimum(support(Beta(1,1))):0.01:maximum(support(Beta(1,1))),
    ylim=(0, 5), size=(400, 300), label=false, 
    xlabel="x", ylabel="P(x)", title="Beta distribution shapes")


# ╔═╡ b1011fa7-ea8a-4c0c-935e-2a57056612b1
0:0.01:1

# ╔═╡ c58b1888-a957-4e49-8486-e0f46346d03a
x -> pdf(Beta(1, 5), x)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
Distributions = "31c24e10-a181-5473-b8eb-7969acd0382f"
DocStringExtensions = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
DrWatson = "634d3b9d-ee7a-5ddf-bec9-22491ea816e1"
FillArrays = "1a297f60-69ca-5386-bcde-b61e274b549b"
InteractiveUtils = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
Markdown = "d6f4376e-aef5-505a-96c1-9c027394607a"
Pkg = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Printf = "de0858da-6303-5e67-8744-51eddeeeb8d7"
Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
StatsPlots = "f3b207a7-027a-5e70-b257-86293d7955fd"
Turing = "fce5fe82-541a-59a6-adf8-730c64b5f9a0"

[compat]
DataFrames = "~1.6.1"
Distributions = "~0.25.107"
DocStringExtensions = "~0.9.3"
DrWatson = "~2.14.1"
FillArrays = "~1.9.3"
Plots = "~1.40.2"
PlutoUI = "~0.7.58"
StatsPlots = "~0.15.7"
Turing = "~0.30.7"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.2"
manifest_format = "2.0"
project_hash = "b6a11094c1286beb263c9643590a12f49d12d8e4"

[[deps.ADTypes]]
git-tree-sha1 = "016833eb52ba2d6bea9fcb50ca295980e728ee24"
uuid = "47edcb42-4c32-4615-8424-f2b9edc5f35b"
version = "0.2.7"

[[deps.AbstractFFTs]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "d92ad398961a3ed262d8bf04a1a2b8340f915fef"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.5.0"
weakdeps = ["ChainRulesCore", "Test"]

    [deps.AbstractFFTs.extensions]
    AbstractFFTsChainRulesCoreExt = "ChainRulesCore"
    AbstractFFTsTestExt = "Test"

[[deps.AbstractMCMC]]
deps = ["BangBang", "ConsoleProgressMonitor", "Distributed", "FillArrays", "LogDensityProblems", "Logging", "LoggingExtras", "ProgressLogging", "Random", "StatsBase", "TerminalLoggers", "Transducers"]
git-tree-sha1 = "b0489adc45a7c8cf0d8e2ddf764f89c1c3decebd"
uuid = "80f14c24-f653-4e6a-9b94-39d6b0f70001"
version = "5.2.0"

[[deps.AbstractPPL]]
deps = ["AbstractMCMC", "DensityInterface", "Random", "Setfield"]
git-tree-sha1 = "9774889eac07c2e342e547b5c5c8ae5a2ce5c80b"
uuid = "7a57a42e-76ec-4ea3-a279-07e840d6d9cf"
version = "0.7.1"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "0f748c81756f2e5e6854298f11ad8b2dfae6911a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.0"

[[deps.AbstractTrees]]
git-tree-sha1 = "2d9c9a55f9c93e8887ad391fbae72f8ef55e1177"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.4.5"

[[deps.Accessors]]
deps = ["CompositionsBase", "ConstructionBase", "Dates", "InverseFunctions", "LinearAlgebra", "MacroTools", "Markdown", "Test"]
git-tree-sha1 = "c0d491ef0b135fd7d63cbc6404286bc633329425"
uuid = "7d9f7c33-5ae7-4f3b-8dc6-eff91059b697"
version = "0.1.36"

    [deps.Accessors.extensions]
    AccessorsAxisKeysExt = "AxisKeys"
    AccessorsIntervalSetsExt = "IntervalSets"
    AccessorsStaticArraysExt = "StaticArrays"
    AccessorsStructArraysExt = "StructArrays"
    AccessorsUnitfulExt = "Unitful"

    [deps.Accessors.weakdeps]
    AxisKeys = "94b1ba4f-4ee9-5380-92f1-94cde586c3c5"
    IntervalSets = "8197267c-284f-5f27-9208-e0e47529a953"
    Requires = "ae029012-a4dd-5104-9daa-d747884805df"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"
    StructArrays = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "6a55b747d1812e699320963ffde36f1ebdda4099"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "4.0.4"
weakdeps = ["StaticArrays"]

    [deps.Adapt.extensions]
    AdaptStaticArraysExt = "StaticArrays"

[[deps.AdvancedHMC]]
deps = ["AbstractMCMC", "ArgCheck", "DocStringExtensions", "InplaceOps", "LinearAlgebra", "LogDensityProblems", "LogDensityProblemsAD", "ProgressMeter", "Random", "Requires", "Setfield", "SimpleUnPack", "Statistics", "StatsBase", "StatsFuns"]
git-tree-sha1 = "dfa0e3508fc3df81d28624b328f3b937c1df8bc2"
uuid = "0bf59076-c3b1-5ca4-86bd-e02cd72cde3d"
version = "0.6.1"

    [deps.AdvancedHMC.extensions]
    AdvancedHMCCUDAExt = "CUDA"
    AdvancedHMCMCMCChainsExt = "MCMCChains"
    AdvancedHMCOrdinaryDiffEqExt = "OrdinaryDiffEq"

    [deps.AdvancedHMC.weakdeps]
    CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"
    MCMCChains = "c7f686f2-ff18-58e9-bc7b-31028e88f75d"
    OrdinaryDiffEq = "1dea7af3-3e70-54e6-95c3-0bf5283fa5ed"

[[deps.AdvancedMH]]
deps = ["AbstractMCMC", "Distributions", "FillArrays", "LinearAlgebra", "LogDensityProblems", "Random", "Requires"]
git-tree-sha1 = "16589dbdd36c782ff01700908e962b303474f641"
uuid = "5b7e9947-ddc0-4b3f-9b55-0d8042f74170"
version = "0.8.1"
weakdeps = ["DiffResults", "ForwardDiff", "MCMCChains", "StructArrays"]

    [deps.AdvancedMH.extensions]
    AdvancedMHForwardDiffExt = ["DiffResults", "ForwardDiff"]
    AdvancedMHMCMCChainsExt = "MCMCChains"
    AdvancedMHStructArraysExt = "StructArrays"

[[deps.AdvancedPS]]
deps = ["AbstractMCMC", "Distributions", "Random", "Random123", "Requires", "StatsFuns"]
git-tree-sha1 = "672f7ce648e06f93fceefde463c5855d77b6915a"
uuid = "576499cb-2369-40b2-a588-c64705576edc"
version = "0.5.4"
weakdeps = ["Libtask"]

    [deps.AdvancedPS.extensions]
    AdvancedPSLibtaskExt = "Libtask"

[[deps.AdvancedVI]]
deps = ["Bijectors", "Distributions", "DistributionsAD", "DocStringExtensions", "ForwardDiff", "LinearAlgebra", "ProgressMeter", "Random", "Requires", "StatsBase", "StatsFuns", "Tracker"]
git-tree-sha1 = "1f919a9c59cf3dfc68b64c22c453a2e356fca473"
uuid = "b5ca4192-6429-45e5-a2d9-87aec30a685c"
version = "0.2.4"

[[deps.ArgCheck]]
git-tree-sha1 = "a3a402a35a2f7e0b87828ccabbd5ebfbebe356b4"
uuid = "dce04be8-c92d-5529-be00-80e4d2c0e197"
version = "2.3.0"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Arpack]]
deps = ["Arpack_jll", "Libdl", "LinearAlgebra", "Logging"]
git-tree-sha1 = "9b9b347613394885fd1c8c7729bfc60528faa436"
uuid = "7d9fca2a-8960-54d3-9f78-7d1dccf2cb97"
version = "0.5.4"

[[deps.Arpack_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "OpenBLAS_jll", "Pkg"]
git-tree-sha1 = "5ba6c757e8feccf03a1554dfaf3e26b3cfc7fd5e"
uuid = "68821587-b530-5797-8361-c406ea357684"
version = "3.5.1+1"

[[deps.ArrayInterface]]
deps = ["Adapt", "LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "44691067188f6bd1b2289552a23e4b7572f4528d"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "7.9.0"

    [deps.ArrayInterface.extensions]
    ArrayInterfaceBandedMatricesExt = "BandedMatrices"
    ArrayInterfaceBlockBandedMatricesExt = "BlockBandedMatrices"
    ArrayInterfaceCUDAExt = "CUDA"
    ArrayInterfaceChainRulesExt = "ChainRules"
    ArrayInterfaceGPUArraysCoreExt = "GPUArraysCore"
    ArrayInterfaceReverseDiffExt = "ReverseDiff"
    ArrayInterfaceStaticArraysCoreExt = "StaticArraysCore"
    ArrayInterfaceTrackerExt = "Tracker"

    [deps.ArrayInterface.weakdeps]
    BandedMatrices = "aae01518-5342-5314-be14-df237901396f"
    BlockBandedMatrices = "ffab5731-97b5-5995-9138-79e8c1846df0"
    CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"
    ChainRules = "082447d4-558c-5d27-93f4-14fc19e9eca2"
    GPUArraysCore = "46192b85-c4d5-4398-a991-12ede77f4527"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"
    StaticArraysCore = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Atomix]]
deps = ["UnsafeAtomics"]
git-tree-sha1 = "c06a868224ecba914baa6942988e2f2aade419be"
uuid = "a9b6321e-bd34-4604-b9c9-b65b8de01458"
version = "0.1.0"

[[deps.AxisAlgorithms]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "WoodburyMatrices"]
git-tree-sha1 = "01b8ccb13d68535d73d2b0c23e39bd23155fb712"
uuid = "13072b0f-2c55-5437-9ae7-d433b7a33950"
version = "1.1.0"

[[deps.AxisArrays]]
deps = ["Dates", "IntervalSets", "IterTools", "RangeArrays"]
git-tree-sha1 = "16351be62963a67ac4083f748fdb3cca58bfd52f"
uuid = "39de3d68-74b9-583c-8d2d-e117c070f3a9"
version = "0.4.7"

[[deps.BangBang]]
deps = ["Compat", "ConstructionBase", "InitialValues", "LinearAlgebra", "Requires", "Setfield", "Tables"]
git-tree-sha1 = "7aa7ad1682f3d5754e3491bb59b8103cae28e3a3"
uuid = "198e06fe-97b7-11e9-32a5-e1d131e6ad66"
version = "0.3.40"

    [deps.BangBang.extensions]
    BangBangChainRulesCoreExt = "ChainRulesCore"
    BangBangDataFramesExt = "DataFrames"
    BangBangStaticArraysExt = "StaticArrays"
    BangBangStructArraysExt = "StructArrays"
    BangBangTypedTablesExt = "TypedTables"

    [deps.BangBang.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"
    StructArrays = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
    TypedTables = "9d95f2ec-7b3d-5a63-8d20-e2491e220bb9"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Baselet]]
git-tree-sha1 = "aebf55e6d7795e02ca500a689d326ac979aaf89e"
uuid = "9718e550-a3fa-408a-8086-8db961cd8217"
version = "0.1.1"

[[deps.Bijectors]]
deps = ["ArgCheck", "ChainRules", "ChainRulesCore", "ChangesOfVariables", "Compat", "Distributions", "Functors", "InverseFunctions", "IrrationalConstants", "LinearAlgebra", "LogExpFunctions", "MappedArrays", "Random", "Reexport", "Requires", "Roots", "SparseArrays", "Statistics"]
git-tree-sha1 = "199dc2c4151db557549a0ad8888ce1a60337ff42"
uuid = "76274a88-744f-5084-9051-94815aaf08c4"
version = "0.13.8"

    [deps.Bijectors.extensions]
    BijectorsDistributionsADExt = "DistributionsAD"
    BijectorsForwardDiffExt = "ForwardDiff"
    BijectorsLazyArraysExt = "LazyArrays"
    BijectorsReverseDiffExt = "ReverseDiff"
    BijectorsTrackerExt = "Tracker"
    BijectorsZygoteExt = "Zygote"

    [deps.Bijectors.weakdeps]
    DistributionsAD = "ced4e74d-a319-5a8a-b0ac-84af2272839c"
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    LazyArrays = "5078a376-72f3-5289-bfd5-ec5146d43c02"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"
    Zygote = "e88e6eb3-aa80-5325-afca-941959d7151f"

[[deps.BitFlags]]
git-tree-sha1 = "2dc09997850d68179b69dafb58ae806167a32b1b"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.8"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9e2a6b69137e6969bab0152632dcb3bc108c8bdd"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+1"

[[deps.CEnum]]
git-tree-sha1 = "389ad5c84de1ae7cf0e28e381131c98ea87d54fc"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.5.0"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "a4c43f59baa34011e303e76f5c8c91bf58415aaf"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.18.0+1"

[[deps.Calculus]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f641eb0a4f00c343bbc32346e1217b86f3ce9dad"
uuid = "49dc2e85-a5d0-5ad3-a950-438e2897f1b9"
version = "0.5.1"

[[deps.ChainRules]]
deps = ["Adapt", "ChainRulesCore", "Compat", "Distributed", "GPUArraysCore", "IrrationalConstants", "LinearAlgebra", "Random", "RealDot", "SparseArrays", "SparseInverseSubset", "Statistics", "StructArrays", "SuiteSparse"]
git-tree-sha1 = "4e42872be98fa3343c4f8458cbda8c5c6a6fa97c"
uuid = "082447d4-558c-5d27-93f4-14fc19e9eca2"
version = "1.63.0"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra"]
git-tree-sha1 = "575cd02e080939a33b6df6c5853d14924c08e35b"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.23.0"
weakdeps = ["SparseArrays"]

    [deps.ChainRulesCore.extensions]
    ChainRulesCoreSparseArraysExt = "SparseArrays"

[[deps.ChangesOfVariables]]
deps = ["LinearAlgebra", "Test"]
git-tree-sha1 = "2fba81a302a7be671aefe194f0525ef231104e7f"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.8"
weakdeps = ["InverseFunctions"]

    [deps.ChangesOfVariables.extensions]
    ChangesOfVariablesInverseFunctionsExt = "InverseFunctions"

[[deps.Clustering]]
deps = ["Distances", "LinearAlgebra", "NearestNeighbors", "Printf", "Random", "SparseArrays", "Statistics", "StatsBase"]
git-tree-sha1 = "9ebb045901e9bbf58767a9f34ff89831ed711aae"
uuid = "aaaa29a8-35af-508c-8bc3-b662a17a0fe5"
version = "0.15.7"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "59939d8a997469ee05c4b4944560a820f9ba0d73"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.4"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "67c1f244b991cad9b0aa4b7540fb758c2488b129"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.24.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "Requires", "Statistics", "TensorCore"]
git-tree-sha1 = "a1f44953f2382ebb937d60dafbe2deea4bd23249"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.10.0"
weakdeps = ["SpecialFunctions"]

    [deps.ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

[[deps.Combinatorics]]
git-tree-sha1 = "08c8b6831dc00bfea825826be0bc8336fc369860"
uuid = "861a8166-3701-5b0c-9a16-15d98fcdc6aa"
version = "1.0.2"

[[deps.CommonSolve]]
git-tree-sha1 = "0eee5eb66b1cf62cd6ad1b460238e60e4b09400c"
uuid = "38540f10-b2f7-11e9-35d8-d573e4eb0ff2"
version = "0.2.4"

[[deps.CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[deps.Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "c955881e3c981181362ae4088b35995446298b80"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.14.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.0+0"

[[deps.CompositionsBase]]
git-tree-sha1 = "802bb88cd69dfd1509f6670416bd4434015693ad"
uuid = "a33af91c-f02d-484b-be07-31d278c5ca2b"
version = "0.1.2"
weakdeps = ["InverseFunctions"]

    [deps.CompositionsBase.extensions]
    CompositionsBaseInverseFunctionsExt = "InverseFunctions"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "6cbbd4d241d7e6579ab354737f4dd95ca43946e1"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.4.1"

[[deps.ConsoleProgressMonitor]]
deps = ["Logging", "ProgressMeter"]
git-tree-sha1 = "3ab7b2136722890b9af903859afcf457fa3059e8"
uuid = "88cd18e8-d9cc-4ea6-8889-5259c0d15c8b"
version = "0.1.2"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "260fd2400ed2dab602a7c15cf10c1933c59930a2"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.5.5"
weakdeps = ["IntervalSets", "StaticArrays"]

    [deps.ConstructionBase.extensions]
    ConstructionBaseIntervalSetsExt = "IntervalSets"
    ConstructionBaseStaticArraysExt = "StaticArrays"

[[deps.Contour]]
git-tree-sha1 = "d05d9e7b7aedff4e5b51a029dced05cfb6125781"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.2"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.DataAPI]]
git-tree-sha1 = "abe83f3a2f1b857aac70ef8b269080af17764bbe"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.16.0"

[[deps.DataFrames]]
deps = ["Compat", "DataAPI", "DataStructures", "Future", "InlineStrings", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrecompileTools", "PrettyTables", "Printf", "REPL", "Random", "Reexport", "SentinelArrays", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "04c738083f29f86e62c8afc341f0967d8717bdb8"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.6.1"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "0f4b5d62a88d8f59003e43c25a8a90de9eb76317"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.18"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DefineSingletons]]
git-tree-sha1 = "0fba8b706d0178b4dc7fd44a96a92382c9065c2c"
uuid = "244e2a9f-e319-4986-a169-4d1fe445cd52"
version = "0.1.2"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[deps.DensityInterface]]
deps = ["InverseFunctions", "Test"]
git-tree-sha1 = "80c3e8639e3353e5d2912fb3a1916b8455e2494b"
uuid = "b429d917-457f-4dbc-8f4c-0cc954292b1d"
version = "0.4.0"

[[deps.DiffResults]]
deps = ["StaticArraysCore"]
git-tree-sha1 = "782dd5f4561f5d267313f23853baaaa4c52ea621"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.1.0"

[[deps.DiffRules]]
deps = ["IrrationalConstants", "LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "23163d55f885173722d1e4cf0f6110cdbaf7e272"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.15.1"

[[deps.Distances]]
deps = ["LinearAlgebra", "Statistics", "StatsAPI"]
git-tree-sha1 = "66c4c81f259586e8f002eacebc177e1fb06363b0"
uuid = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
version = "0.10.11"
weakdeps = ["ChainRulesCore", "SparseArrays"]

    [deps.Distances.extensions]
    DistancesChainRulesCoreExt = "ChainRulesCore"
    DistancesSparseArraysExt = "SparseArrays"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Distributions]]
deps = ["FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SpecialFunctions", "Statistics", "StatsAPI", "StatsBase", "StatsFuns"]
git-tree-sha1 = "7c302d7a5fec5214eb8a5a4c466dcf7a51fcf169"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.107"
weakdeps = ["ChainRulesCore", "DensityInterface", "Test"]

    [deps.Distributions.extensions]
    DistributionsChainRulesCoreExt = "ChainRulesCore"
    DistributionsDensityInterfaceExt = "DensityInterface"
    DistributionsTestExt = "Test"

[[deps.DistributionsAD]]
deps = ["Adapt", "ChainRules", "ChainRulesCore", "Compat", "Distributions", "FillArrays", "LinearAlgebra", "PDMats", "Random", "Requires", "SpecialFunctions", "StaticArrays", "StatsFuns", "ZygoteRules"]
git-tree-sha1 = "060a19f3f879773399a7011676eb273ccc265241"
uuid = "ced4e74d-a319-5a8a-b0ac-84af2272839c"
version = "0.6.54"

    [deps.DistributionsAD.extensions]
    DistributionsADForwardDiffExt = "ForwardDiff"
    DistributionsADLazyArraysExt = "LazyArrays"
    DistributionsADReverseDiffExt = "ReverseDiff"
    DistributionsADTrackerExt = "Tracker"

    [deps.DistributionsAD.weakdeps]
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    LazyArrays = "5078a376-72f3-5289-bfd5-ec5146d43c02"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.DrWatson]]
deps = ["Dates", "FileIO", "JLD2", "LibGit2", "MacroTools", "Pkg", "Random", "Requires", "Scratch", "UnPack"]
git-tree-sha1 = "8a1b165850e0a7967a662be78f4a1b131df84898"
uuid = "634d3b9d-ee7a-5ddf-bec9-22491ea816e1"
version = "2.14.1"

[[deps.DualNumbers]]
deps = ["Calculus", "NaNMath", "SpecialFunctions"]
git-tree-sha1 = "5837a837389fccf076445fce071c8ddaea35a566"
uuid = "fa6b7ba4-c1ee-5f82-b5fc-ecf0adba8f74"
version = "0.6.8"

[[deps.DynamicPPL]]
deps = ["ADTypes", "AbstractMCMC", "AbstractPPL", "BangBang", "Bijectors", "Compat", "ConstructionBase", "Distributions", "DocStringExtensions", "LinearAlgebra", "LogDensityProblems", "LogDensityProblemsAD", "MacroTools", "OrderedCollections", "Random", "Requires", "Setfield", "Test"]
git-tree-sha1 = "6fe2424f8f47c0fecd01349a2a77987f3c988393"
uuid = "366bfd00-2699-11ea-058f-f148b4cae6d8"
version = "0.24.9"

    [deps.DynamicPPL.extensions]
    DynamicPPLChainRulesCoreExt = ["ChainRulesCore"]
    DynamicPPLEnzymeCoreExt = ["EnzymeCore"]
    DynamicPPLForwardDiffExt = ["ForwardDiff"]
    DynamicPPLMCMCChainsExt = ["MCMCChains"]
    DynamicPPLReverseDiffExt = ["ReverseDiff"]
    DynamicPPLZygoteRulesExt = ["ZygoteRules"]

    [deps.DynamicPPL.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    EnzymeCore = "f151be2c-9106-41f4-ab19-57ee4f262869"
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    MCMCChains = "c7f686f2-ff18-58e9-bc7b-31028e88f75d"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"
    ZygoteRules = "700de1a5-db45-46bc-99cf-38207098b444"

[[deps.EllipticalSliceSampling]]
deps = ["AbstractMCMC", "ArrayInterface", "Distributions", "Random", "Statistics"]
git-tree-sha1 = "e611b7fdfbfb5b18d5e98776c30daede41b44542"
uuid = "cad2338a-1db2-11e9-3401-43bc07c9ede2"
version = "2.0.0"

[[deps.EnumX]]
git-tree-sha1 = "bdb1942cd4c45e3c678fd11569d5cccd80976237"
uuid = "4e289a0a-7415-4d19-859d-a7e5c4648b56"
version = "1.0.4"

[[deps.EpollShim_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8e9441ee83492030ace98f9789a654a6d0b1f643"
uuid = "2702e6a9-849d-5ed8-8c21-79e8b8f9ee43"
version = "0.0.20230411+0"

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "dcb08a0d93ec0b1cdc4af184b26b591e9695423a"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.10"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "4558ab818dcceaab612d1bb8c19cee87eda2b83c"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.5.0+0"

[[deps.ExprTools]]
git-tree-sha1 = "27415f162e6028e81c72b82ef756bf321213b6ec"
uuid = "e2ba6199-217a-4e67-a87a-7c52f15ade04"
version = "0.1.10"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "466d45dc38e15794ec7d5d63ec03d776a9aff36e"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.4+1"

[[deps.FFTW]]
deps = ["AbstractFFTs", "FFTW_jll", "LinearAlgebra", "MKL_jll", "Preferences", "Reexport"]
git-tree-sha1 = "4820348781ae578893311153d69049a93d05f39d"
uuid = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
version = "1.8.0"

[[deps.FFTW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c6033cc3892d0ef5bb9cd29b7f2f0331ea5184ea"
uuid = "f5851436-0d7a-5f13-b9de-f02708fd171a"
version = "3.3.10+0"

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "82d8afa92ecf4b52d78d869f038ebfb881267322"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.16.3"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FillArrays]]
deps = ["LinearAlgebra", "Random"]
git-tree-sha1 = "5b93957f6dcd33fc343044af3d48c215be2562f1"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "1.9.3"
weakdeps = ["PDMats", "SparseArrays", "Statistics"]

    [deps.FillArrays.extensions]
    FillArraysPDMatsExt = "PDMats"
    FillArraysSparseArraysExt = "SparseArrays"
    FillArraysStatisticsExt = "Statistics"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Format]]
git-tree-sha1 = "9c68794ef81b08086aeb32eeaf33531668d5f5fc"
uuid = "1fa38f19-a742-5d3f-a2b9-30dd87b9d5f8"
version = "1.3.7"

[[deps.ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions"]
git-tree-sha1 = "cf0fe81336da9fb90944683b8c41984b08793dad"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.36"
weakdeps = ["StaticArrays"]

    [deps.ForwardDiff.extensions]
    ForwardDiffStaticArraysExt = "StaticArrays"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "d8db6a5a2fe1381c1ea4ef2cab7c69c2de7f9ea0"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.13.1+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.FunctionWrappers]]
git-tree-sha1 = "d62485945ce5ae9c0c48f124a84998d755bae00e"
uuid = "069b7b12-0de2-55c6-9aab-29f3d0a68a2e"
version = "1.1.3"

[[deps.FunctionWrappersWrappers]]
deps = ["FunctionWrappers"]
git-tree-sha1 = "b104d487b34566608f8b4e1c39fb0b10aa279ff8"
uuid = "77dc65aa-8811-40c2-897b-53d922fa7daf"
version = "0.1.3"

[[deps.Functors]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "8ae30e786837ce0a24f5e2186938bf3251ab94b2"
uuid = "d9f16b24-f501-4c13-a1f2-28368ffc5196"
version = "0.4.8"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "ff38ba61beff76b8f4acad8ab0c97ef73bb670cb"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.9+0"

[[deps.GPUArraysCore]]
deps = ["Adapt"]
git-tree-sha1 = "ec632f177c0d990e64d955ccc1b8c04c485a0950"
uuid = "46192b85-c4d5-4398-a991-12ede77f4527"
version = "0.1.6"

[[deps.GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Preferences", "Printf", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "UUIDs", "p7zip_jll"]
git-tree-sha1 = "3437ade7073682993e092ca570ad68a2aba26983"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.73.3"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "FreeType2_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt6Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "a96d5c713e6aa28c242b0d25c1347e258d6541ab"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.73.3+0"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Zlib_jll"]
git-tree-sha1 = "359a1ba2e320790ddbe4ee8b4d54a305c0ea2aff"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.80.0+0"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "8e59b47b9dc525b70550ca082ce85bcd7f5477cd"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.10.5"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.HypergeometricFunctions]]
deps = ["DualNumbers", "LinearAlgebra", "OpenLibm_jll", "SpecialFunctions"]
git-tree-sha1 = "f218fe3736ddf977e0e772bc9a586b2383da2685"
uuid = "34004b35-14d8-5ef3-9330-4cdb6864b03a"
version = "0.3.23"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "179267cfa5e712760cd43dcae385d7ea90cc25a4"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.5"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "8b72179abc660bfab5e28472e019392b97d0985c"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.4"

[[deps.InitialValues]]
git-tree-sha1 = "4da0f88e9a39111c2fa3add390ab15f3a44f3ca3"
uuid = "22cec73e-a1b8-11e9-2c92-598750a2cf9c"
version = "0.3.1"

[[deps.InlineStrings]]
deps = ["Parsers"]
git-tree-sha1 = "9cc2baf75c6d09f9da536ddf58eb2f29dedaf461"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.4.0"

[[deps.InplaceOps]]
deps = ["LinearAlgebra", "Test"]
git-tree-sha1 = "50b41d59e7164ab6fda65e71049fee9d890731ff"
uuid = "505f98c9-085e-5b2c-8e89-488be7bf1f34"
version = "0.3.0"

[[deps.IntelOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "5fdf2fe6724d8caabf43b557b84ce53f3b7e2f6b"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2024.0.2+0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.Interpolations]]
deps = ["Adapt", "AxisAlgorithms", "ChainRulesCore", "LinearAlgebra", "OffsetArrays", "Random", "Ratios", "Requires", "SharedArrays", "SparseArrays", "StaticArrays", "WoodburyMatrices"]
git-tree-sha1 = "88a101217d7cb38a7b481ccd50d21876e1d1b0e0"
uuid = "a98d9a8b-a2ab-59e6-89dd-64a1c18fca59"
version = "0.15.1"
weakdeps = ["Unitful"]

    [deps.Interpolations.extensions]
    InterpolationsUnitfulExt = "Unitful"

[[deps.IntervalSets]]
git-tree-sha1 = "dba9ddf07f77f60450fe5d2e2beb9854d9a49bd0"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.7.10"
weakdeps = ["Random", "RecipesBase", "Statistics"]

    [deps.IntervalSets.extensions]
    IntervalSetsRandomExt = "Random"
    IntervalSetsRecipesBaseExt = "RecipesBase"
    IntervalSetsStatisticsExt = "Statistics"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "896385798a8d49a255c398bd49162062e4a4c435"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.13"
weakdeps = ["Dates"]

    [deps.InverseFunctions.extensions]
    DatesExt = "Dates"

[[deps.InvertedIndices]]
git-tree-sha1 = "0dc7b50b8d436461be01300fd8cd45aa0274b038"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.3.0"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.IterTools]]
git-tree-sha1 = "42d5f897009e7ff2cf88db414a389e5ed1bdd023"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.10.0"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLD2]]
deps = ["FileIO", "MacroTools", "Mmap", "OrderedCollections", "Pkg", "PrecompileTools", "Printf", "Reexport", "Requires", "TranscodingStreams", "UUIDs"]
git-tree-sha1 = "5ea6acdd53a51d897672edb694e3cc2912f3f8a7"
uuid = "033835bb-8acc-5ee8-8aae-3f567f8a3819"
version = "0.4.46"

[[deps.JLFzf]]
deps = ["Pipe", "REPL", "Random", "fzf_jll"]
git-tree-sha1 = "a53ebe394b71470c7f97c2e7e170d51df21b17af"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.7"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "7e5d6779a1e09a36db2a7b6cff50942a0a7d0fca"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.5.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "3336abae9a713d2210bb57ab484b1e065edd7d23"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "3.0.2+0"

[[deps.KernelAbstractions]]
deps = ["Adapt", "Atomix", "InteractiveUtils", "LinearAlgebra", "MacroTools", "PrecompileTools", "Requires", "SparseArrays", "StaticArrays", "UUIDs", "UnsafeAtomics", "UnsafeAtomicsLLVM"]
git-tree-sha1 = "ed7167240f40e62d97c1f5f7735dea6de3cc5c49"
uuid = "63c18a36-062a-441e-b654-da1e3ab1ce7c"
version = "0.9.18"

    [deps.KernelAbstractions.extensions]
    EnzymeExt = "EnzymeCore"

    [deps.KernelAbstractions.weakdeps]
    EnzymeCore = "f151be2c-9106-41f4-ab19-57ee4f262869"

[[deps.KernelDensity]]
deps = ["Distributions", "DocStringExtensions", "FFTW", "Interpolations", "StatsBase"]
git-tree-sha1 = "fee018a29b60733876eb557804b5b109dd3dd8a7"
uuid = "5ab0869b-81aa-558d-bb23-cbf5423bbe9b"
version = "0.6.8"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LLVM]]
deps = ["CEnum", "LLVMExtra_jll", "Libdl", "Preferences", "Printf", "Requires", "Unicode"]
git-tree-sha1 = "ab01dde107f21aa76144d0771dccc08f152ccac7"
uuid = "929cbde3-209d-540e-8aea-75f648917ca0"
version = "6.6.2"

    [deps.LLVM.extensions]
    BFloat16sExt = "BFloat16s"

    [deps.LLVM.weakdeps]
    BFloat16s = "ab4f0b2a-ad5b-11e8-123f-65d77653426b"

[[deps.LLVMExtra_jll]]
deps = ["Artifacts", "JLLWrappers", "LazyArtifacts", "Libdl", "TOML"]
git-tree-sha1 = "88b916503aac4fb7f701bb625cd84ca5dd1677bc"
uuid = "dad2f222-ce93-54a1-a47d-0025e8a3acab"
version = "0.0.29+0"

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "d986ce2d884d49126836ea94ed5bfb0f12679713"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "15.0.7+0"

[[deps.LRUCache]]
git-tree-sha1 = "b3cc6698599b10e652832c2f23db3cab99d51b59"
uuid = "8ac3fa9e-de4c-5943-b1dc-09c6b5f20637"
version = "1.6.1"
weakdeps = ["Serialization"]

    [deps.LRUCache.extensions]
    SerializationExt = ["Serialization"]

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "50901ebc375ed41dbf8058da26f9de442febbbec"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.1"

[[deps.Latexify]]
deps = ["Format", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Requires"]
git-tree-sha1 = "cad560042a7cc108f5a4c24ea1431a9221f22c1b"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.2"

    [deps.Latexify.extensions]
    DataFramesExt = "DataFrames"
    SymEngineExt = "SymEngine"

    [deps.Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

[[deps.LeftChildRightSiblingTrees]]
deps = ["AbstractTrees"]
git-tree-sha1 = "fb6803dafae4a5d62ea5cab204b1e657d9737e7f"
uuid = "1d6d02ad-be62-4b6b-8a6d-2f90e265016e"
version = "0.2.0"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.4.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.6.4+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "6f73d1dd803986947b2c750138528a999a6c7733"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.6.0+0"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "f9557a255370125b405568f9767d6d195822a175"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.17.0+0"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "dae976433497a2f841baadea93d27e68f1a12a97"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.39.3+0"

[[deps.Libtask]]
deps = ["FunctionWrappers", "LRUCache", "LinearAlgebra", "Statistics"]
git-tree-sha1 = "ed1f362b3fd13f00b65e61d98669c652c17663ab"
uuid = "6f1fad26-d15e-5dc8-ae53-837a1d7b8c9f"
version = "0.8.7"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "XZ_jll", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "2da088d113af58221c52828a80378e16be7d037a"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.5.1+1"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "0a04a1318df1bf510beb2562cf90fb0c386f58c4"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.39.3+1"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogDensityProblems]]
deps = ["ArgCheck", "DocStringExtensions", "Random"]
git-tree-sha1 = "f9a11237204bc137617194d79d813069838fcf61"
uuid = "6fdf6af0-433a-55f7-b3ed-c6c6e0b8df7c"
version = "2.1.1"

[[deps.LogDensityProblemsAD]]
deps = ["DocStringExtensions", "LogDensityProblems", "Requires", "SimpleUnPack"]
git-tree-sha1 = "9c50732cd0f188766b6217ed6a2ebbdaf9890029"
uuid = "996a588d-648d-4e1f-a8f0-a84b347e47b1"
version = "1.7.0"

    [deps.LogDensityProblemsAD.extensions]
    LogDensityProblemsADADTypesExt = "ADTypes"
    LogDensityProblemsADEnzymeExt = "Enzyme"
    LogDensityProblemsADFiniteDifferencesExt = "FiniteDifferences"
    LogDensityProblemsADForwardDiffBenchmarkToolsExt = ["BenchmarkTools", "ForwardDiff"]
    LogDensityProblemsADForwardDiffExt = "ForwardDiff"
    LogDensityProblemsADReverseDiffExt = "ReverseDiff"
    LogDensityProblemsADTrackerExt = "Tracker"
    LogDensityProblemsADZygoteExt = "Zygote"

    [deps.LogDensityProblemsAD.weakdeps]
    ADTypes = "47edcb42-4c32-4615-8424-f2b9edc5f35b"
    BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
    Enzyme = "7da242da-08ed-463a-9acd-ee780be4f1d9"
    FiniteDifferences = "26cc04aa-876d-5657-8c51-4c34ba976000"
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"
    Zygote = "e88e6eb3-aa80-5325-afca-941959d7151f"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "18144f3e9cbe9b15b070288eef858f71b291ce37"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.27"
weakdeps = ["ChainRulesCore", "ChangesOfVariables", "InverseFunctions"]

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "c1dd6d7978c12545b4179fb6153b9250c96b0075"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.3"

[[deps.MCMCChains]]
deps = ["AbstractMCMC", "AxisArrays", "Dates", "Distributions", "IteratorInterfaceExtensions", "KernelDensity", "LinearAlgebra", "MCMCDiagnosticTools", "MLJModelInterface", "NaturalSort", "OrderedCollections", "PrettyTables", "Random", "RecipesBase", "Statistics", "StatsBase", "StatsFuns", "TableTraits", "Tables"]
git-tree-sha1 = "d28056379864318172ff4b7958710cfddd709339"
uuid = "c7f686f2-ff18-58e9-bc7b-31028e88f75d"
version = "6.0.6"

[[deps.MCMCDiagnosticTools]]
deps = ["AbstractFFTs", "DataAPI", "DataStructures", "Distributions", "LinearAlgebra", "MLJModelInterface", "Random", "SpecialFunctions", "Statistics", "StatsBase", "StatsFuns", "Tables"]
git-tree-sha1 = "8ba8b1840d3ab5b38e7c71c23c3193bb5cbc02b5"
uuid = "be115224-59cd-429b-ad48-344e309966f0"
version = "0.3.10"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl"]
git-tree-sha1 = "72dc3cf284559eb8f53aa593fe62cb33f83ed0c0"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2024.0.0+0"

[[deps.MLJModelInterface]]
deps = ["Random", "ScientificTypesBase", "StatisticalTraits"]
git-tree-sha1 = "d2a45e1b5998ba3fdfb6cfe0c81096d4c7fb40e7"
uuid = "e80e1ace-859a-464e-9ed9-23947d8ae3ea"
version = "1.9.6"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "2fa9ee3e63fd3a4f7a9a4f4744a52f4856de82df"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.13"

[[deps.MappedArrays]]
git-tree-sha1 = "2dab0221fe2b0f2cb6754eaa743cc266339f527e"
uuid = "dbb5928d-eab1-5f90-85c2-b9b0edb7c900"
version = "0.4.2"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "NetworkOptions", "Random", "Sockets"]
git-tree-sha1 = "c067a280ddc25f196b5e7df3877c6b226d390aaf"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.9"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+1"

[[deps.Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

[[deps.MicroCollections]]
deps = ["BangBang", "InitialValues", "Setfield"]
git-tree-sha1 = "629afd7d10dbc6935ec59b32daeb33bc4460a42e"
uuid = "128add7d-3638-4c79-886c-908ea0c25c34"
version = "0.1.4"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.1.10"

[[deps.MultivariateStats]]
deps = ["Arpack", "LinearAlgebra", "SparseArrays", "Statistics", "StatsAPI", "StatsBase"]
git-tree-sha1 = "68bf5103e002c44adfd71fea6bd770b3f0586843"
uuid = "6f286f6a-111f-5878-ab1e-185364afe411"
version = "0.10.2"

[[deps.NNlib]]
deps = ["Adapt", "Atomix", "ChainRulesCore", "GPUArraysCore", "KernelAbstractions", "LinearAlgebra", "Pkg", "Random", "Requires", "Statistics"]
git-tree-sha1 = "877f15c331337d54cf24c797d5bcb2e48ce21221"
uuid = "872c559c-99b0-510c-b3b7-b6c96a88d5cd"
version = "0.9.12"

    [deps.NNlib.extensions]
    NNlibAMDGPUExt = "AMDGPU"
    NNlibCUDACUDNNExt = ["CUDA", "cuDNN"]
    NNlibCUDAExt = "CUDA"
    NNlibEnzymeCoreExt = "EnzymeCore"

    [deps.NNlib.weakdeps]
    AMDGPU = "21141c5a-9bdb-4563-92ae-f87d6854732e"
    CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"
    EnzymeCore = "f151be2c-9106-41f4-ab19-57ee4f262869"
    cuDNN = "02a925ec-e4fe-4b08-9a7e-0d78e3d38ccd"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NamedArrays]]
deps = ["Combinatorics", "DataStructures", "DelimitedFiles", "InvertedIndices", "LinearAlgebra", "Random", "Requires", "SparseArrays", "Statistics"]
git-tree-sha1 = "0ae91efac93c3859f5c812a24c9468bb9e50b028"
uuid = "86f7a689-2022-50b4-a561-43c23ac3c673"
version = "0.10.1"

[[deps.NaturalSort]]
git-tree-sha1 = "eda490d06b9f7c00752ee81cfa451efe55521e21"
uuid = "c020b1a1-e9b0-503a-9c33-f039bfc54a85"
version = "1.0.0"

[[deps.NearestNeighbors]]
deps = ["Distances", "StaticArrays"]
git-tree-sha1 = "ded64ff6d4fdd1cb68dfcbb818c69e144a5b2e4c"
uuid = "b8a86587-4115-5ab1-83bc-aa920d37bbce"
version = "0.4.16"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Observables]]
git-tree-sha1 = "7438a59546cf62428fc9d1bc94729146d37a7225"
uuid = "510215fc-4207-5dde-b226-833fc4488ee2"
version = "0.5.5"

[[deps.OffsetArrays]]
git-tree-sha1 = "6a731f2b5c03157418a20c12195eb4b74c8f8621"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.13.0"
weakdeps = ["Adapt"]

    [deps.OffsetArrays.extensions]
    OffsetArraysAdaptExt = "Adapt"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.23+4"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+2"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "af81a32750ebc831ee28bdaaba6e1067decef51e"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.2"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "60e3045590bd104a16fefb12836c00c0ef8c7f8c"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.0.13+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Optimisers]]
deps = ["ChainRulesCore", "Functors", "LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "264b061c1903bc0fe9be77cb9050ebacff66bb63"
uuid = "3bd65402-5787-11e9-1adc-39752487f4e2"
version = "0.3.2"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "dfdf5519f235516220579f949664f1bf44e741c5"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.3"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.42.0+1"

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "949347156c25054de2db3b166c52ac4728cbad65"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.31"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Pipe]]
git-tree-sha1 = "6842804e7867b115ca9de748a0cf6b364523c16d"
uuid = "b98c9c47-44ae-5843-9183-064241ee97a0"
version = "1.3.0"

[[deps.Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "64779bc4c9784fee475689a1752ef4d5747c5e87"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.42.2+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.10.0"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "1f03a2d339f42dca4a4da149c7e15e9b896ad899"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.1.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "PrecompileTools", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "7b1a9df27f072ac4c9c7cbe5efb198489258d1f5"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.4.1"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "PrecompileTools", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "UnitfulLatexify", "Unzip"]
git-tree-sha1 = "3c403c6590dd93b36752634115e20137e79ab4df"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.40.2"

    [deps.Plots.extensions]
    FileIOExt = "FileIO"
    GeometryBasicsExt = "GeometryBasics"
    IJuliaExt = "IJulia"
    ImageInTerminalExt = "ImageInTerminal"
    UnitfulExt = "Unitful"

    [deps.Plots.weakdeps]
    FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
    GeometryBasics = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
    IJulia = "7073ff75-c697-5162-941a-fcdaad2a7d2a"
    ImageInTerminal = "d8c32880-2388-543b-8c61-d9f865259254"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "71a22244e352aa8c5f0f2adde4150f62368a3f2e"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.58"

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "36d8b4b899628fb92c2749eb488d884a926614d3"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.3"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.PrettyTables]]
deps = ["Crayons", "LaTeXStrings", "Markdown", "PrecompileTools", "Printf", "Reexport", "StringManipulation", "Tables"]
git-tree-sha1 = "88b895d13d53b5577fd53379d913b9ab9ac82660"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "2.3.1"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.ProgressLogging]]
deps = ["Logging", "SHA", "UUIDs"]
git-tree-sha1 = "80d919dee55b9c50e8d9e2da5eeafff3fe58b539"
uuid = "33c8b6b6-d38a-422a-b730-caa89a2f386c"
version = "0.1.4"

[[deps.ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "763a8ceb07833dd51bb9e3bbca372de32c0605ad"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.10.0"

[[deps.Qt6Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Vulkan_Loader_jll", "Xorg_libSM_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_cursor_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "libinput_jll", "xkbcommon_jll"]
git-tree-sha1 = "37b7bb7aabf9a085e0044307e1717436117f2b3b"
uuid = "c0090381-4147-56d7-9ebc-da0b1113ec56"
version = "6.5.3+1"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "9b23c31e76e333e6fb4c1595ae6afa74966a729e"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.9.4"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Random123]]
deps = ["Random", "RandomNumbers"]
git-tree-sha1 = "4743b43e5a9c4a2ede372de7061eed81795b12e7"
uuid = "74087812-796a-5b5d-8853-05524746bad3"
version = "1.7.0"

[[deps.RandomNumbers]]
deps = ["Random", "Requires"]
git-tree-sha1 = "043da614cc7e95c703498a491e2c21f58a2b8111"
uuid = "e6cf234a-135c-5ec9-84dd-332b85af5143"
version = "1.5.3"

[[deps.RangeArrays]]
git-tree-sha1 = "b9039e93773ddcfc828f12aadf7115b4b4d225f5"
uuid = "b3c3ace0-ae52-54e7-9d0b-2c1406fd6b9d"
version = "0.3.2"

[[deps.Ratios]]
deps = ["Requires"]
git-tree-sha1 = "1342a47bf3260ee108163042310d26f2be5ec90b"
uuid = "c84ed2f1-dad5-54f0-aa8e-dbefe2724439"
version = "0.4.5"
weakdeps = ["FixedPointNumbers"]

    [deps.Ratios.extensions]
    RatiosFixedPointNumbersExt = "FixedPointNumbers"

[[deps.RealDot]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "9f0a1b71baaf7650f4fa8a1d168c7fb6ee41f0c9"
uuid = "c1ae055f-0cd5-4b69-90a6-9a35b1a98df9"
version = "0.1.0"

[[deps.RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "PrecompileTools", "RecipesBase"]
git-tree-sha1 = "45cf9fd0ca5839d06ef333c8201714e888486342"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.12"

[[deps.RecursiveArrayTools]]
deps = ["Adapt", "ArrayInterface", "DocStringExtensions", "GPUArraysCore", "IteratorInterfaceExtensions", "LinearAlgebra", "RecipesBase", "SparseArrays", "StaticArraysCore", "Statistics", "SymbolicIndexingInterface", "Tables"]
git-tree-sha1 = "d8f131090f2e44b145084928856a561c83f43b27"
uuid = "731186ca-8d62-57ce-b412-fbd966d074cd"
version = "3.13.0"

    [deps.RecursiveArrayTools.extensions]
    RecursiveArrayToolsFastBroadcastExt = "FastBroadcast"
    RecursiveArrayToolsForwardDiffExt = "ForwardDiff"
    RecursiveArrayToolsMeasurementsExt = "Measurements"
    RecursiveArrayToolsMonteCarloMeasurementsExt = "MonteCarloMeasurements"
    RecursiveArrayToolsReverseDiffExt = ["ReverseDiff", "Zygote"]
    RecursiveArrayToolsTrackerExt = "Tracker"
    RecursiveArrayToolsZygoteExt = "Zygote"

    [deps.RecursiveArrayTools.weakdeps]
    FastBroadcast = "7034ab61-46d4-4ed7-9d0f-46aef9175898"
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    Measurements = "eff96d63-e80a-5855-80a2-b1b0885c5ab7"
    MonteCarloMeasurements = "0987c9cc-fe09-11e8-30f0-b96dd679fdca"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"
    Zygote = "e88e6eb3-aa80-5325-afca-941959d7151f"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "ffdaf70d81cf6ff22c2b6e733c900c3321cab864"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.1"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "f65dcb5fa46aee0cf9ed6274ccbd597adc49aa7b"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.7.1"

[[deps.Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6ed52fdd3382cf21947b15e8870ac0ddbff736da"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.4.0+0"

[[deps.Roots]]
deps = ["Accessors", "ChainRulesCore", "CommonSolve", "Printf"]
git-tree-sha1 = "1ab580704784260ee5f45bffac810b152922747b"
uuid = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"
version = "2.1.5"

    [deps.Roots.extensions]
    RootsForwardDiffExt = "ForwardDiff"
    RootsIntervalRootFindingExt = "IntervalRootFinding"
    RootsSymPyExt = "SymPy"
    RootsSymPyPythonCallExt = "SymPyPythonCall"

    [deps.Roots.weakdeps]
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    IntervalRootFinding = "d2bf35a9-74e0-55ec-b149-d360ff49b807"
    SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"
    SymPyPythonCall = "bc8888f7-b21e-4b7c-a06a-5d9c9496438c"

[[deps.RuntimeGeneratedFunctions]]
deps = ["ExprTools", "SHA", "Serialization"]
git-tree-sha1 = "6aacc5eefe8415f47b3e34214c1d79d2674a0ba2"
uuid = "7e49a35a-f44a-4d26-94aa-eba1b4ca6b47"
version = "0.5.12"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.SciMLBase]]
deps = ["ADTypes", "ArrayInterface", "CommonSolve", "ConstructionBase", "Distributed", "DocStringExtensions", "EnumX", "FunctionWrappersWrappers", "IteratorInterfaceExtensions", "LinearAlgebra", "Logging", "Markdown", "PrecompileTools", "Preferences", "Printf", "RecipesBase", "RecursiveArrayTools", "Reexport", "RuntimeGeneratedFunctions", "SciMLOperators", "SciMLStructures", "StaticArraysCore", "Statistics", "SymbolicIndexingInterface", "Tables"]
git-tree-sha1 = "d15c65e25615272e1b1c5edb1d307484c7942824"
uuid = "0bca4576-84f4-4d90-8ffe-ffa030f20462"
version = "2.31.0"

    [deps.SciMLBase.extensions]
    SciMLBaseChainRulesCoreExt = "ChainRulesCore"
    SciMLBaseMakieExt = "Makie"
    SciMLBasePartialFunctionsExt = "PartialFunctions"
    SciMLBasePyCallExt = "PyCall"
    SciMLBasePythonCallExt = "PythonCall"
    SciMLBaseRCallExt = "RCall"
    SciMLBaseZygoteExt = "Zygote"

    [deps.SciMLBase.weakdeps]
    ChainRules = "082447d4-558c-5d27-93f4-14fc19e9eca2"
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    Makie = "ee78f7c6-11fb-53f2-987a-cfe4a2b5a57a"
    PartialFunctions = "570af359-4316-4cb7-8c74-252c00c2016b"
    PyCall = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
    PythonCall = "6099a3de-0909-46bc-b1f4-468b9a2dfc0d"
    RCall = "6f49c342-dc21-5d91-9882-a32aef131414"
    Zygote = "e88e6eb3-aa80-5325-afca-941959d7151f"

[[deps.SciMLOperators]]
deps = ["ArrayInterface", "DocStringExtensions", "LinearAlgebra", "MacroTools", "Setfield", "SparseArrays", "StaticArraysCore"]
git-tree-sha1 = "10499f619ef6e890f3f4a38914481cc868689cd5"
uuid = "c0aeaf25-5076-4817-a8d5-81caf7dfa961"
version = "0.3.8"

[[deps.SciMLStructures]]
git-tree-sha1 = "5833c10ce83d690c124beedfe5f621b50b02ba4d"
uuid = "53ae85a6-f571-4167-b2af-e1d143709226"
version = "1.1.0"

[[deps.ScientificTypesBase]]
git-tree-sha1 = "a8e18eb383b5ecf1b5e6fc237eb39255044fd92b"
uuid = "30f210dd-8aff-4c5f-94ba-8e64358c1161"
version = "3.0.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "3bac05bc7e74a75fd9cba4295cde4045d9fe2386"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.1"

[[deps.SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "0e7508ff27ba32f26cd459474ca2ede1bc10991f"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.4.1"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "StaticArraysCore"]
git-tree-sha1 = "e2cc6d8c88613c05e1defb55170bf5ff211fbeac"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "1.1.1"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.SimpleUnPack]]
git-tree-sha1 = "58e6353e72cde29b90a69527e56df1b5c3d8c437"
uuid = "ce78b400-467f-4804-87d8-8f486da07d0a"
version = "1.1.0"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "66e0a8e672a0bdfca2c3f5937efb8538b9ddc085"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.1"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.10.0"

[[deps.SparseInverseSubset]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "52962839426b75b3021296f7df242e40ecfc0852"
uuid = "dc90abb0-5640-4711-901d-7e5b23a2fada"
version = "0.1.2"

[[deps.SpecialFunctions]]
deps = ["IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "e2cfc4012a19088254b3950b85c3c1d8882d864d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.3.1"
weakdeps = ["ChainRulesCore"]

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

[[deps.SplittablesBase]]
deps = ["Setfield", "Test"]
git-tree-sha1 = "e08a62abc517eb79667d0a29dc08a3b589516bb5"
uuid = "171d559e-b47b-412a-8079-5efa626c420e"
version = "0.1.15"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "PrecompileTools", "Random", "StaticArraysCore"]
git-tree-sha1 = "bf074c045d3d5ffd956fa0a461da38a44685d6b2"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.9.3"
weakdeps = ["ChainRulesCore", "Statistics"]

    [deps.StaticArrays.extensions]
    StaticArraysChainRulesCoreExt = "ChainRulesCore"
    StaticArraysStatisticsExt = "Statistics"

[[deps.StaticArraysCore]]
git-tree-sha1 = "36b3d696ce6366023a0ea192b4cd442268995a0d"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.2"

[[deps.StatisticalTraits]]
deps = ["ScientificTypesBase"]
git-tree-sha1 = "30b9236691858e13f167ce829490a68e1a597782"
uuid = "64bff920-2084-43da-a3e6-9bb72801c0c9"
version = "3.2.0"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.10.0"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1ff449ad350c9c4cbc756624d6f8a8c3ef56d3ed"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.7.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "1d77abd07f617c4868c33d4f5b9e1dbb2643c9cf"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.2"

[[deps.StatsFuns]]
deps = ["HypergeometricFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "cef0472124fab0695b58ca35a77c6fb942fdab8a"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "1.3.1"
weakdeps = ["ChainRulesCore", "InverseFunctions"]

    [deps.StatsFuns.extensions]
    StatsFunsChainRulesCoreExt = "ChainRulesCore"
    StatsFunsInverseFunctionsExt = "InverseFunctions"

[[deps.StatsPlots]]
deps = ["AbstractFFTs", "Clustering", "DataStructures", "Distributions", "Interpolations", "KernelDensity", "LinearAlgebra", "MultivariateStats", "NaNMath", "Observables", "Plots", "RecipesBase", "RecipesPipeline", "Reexport", "StatsBase", "TableOperations", "Tables", "Widgets"]
git-tree-sha1 = "3b1dcbf62e469a67f6733ae493401e53d92ff543"
uuid = "f3b207a7-027a-5e70-b257-86293d7955fd"
version = "0.15.7"

[[deps.StringManipulation]]
deps = ["PrecompileTools"]
git-tree-sha1 = "a04cabe79c5f01f4d723cc6704070ada0b9d46d5"
uuid = "892a3eda-7b42-436c-8928-eab12a02cf0e"
version = "0.3.4"

[[deps.StructArrays]]
deps = ["ConstructionBase", "DataAPI", "Tables"]
git-tree-sha1 = "f4dc295e983502292c4c3f951dbb4e985e35b3be"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.18"
weakdeps = ["Adapt", "GPUArraysCore", "SparseArrays", "StaticArrays"]

    [deps.StructArrays.extensions]
    StructArraysAdaptExt = "Adapt"
    StructArraysGPUArraysCoreExt = "GPUArraysCore"
    StructArraysSparseArraysExt = "SparseArrays"
    StructArraysStaticArraysExt = "StaticArrays"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.2.1+1"

[[deps.SymbolicIndexingInterface]]
deps = ["ArrayInterface", "MacroTools", "RuntimeGeneratedFunctions", "StaticArraysCore"]
git-tree-sha1 = "dd94edee1542e9da422cb2f12494ef09ea823e48"
uuid = "2efcf032-c050-4f8e-a9bb-153293bab1f5"
version = "0.3.13"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.TableOperations]]
deps = ["SentinelArrays", "Tables", "Test"]
git-tree-sha1 = "e383c87cf2a1dc41fa30c093b2a19877c83e1bc1"
uuid = "ab02a1b2-a7df-11e8-156e-fb1833f50b87"
version = "1.2.0"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits"]
git-tree-sha1 = "cb76cf677714c095e535e3501ac7954732aeea2d"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.11.1"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.TerminalLoggers]]
deps = ["LeftChildRightSiblingTrees", "Logging", "Markdown", "Printf", "ProgressLogging", "UUIDs"]
git-tree-sha1 = "f133fab380933d042f6796eda4e130272ba520ca"
uuid = "5d786b92-1e48-4d6f-9151-6b4477ca9bed"
version = "0.1.7"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tracker]]
deps = ["Adapt", "DiffRules", "ForwardDiff", "Functors", "LinearAlgebra", "LogExpFunctions", "MacroTools", "NNlib", "NaNMath", "Optimisers", "Printf", "Random", "Requires", "SpecialFunctions", "Statistics"]
git-tree-sha1 = "685387ff526b7f4bafc5fe093949315d2680ce25"
uuid = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"
version = "0.2.33"
weakdeps = ["PDMats"]

    [deps.Tracker.extensions]
    TrackerPDMatsExt = "PDMats"

[[deps.TranscodingStreams]]
git-tree-sha1 = "14389d51751169994b2e1317d5c72f7dc4f21045"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.10.6"
weakdeps = ["Random", "Test"]

    [deps.TranscodingStreams.extensions]
    TestExt = ["Test", "Random"]

[[deps.Transducers]]
deps = ["Adapt", "ArgCheck", "BangBang", "Baselet", "CompositionsBase", "ConstructionBase", "DefineSingletons", "Distributed", "InitialValues", "Logging", "Markdown", "MicroCollections", "Requires", "Setfield", "SplittablesBase", "Tables"]
git-tree-sha1 = "3064e780dbb8a9296ebb3af8f440f787bb5332af"
uuid = "28d57a85-8fef-5791-bfe6-a80928e7c999"
version = "0.4.80"

    [deps.Transducers.extensions]
    TransducersBlockArraysExt = "BlockArrays"
    TransducersDataFramesExt = "DataFrames"
    TransducersLazyArraysExt = "LazyArrays"
    TransducersOnlineStatsBaseExt = "OnlineStatsBase"
    TransducersReferenceablesExt = "Referenceables"

    [deps.Transducers.weakdeps]
    BlockArrays = "8e7c35d0-a365-5155-bbbb-fb81a777f24e"
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    LazyArrays = "5078a376-72f3-5289-bfd5-ec5146d43c02"
    OnlineStatsBase = "925886fa-5bf2-5e8e-b522-a9147a512338"
    Referenceables = "42d2dcc6-99eb-4e98-b66c-637b7d73030e"

[[deps.Tricks]]
git-tree-sha1 = "eae1bb484cd63b36999ee58be2de6c178105112f"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.8"

[[deps.Turing]]
deps = ["ADTypes", "AbstractMCMC", "AdvancedHMC", "AdvancedMH", "AdvancedPS", "AdvancedVI", "BangBang", "Bijectors", "DataStructures", "Distributions", "DistributionsAD", "DocStringExtensions", "DynamicPPL", "EllipticalSliceSampling", "ForwardDiff", "Libtask", "LinearAlgebra", "LogDensityProblems", "LogDensityProblemsAD", "MCMCChains", "NamedArrays", "Printf", "Random", "Reexport", "Requires", "SciMLBase", "Setfield", "SpecialFunctions", "Statistics", "StatsAPI", "StatsBase", "StatsFuns"]
git-tree-sha1 = "0e61d150c55162770c9dd904aa24a271921689e7"
uuid = "fce5fe82-541a-59a6-adf8-730c64b5f9a0"
version = "0.30.7"

    [deps.Turing.extensions]
    TuringDynamicHMCExt = "DynamicHMC"
    TuringOptimExt = "Optim"

    [deps.Turing.weakdeps]
    DynamicHMC = "bbc10e6e-7c05-544b-b16e-64fede858acb"
    Optim = "429524aa-4258-5aef-a3af-852621145aeb"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unitful]]
deps = ["Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "3c793be6df9dd77a0cf49d80984ef9ff996948fa"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.19.0"
weakdeps = ["ConstructionBase", "InverseFunctions"]

    [deps.Unitful.extensions]
    ConstructionBaseUnitfulExt = "ConstructionBase"
    InverseFunctionsUnitfulExt = "InverseFunctions"

[[deps.UnitfulLatexify]]
deps = ["LaTeXStrings", "Latexify", "Unitful"]
git-tree-sha1 = "e2d817cc500e960fdbafcf988ac8436ba3208bfd"
uuid = "45397f5d-5981-4c77-b2b3-fc36d6e9b728"
version = "1.6.3"

[[deps.UnsafeAtomics]]
git-tree-sha1 = "6331ac3440856ea1988316b46045303bef658278"
uuid = "013be700-e6cd-48c3-b4a1-df204f14c38f"
version = "0.2.1"

[[deps.UnsafeAtomicsLLVM]]
deps = ["LLVM", "UnsafeAtomics"]
git-tree-sha1 = "323e3d0acf5e78a56dfae7bd8928c989b4f3083e"
uuid = "d80eeb9a-aca5-4d75-85e5-170c8b632249"
version = "0.1.3"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.Vulkan_Loader_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Wayland_jll", "Xorg_libX11_jll", "Xorg_libXrandr_jll", "xkbcommon_jll"]
git-tree-sha1 = "2f0486047a07670caad3a81a075d2e518acc5c59"
uuid = "a44049a8-05dd-5a78-86c9-5fde0876e88c"
version = "1.3.243+0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "EpollShim_jll", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "7558e29847e99bc3f04d6569e82d0f5c54460703"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.21.0+1"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "93f43ab61b16ddfb2fd3bb13b3ce241cafb0e6c9"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.31.0+0"

[[deps.Widgets]]
deps = ["Colors", "Dates", "Observables", "OrderedCollections"]
git-tree-sha1 = "fcdae142c1cfc7d89de2d11e08721d0f2f86c98a"
uuid = "cc8bc4a8-27d6-5769-a93b-9d913e69aa62"
version = "0.6.6"

[[deps.WoodburyMatrices]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "c1a7aa6219628fcd757dede0ca95e245c5cd9511"
uuid = "efce3f68-66dc-5838-9240-27a6d6f5f9b6"
version = "1.0.0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Zlib_jll"]
git-tree-sha1 = "07e470dabc5a6a4254ffebc29a1b3fc01464e105"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.12.5+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.XZ_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "31c421e5516a6248dfb22c194519e37effbf1f30"
uuid = "ffd25f8a-64ca-5728-b0f7-c24cf3aae800"
version = "5.6.1+0"

[[deps.Xorg_libICE_jll]]
deps = ["Libdl", "Pkg"]
git-tree-sha1 = "e5becd4411063bdcac16be8b66fc2f9f6f1e8fe5"
uuid = "f67eecfb-183a-506d-b269-f58e52b52d7c"
version = "1.0.10+1"

[[deps.Xorg_libSM_jll]]
deps = ["Libdl", "Pkg", "Xorg_libICE_jll"]
git-tree-sha1 = "4a9d9e4c180e1e8119b5ffc224a7b59d3a7f7e18"
uuid = "c834827a-8449-5923-a945-d239c165b7dd"
version = "1.2.3+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "afead5aba5aa507ad5a3bf01f58f82c8d1403495"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.8.6+0"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6035850dcc70518ca32f012e46015b9beeda49d8"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.11+0"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "34d526d318358a859d7de23da945578e8e8727b7"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.4+0"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8fdda4c692503d44d04a0603d9ac0982054635f9"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.1+0"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "b4bfde5d5b652e22b9c790ad00af08b6d042b97d"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.15.0+0"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "730eeca102434283c50ccf7d1ecdadf521a765a4"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.2+0"

[[deps.Xorg_xcb_util_cursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_jll", "Xorg_xcb_util_renderutil_jll"]
git-tree-sha1 = "04341cb870f29dcd5e39055f895c39d016e18ccd"
uuid = "e920d4aa-a673-5f3a-b3d7-f755a4d47c43"
version = "0.1.4+0"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "330f955bc41bb8f5270a369c473fc4a5a4e4d3cb"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.6+0"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "691634e5453ad362044e2ad653e79f3ee3bb98c3"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.39.0+0"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e92a1a012a10506618f10b7047e478403a046c77"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.5.0+0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "49ce682769cd5de6c72dcf1b94ed7790cd08974c"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.5+0"

[[deps.ZygoteRules]]
deps = ["ChainRulesCore", "MacroTools"]
git-tree-sha1 = "27798139afc0a2afa7b1824c206d5e87ea587a00"
uuid = "700de1a5-db45-46bc-99cf-38207098b444"
version = "0.2.5"

[[deps.eudev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "gperf_jll"]
git-tree-sha1 = "431b678a28ebb559d224c0b6b6d01afce87c51ba"
uuid = "35ca27e7-8b34-5b7f-bca9-bdc33f59eb06"
version = "3.2.9+0"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a68c9655fbe6dfcab3d972808f1aafec151ce3f8"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.43.0+0"

[[deps.gperf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3516a5630f741c9eecb3720b1ec9d8edc3ecc033"
uuid = "1a1c6b14-54f6-533d-8383-74cd7377aa70"
version = "3.1.1+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a2ea60308f0996d26f1e5354e10c24e9ef905d4"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.4.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+1"

[[deps.libevdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "141fe65dc3efabb0b1d5ba74e91f6ad26f84cc22"
uuid = "2db6ffa8-e38f-5e21-84af-90c45d0032cc"
version = "1.11.0+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libinput_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "eudev_jll", "libevdev_jll", "mtdev_jll"]
git-tree-sha1 = "ad50e5b90f222cfe78aa3d5183a20a12de1322ce"
uuid = "36db933b-70db-51c0-b978-0f229ee0e533"
version = "1.18.0+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "d7015d2e18a5fd9a4f47de711837e980519781a4"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.43+1"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.mtdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "814e154bdb7be91d78b6802843f76b6ece642f11"
uuid = "009596ad-96f7-51b1-9f1b-5ce2d5e8a71e"
version = "1.1.6+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "9c304562909ab2bab0262639bd4f444d7bc2be37"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+1"
"""

# ╔═╡ Cell order:
# ╟─c1836feb-ce9d-4e26-aa25-7e28dd55506e
# ╠═36c62876-1ab7-438b-8d5e-16ee391a11eb
# ╠═ff1dc8d2-ecbc-11ee-022e-653b5473f25a
# ╠═5c25b00d-5c84-498d-b439-de3a59198ef2
# ╠═49d67176-6130-4bc0-bd99-2f5a43e20b5d
# ╠═ea83b213-db5e-4a18-a274-51aeb86c14a8
# ╠═660853b1-0c41-466d-aa5d-49422ff076a8
# ╟─5964c6e8-ad85-4f20-8eee-85b1b6673546
# ╟─132e9d0f-06fb-4b23-bdc3-3577c90dabbc
# ╟─e027a63d-c856-4299-b1ca-4124864884de
# ╠═ed092bf4-4b9a-4e1d-b65d-f1d245eb7f3f
# ╟─3109f2ae-54ad-45b7-b260-3ffcc025bdaf
# ╠═e9e7cf2b-a241-44a7-916d-1b5929edcb2e
# ╠═79851d71-69e1-4e57-9e2c-fb646a026f80
# ╟─b11ee357-4212-4b54-8d2b-74eb48c967a7
# ╟─054d552e-7a21-4f1f-b0c4-322bf3c12cdb
# ╟─42ed313f-2919-4463-8c76-1a15363ebd60
# ╠═6bfce2a4-838e-47eb-86a9-35559594ea90
# ╠═0bcb19ff-193b-49d1-a7f2-1225288ee7ec
# ╠═c343aeb9-4fad-46ec-8df5-ad47ea3737fc
# ╠═70fcc963-418a-4899-a91c-495ff27a7c27
# ╟─a8961089-08a8-4d27-b1b2-117811ea7731
# ╠═3d962581-bbab-490c-9b39-088b0608070f
# ╠═4ca651ec-4586-49f2-a834-c6b0eb40ecbf
# ╠═81f972c6-ce66-4ab5-915a-4b1c6501f672
# ╟─7479b86b-bdad-45ea-a593-417a59cbb834
# ╠═92251c31-7c79-4916-a192-1400f5225ea3
# ╟─08163980-3f63-4c40-8bc8-677b00f66010
# ╠═89f3522f-7b26-4880-9645-d3ad66f4838b
# ╠═96c363fd-7b02-4f56-b80b-64ae4eba2b7d
# ╟─bcf0fb30-a7c1-42b4-a600-1d22d1337bd2
# ╟─445f820a-d728-40d9-8931-c57d68e73465
# ╠═a08f37fe-8b91-473c-86e6-5f6bc3dc2654
# ╠═8c594c78-3936-421f-9c2a-3d5cf7360459
# ╟─f21edd05-313d-4b86-8d32-efeec20563e7
# ╠═057bff58-80b8-47d0-be1c-d8f29ae5af61
# ╠═eaed7dc5-0030-440b-966f-8c54b4b5b880
# ╠═31c0b694-d44d-4671-b599-9dc8c10c22b3
# ╠═0b0bd243-a01b-41e0-b463-ad88ccbd6d32
# ╠═1fd59165-56b9-4359-b1be-b310c07ec37d
# ╟─773aeb7c-7384-48a5-9f15-8ceb886e68de
# ╠═8eeeb415-843d-4e02-a0d2-ed8c2e68f83b
# ╠═08c4eca9-5486-4375-b9f7-68b5d38a40d2
# ╠═d765047a-4d2a-494d-82c3-5f226b91ca40
# ╟─89043a50-6e28-4a86-ae96-95723ca8a86f
# ╠═7323e6f8-963c-4758-b94f-2e44859f6db4
# ╠═912b142f-d5e8-454c-a920-36957188f045
# ╠═8ac0c6dc-a58e-40da-bd53-00dfa00e56bf
# ╠═2d4030bc-edeb-4604-bd97-a1f1e8dcbaf8
# ╠═83a126e4-ad88-4bf3-acaf-2e61aa3b2e4f
# ╠═9fb6cdfc-42af-4c9a-834d-cf6ab843dd6d
# ╠═2e892a96-6791-406c-a2b2-c463a9d7bf5f
# ╠═05862f61-8ba2-4f37-bcd7-968f8c7356c6
# ╟─f5c08e91-c9ec-4bad-8503-46d8585672fa
# ╠═9f398fd0-0ff4-4cce-bbca-a6ce9457d241
# ╠═1822008e-27a8-4806-aa16-d324fd189d96
# ╠═2a047555-c821-4e81-a795-12d295cc383f
# ╟─cd430d83-7b9a-4b69-90e6-87292df06e20
# ╠═cca5db8c-d7f9-4087-9fb3-c304b34c3095
# ╠═2a57727a-8289-4555-969c-16e84d1b34aa
# ╟─c586376a-67f3-4576-88bc-b40d78562435
# ╠═dafdd5da-7d0d-492a-ade5-a9e50abfedf2
# ╠═bbbd86fe-376d-470c-943f-d2ca8d38b08a
# ╟─e81f7ba7-3596-4960-9368-5836929c8ce0
# ╠═c1ca8939-99e0-4cb4-ac8f-94a6f28c529e
# ╠═0f4bfb27-0483-45ca-b8bb-d21fa5231c9c
# ╠═6b77e7f2-d1d9-4b63-9705-507122fd5fe3
# ╟─67bd9e57-e37c-4407-9ee3-0e22deeb25b0
# ╠═44fcbd22-cc6f-4c09-b749-406cff1aeced
# ╟─1a090beb-8c1b-4a0d-aad3-d85a846ae323
# ╠═51d7a213-2ba0-4d09-8ee2-0e91002ea915
# ╠═27458d34-0b45-4463-bdde-19f07fd7d7c7
# ╠═298edd25-30eb-47ab-b8a6-26064168e76d
# ╠═439a26f2-be2f-43f2-a947-5f1e00e43d27
# ╠═8b71b6d6-ab79-4a02-af29-3a7d2a963f51
# ╠═03b37ea3-24f5-442b-b9ec-cc7178def82b
# ╠═778927a5-e149-4512-9475-895d45e4095b
# ╠═14fd3f37-cf8b-4867-903f-36aa505b7683
# ╠═706bb0da-9dff-47c8-bd42-6096fa7e0025
# ╠═5e68050f-758f-4380-9fbe-f4cae31e0754
# ╟─8f428c07-e87e-4642-be5e-2347a25a86f4
# ╠═c4065dfe-55c5-42a0-88bc-9231125757b9
# ╠═b6cf9057-1f2a-42cc-9233-6692806ee419
# ╠═af8227a8-3249-43dd-8bc6-0f08a05e81ef
# ╠═4756ab6b-fc05-40ca-9759-c6f1d0b78ff7
# ╟─9975d122-59e6-4513-ad82-7f5a7c37bbe4
# ╠═d72cab2e-7c27-471e-af55-2c575230ca93
# ╠═0813082a-36b3-4d9f-867a-5324281f244b
# ╠═0d525767-52eb-490c-b628-1a7db9ecea21
# ╠═cff0108b-b745-4f2e-9f27-48e3624bbf0e
# ╠═8849387c-f4b0-47f3-9061-e286e23edbde
# ╠═c5c9bdaa-6e3b-46d9-b537-791a7c1739bf
# ╠═28cbcd7a-bfb3-4f59-86fc-d5e84829da01
# ╠═65f761e5-5b59-4d87-89ae-a763591e63d9
# ╠═4ef1c808-bc54-459e-a0c4-4928714eaa0b
# ╟─a8393424-e097-4dd5-be88-24886798ffb0
# ╠═7c0c50dc-e376-4365-b2ec-eeb7f26722fd
# ╠═48477352-5850-4291-8b99-e4a688811246
# ╠═41a0c3b8-8975-4d69-88cf-6d076f5ad5f2
# ╟─baf60493-ff2f-4e17-8314-7c7ebdfaf536
# ╠═df4c8aa3-9961-44ca-b24f-0bf3f7e26d39
# ╠═f3027ecf-4b95-4a76-b5cf-b572ca3eb050
# ╠═245f4489-1320-4502-a956-5f922e4fcf8e
# ╠═b551b54c-ab60-473a-89df-c7e9388cecd0
# ╠═f6870036-a104-41a0-8b4f-a23d38b119d4
# ╠═ac4a1de3-8ac4-4acb-9a0e-d7f517253e50
# ╠═d832417b-151f-4a0f-8084-6c9007c8614a
# ╠═f875202b-5c14-4800-8624-af904d1b19a3
# ╟─a1198545-4cc6-420e-bc85-ddde4ba8ab3c
# ╟─8d269347-42a0-4ce6-8b07-1d065780eda1
# ╠═3c6f3a86-84c2-4ef8-b520-a5804d053d86
# ╠═c37b709c-bcf5-4229-a421-5b40cbda24f8
# ╠═dd7592d0-0031-4978-8392-80d31d672f21
# ╠═4d22ab2c-88af-4349-8a10-fd48e83c835d
# ╠═fc893fa0-77f0-44fb-8071-b5b3c5d64697
# ╟─cc9b2c50-e5d0-4764-8089-95804c5a1dc7
# ╠═4a05157d-1792-4f01-8b80-0639aac47998
# ╠═b1011fa7-ea8a-4c0c-935e-2a57056612b1
# ╠═c58b1888-a957-4e49-8486-e0f46346d03a
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
