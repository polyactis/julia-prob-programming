### A Pluto.jl notebook ###
# v0.19.40

using Markdown
using InteractiveUtils

# ╔═╡ f60605ab-b182-4212-bd65-4f9e1ba67f2c
begin
        using Markdown
        using InteractiveUtils
        using Pkg, DrWatson, PlutoUI
end

# ╔═╡ b1e7d68a-ce33-4c36-84b8-bb36d6426da1
using Plots # load the Plots package

# ╔═╡ 349534f6-1449-4e09-adb0-b210c384dda4
using PyPlot # The PyPlot imitates Python's matplotlib package

# ╔═╡ 98953899-4029-4220-a113-aba2385c9c47
begin
	using Distributions
	pathof(Distributions)
end

# ╔═╡ 4f903e4c-aa4b-47d6-b975-eb3acaad6be8
begin
	using RCall
	
	x = randn(1000)
	R"""
	hist($x, main="I'm plotting a Julia vector")
	"""
end

# ╔═╡ d7c485db-14da-4c29-ab0f-6ddd030da9b8
using SparseArrays

# ╔═╡ 41647387-7b4c-4d5d-b815-51a777b8e637
# try AVX
using LoopVectorization

# ╔═╡ e282c856-b3f5-4d8c-94cc-9d57b1c34165
@time using DataFrames, CSV

# ╔═╡ 5776d5e9-95a3-4cf1-b9c0-1b3c4c51c91b
html"""<style>
main {
        margin: 0 auto;
    max-width: 90%;
        padding-left: max(50px, 1%);
    padding-right: max(253px, 10%);
        # 253px to accomodate TableOfContents(aside=true)
}
"""


# ╔═╡ 4a7545ec-21aa-4eb1-9a6a-a4cacbca4c5f
PlutoUI.TableOfContents()

# ╔═╡ 78742224-eb68-4f3a-a848-2f4bf30dbc05
versioninfo()

# ╔═╡ cab57f22-b2e5-4e2b-bac9-1b08d91b3a12
let
	x = nothing
	for i=1:5
		y=cumsum(randn(500))
		x = Plots.plot!(y)
	end
	x
end

# ╔═╡ 55ee298b-ca9e-46fb-a352-073dbb6109f0
let
	x = nothing
	for i=1:5
	#map(1:5) do i
		y2=cumsum(randn(500))
    	x=PyPlot.plot(y2)
	end
	x
end

# ╔═╡ 73d63463-abb6-4b7c-b27a-221125c87222
md"# 0  Julia REPL (Read-Evaluation-Print-Loop)

The Julia REPL, or Julia shell, has at least five modes.

    Default mode is the Julian prompt julia>. Type backspace in other modes to enter default mode.

    Help mode help?>. Type ? to enter help mode. ?search_term does a fuzzy search for search_term.

    Shell mode shell>. Type ; to enter shell mode.

    Package mode (@v1.4) pkg>. Type ] to enter package mode for managing Julia packages (install, uninstall, update, ...).

    Search mode (reverse-i-search). Press ctrl+R to enter search model.

    With RCall.jl package installed, we can enter the R mode by typing $ (shift+4) at Julia REPL.

Some survival commands in Julia REPL:

    exit() or Ctrl+D: exit Julia.

    Ctrl+C: interrupt execution.

    Ctrl+L: clear screen.

    Append ; (semi-colon) to suppress displaying output from a command. Same as Matlab.

    include(`filename.jl`) to source a Julia code file.
"

# ╔═╡ 0a174786-ee9f-48f5-8b72-f9e840c9ff7e
readdir(Sys.islinux() ? ENV["HOME"] * "/.julia/packages" : ENV["JULIA_PATH"] * "/pkg/packages")

# ╔═╡ ca6e6f4c-d911-4841-97ed-528fbd61f4d2
md"## 0.1 parentmodule, names, methodswith, varinfo"

# ╔═╡ 99d2c8f1-fb4f-4b55-a80a-845d5ef840d0
names(Distributions)

# ╔═╡ 0e050586-c204-4056-86d9-020e825d1e72
:std in names(Distributions)

# ╔═╡ e61a730b-6086-451a-93fe-06b9604c2136
parentmodule(Distributions.std)

# ╔═╡ 4b32e66f-cb5e-4e27-9bca-101be60d7bf7
parentmodule(std)

# ╔═╡ e34612a8-11de-4b19-8d99-a8742d9b0ae6
parentmodule(Beta)

# ╔═╡ e46de96b-f9dd-4750-a0a5-36585fdb07d1
# show private properties as well. But Beta does not seem to have private properties.
propertynames(Beta, true)

# ╔═╡ 73820768-d442-4ad7-880f-00a2cf74a283
fieldnames(Beta)

# ╔═╡ 8e6ba332-a4f2-4073-987f-f4343d61e6e8
methodswith(Beta)

# ╔═╡ 2c7dfca1-e30f-47e9-9a5e-91b37ab6677a
varinfo()

# ╔═╡ 2b989517-20b2-4076-93c2-ce85965e9caf
varinfo(Distributions)

# ╔═╡ f599cfd1-cc84-41af-b4bc-a2f7e7a248d9
varinfo(Core, r".*field.*")

# ╔═╡ 7667bf41-a157-4c55-91f9-53532b729910
md"
* Periodically, one should run update in Pkg mode or Pkg.update(), which checks for, downloads and installs updated versions of all the packages you currently have installed.

* status in Pkg mode (or Pkg.status() ) lists the status of all installed packages.

```julia
(@v1.5) pkg> status
Status `~/.julia/environments/v1.5/Project.toml`
  [6e4b80f9] BenchmarkTools v0.5.0
  [31c24e10] Distributions v0.23.12
  [c91e804a] Gadfly v1.3.1
  [7073ff75] IJulia v1.22.0
  [438e738f] PyCall v1.92.1
  [d330b81b] PyPlot v2.9.0
  [6f49c342] RCall v0.13.9
```

* If you start having problems with packages that seem to be unsolvable, you may try just deleting your .julia directory and reinstalling all your packages."

# ╔═╡ ed86b679-a968-4169-90d8-812860473493
Pkg.status()

# ╔═╡ 0243c332-6961-4f18-b29c-838dd0ca3f9e
Pkg.precompile()

# ╔═╡ 4703589a-d291-406c-a263-ed2cdd92a2b9
md"- If a package reports error upon first `using`, try Pkg.precompile() to fix it.

- If Pkg.precompile() can't fix it, run Pkg.build(...) to re-build that package ( Pkg.build() to re-build all packages) from its source code."

# ╔═╡ af9f519c-88a0-4191-9a37-f4b89936995b
Pkg.build("Distributions")

# ╔═╡ 1b5270f5-62ab-4d88-bb1d-9a96bcddf7c8
Pkg.build()

# ╔═╡ bd3f8a44-bd6b-4f01-a488-6d674e73e9f6
md"## 0.2 Find all dependencies of a package"

# ╔═╡ b716fd3f-6a7e-4c0c-a36b-dad9c445bb27
function pkgdeps(pkg::AbstractString)
    uuid = Pkg.project().dependencies[pkg]
    pkginfo = Pkg.dependencies()[uuid]
    return pkginfo.dependencies
end

# ╔═╡ f207f2f0-bf29-479b-831c-b7c4fad726d4
pkgdeps("Distributions")

# ╔═╡ e2cdb32d-82ef-4d1c-b8a4-110232a90323
md"# 1 Calling R from Julia

* The RCall.jl package allows us to embed R code inside of Julia.
* There are also PyCall.jl, MATLAB.jl, JavaCall.jl, CxxWrap.jl packages for interfacing with other languages.
"

# ╔═╡ a3e853d4-7a27-46fa-94a9-32988bf870e0
R"""
library(ggplot2)
qplot($x)
"""

# ╔═╡ 5532c10d-e8f3-4012-9c40-183c461c2b77
x_tmp1 = R"""
rnorm(10)
"""

# ╔═╡ d024b5b2-4ba2-4c47-a0ba-f73c63990bc8
# collect R variable into Julia workspace
y = collect(x_tmp1)

# ╔═╡ 212eef0d-a257-4056-a0f0-16531ca702b5
Base.summarysize(y)

# ╔═╡ 0affeb8e-a2a4-44bf-b2c9-df6b0eeec07e
varinfo(Base, r".*summary.*")

# ╔═╡ f98281a1-16d0-4a2f-b598-af8445ad28d0
md"## 1.1 Access Julia variables in R REPL mode:

```bash
julia> x = rand(5) # Julia variable
R> y <- $x
```

Pass Julia expression in R REPL mode:

```R
R> y <- $(rand(5))
```

Put Julia variable into R environment:
```
julia> @rput x
R> x
```

Get R variable into Julia environment:

```R
R> r <- 2
Julia> @rget r
```

If you want to call Julia within R, check out the XRJulia package by John Chambers.
"

