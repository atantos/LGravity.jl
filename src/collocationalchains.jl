"""
    collocationalchains(text::Strings; mode = "forward") 

A function that takes text and returns ngram sequences of words with lexical gravity score above 5.5.
For more details, cf. (2004).

# Examples
```julia-repl
julia> collocationalchains(text)
sample output
```
"""
function collocationalchains(lowertextdata)
    intermediatearray = Array{String,1}()
    finalarray = Array{Array{String},1}()
    for ngram in ngram(tokenizestr(lowertextdata)[4:end - 3], 2)
    # i need to first clean and normalize the data before applying the lexicalgravitypair() function.
        ngram = lowercase.(ngram)
    # println(ngram)
        if lexicalgravitypair(ngram[1], ngram[2], lowertextdata) <= 5.5
            println("next")
            intermediatearray = Array{String,1}()
        else
            push!(intermediatearray, ngram[1], ngram[2])
            push!(finalarray, intermediatearray)
            println("ngram")
        
        end 
    end
end