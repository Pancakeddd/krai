rem_nl = (s) ->
  string.sub s, 1, #s-1

indent = (i, s) ->
  ind = ""
  for j = 1, i
    ind ..= " "
  ind .. s\gsub "\n", "\n#{ind}"

str = (s) ->
  "\"#{s}\""

class Line
  new: (@value) =>
  add_data: (@data) =>
  add_context: (@context) =>
  nl: => @nll = true
  is_block: =>
    @isblock = "\n"

  -- Renders line
  render: =>
    s = ""
    if @context
      d = do
        buf = " "
        if @data
          for k, v in pairs @data
            buf ..= "#{k}=#{v} "
        rem_nl buf
      if @nll
        s ..= "<#{@context}#{d or ""}>\n#{@isblock or ""}#{do indent 2, @value}\n</#{@context}>"
      else
        s ..= "<#{@context}#{d or ""}>#{@isblock or ""}#{do @value}</#{@context}>"
    s

class Literal extends Line
  render: =>
    @value

class SmallLine extends Line
  render: =>
    s = ""
    if @context
      d = do
        buf = " "
        if @data
          for k, v in pairs @data
            buf ..= "#{k}=#{v} "
        rem_nl buf
      s ..= "<#{@context}#{d or ""}>"
    s

class Kraibuffer
  new: =>
    @bodybuffer, @headbuffer = {}, {}

  -- Pushes line to the body buffer
  push_body: (s) =>
    @bodybuffer[#@bodybuffer+1] = s

  -- Pushes line to the head buffer
  push_head: (s) =>
    @headbuffer[#@headbuffer+1] = s

  -- Pushes string to top of buffer
  text: (s) =>
    @push_body with Line s
      \add_context "p"

  -- Title line
  title: (t) =>
    @push_body with Line t
      \add_context "h1"

  link: (a, l) =>
    @push_body with Line a
      \add_context "a"
      \add_data href: str l

  load_css: (name) =>
    @push_head with SmallLine!
      \add_context "link"
      \add_data 
        rel: str "stylesheet"
        href: str name

  group: (f0, f1) =>
    name = nil
    f = do
      if type(f0) == "string"
        name = f0
        f1
      else
        f0
    k = Kraibuffer!
    f k
    @push_body Literal "<div#{do " class=" .. str name if name else ""}>
#{indent 2, k\render k.bodybuffer}
</div>"

  list: (lst) =>
    line = Line do 
      s = ""
      for l in *lst
        if type(l) == "string"
          s ..= "<li>#{l}</li>\n"
      rem_nl s
    line\add_context "ul"
    line\nl!
    @push_body line

  render: (buffer) =>
    s = ""
    for b in *buffer
      s ..= b\render! .. do
        if _index_0 < #buffer
          return "\n"
        else
          ""
    s

  render_body: =>
    s = @render @bodybuffer
    "<body>
#{indent 2, s}
</body>"

  render_header: =>
    s = @render @headbuffer
    "<head>
#{indent 2, s}
</head>"

  render_final: =>
    "<!DOCTYPE html>
<html>
#{indent 2, @render_header! .. "\n" .. @render_body!}
</html>"
    


krai = (f) ->
  k = Kraibuffer!
  f k
  k\render_final!

{:krai}