# ╔═╡ ac0160b2-30fc-4f05-90f9-02efd91f8c6e
md"# 2 Basics: irrational numbers, greeks, matrices, Definitions"

# ╔═╡ 6aa9b25e-cf95-4b86-ad7c-730131e61a57
begin
	# an integer, same as int in R
	y1 = 1
	typeof(y1)
end

# ╔═╡ bc4f6f45-7c5d-4f92-9665-3b50fb5ed857
Base.summarysize(y1)

# ╔═╡ 9558054f-de63-4d87-985d-953965eb36c3
let
	# a Float64 number, same as double in R
	y = 1.0
	typeof(y)
end

# ╔═╡ 70fd675e-e74f-4578-a7aa-2b6dcde4e455
π

# ╔═╡ 03fd9279-cd4f-405a-952d-88dbf7e756a4
typeof(π)

# ╔═╡ 8bcafee0-508a-44e7-a5b8-ce2a4307f724
# Greek letters:  `\theta<tab>`
θ = y1 + π

# ╔═╡ 259d6216-7a2b-4e26-91c4-c10299b4cc00
# emoji! `\:kissing_cat:<tab>`
😽 = 5.0

# ╔═╡ 33655512-9341-424e-90dc-d73d3f49c6f8
let
	# `\alpha<tab>\hat<tab>`
	α̂ = π
	α̂
end

# ╔═╡ a3264c09-a4c1-40b6-a20e-d9dc7523b21d
# rational number
a = 3//7

# ╔═╡ 4a62f652-c28a-4613-9a20-36b04502c85e
typeof(a)

# ╔═╡ d4373aa6-1c92-4d0c-bfed-1cbcc40be2b9
b = 3//11

# ╔═╡ 2c7e73b7-1f8f-4377-a216-f55997ccab55
a + b

# ╔═╡ bad3f7db-fa79-4a9a-9581-ca8172ed09d9
md"## 2.1 vectors, arrays, matricies"

# ╔═╡ 2a1614c8-61b9-496f-a1f9-309239607fb6
let
	# vector of Float64 0s
	x = zeros(5)
end

# ╔═╡ 8eaf8a0f-27c1-48d4-89c2-07f5dc0c4e6a
let
	# vector Int64 0s
	x = zeros(Int, 5)
end

# ╔═╡ 72adabc4-c663-4e40-898e-d19949802450
let
	@show x = ones(5)
end

# ╔═╡ c2e972a3-6be7-4f97-8f31-fd7364b7fde1
let
	# matrix of Float64 0s
	@show x = zeros(5, 3)
	@show x = zeros(Int32, 5, 3)
end

# ╔═╡ 86854214-b765-4a1f-9616-2c50f767c863
let
	# matrix of Float64 1s
	x = ones(5, 3)
end

# ╔═╡ dfccc449-ef43-4381-af16-191cdaed79fc
let
	# define array without initialization
	x = Matrix{Float64}(undef, 5, 3)
end

# ╔═╡ a86c5507-cfd4-4b22-bed2-023e971cb32c
let
	# fill a matrix by 0s
	x = Matrix{Float64}(undef, 5, 3)
	fill!(x, 0)
end

# ╔═╡ b5c0e94a-7e2d-41d9-b9cf-4420a0aaa84c
# initialize an array to be constant 2.5
fill(2.5, (5, 3))

# ╔═╡ 5156e29d-fb6c-4019-8c93-c526fb2f3a78
let
	# uniform [0, 1) random numbers
	x = rand(5, 3)
end

# ╔═╡ a921af57-37ad-4d5e-8b7e-df75c9f20c9c
let
	# uniform random numbers (in single precision)
	x = rand(Float16, 5, 3)
end

# ╔═╡ d274e56f-80e7-4b50-82d8-1daa9e7819d3
let
	# random numbers from {1,...,5}
	x = rand(1:5, 5, 3)
end

# ╔═╡ 1f10e782-97c5-459c-a456-bc991c726960
let
	# standard normal random numbers
	x = randn(5, 3)
end

# ╔═╡ 5d7529fe-c751-46a4-bb68-db856ef8682e
md"## 2.2 Range, collect, convert"

# ╔═╡ a05995ba-e882-40fc-8597-f7962c3a728b
# range
1:10

# ╔═╡ 25ae1391-0f74-4248-8683-6c7294172ced
typeof(1:10)

# ╔═╡ 033647d7-c3a6-4ea4-93d8-6017e006f97b
let
	@show x=1:2:10
@show length(x)
@show typeof(x)
end

# ╔═╡ c65f388e-aa0a-442e-8815-b7a7b8514f36
let
	# integers 1-10
@show x = collect(1:10)
@show typeof(x)
end

# ╔═╡ 03842bb7-bcb7-421e-b363-eb4bce7e32fd
let
	# or equivalently
@show y=[1:10...]
@show typeof(y)
end

# ╔═╡ cb9e9023-2438-4ad8-9268-cb77ca72cdcb
let
	# integers 1-10
	x = collect(1:2:10)
end

# ╔═╡ ebb04d62-79d9-47a6-9095-4a7f6aae10ef
let
	# Float64 numbers 1-10
	x = collect(1.0:10)
end

# ╔═╡ 9974acba-0e3a-4697-9fa9-ffc2a10a5729
md"# 3  Matrices and vectors operations

## 3.1  Dimensions"

# ╔═╡ 279ad791-4d32-487d-936b-9b2c4e2a75e1
let
	x = randn(5, 3)
	@show size(x)
	@show size(x, 1) # nrow() in R
	@show size(x, 2) # ncol() in R
	# total number of elements
	@show length(x)
	x
end

# ╔═╡ ecd80612-292d-45af-8724-bcee7abfce27
md"## 3.2  Indexing"

# ╔═╡ 1edb3564-39e2-41ec-adde-360d24b05dbe
begin
	# 5 × 5 matrix of random Normal(0, 1)
	x3 = randn(5, 5)
	# first column
	@show x3[:, 1]
	# first row
	@show x3[1, :]
	# sub-array
	@show x3[1:2, 2:3]
	x3
end

# ╔═╡ 9123e911-716a-4e29-8d14-a0cd3296a159
# getting a subset of a matrix creates a copy, but you can also create "views"
view(x3, 1:2, 2:3)

# ╔═╡ 751b11cc-7171-410a-a285-5ea85d53ac00
# same as
@views z=x3[1:2, 2:3]

# ╔═╡ 015fbf1c-2398-4820-b638-fdc87ca70b65
begin
	# change in z (view) changes x as well
	z[2, 2] = 0.0
	x3
end

# ╔═╡ 83f8ac52-675e-45e0-b0ff-9adaa6b43b63
# y points to same data as x
y3 = x3

# ╔═╡ 4ab6ff13-cbbd-4b58-bd6e-f39c89caea61
# x and y point to same data
pointer(x3), pointer(y3)

# ╔═╡ 54cf1a59-7467-42ad-9c4f-112688ca4cf0
begin
	# changing y also changes x
	y3[:, 1] .= 0
	x3
end

# ╔═╡ b3930380-ae2e-43e7-8439-5d2bebf391b9
# create a new copy of data
z3 = copy(x3)

# ╔═╡ ac808c3b-8e72-4d3f-bd49-fe15ac7265fb
pointer(x3), pointer(z3)

# ╔═╡ 460c86af-5ef8-441f-ac32-c9c2e379b57c
parentmodule(pointer), parentmodule(copy)

# ╔═╡ 7e855b33-d0b0-48ef-a107-b7a4e5dd0fe9
md"## 3.3  Concatenate matrices"

# ╔═╡ cf3b65fd-bf41-45a7-a5dd-82908d7d2f37
# 3-by-1 vector
[1, 2, 3]

# ╔═╡ 54ebd4bf-dfe0-46bf-9e87-34d89df8145c
# 1-by-3 array
[1 2 3]

# ╔═╡ 5e8413b0-20e0-4a31-8aa0-e1d915b05fd9
begin
	# multiple assignment by tuple
	x4, y4, z4 = randn(5, 3), randn(5, 2), randn(3, 5)
end

# ╔═╡ 1a393b2b-ed29-48dd-91a5-b8e85533de28
# 5-by-5 matrix
[x4 y4]

# ╔═╡ 8eab5808-2abd-462e-8d07-f5e0f6f71dd9
 # 8-by-5 matrix
 [x4 y4; z4]

# ╔═╡ 38604bd5-7a31-492e-8082-83c5ac6d34d6
md"## 3.4  Dot operation
Dot operation in Julia is elementwise operation, similar to Matlab."

# ╔═╡ ea365523-21bf-4cad-bc61-79241cbe29f3
x4

# ╔═╡ 33180cc7-65d0-4f9e-a0db-bd3a804ef7a4
# ╠═╡ disabled = true
#=╠═╡
y5 = ones(5, 3)
  ╠═╡ =#

