:class HtmlPage

    :field public Content
    :field public Head
    :field public Body
    :field public Scripts
    :field public HTML  ⍝ shortcut to #.HTML
    :field public _HTML ⍝ shortcut to #._HTML
    :field public _JQ   ⍝ shortcut to #._JQ
    :field public _SF
    :field public _JQM

    ∇ make
      :Access public
      :Implements constructor
      Init
    ∇

    ∇ r←Render
      :Access public
      Body.Add Scripts
      r←'<!DOCTYPE html>',Content.Render
    ∇

    ∇ Init
      :Access public
      (HTML _HTML _JQ _SF _JQM)←#.(HTML _HTML _JQ _SF _JQM)
      Content←⎕NEW HTML.html
      (Head Body)←Content.Add¨HTML.head HTML.body
      Scripts←''
    ∇

    ∇ {r}←{loc}Add what
      :Access public
        ⍝ loc can override where the element is placed (0 where it belongs, 1 head, 2 body, 3 end of body)
      loc←{6::0 ⋄ loc}0
      :Select loc
      :Case 0
              ⍝ elements that belong exclusively or primarily in the <head> element
          :If isClass⊃what
          :AndIf ⊃∨/(⎕CLASS⊃what)∊¨⊂HTML.(title style meta link script noscript base)
              r←Head.Add what
          :Else
              r←Body.Add what
          :EndIf
      :Case 1
          r←Head.Add what
      :Case 2
          r←Body.Add what
      :Case 3
          Scripts,←what ⋄ r←what
      :EndSelect
    ∇

    ∇ r←isClass ao
      :Access public
      r←9.4∊⎕NC⊂'ao'
    ∇

:endclass