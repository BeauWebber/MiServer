:Class MiPage : #.HtmlPage

    :Field Public Instance _PageName←'' ⍝ Page file name
    :Field Public Instance _PageDate←'' ⍝ Page saved date
    :field Public Instance _Request     ⍝ HTTPRequest

    ∇ Make
      :Access public
      :Implements constructor :Base
    ∇

    ∇ Make1 req
      :Access public
      _Request←req
      :Implements constructor :base
    ∇


    ∇ Wrap
      :Access public instance
      _Request.Response.HTML←⎕BASE.Render
    ∇

    ∇ Use x;n;ind;t
      :Access public instance
      :If 0≠⎕NC⊂'_Request.Server.Config.Resources'
      :AndIf ~0∊n←1↑⍴_Request.Server.Config.Resources
          :If n≥ind←_Request.Server.Config.Resources[;1]⍳⊂x
              :If ~0∊⍴t←{(~0∘∊∘⍴¨⍵)/⍵}(⊂ind 2)⊃_Request.Server.Config.Resources
                  {(Add HTML.script).SetAttr('src'⍵)}¨t
              :EndIf
              :If ~0∊⍴t←{(~0∘∊∘⍴¨⍵)/⍵}(⊂ind 3)⊃_Request.Server.Config.Resources
                  {(Add HTML.link).SetAttr(('href'⍵)('rel' 'stylesheet')('type' 'text/css'))}¨t
              :EndIf
          :Else
              1 _Request.Server.Log Page,' references unknown resource: ',x
          :EndIf
      :EndIf
    ∇

    ∇ Close session ⍝ Called when the session ends
      :Access Public Instance
    ∇

:EndClass