# ╔═╡ 85e44386-dc88-4a6c-acb6-974a396d1db2
x4 .^ (-2)

# ╔═╡ 5838585e-fa6b-4d1c-ac58-3d96c18037ec
sin.(x4)

# ╔═╡ b98b423d-d45e-4249-a77a-667058c2fc71
sin(x4)

# ╔═╡ 51deb560-0b19-46d5-918a-1d36cdf78052
md"## 3.5  Basic linear algebra"

# ╔═╡ da5c3c4f-09a5-43e0-a567-582473d0c746
x5 = randn(5)

# ╔═╡ bfe53b42-768d-49ab-a29a-e0766c2459ec
begin
	begin
		using LinearAlgebra
		# vector L2 norm
		norm(x5)
	end
end

# ╔═╡ 2ecb4581-f50d-4f5c-90a6-47e577f155d2
# convert to a specific type
convert(Vector{Float64}, 1:10)

# ╔═╡ 701d1566-5748-4e93-ab1c-29b6345d8f95
# same as
sqrt(sum(abs2, x5))

# ╔═╡ f7c5b451-245f-4b8e-8670-996e5b56fa3b
sqrt(sum(x5 .^ (2)))

# ╔═╡ cdb40317-78ce-4c12-9d1b-a19d180fdf0a
begin
	y5 = randn(5) # another vector
	# dot product
	dot(x5, y5) # x' * y
end

# ╔═╡ 2c7fec11-7629-44ee-8551-0a5e782f75d5
x4 .* y5 # same x * y in R. multiplication element by element.

# ╔═╡ b06f788a-21f1-428a-b84c-54805b7cac55
# same as
x5'y5

# ╔═╡ b355f1aa-bc1b-404e-a9d0-0f86763883d7
# = x'y = transpose(x)*y
x5'*y5

# ╔═╡ 3b09f24d-7145-4b29-be42-31da91867f4c
x5'

