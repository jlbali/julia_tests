
using Turing, StatsPlots, Random

# Base: http://krasserm.github.io/2018/12/16/topic-models-pymc3/
# Paper "Turing: a language for flexible probabilistic inference" de Ge et al. (2018), ge18b.pdf.

V = 1000 # Vocabulary Length
D = 200  # Cantidad de documentos.
mean_doc_size = 20 # Longitud media de cada documento.

vocabulary = 1:V

## Construimos los documentos ###
w = Vector{Vector{Int64}}(undef, D)
# Documentos del tópico 1.
for i in 1:100
    doc_size = mean_doc_size
    doc = rand(1:500, doc_size)
    #println(doc)
    w[i] = doc
end
# Documentos del tópico 2.
for i in 1:100
    doc_size = mean_doc_size
    doc = rand(501:1000, doc_size)
    #println(doc)
    w[100+i] = doc
end

#println(w)

# Topicos.
K = 2

alpha = vec((1.0/K).*ones(K)) # quizás el vec no es necesario...
#println(alpha)
beta = vec((1.0/V).*ones(V))

# Definición del Modelo Naive-Bayes.

@model naive_bayes(K, D, V, w, alpha, beta) = begin
    theta = Vector{Float64}(undef, K) # theta es la distribución a priori de los tópicos.
    theta ~ Dirichlet(alpha)
    phi = Vector{Vector{Float64}}(undef, K) # Phi es la distribución a priori de la distribución de palabras seǵun el tópico k.
    for k in 1:K
        phi[k] = Vector{Float64}(undef, V) # Quizás no es necesario.
        phi[k] ~ Dirichlet(beta)
    end
    z = Vector{Int64}(undef, D) # z representa los tópicos del documento d. Es único el tópico por documento.
    for d in 1:D
        z[d] ~ Categorical(theta) # Ver si está bien...
        for i in 1:length(w[d])
            w[d][i] ~ Categorical(phi[z[d]])
        end
    end
end

model = naive_bayes(K,D,V,w,alpha,beta)
#println(model)

#sampler = PG(10,10)
# Al PG se le pasan los parámetros discretos, al HMC los continuos.
sampler = Gibbs(100, PG(100, 1,:z), HMC(1, 0.05, 10, :theta, :phi))
muestra = sample(model, sampler)
#println(muestra)

# así y todo tira un error...
# Es preciso también tener algo para sacar el MAP.
