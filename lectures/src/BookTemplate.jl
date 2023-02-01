module BookTemplate

using Reexport: @reexport
@reexport using Books:
    build_all,
    gen
@reexport using DataFrames:
    DataFrame,
    filter!,
    filter,
    select!,
    select

export M, example_dataframe

include("data.jl")

"""
    build()

This function is called during CI.
"""
function build()
    println("Building Example Book")
    # To avoid publishing broken websites.
    fail_on_error = true
    gen(; fail_on_error)
    build_all(; fail_on_error)
end

end # module