# ╔═╡ 4660e305-6a53-4f79-9286-3b4e2d9f5e9d
(x5')y5

# ╔═╡ ef2adf62-6bd5-453d-b4e8-fbf30ad97623
(x5)y5

# ╔═╡ e3bcd949-4885-44dc-9bb7-c6092994fbde
begin
	x6, y6 = randn(5, 3), randn(3, 2)
	# matrix multiplication, same as %*% in R
	x6 * y6
end

# ╔═╡ 29024097-0cf2-4f4f-8cb2-c37701cddc45
x7 = randn(3, 3)

# ╔═╡ 53a3ae85-1496-4abc-8057-4e308b0955fd
# conjugate transpose
x7'

# ╔═╡ 28722b1e-018f-4ffb-b0cb-b749079474b2
let
	b = rand(3)
	print(b)
	x7'b # same as x' * b
end

# ╔═╡ 5819d09a-23a9-4694-88fd-ab6f546018ed
# trace
tr(x7)

# ╔═╡ 5fb8b8b8-6658-443a-b703-833f8dfdc350
det(x7)

# ╔═╡ 753bd9e1-d5f3-4dc7-aa95-f56b527ba668
rank(x)

# ╔═╡ d537df2c-8c25-4fc2-8e10-49e38924f4a4
md"## 3.6  Sparse matrices"

# ╔═╡ aa88c8bc-4e17-4fc7-b111-3fad18d1d5a4
# 10-by-10 sparse matrix with sparsity 0.1
X = sprandn(10, 10, 0.1)

# ╔═╡ 279897fd-877c-4764-8de7-94d91cafd4a2
# dump() in Julia is like str() in R
dump(X)

# ╔═╡ 63892daa-ec8d-465b-ab83-8d4cd8347dcf
sizeof(X)

# ╔═╡ f61017b4-819d-494d-9374-4d4ea0a6777f
Base.summarysize(X)

# ╔═╡ 4c2ac38b-4cfe-40e7-bc4f-464ee73a4365
# convert to dense matrix; be cautious when dealing with big data
Xfull = convert(Matrix{Float64}, X)

# ╔═╡ 945d4d88-4856-4085-8605-bbec9469e3b9
sizeof(Xfull)

# ╔═╡ 6f1f3716-4b4d-4dcf-8215-829b76bab6d5
Base.summarysize(Xfull)

# ╔═╡ 2596d636-37ca-4516-afc5-458fc8974ba5
# convert a dense matrix to sparse matrix
sparse(Xfull)

# ╔═╡ 4375cf31-295a-48dc-a17a-c3ec9ee4ccf0
let
	# syntax for sparse linear algebra is same as dense linear algebra
	β = ones(10)
	X * β
end

# ╔═╡ 85fe3529-479f-42a7-b196-bfe461adc310
# many functions apply to sparse matrices as well
sum(X)

# ╔═╡ 104b34ed-e805-4869-a5f3-69b5f92ee01a
md"# 4 Control flow and loops


```julia
# if-elseif-else-end
if condition1
    # do something
elseif condition2
    # do something
else
    # do something
end

# for loop

for i in 1:10
    println(i)
end

# Nested for loop:

for i in 1:10
    for j in 1:5
        println(i * j)
    end
end

# Same as

for i in 1:10, j in 1:5
    println(i * j)
end

# Exit loop:

for i in 1:10
    # do something
    if condition1
        break # skip remaining loop
    end
end

# Exit iteration:
for i in 1:10
    # do something
    if condition1
        continue # skip to next iteration
    end
    # do something
end
```
"

# ╔═╡ 40916923-e191-42a8-aab4-4750bac9d929
md"# 5  Functions

In Julia, all arguments to functions are passed by *reference*, in contrast to R and Matlab.

Function names ending with ! indicates that function mutates at least one argument, typically the first.
```julia
    sort!(x) # vs sort(x)
```

## 5.1 Function definition

```julia
function func(req1, req2; key1=dflt1, key2=dflt2)
    # do stuff
    return out1, out2, out3
end
```

* Required arguments are separated with a comma and use the positional notation.
* Optional arguments need a default value in the signature.
* Semicolon is not required in function call.
* return statement is optional.
* Multiple outputs can be returned as a tuple, e.g., return out1, out2, out3.

* Anonymous functions, e.g., ```x -> x^2```, is commonly used in collection function or list comprehensions.

```julia
map(x -> x^2, y) # square each element in x
```

* Functions can be nested:
```julia
function outerfunction()
    # do some outer stuff
    function innerfunction()
        # do inner stuff
        # can access prior outer definitions
    end
    # do more outer stuff
end
```

* Functions can be vectorized using the Dot syntax:
"

# ╔═╡ 4e2bf01a-1ec6-4898-9c30-fdbb885d08f6
# defined for scalar
function myfunc(x)
    return sin(x^2)
end

# ╔═╡ 4f46ad05-f8fc-406a-a210-903a17454193
begin
	@show x51 = randn(5, 3)
	myfunc.(x51)
end

# ╔═╡ 33f6de41-cd2a-492c-802e-69c16fab3224
md"* Collection function (think this as the series of ```apply``` functions in R).

Apply a function to each element of a collection:

```julia
map(f, coll) # or
map(coll) do elem
    # do stuff with elem
    # must contain return
end
```
"

# ╔═╡ 4f62135e-fc65-4362-a2e0-ee1fca52df16
map(x -> sin(x^2), x51)

# ╔═╡ 070a85bc-5869-425b-a167-e1c4a875ae0b
map(x51) do elem
    elem = elem^2
    return sin(elem)
end

# ╔═╡ 39c4604d-4c82-4de1-a44b-272a941f1cb4
# Mapreduce
mapreduce(x -> sin(x^2), +, x51)

# ╔═╡ f8b9af49-47ad-4de7-8281-51f635f9ca22
# same as
sum(x -> sin(x^2), x51)

# ╔═╡ c323fb68-3f6b-474e-a457-11bbc348ff20
md"* List comprehension"

# ╔═╡ 4f436bd8-6fd8-4ef5-8738-b80f32fc32c8
[sin(2i + j) for i in 1:5, j in 1:3] # similar to Python

# ╔═╡ 89325db2-7c9c-4580-a076-26f658f74975
md"# 6  Type system

* Every variable in Julia has a type.
* When thinking about types, think about sets.
* Everything is a subtype of the abstract type ```Any```.
* An abstract type defines a set of types
  *  Consider types in Julia that are a ```Number```:

* We can explore type hierarchy with ```typeof()```, ```supertype()```, and subtypes()."

# ╔═╡ 59675e9a-ba54-4309-8863-2d723ce76345
typeof(1.0), typeof(1)

# ╔═╡ db62e7c6-8141-4abc-8ea7-64fb3a3db3b2
supertype(Float64)

# ╔═╡ b382fc07-4f8e-4d2f-b14d-243f91b5cb47
parentmodule(Float64)

# ╔═╡ e1d90e00-61b7-425c-a887-1607810ebff7
subtypes(AbstractFloat)

# ╔═╡ 13f3c83d-7f31-4b06-8d51-f5898685c825
# Is Float64 a subtype of AbstractFloat?
Float64 <: AbstractFloat

# ╔═╡ 5e3d79d5-ae71-4681-add6-999241f3e8a8
# On 64bit machine, Int == Int64
Int == Int64

# ╔═╡ 1cce3339-8180-4cc7-af72-633173648876
# convert to Float64
convert(Float64, 1)

# ╔═╡ b35c61bb-d00d-42bc-89d5-5b841a3c08e0
# same as
Float64(1)

# ╔═╡ 61e61f20-8851-4635-b68e-63b300040a96
# Float32 vector
x61 = randn(Float32, 5)

# ╔═╡ 187c5292-fb29-4675-8d8b-3c6ca28a279c
# convert to Float64
convert(Vector{Float64}, x61)

# ╔═╡ d69ac884-bc88-425b-9f9f-9ddea8e5a820
# same as
Float64.(x61)

# ╔═╡ 4b4be343-211e-4e4e-874e-34a4567d1879
# convert Float64 to Int64
convert(Int, 1.0)

# ╔═╡ 370b0ca4-8965-4043-a8f0-a25040d1ff14
convert(Int, 1.5) # should use round(1.5)

# ╔═╡ 2a195610-7581-4ea7-8c3b-287f404a25d0
round(Int, 1.5)

# ╔═╡ e4bd2b27-3274-4bac-bfa0-0e5c7d6ea10f
md"
# 7  Multiple dispatch

- Multiple dispatch lies in the core of Julia design. It allows built-in and user-defined functions to be overloaded for different combinations of argument types.
- Let's consider a simple `doubling` function:
"


# ╔═╡ 2e35a08c-27d0-48d2-96c7-4fbc2c8cb5d1
g(x) = x + x

# ╔═╡ 787a98bd-04c2-4313-8209-5a51cd44a98c
g(x::Float64) = x + x

# ╔═╡ 52af846f-ed68-4459-a5fd-2743fede9d8c
g(x::Number) = x + x

# ╔═╡ e2ea88d8-a89d-4096-9259-fc621899f825
methods(g)

# ╔═╡ 1bab9743-a6f1-44c6-b2b5-c44ce3c2b06c
# an Int64 input
@which g(1)

# ╔═╡ 4bde8a76-e7de-47e7-92f5-f26f9554d494
# a Vector{Float64} input
@which g(randn(5))

# ╔═╡ 716d2838-3bcd-42a8-9f4d-e4cea921ed09
md"# 8  Just-in-time compilation (JIT)

Following figures are taken from Arch D. Robinson's slides Introduction to Writing High Performance Julia.

- Julia toolchain
- Julia's efficiency results from its capability to infer the types of **all** variables within a function and then call LLVM to generate optimized machine code at run-time.
- Consider the g (doubling) function defined earlier. This function will work on **any** type which has a method for +."

# ╔═╡ 2db16e8f-3601-4bb0-9f3e-a53033e72a9f
g(2), g(2.0)

# ╔═╡ 0c7c173b-e820-498a-811b-8e81862ca971
@which g(2)

# ╔═╡ 97b27928-3129-4f5e-8d03-5687a12871a4
#Step 1: Parse Julia code into abstract syntax tree (AST).
@code_lowered g(2)

# ╔═╡ a7adb11f-d44e-47c2-a473-b96351cdea52
# Step 2: Type inference according to input type.
@code_warntype g(2)

# ╔═╡ e73bc7a1-17bd-4dcf-b325-9e07225c15b8
@code_warntype g(2.0)

# ╔═╡ fc8ca968-f3b8-460a-bc47-7eeb67655c56
#  Step 3: Compile into LLVM bytecode (equivalent of R bytecode generated by compiler package).
@code_llvm g(2)

# ╔═╡ c7a9df51-0920-45ac-bbe8-8e32a863fe8a
@code_llvm g(2.0)

# ╔═╡ 77ef5da9-2306-462b-958c-659ecad31d04
md"

- We didn't provide a type annotation. But different LLVM code gets generated depending on the argument type!
- In R or Python, g(2) and g(2.0) would use the same code for both.
- In Julia, g(2) and g(2.0) dispatches to optimized code for Int64 and Float64, respectively.

- For integer input x, LLVM compiler is smart enough to know x + x is simple shifting x by 1 bit, which is faster than addition.

Step 4: Lowest level is the assembly code, which is machine dependent."

# ╔═╡ 0eeb5b9b-1c1c-4c04-88d2-42e34e7f7366
@code_native g(2)

# ╔═╡ 2f25afd2-eb3e-47b7-8730-5b8151b4cedc
code_native(g, (Int64,))

# ╔═╡ 7d02bbdf-04a3-4b50-928f-efd918b1bf45
@code_native g(2.0)

# ╔═╡ 39e95a37-22a2-4e9a-8032-7c571f25018d
md"# 9  Profiling Julia code for tally()

Julia has several built-in tools for profiling. The ```@time``` marco outputs run time and heap allocation."

# ╔═╡ 76368c75-696a-49db-8018-7422a61e17b7
md"## 9.1 @benchmark and @time marco."

# ╔═╡ d2891a6a-1dc7-494e-b904-41646c5afe70
# a function to sum numbers from an array
function tally(x::Array)
    s = zero(eltype(x))
    for v in x
        s += v
    end
    s
end

# ╔═╡ c827384f-5346-4a2f-af6b-370297696407
begin
	using BenchmarkTools
	using Random
	Random.seed!(123)
	a9 = rand(20_000_000)
	@benchmark tally($a9)
end

# ╔═╡ f8091430-f28d-4ddc-83c4-9d205295271c
begin
	# The Profile module gives line by line profile results.
	using Profile
	
	Profile.clear()
	@profile tally(a9)
	Profile.print(format=:flat)
end

# ╔═╡ 5d42dd55-43c6-43a2-b627-92506ca670bb
@time tally(a9) # first run: include compile time

# ╔═╡ d60b35f7-c171-4734-bb82-00a1371bebc2
@time tally(a9)

# ╔═╡ 4a15ef97-9792-4b83-9ef9-d51a9cc017b4
md"## 9.2 Profile"

# ╔═╡ 5c6d6e23-5c71-45ef-9052-373008314434
begin
		
	Profile.clear()
	@profile tally(a9)
	Profile.print(format=:flat)
end

# ╔═╡ 1af062e1-3006-4277-9dfa-5170f48f99e2
md"## 9.3 Profileview needs GUI display. Do it locally.

- Fail to install on n100 via Pluto.jl. "

# ╔═╡ ef56d3e5-4993-4928-a15a-39dd6f8f9167
#begin
	#using ProfileView
	#ProfileView.view()
#end

# ╔═╡ 2dd5297a-1367-4b3a-978c-a4b31efb52d1
md"## 9.4 Check type stability, LLVM bitcode, native code"

# ╔═╡ 249ca105-7832-4978-84eb-5a6b02c45835
# check type stability
@code_warntype tally(a9)

# ╔═╡ de56a1d9-71a9-491d-8fcf-e06ea0365833
# check LLVM bitcode
@code_llvm tally(a9)

# ╔═╡ 074dce2c-bd71-40dd-a4c3-1b316301ab1a
@code_native tally(a9)

# ╔═╡ 2bb1e3a0-981f-44b7-a812-cb4b33910aec
md"## 9.5 tally_SIMD

- Annotate the loop in tally function by @simd and look for the difference in LLVM bitcode and machine code.
"

# ╔═╡ 9c9f77ba-7b89-48e8-a467-12cbac0b68c9
# sum with SIMD/AVX
function tally_SIMD(x::Array)
    s = zero(eltype(x))
    @simd for v in x
        s += v
    end
    s
end

# ╔═╡ 354375ab-0ac4-4fd5-8abc-e4b37fd81f97
@benchmark tally_SIMD($a9)

# ╔═╡ 51cd129e-0207-48e1-b2d9-b70742f85cce
@time tally_SIMD(a9) # first run: include compile time

# ╔═╡ 3ebb433e-693f-4551-b094-aa351e807790
@code_warntype tally_SIMD(a9)

# ╔═╡ c0441f9c-b68d-44a8-8234-701af657ddb3
@code_llvm tally_SIMD(a9)

# ╔═╡ dce56489-bc93-4f85-af52-219d202594d8
@code_native tally_SIMD(a9)

# ╔═╡ ccb9098c-0638-464a-b539-1684a17f8a38
size(a9,1)

# ╔═╡ 01d504be-c1ae-4cc9-9466-3b130fb0fc3c
md"## 9.5.1 somebody suggests using @fastmath, instead of LoopVectorization or @avx ?"

# ╔═╡ 55db9790-8499-4d6b-84da-7f5f1049c7fd
function tally_avx(x::Array)
    s = zero(eltype(x))
    @avx for i ∈ 1:size(x,1)
        s += x[i]
    end
    s
end

# ╔═╡ 31169cb0-50d2-4091-9aa0-7b24351c130f
@time tally_avx(a9) # first run: include compile time

# ╔═╡ 67c72c4c-5964-4021-bb51-e9db564240e5
@time tally_avx(a9)

# ╔═╡ e5facd8c-69d7-43d0-bb02-392c45ece7fc
@benchmark tally_avx($a9)

# ╔═╡ b2a5b09c-1e56-4a8b-bf1e-8122b13e9749
@code_warntype tally_avx(a9)

# ╔═╡ c30d5f4f-5df6-4d2d-9dca-e79c7db5d766
@code_llvm tally_avx(a9)

# ╔═╡ 7bc41f47-b811-4f4f-889e-6d90adae8253
@code_native tally_avx(a9)

# ╔═╡ 7876684c-13a3-4a9c-97d3-abfab3965015
md"# 10 Read bed files"

# ╔═╡ 022c09c1-e3d8-4a6d-86b1-0c34eb8a2217
split_func = x -> split(x, r"[,;]")

# ╔═╡ 94084cb5-8510-48fd-8dd9-c3dbfe47b982
function calc_bed_total_span(filepath)
	d = DataFrame(CSV.File(expanduser(filepath), header=0));
	if hasproperty(d, "Column4")
		gene_name_ls = vcat(map(split_func, d.Column4)...)
		no_of_genes =  length(unique(gene_name_ls));
	else
		no_of_genes = NaN
	end
	span =  sum(d.Column3-d.Column2);
	println("Span is ", span, ". No of genes = ", no_of_genes);
	(d, span, no_of_genes)
end

# ╔═╡ db4b8a39-89ac-426d-8ed7-be33a9f2efa9
if_snp_func = x -> startswith(x, "rs") ? 1 : 0

# ╔═╡ e62e64d6-8264-4aed-8af1-6169e07e8065
@time (d, span, n) = calc_bed_total_span("XXX.bed") ;

# ╔═╡ 15d028e7-099b-4f0e-9857-90ee49b47ea6
@time gene_name_ls = vcat(map(split_func, d.Column4)...)

# ╔═╡ afcc0d8d-8476-418c-8dcd-17192e957af6
@time gene_unique_ls = unique(gene_name_ls)

# ╔═╡ 8a7a9ecb-fe3b-42ea-9297-1d384c856ffc
sum(map(if_snp_func, gene_unique_ls))

# ╔═╡ 50ae1bf3-5cd6-4afb-9d6d-977bec60b546
if_Target_func = x -> startswith(x, "Target") ? 1 : 0
sum(map(if_Target_func, gene_unique_ls))

# ╔═╡ d9f24136-4239-47e7-ae06-f1527b4712cb


# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
Distributions = "31c24e10-a181-5473-b8eb-7969acd0382f"
DrWatson = "634d3b9d-ee7a-5ddf-bec9-22491ea816e1"
InteractiveUtils = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
LoopVectorization = "bdcacae8-1622-11e9-2a5c-532679323890"
Markdown = "d6f4376e-aef5-505a-96c1-9c027394607a"
Pkg = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Profile = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"
PyPlot = "d330b81b-6aea-500a-939a-2ce795aea3ee"
RCall = "6f49c342-dc21-5d91-9882-a32aef131414"
Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[compat]
BenchmarkTools = "~1.5.0"
CSV = "~0.10.13"
DataFrames = "~1.6.1"
Distributions = "~0.25.107"
DrWatson = "~2.14.1"
LoopVectorization = "~0.12.166"
Plots = "~1.40.2"
PlutoUI = "~0.7.58"
PyPlot = "~2.11.2"
RCall = "~0.14.1"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.2"
manifest_format = "2.0"
project_hash = "bd450d88f9e71465fc14f7d3f45a2d4bb587fcb2"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "0f748c81756f2e5e6854298f11ad8b2dfae6911a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.0"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "6a55b747d1812e699320963ffde36f1ebdda4099"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "4.0.4"

    [deps.Adapt.extensions]
    AdaptStaticArraysExt = "StaticArrays"

    [deps.Adapt.weakdeps]
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

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

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Profile", "Statistics", "UUIDs"]
git-tree-sha1 = "f1dff6729bc61f4d49e140da1af55dcd1ac97b2f"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.5.0"

[[deps.BitFlags]]
git-tree-sha1 = "2dc09997850d68179b69dafb58ae806167a32b1b"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.8"

[[deps.BitTwiddlingConvenienceFunctions]]
deps = ["Static"]
git-tree-sha1 = "0c5f81f47bbbcf4aea7b2959135713459170798b"
uuid = "62783981-4cbd-42fc-bca8-16325de8dc4b"
version = "0.1.5"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9e2a6b69137e6969bab0152632dcb3bc108c8bdd"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+1"

[[deps.CPUSummary]]
deps = ["CpuId", "IfElse", "PrecompileTools", "Static"]
git-tree-sha1 = "601f7e7b3d36f18790e2caf83a882d88e9b71ff1"
uuid = "2a0fbf3d-bb9c-48f3-b0a9-814d99fd7ab9"
version = "0.2.4"

[[deps.CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "PrecompileTools", "SentinelArrays", "Tables", "Unicode", "WeakRefStrings", "WorkerUtilities"]
git-tree-sha1 = "a44910ceb69b0d44fe262dd451ab11ead3ed0be8"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.10.13"

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

[[deps.CategoricalArrays]]
deps = ["DataAPI", "Future", "Missings", "Printf", "Requires", "Statistics", "Unicode"]
git-tree-sha1 = "1568b28f91293458345dabba6a5ea3f183250a61"
uuid = "324d7699-5711-5eae-9e2f-1d82baa6b597"
version = "0.10.8"

    [deps.CategoricalArrays.extensions]
    CategoricalArraysJSONExt = "JSON"
    CategoricalArraysRecipesBaseExt = "RecipesBase"
    CategoricalArraysSentinelArraysExt = "SentinelArrays"
    CategoricalArraysStructTypesExt = "StructTypes"

    [deps.CategoricalArrays.weakdeps]
    JSON = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
    RecipesBase = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
    SentinelArrays = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
    StructTypes = "856f2bd8-1eba-4b0a-8007-ebc267875bd4"

[[deps.CloseOpenIntervals]]
deps = ["Static", "StaticArrayInterface"]
git-tree-sha1 = "70232f82ffaab9dc52585e0dd043b5e0c6b714f1"
uuid = "fb6a15b2-703c-40df-9091-08a04967cfa9"
version = "0.1.12"

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

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "6cbbd4d241d7e6579ab354737f4dd95ca43946e1"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.4.1"

[[deps.Conda]]
deps = ["Downloads", "JSON", "VersionParsing"]
git-tree-sha1 = "51cab8e982c5b598eea9c8ceaced4b58d9dd37c9"
uuid = "8f4d0f93-b110-5947-807f-2305c1781a2d"
version = "1.10.0"

[[deps.Contour]]
git-tree-sha1 = "d05d9e7b7aedff4e5b51a029dced05cfb6125781"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.2"

[[deps.CpuId]]
deps = ["Markdown"]
git-tree-sha1 = "fcbb72b032692610bfbdb15018ac16a36cf2e406"
uuid = "adafc99b-e345-5852-983c-f28acb93d879"
version = "0.3.1"

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

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[deps.Distributions]]
deps = ["FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SpecialFunctions", "Statistics", "StatsAPI", "StatsBase", "StatsFuns"]
git-tree-sha1 = "7c302d7a5fec5214eb8a5a4c466dcf7a51fcf169"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.107"

    [deps.Distributions.extensions]
    DistributionsChainRulesCoreExt = "ChainRulesCore"
    DistributionsDensityInterfaceExt = "DensityInterface"
    DistributionsTestExt = "Test"

    [deps.Distributions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    DensityInterface = "b429d917-457f-4dbc-8f4c-0cc954292b1d"
    Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

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

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "82d8afa92ecf4b52d78d869f038ebfb881267322"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.16.3"

[[deps.FilePathsBase]]
deps = ["Compat", "Dates", "Mmap", "Printf", "Test", "UUIDs"]
git-tree-sha1 = "9f00e42f8d99fdde64d40c8ea5d14269a2e2c1aa"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.21"

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

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "ff38ba61beff76b8f4acad8ab0c97ef73bb670cb"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.9+0"

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

[[deps.HostCPUFeatures]]
deps = ["BitTwiddlingConvenienceFunctions", "IfElse", "Libdl", "Static"]
git-tree-sha1 = "eb8fed28f4994600e29beef49744639d985a04b2"
uuid = "3e5b6fbb-0976-4d2c-9146-d79de83f2fb0"
version = "0.1.16"

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

[[deps.IfElse]]
git-tree-sha1 = "debdd00ffef04665ccbb3e150747a77560e8fad1"
uuid = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
version = "0.1.1"

[[deps.InlineStrings]]
deps = ["Parsers"]
git-tree-sha1 = "9cc2baf75c6d09f9da536ddf58eb2f29dedaf461"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.4.0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InvertedIndices]]
git-tree-sha1 = "0dc7b50b8d436461be01300fd8cd45aa0274b038"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.3.0"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

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

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "d986ce2d884d49126836ea94ed5bfb0f12679713"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "15.0.7+0"

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

