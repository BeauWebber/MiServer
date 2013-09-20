:Namespace _JQ
    ⎕IO ⎕ML ⎕WX←1 1 3
    :class JQTabs : #.HtmlElement
        :field public Titles←''
        :field public Id←'jquitabs'
        :field public Tabs←''

        ∇ r←Render
          :Access public
          'JQTabs title and content lengths do not match'⎕SIGNAL((⍴Titles)≠⍴Tabs)/5
          r←#.JQUI.Tabs Id Titles(RenderTab¨Tabs)
        ∇

        ∇ r←RenderTab tab;e;t
          :Access public
          r←''
          :For e :In tab
              t←⊃e
              :If isInstance t
              :AndIf isHtmlElement t
                  r,←e.Render
              :ElseIf isClass t
              :AndIf isHtmlElement t
                  r,←(⎕NEW∘{2<⍴,⍵:(⊃⍵)(1↓⍵) ⋄ ⍵}Eis e).Render
              :Else
                  r,←e
              :EndIf
          :EndFor
        ∇
    :endclass

    :class Handler
        :field public Selectors←''
        :field public Delegates←''
        :field public Events←''
        :field public ClientData←''
        :field public Callback←''

        ∇ Make0
          :Access public
          :Implements constructor
        ∇

        ∇ Make1 params
          :Access public
          :Implements constructor
          params←eIs params
          (Selectors Delegates Events ClientData)←4↑params,(⍴params)↓'' '' '' ''
        ∇

        ∇ r←Render;sel;cd
          :Access public
          sel←Selectors
          :If ''≢Delegates
              sel←⊂Selectors Delegates
          :EndIf
          cd←ClientData
          :If ''≢Callback
         
          :EndIf
          :If 0≠⎕NC'_Request.Page'
              r←_Request.Page #.JQ.On sel Events ClientData
          :Else
              r←#.JQ.On sel Events ClientData
          :EndIf
        ∇

    :endclass
:EndNamespace