"""
    Strings = Union{Str,String,StringDocument, Vector{String}}

Create a Union of three types of strings that the functions of the package accepts; Str, String, TextAnalysis::StringDocument and  Vector{String}. 
"""
const Strings = Union{Str,String,StringDocument, Vector{String}, Vector{Vector{String}}}

"Create a new type that carries all relevant information needed for calculating the lexical gravity index: gdict is a feature that includes a dictionary
of the words and their lexical richness index."
struct RichnessBundle
    gdict::Dict{String, Float64}
    uniquecontext::Vector{String}
    bigrams::Vector{Vector{String}} 
    word::String
end