[[deps.LayoutPointers]]
deps = ["ArrayInterface", "LinearAlgebra", "ManualMemory", "SIMDTypes", "Static", "StaticArrayInterface"]
git-tree-sha1 = "62edfee3211981241b57ff1cedf4d74d79519277"
uuid = "10f19ff3-798f-405d-979b-55457f8fc047"
version = "0.1.15"

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

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "18144f3e9cbe9b15b070288eef858f71b291ce37"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.27"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "c1dd6d7978c12545b4179fb6153b9250c96b0075"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.3"

[[deps.LoopVectorization]]
deps = ["ArrayInterface", "CPUSummary", "CloseOpenIntervals", "DocStringExtensions", "HostCPUFeatures", "IfElse", "LayoutPointers", "LinearAlgebra", "OffsetArrays", "PolyesterWeave", "PrecompileTools", "SIMDTypes", "SLEEFPirates", "Static", "StaticArrayInterface", "ThreadingUtilities", "UnPack", "VectorizationBase"]
git-tree-sha1 = "0f5648fbae0d015e3abe5867bca2b362f67a5894"
uuid = "bdcacae8-1622-11e9-2a5c-532679323890"
version = "0.12.166"

    [deps.LoopVectorization.extensions]
    ForwardDiffExt = ["ChainRulesCore", "ForwardDiff"]
    SpecialFunctionsExt = "SpecialFunctions"

    [deps.LoopVectorization.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    SpecialFunctions = "276daf66-3868-5448-9aa4-cd146d93841b"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "2fa9ee3e63fd3a4f7a9a4f4744a52f4856de82df"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.13"

[[deps.ManualMemory]]
git-tree-sha1 = "bcaef4fc7a0cfe2cba636d84cda54b5e4e4ca3cd"
uuid = "d125e4d3-2237-4719-b19c-fa641b8a4667"
version = "0.1.8"

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

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

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

[[deps.PolyesterWeave]]
deps = ["BitTwiddlingConvenienceFunctions", "CPUSummary", "IfElse", "Static", "ThreadingUtilities"]
git-tree-sha1 = "240d7170f5ffdb285f9427b92333c3463bf65bf6"
uuid = "1d0040c9-8b98-4ee7-8388-3f51789ca0ad"
version = "0.2.1"

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

[[deps.Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

[[deps.PyCall]]
deps = ["Conda", "Dates", "Libdl", "LinearAlgebra", "MacroTools", "Serialization", "VersionParsing"]
git-tree-sha1 = "9816a3826b0ebf49ab4926e2b18842ad8b5c8f04"
uuid = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
version = "1.96.4"

[[deps.PyPlot]]
deps = ["Colors", "LaTeXStrings", "PyCall", "Sockets", "Test", "VersionParsing"]
git-tree-sha1 = "9220a9dae0369f431168d60adab635f88aca7857"
uuid = "d330b81b-6aea-500a-939a-2ce795aea3ee"
version = "2.11.2"

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

[[deps.RCall]]
deps = ["CategoricalArrays", "Conda", "DataFrames", "DataStructures", "Dates", "Libdl", "Missings", "Preferences", "REPL", "Random", "Requires", "StatsModels", "WinReg"]
git-tree-sha1 = "846b2aab2d312fda5e7b099fc217c661e8fae27e"
uuid = "6f49c342-dc21-5d91-9882-a32aef131414"
version = "0.14.1"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

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

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.SIMDTypes]]
git-tree-sha1 = "330289636fb8107c5f32088d2741e9fd7a061a5c"
uuid = "94e857df-77ce-4151-89e5-788b33177be4"
version = "0.1.0"

[[deps.SLEEFPirates]]
deps = ["IfElse", "Static", "VectorizationBase"]
git-tree-sha1 = "3aac6d68c5e57449f5b9b865c9ba50ac2970c4cf"
uuid = "476501e8-09a2-5ece-8869-fb82de89a1fa"
version = "0.6.42"

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

[[deps.ShiftedArrays]]
git-tree-sha1 = "503688b59397b3307443af35cd953a13e8005c16"
uuid = "1277b4bf-5013-50f5-be3d-901d8477a67a"
version = "2.0.0"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
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

[[deps.SpecialFunctions]]
deps = ["IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "e2cfc4012a19088254b3950b85c3c1d8882d864d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.3.1"

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

    [deps.SpecialFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"

[[deps.Static]]
deps = ["IfElse"]
git-tree-sha1 = "d2fdac9ff3906e27f7a618d47b676941baa6c80c"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "0.8.10"

[[deps.StaticArrayInterface]]
deps = ["ArrayInterface", "Compat", "IfElse", "LinearAlgebra", "PrecompileTools", "Requires", "SparseArrays", "Static", "SuiteSparse"]
git-tree-sha1 = "5d66818a39bb04bf328e92bc933ec5b4ee88e436"
uuid = "0d7ed370-da01-4f52-bd93-41d350b8b718"
version = "1.5.0"

    [deps.StaticArrayInterface.extensions]
    StaticArrayInterfaceOffsetArraysExt = "OffsetArrays"
    StaticArrayInterfaceStaticArraysExt = "StaticArrays"

    [deps.StaticArrayInterface.weakdeps]
    OffsetArrays = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

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

    [deps.StatsFuns.extensions]
    StatsFunsChainRulesCoreExt = "ChainRulesCore"
    StatsFunsInverseFunctionsExt = "InverseFunctions"

    [deps.StatsFuns.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.StatsModels]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "Printf", "REPL", "ShiftedArrays", "SparseArrays", "StatsAPI", "StatsBase", "StatsFuns", "Tables"]
git-tree-sha1 = "5cf6c4583533ee38639f73b880f35fc85f2941e0"
uuid = "3eaba693-59b7-5ba5-a881-562e759f1c8d"
version = "0.7.3"

[[deps.StringManipulation]]
deps = ["PrecompileTools"]
git-tree-sha1 = "a04cabe79c5f01f4d723cc6704070ada0b9d46d5"
uuid = "892a3eda-7b42-436c-8928-eab12a02cf0e"
version = "0.3.4"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.2.1+1"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

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

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.ThreadingUtilities]]
deps = ["ManualMemory"]
git-tree-sha1 = "eda08f7e9818eb53661b3deb74e3159460dfbc27"
uuid = "8290d209-cae3-49c0-8002-c8c24d57dab5"
version = "0.5.2"

