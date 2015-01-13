using PEGParser

# for testing purposes
# using DataFrames

@grammar csv begin
  start = list(record, crlf)
  record = list(field, comma)
  field = escaped_field | unescaped_field
  escaped_field = dquote + escaped_field_value + dquote
  escaped_field_value = (r"[ ,\n\r!#$%&'()*+\-./0-~]+" | dquote2)
  unescaped_field = r"[ !#$%&'()*+\-./0-~]+"
  crlf = r"[\n\r]+"
  dquote = '"'
  dqoute2 = "\"\""
  comma = ','
end


function toarrays(node::Node, cvalues, ::MatchRule{:default})
  if length(cvalues) == 1
    return cvalues[1]
  end

  return cvalues
end

toarrays(node::Node, cvalues, ::MatchRule{:escaped_field_value}) = node.value
toarrays(node::Node, cvalues, ::MatchRule{:unescaped_field}) = node.value


data = """
1,2,3
4,5,6
this,is,a,"test"
"""

(ast, pos, error) = parse(csv, data)
# println(ast)
result = transform(toarrays, ast, ignore=[:dquote, :dquote2, :comma, :crlf])
println("---------------")
println(result)
