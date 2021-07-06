"""
    ngramfirstcombine(x::Strings)

A function that takes a Vector of strings and outputs a vector of string vectors with ngram combinations of the
    first member with all the other elements of the vector. It is the first step for implementing the lexical gravity association measure.
    For more details, cf. (Daudaravičius & Marcinkevičienė 2004).

# Examples
```julia-repl
julia> ngramfirstcombine(["σε", "νόμιμες", "ενέργειες", "κατά"], 4)
3-element Vector{Vector{String}}:
["σε", "νόμιμες"]
["σε", "ενέργειες"]
["σε", "κατά"]
```
"""
@memoize function ngramfirstcombine(str::Strings)
ngramArray::Vector{Vector{String}} = []
for i in 1:(length(str) - 1)
    push!(ngramArray, [str[1], str[1 + i]])
end
return ngramArray
end

@memoize function ngramfirstcombine(str::Strings)
    println("am fine")
    ngramArray = Dictionary{Vector{String}, Float64}()
    str = tokenize(str)
    #println(str)
    for i in 1:(length(str) - 1)
        insert!(ngramArray, [str[1], str[1 + i]], 1/i)
        #println(ngramArray)
    end
    return ngramArray
end



"""
    tokenize(s::StringDocument)

A function that takes a StringDocument and tokenizes it using using the tokenize() function created in the TextAnalysis package.

# Examples
```julia-repl
julia> nicestringdoc = StringDocument("This is a nice string.")
julia> tokenize(nicestringdoc)
6-element Vector{String}:
 "This"
 "is"
 "a"
 "nice"
 "string"
 "."
```
"""
tokenize(s::StringDocument) =  tokenize(text(s))

#ngram_simple(s::Strings_simple1, n::Integer) = [s[i:i+n-1] for i=1:length(s)-n+1]
# s must be first tokenized 
ngram(s::Strings, n::Integer) = [s[i:i+n-1] for i=1:length(s)-n+1]


"""
    ngramdirection(x::Strings)

A function that takes a Vector of strings and outputs a vector of string vectors with ngram combinations of the
first member with all the other elements of the vector. It is the first step for implementing the lexical gravity association measure.
For more details, cf. (Daudaravičius & Marcinkevičienė 2004).

# Examples
```julia-repl
julia> ngramfirstcombine(["σε", "νόμιμες", "ενέργειες", "κατά"], 4)
3-element Vector{Vector{String}}:
["σε", "νόμιμες"]
["σε", "ενέργειες"]
["σε", "κατά"]
```
"""
@memoize function ngramdirection(mydata::Strings; n = 4, direction = "forward")
if direction == "forward"
    str = ngram(mydata, n)
    ngramfirstcombine.(str)
elseif  direction == "backward"
    str = reverse.(ngram(mydata, n))
    ngramfirstcombine.(str)
end       
end


# tokenizedtext


"""
    bigramsinside(x::Strings)

A function that takes a Vector of strings and outputs a vector of string vectors with ngram combinations of the
first member with all the other elements of the vector. It is the first step for implementing the lexical gravity association measure.
For more details, cf. (Daudaravičius & Marcinkevičienė 2004).

# Examples
```julia-repl
julia> bigramsinside(["σε", "νόμιμες", "ενέργειες", "κατά"], 4)
3-element Vector{Vector{String}}:
["σε", "νόμιμες"]
["σε", "ενέργειες"]
["σε", "κατά"]
```
"""
@memoize function bigramsinside(word, text::Strings, ngram)
typeof(text) == Vector{String} || (text = tokenize(text))
wordbigrams = filter(x -> x[1][1] == word, ngram)
return wordbigrams  
end