[[deps.TranscodingStreams]]
git-tree-sha1 = "14389d51751169994b2e1317d5c72f7dc4f21045"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.10.6"
weakdeps = ["Random", "Test"]

    [deps.TranscodingStreams.extensions]
    TestExt = ["Test", "Random"]

[[deps.Tricks]]
git-tree-sha1 = "eae1bb484cd63b36999ee58be2de6c178105112f"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.8"

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

    [deps.Unitful.extensions]
    ConstructionBaseUnitfulExt = "ConstructionBase"
    InverseFunctionsUnitfulExt = "InverseFunctions"

    [deps.Unitful.weakdeps]
    ConstructionBase = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.UnitfulLatexify]]
deps = ["LaTeXStrings", "Latexify", "Unitful"]
git-tree-sha1 = "e2d817cc500e960fdbafcf988ac8436ba3208bfd"
uuid = "45397f5d-5981-4c77-b2b3-fc36d6e9b728"
version = "1.6.3"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.VectorizationBase]]
deps = ["ArrayInterface", "CPUSummary", "HostCPUFeatures", "IfElse", "LayoutPointers", "Libdl", "LinearAlgebra", "SIMDTypes", "Static", "StaticArrayInterface"]
git-tree-sha1 = "7209df901e6ed7489fe9b7aa3e46fb788e15db85"
uuid = "3d5dd08c-fd9d-11e8-17fa-ed2836048c2f"
version = "0.21.65"

[[deps.VersionParsing]]
git-tree-sha1 = "58d6e80b4ee071f5efd07fda82cb9fbe17200868"
uuid = "81def892-9a0e-5fdd-b105-ffc91e053289"
version = "1.3.0"

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

[[deps.WeakRefStrings]]
deps = ["DataAPI", "InlineStrings", "Parsers"]
git-tree-sha1 = "b1be2855ed9ed8eac54e5caff2afcdb442d52c23"
uuid = "ea10d353-3f73-51f8-a26c-33c1cb351aa5"
version = "1.4.2"

[[deps.WinReg]]
git-tree-sha1 = "cd910906b099402bcc50b3eafa9634244e5ec83b"
uuid = "1b915085-20d7-51cf-bf83-8f477d6f5128"
version = "1.0.0"

