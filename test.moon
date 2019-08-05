import krai from require 'krai'

print krai =>
  @load_css "styles.css"

  @group "friaul", =>
    @title "Moonscript Expanded"
    @text "hey"