using PEGParser

@grammar mlgrammar begin
  start = sexpr
  sexpr  = "(" + list(expr, white_space) + ")"
  expr = r"[0-9]+"
  white_space = r"[ \t\n]+"
end