[[deps.WorkerUtilities]]
git-tree-sha1 = "cd1659ba0d57b71a464a29e64dbc67cfe83d54e7"
uuid = "76eceee3-57b5-4d4a-8e66-0e911cebbf60"
version = "1.6.1"

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
# ╠═f60605ab-b182-4212-bd65-4f9e1ba67f2c
# ╠═5776d5e9-95a3-4cf1-b9c0-1b3c4c51c91b
# ╠═4a7545ec-21aa-4eb1-9a6a-a4cacbca4c5f
# ╠═78742224-eb68-4f3a-a848-2f4bf30dbc05
# ╠═b1e7d68a-ce33-4c36-84b8-bb36d6426da1
# ╠═cab57f22-b2e5-4e2b-bac9-1b08d91b3a12
# ╠═349534f6-1449-4e09-adb0-b210c384dda4
# ╠═55ee298b-ca9e-46fb-a352-073dbb6109f0
# ╟─73d63463-abb6-4b7c-b27a-221125c87222
# ╠═0a174786-ee9f-48f5-8b72-f9e840c9ff7e
# ╠═98953899-4029-4220-a113-aba2385c9c47
# ╟─ca6e6f4c-d911-4841-97ed-528fbd61f4d2
# ╠═99d2c8f1-fb4f-4b55-a80a-845d5ef840d0
# ╠═0e050586-c204-4056-86d9-020e825d1e72
# ╠═e61a730b-6086-451a-93fe-06b9604c2136
# ╠═4b32e66f-cb5e-4e27-9bca-101be60d7bf7
# ╠═e34612a8-11de-4b19-8d99-a8742d9b0ae6
# ╠═e46de96b-f9dd-4750-a0a5-36585fdb07d1
# ╠═73820768-d442-4ad7-880f-00a2cf74a283
# ╠═8e6ba332-a4f2-4073-987f-f4343d61e6e8
# ╠═2c7dfca1-e30f-47e9-9a5e-91b37ab6677a
# ╠═2b989517-20b2-4076-93c2-ce85965e9caf
# ╠═f599cfd1-cc84-41af-b4bc-a2f7e7a248d9
# ╟─7667bf41-a157-4c55-91f9-53532b729910
# ╠═ed86b679-a968-4169-90d8-812860473493
# ╠═0243c332-6961-4f18-b29c-838dd0ca3f9e
# ╟─4703589a-d291-406c-a263-ed2cdd92a2b9
# ╠═af9f519c-88a0-4191-9a37-f4b89936995b
# ╠═1b5270f5-62ab-4d88-bb1d-9a96bcddf7c8
# ╟─bd3f8a44-bd6b-4f01-a488-6d674e73e9f6
# ╠═b716fd3f-6a7e-4c0c-a36b-dad9c445bb27
# ╠═f207f2f0-bf29-479b-831c-b7c4fad726d4
# ╟─e2cdb32d-82ef-4d1c-b8a4-110232a90323
# ╠═4f903e4c-aa4b-47d6-b975-eb3acaad6be8
# ╠═a3e853d4-7a27-46fa-94a9-32988bf870e0
# ╠═5532c10d-e8f3-4012-9c40-183c461c2b77
# ╠═d024b5b2-4ba2-4c47-a0ba-f73c63990bc8
# ╠═212eef0d-a257-4056-a0f0-16531ca702b5
# ╠═0affeb8e-a2a4-44bf-b2c9-df6b0eeec07e
# ╟─f98281a1-16d0-4a2f-b598-af8445ad28d0
# ╠═ac0160b2-30fc-4f05-90f9-02efd91f8c6e
# ╠═6aa9b25e-cf95-4b86-ad7c-730131e61a57
# ╠═bc4f6f45-7c5d-4f92-9665-3b50fb5ed857
# ╠═9558054f-de63-4d87-985d-953965eb36c3
# ╠═70fd675e-e74f-4578-a7aa-2b6dcde4e455
# ╠═03fd9279-cd4f-405a-952d-88dbf7e756a4
# ╠═8bcafee0-508a-44e7-a5b8-ce2a4307f724
# ╠═259d6216-7a2b-4e26-91c4-c10299b4cc00
# ╠═33655512-9341-424e-90dc-d73d3f49c6f8
# ╠═a3264c09-a4c1-40b6-a20e-d9dc7523b21d
# ╠═4a62f652-c28a-4613-9a20-36b04502c85e
# ╠═d4373aa6-1c92-4d0c-bfed-1cbcc40be2b9
# ╠═2c7e73b7-1f8f-4377-a216-f55997ccab55
# ╟─bad3f7db-fa79-4a9a-9581-ca8172ed09d9
# ╠═2a1614c8-61b9-496f-a1f9-309239607fb6
# ╠═8eaf8a0f-27c1-48d4-89c2-07f5dc0c4e6a
# ╠═72adabc4-c663-4e40-898e-d19949802450
# ╠═c2e972a3-6be7-4f97-8f31-fd7364b7fde1
# ╠═86854214-b765-4a1f-9616-2c50f767c863
# ╠═dfccc449-ef43-4381-af16-191cdaed79fc
# ╠═a86c5507-cfd4-4b22-bed2-023e971cb32c
# ╠═b5c0e94a-7e2d-41d9-b9cf-4420a0aaa84c
# ╠═5156e29d-fb6c-4019-8c93-c526fb2f3a78
# ╠═a921af57-37ad-4d5e-8b7e-df75c9f20c9c
# ╠═d274e56f-80e7-4b50-82d8-1daa9e7819d3
# ╠═1f10e782-97c5-459c-a456-bc991c726960
# ╟─5d7529fe-c751-46a4-bb68-db856ef8682e
# ╠═a05995ba-e882-40fc-8597-f7962c3a728b
# ╠═25ae1391-0f74-4248-8683-6c7294172ced
# ╠═033647d7-c3a6-4ea4-93d8-6017e006f97b
# ╠═c65f388e-aa0a-442e-8815-b7a7b8514f36
# ╠═03842bb7-bcb7-421e-b363-eb4bce7e32fd
# ╠═cb9e9023-2438-4ad8-9268-cb77ca72cdcb
# ╠═ebb04d62-79d9-47a6-9095-4a7f6aae10ef
# ╠═2ecb4581-f50d-4f5c-90a6-47e577f155d2
# ╟─9974acba-0e3a-4697-9fa9-ffc2a10a5729
# ╠═279ad791-4d32-487d-936b-9b2c4e2a75e1
# ╟─ecd80612-292d-45af-8724-bcee7abfce27
# ╠═1edb3564-39e2-41ec-adde-360d24b05dbe
# ╠═9123e911-716a-4e29-8d14-a0cd3296a159
# ╠═751b11cc-7171-410a-a285-5ea85d53ac00
# ╠═015fbf1c-2398-4820-b638-fdc87ca70b65
# ╠═83f8ac52-675e-45e0-b0ff-9adaa6b43b63
# ╠═4ab6ff13-cbbd-4b58-bd6e-f39c89caea61
# ╠═54cf1a59-7467-42ad-9c4f-112688ca4cf0
# ╠═b3930380-ae2e-43e7-8439-5d2bebf391b9
# ╠═ac808c3b-8e72-4d3f-bd49-fe15ac7265fb
# ╠═460c86af-5ef8-441f-ac32-c9c2e379b57c
# ╟─7e855b33-d0b0-48ef-a107-b7a4e5dd0fe9
# ╠═cf3b65fd-bf41-45a7-a5dd-82908d7d2f37
# ╠═54ebd4bf-dfe0-46bf-9e87-34d89df8145c
# ╠═5e8413b0-20e0-4a31-8aa0-e1d915b05fd9
# ╠═1a393b2b-ed29-48dd-91a5-b8e85533de28
# ╠═8eab5808-2abd-462e-8d07-f5e0f6f71dd9
# ╠═38604bd5-7a31-492e-8082-83c5ac6d34d6
# ╠═ea365523-21bf-4cad-bc61-79241cbe29f3
# ╠═33180cc7-65d0-4f9e-a0db-bd3a804ef7a4
# ╠═2c7fec11-7629-44ee-8551-0a5e782f75d5
# ╠═85e44386-dc88-4a6c-acb6-974a396d1db2
# ╠═5838585e-fa6b-4d1c-ac58-3d96c18037ec
# ╠═b98b423d-d45e-4249-a77a-667058c2fc71
# ╠═51deb560-0b19-46d5-918a-1d36cdf78052
# ╠═da5c3c4f-09a5-43e0-a567-582473d0c746
# ╠═bfe53b42-768d-49ab-a29a-e0766c2459ec
# ╠═701d1566-5748-4e93-ab1c-29b6345d8f95
# ╠═f7c5b451-245f-4b8e-8670-996e5b56fa3b
# ╠═cdb40317-78ce-4c12-9d1b-a19d180fdf0a
# ╠═b06f788a-21f1-428a-b84c-54805b7cac55
# ╠═b355f1aa-bc1b-404e-a9d0-0f86763883d7
# ╠═3b09f24d-7145-4b29-be42-31da91867f4c
# ╠═4660e305-6a53-4f79-9286-3b4e2d9f5e9d
# ╠═ef2adf62-6bd5-453d-b4e8-fbf30ad97623
# ╠═e3bcd949-4885-44dc-9bb7-c6092994fbde
# ╠═29024097-0cf2-4f4f-8cb2-c37701cddc45
# ╠═53a3ae85-1496-4abc-8057-4e308b0955fd
# ╠═28722b1e-018f-4ffb-b0cb-b749079474b2
# ╠═5819d09a-23a9-4694-88fd-ab6f546018ed
# ╠═5fb8b8b8-6658-443a-b703-833f8dfdc350
# ╠═753bd9e1-d5f3-4dc7-aa95-f56b527ba668
# ╠═d537df2c-8c25-4fc2-8e10-49e38924f4a4
# ╠═d7c485db-14da-4c29-ab0f-6ddd030da9b8
# ╠═aa88c8bc-4e17-4fc7-b111-3fad18d1d5a4
# ╠═279897fd-877c-4764-8de7-94d91cafd4a2
# ╠═63892daa-ec8d-465b-ab83-8d4cd8347dcf
# ╠═f61017b4-819d-494d-9374-4d4ea0a6777f
# ╠═4c2ac38b-4cfe-40e7-bc4f-464ee73a4365
# ╠═945d4d88-4856-4085-8605-bbec9469e3b9
# ╠═6f1f3716-4b4d-4dcf-8215-829b76bab6d5
# ╠═2596d636-37ca-4516-afc5-458fc8974ba5
# ╠═4375cf31-295a-48dc-a17a-c3ec9ee4ccf0
# ╠═85fe3529-479f-42a7-b196-bfe461adc310
# ╟─104b34ed-e805-4869-a5f3-69b5f92ee01a
# ╟─40916923-e191-42a8-aab4-4750bac9d929
# ╠═4e2bf01a-1ec6-4898-9c30-fdbb885d08f6
# ╠═4f46ad05-f8fc-406a-a210-903a17454193
# ╟─33f6de41-cd2a-492c-802e-69c16fab3224
# ╠═4f62135e-fc65-4362-a2e0-ee1fca52df16
# ╠═070a85bc-5869-425b-a167-e1c4a875ae0b
# ╠═39c4604d-4c82-4de1-a44b-272a941f1cb4
# ╠═f8b9af49-47ad-4de7-8281-51f635f9ca22
# ╟─c323fb68-3f6b-474e-a457-11bbc348ff20
# ╠═4f436bd8-6fd8-4ef5-8738-b80f32fc32c8
# ╟─89325db2-7c9c-4580-a076-26f658f74975
# ╠═59675e9a-ba54-4309-8863-2d723ce76345
# ╠═db62e7c6-8141-4abc-8ea7-64fb3a3db3b2
# ╠═b382fc07-4f8e-4d2f-b14d-243f91b5cb47
# ╠═e1d90e00-61b7-425c-a887-1607810ebff7
# ╠═13f3c83d-7f31-4b06-8d51-f5898685c825
# ╠═5e3d79d5-ae71-4681-add6-999241f3e8a8
# ╠═1cce3339-8180-4cc7-af72-633173648876
# ╠═b35c61bb-d00d-42bc-89d5-5b841a3c08e0
# ╠═61e61f20-8851-4635-b68e-63b300040a96
# ╠═187c5292-fb29-4675-8d8b-3c6ca28a279c
# ╠═d69ac884-bc88-425b-9f9f-9ddea8e5a820
# ╠═4b4be343-211e-4e4e-874e-34a4567d1879
# ╠═370b0ca4-8965-4043-a8f0-a25040d1ff14
# ╠═2a195610-7581-4ea7-8c3b-287f404a25d0
# ╟─e4bd2b27-3274-4bac-bfa0-0e5c7d6ea10f
# ╠═2e35a08c-27d0-48d2-96c7-4fbc2c8cb5d1
# ╠═787a98bd-04c2-4313-8209-5a51cd44a98c
# ╠═52af846f-ed68-4459-a5fd-2743fede9d8c
# ╠═e2ea88d8-a89d-4096-9259-fc621899f825
# ╠═1bab9743-a6f1-44c6-b2b5-c44ce3c2b06c
# ╠═4bde8a76-e7de-47e7-92f5-f26f9554d494
# ╟─716d2838-3bcd-42a8-9f4d-e4cea921ed09
# ╠═2db16e8f-3601-4bb0-9f3e-a53033e72a9f
# ╠═0c7c173b-e820-498a-811b-8e81862ca971
# ╠═97b27928-3129-4f5e-8d03-5687a12871a4
# ╠═a7adb11f-d44e-47c2-a473-b96351cdea52
# ╠═e73bc7a1-17bd-4dcf-b325-9e07225c15b8
# ╠═fc8ca968-f3b8-460a-bc47-7eeb67655c56
# ╠═c7a9df51-0920-45ac-bbe8-8e32a863fe8a
# ╟─77ef5da9-2306-462b-958c-659ecad31d04
# ╠═0eeb5b9b-1c1c-4c04-88d2-42e34e7f7366
# ╠═2f25afd2-eb3e-47b7-8730-5b8151b4cedc
# ╠═7d02bbdf-04a3-4b50-928f-efd918b1bf45
# ╠═39e95a37-22a2-4e9a-8032-7c571f25018d
# ╟─76368c75-696a-49db-8018-7422a61e17b7
# ╠═d2891a6a-1dc7-494e-b904-41646c5afe70
# ╠═c827384f-5346-4a2f-af6b-370297696407
# ╠═5d42dd55-43c6-43a2-b627-92506ca670bb
# ╠═d60b35f7-c171-4734-bb82-00a1371bebc2
# ╟─4a15ef97-9792-4b83-9ef9-d51a9cc017b4
# ╠═f8091430-f28d-4ddc-83c4-9d205295271c
# ╠═5c6d6e23-5c71-45ef-9052-373008314434
# ╟─1af062e1-3006-4277-9dfa-5170f48f99e2
# ╟─ef56d3e5-4993-4928-a15a-39dd6f8f9167
# ╟─2dd5297a-1367-4b3a-978c-a4b31efb52d1
# ╠═249ca105-7832-4978-84eb-5a6b02c45835
# ╠═de56a1d9-71a9-491d-8fcf-e06ea0365833
# ╠═074dce2c-bd71-40dd-a4c3-1b316301ab1a
# ╠═2bb1e3a0-981f-44b7-a812-cb4b33910aec
# ╠═9c9f77ba-7b89-48e8-a467-12cbac0b68c9
# ╠═354375ab-0ac4-4fd5-8abc-e4b37fd81f97
# ╠═51cd129e-0207-48e1-b2d9-b70742f85cce
# ╠═3ebb433e-693f-4551-b094-aa351e807790
# ╠═c0441f9c-b68d-44a8-8234-701af657ddb3
# ╠═dce56489-bc93-4f85-af52-219d202594d8
# ╠═ccb9098c-0638-464a-b539-1684a17f8a38
# ╟─01d504be-c1ae-4cc9-9466-3b130fb0fc3c
# ╠═41647387-7b4c-4d5d-b815-51a777b8e637
# ╠═55db9790-8499-4d6b-84da-7f5f1049c7fd
# ╠═31169cb0-50d2-4091-9aa0-7b24351c130f
# ╠═67c72c4c-5964-4021-bb51-e9db564240e5
# ╠═e5facd8c-69d7-43d0-bb02-392c45ece7fc
# ╠═b2a5b09c-1e56-4a8b-bf1e-8122b13e9749
# ╠═c30d5f4f-5df6-4d2d-9dca-e79c7db5d766
# ╠═7bc41f47-b811-4f4f-889e-6d90adae8253
# ╠═7876684c-13a3-4a9c-97d3-abfab3965015
# ╠═e282c856-b3f5-4d8c-94cc-9d57b1c34165
# ╠═022c09c1-e3d8-4a6d-86b1-0c34eb8a2217
# ╠═94084cb5-8510-48fd-8dd9-c3dbfe47b982
# ╠═db4b8a39-89ac-426d-8ed7-be33a9f2efa9
# ╠═e62e64d6-8264-4aed-8af1-6169e07e8065
# ╠═15d028e7-099b-4f0e-9857-90ee49b47ea6
# ╠═afcc0d8d-8476-418c-8dcd-17192e957af6
# ╠═8a7a9ecb-fe3b-42ea-9297-1d384c856ffc
# ╠═50ae1bf3-5cd6-4afb-9d6d-977bec60b546
# ╠═d9f24136-4239-47e7-ae06-f1527b4712cb
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
