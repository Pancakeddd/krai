import krai from require 'krai'

print krai =>
  @load_css "css/style.css"

  @group "friaul", =>
    @title "Moonscript Expanded"
    @text "hey"