:Namespace _HTML
⎕IO ⎕ML ⎕WX←1 1 3

    :class Table : #.HtmlElement

        :field public Data←0 0⍴⊂''
        :field public Header←0 0⍴⊂''
        :field public Ids←0             ⍝ generate ids for cells?
        :field public DataAttr←''       ⍝ data attributes, see below
        :field public HeaderAttr←''     ⍝ header attributes, see below
        :field public HeaderRows←0      ⍝ number of header rows
        :field public TableAttr←''      ⍝ table attributes

        ∇ Make0
          :Access public
          :Implements constructor
        ∇

        ∇ Make1 params
          :Access public
          :Implements constructor
          params←eIs params
          (Data HeaderRows TableAttr DataAttr HeaderAttr Ids)←6↑params,(⍴params)↓(0 0⍴⊂'')0 '' '' '' 0
        ∇

        ∇ html←Render;t;h;hdr;th;body;d;td
          :Access public
          t←⎕NEW HTML.table(''TableAttr)
          :If 0≠HeaderRows
              Header←HeaderRows↑[1]Data
          :EndIf
          :If ~0∊⍴Header
              h←(¯2↑1 1,⍴Header)⍴Header
              hdr←t.Add HTML.thead
              th←⎕NEW¨(⍴h)⍴HTML.th
              th.Content←h
              :If ~0∊⍴HeaderAttr
                  th.SetAttr(⍴h)⍴ParseAttr HeaderAttr
              :EndIf
              (hdr.Add¨(1⊃⍴h)⍴HTML.tr).Add↓th
          :EndIf
          :If ~0∊⍴d←HeaderRows↓[1]Data
              body←t.Add HTML.tbody
              td←⎕NEW¨(⍴d)⍴HTML.td
              td.Content←d
              :If ~0∊⍴DataAttr
                  td.SetAttr(⍴d)⍴ParseAttr DataAttr
              :EndIf
              :If 0≢Ids
                  prefix←{⎕ML←0 ⋄ ' '=1↑∊⍵:⍵ ⋄ ''}Ids
                  td.SetAttr(⊂⊂'id'),¨{prefix,'r',(⍕⍺),'c',⍕⍵}/¨⍳⍴d
              :EndIf
              (body.Add¨(1⊃⍴d)⍴HTML.tr).Add↓td
          :EndIf
          html←t.Render
        ∇

    :endclass

    :class Submit : #.HTML.input

        ∇ make args;value;name
          :Access public
          :Implements constructor :base
          args←eIs args
          (name value)←2↑args,(⍴args)↓'submit' 'submit'
          SetAttr('name'name)('type' 'submit')('value'value)
        ∇

    :endclass

    :class Script : #.HTML.script

        :field public File←''
        :field public Code←''

        ∇ Make0
          :Access public
          :Implements constructor
        ∇

        ∇ Make1 params
          :Access public
          :Implements constructor
          params←eIs params
          Code File←2↑params,(⍴params)↓'' ''
        ∇

        ∇ html←Render
          :Access public
          (t←⎕NEW HTML.script).SetAttr('type' 'text/javascript')
          :If ~0∊⍴File
              t.SetAttr('src'File)
          :ElseIf ~0∊⍴Code
              t.Content←Code
          :EndIf
          html←t.Render
        ∇

    :endclass

    :class Form : #.HTML.form
        :field public Method←'post'
        :field public Action←''

        ∇ make action
          :Access public
          :Implements constructor
          Action←action
        ∇

        ∇ r←Render
          :Access public
          Attr['action' 'method']←Action Method
          r←⎕BASE.Render
        ∇

    :endclass




:EndNamespace 