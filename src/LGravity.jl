module LGravity

include("Types.jl")
include("Preprocessing.jl")

using TextAnalysis
using StaticArrays
using Counters
using Strs
using WordTokenizers # TODO: see if I need it
using Dictionaries 
using Memoize
import WordTokenizers: tokenize # for being able to extend an existing package

export Strings, RichnessBundle, ngramfirstcombine, f, g, ngram, ngramdirection, tokenizestr, bigramsinside, lexicalgravitypair


"""
    g(text::Strings; mode = "forward") 

A function that takes a Vector of strings and outputs a vector of string vectors with ngram combinations of the
    first member with all the other elements of the vector. It is the first step for implementing the lexical gravity.
    For more details, cf. (2004).

# Examples
```julia-repl
julia> g(text)
2-element Vector{RichnessBundle}:
RichnessBundle(Dict("Στα" => 0.3475), ["Στα", "δικαστήρια", "θα", "αναζητήσει"], [["Στα", "δικαστήρια"], ["Στα", "θα"], ["Στα", "αναζητήσει"]], "Στα")
 RichnessBundle(Dict("δικαστήρια" => 0.3215), ["δικαστήρια", "θα", "αναζητήσει", "το"], [["δικαστήρια", "θα"], ["δικαστήρια", "αναζητήσει"], ["δικαστήρια", "το"]], "δικαστήρια")
```
"""
@memoize function g(text::Strings; mode = "forward") 
    lexicalrichness = Vector{Union{RichnessBundle, Dict}}(undef, 0)
    text = lowercase(text)
    tokenized_text2 = tokenizestr(text)
    tokenized_text = unique(tokenizestr(text))
    ngrams = ngramdirection2(tokenized_text2, direction = mode)
    overallgdict = Dict()
    for word in tokenized_text
        gdict = Dict()
        bigrams = bigramsinside(word, tokenized_text2, ngrams)
        if length(bigrams) > 0
            # unique words in the context of word within a 4-gram.
            uniquecontext = unique(collect(Iterators.flatten(bigrams)))
            g = size(bigrams, 1) / (length(uniquecontext) - 1)
            println(g)
            push!(gdict, word => g)
            push!(overallgdict, word => g)
            println(typeof(uniquecontext), typeof(allbigrams), typeof(word))
            push!(lexicalrichness, RichnessBundle(gdict, uniquecontext, bigrams, word))
        end
    end
    push!(lexicalrichness, overallgdict)
    return lexicalrichness
end

# For getting the g of a specific word for the denominators in the lexicalgravitypair() function.
@memoize function g(word::String, text::Strings; mode = "forward")
    word = lowercase(word)
    return gsimple2(text, mode=mode)[end][word]
end

"""
    f(x::String, y::String, text::Strings)

A function that returns co-occurence frequency of words (x, y) within a 3-word span from x onwards in the right direction. In other words, x is the focal word. The type **Strings** 
    Union{Str,String,StringDocument, Vector{String}}. For this type of frequency, plase cf. XXX(2004).

# Examples
```julia-repl
julia> f("η", "τιμή", mytext)
2
```
"""
@memoize function f(x::String, y::String, lexicalrichness::Vector{Union{RichnessBundle, Dict}})
    ind = [lowercase(x) == lexicalrichness[i].word for i=1:length(lexicalrichness)]
    freqxy = counter([x[2] for x in lexicalrichness[ind][1].bigrams])[y]
    return freqxy
end


"""
    lexicalgravitypair(x::String, y::String, text::Strings) 

A function that takes a Vector of strings and outputs a vector of string vectors with ngram combinations of the
    first member with all the other elements of the vector. It is the first step for implementing the lexical gravity.
    For more details, cf. (2004).

# Examples
```julia-repl
julia> f("η", "τιμή")
2
```
"""
@memoize function lexicalgravitypair(x::String, y::String, text::Strings) 
    f_xy = f(x,y,g(text)[1:end-1])
    log(f_xy/g(x, text)) + log(f_xy/g(x, text, mode = "backward"))
end

end
