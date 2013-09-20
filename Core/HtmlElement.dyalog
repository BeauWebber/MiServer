:class HtmlElement             ⍝ this is the most basic element of a page

    ⎕io←⎕ml←1

    :field public NL←⎕ucs 13 ⍝ 10

    :field public Tag          ⍝ this is the element name
    :field public Content←''   ⍝ this is a series of strings/instances/class+parms
    :field public HTML
    :field public _HTML
    :field public _JQ
    :field public _SF
    :field public _JQM


    UNDEF←⎕NULL
    :field public id←UNDEF
    :field public value←UNDEF
    :field public name←UNDEF
    :field public class←UNDEF
    :field public hidden←UNDEF
    :field public style←UNDEF
    :field public title←UNDEF

    _names←_values←0⍴⊂''

    ∇ r←eIs w
      :Access public
      r←{⊂⍣(1≡≡⍵)+⍵}w
    ∇

    :section Attribute Handling

    :property keyed Attr       ⍝ element attributes
    :access public
        ∇ set ra;i;new;there;ind
          there←~new←(⍴_names)<i←_names⍳ind←eIs⊃ra.Indexers
          (_values _names),←new∘/¨ra.NewValue ind
          _values[there/i]←there/ra.NewValue
        ∇
        ∇ r←get ra;i;n
          ⎕SIGNAL(1<⍴i←ra.Indexers)⍴4 ⍝ RANK err
          :If 1↑ra.IndexersSpecified
              r←(_values,⊂'')[_names⍳n←eIs⊃⍣(2≤|≡i)+i]
          :Else
              r←↓_names,[1.1]_values
          :EndIf
        ∇
    :endproperty


    ∇ del←ParseAttr arg;split
      :Access public shared
⍝ Parse html sttributes
⍝ The result is Doubly Enclosed List of pairs of strings (del)
     
⍝ The argument comes in various formats:
⍝ - in a doubly enclosed list of pairs (no work to do)
⍝ - an even number of strings alternating attr and value
⍝ - in a list of strings each attr=value
⍝ - in a string of attr=value
     
      →0/⍨3≡|≡del←arg ⍝ no further checks, better be all pairs of strings
     
      split←{a←~v←∨\'='=⍵ ⋄ (a/⍵)({'"'∧.=∊1 ¯1↑¨⊂⍵:¯1↓1↓⍵ ⋄ ⍵}1↓v/⍵)}
      :If 2≡|≡arg
          :If ∧/'='∊¨arg ⍝ attr=value in each
              del←split¨del
          :Else
              del←↓((0.5×⍴arg),2)⍴arg
          :EndIf
      :Else ⍝ assume this is one big string of attr=values
          del←split¨{⎕ML←3 ⋄ (⍵≠' ')⊂⍵}arg
      :EndIf
    ∇

    ∇ {r}←SetAttr attr
      :Access public
      attr←ParseAttr attr
      Attr[1⊃¨attr]←2⊃¨attr
      r←⎕THIS
    ∇

    ∇ r←CommonAttributes
      r←'abcdefghijklmnopqrstuvwxyz'⎕NL ¯2.2
    ∇

    :endsection

  ⍝                     The constructors

  ⍝ The first arg is the Tag, followed by its contents, then its attributes, if present
  ⍝ Note that attributes can be specified with the tag as in
  ⍝  button type="submit"

    :section Constructors

    ∇ Make0
      :Implements constructor
      :Access public
      Init
    ∇

    ∇ Make1 t    ⍝ this can be any length
      :Implements constructor
      :Access public
      Tag←t
      Init
    ∇
    ∇ Make2(t arg);attr;content            ⍝ attributes can be added here
      :Implements constructor
      :Access public
      :If 0∧.≡≡¨t arg                      ⍝ handle 2-character tag (e.g. 'ul' 'tr')
          Tag←t,arg
      :Else
          :If 1<|≡arg
              (content attr)←arg
              :If ~0∊⍴attr
                  SetAttr attr
              :EndIf
          :Else
              content←arg
          :EndIf
          Tag←t
          Add content
      :EndIf
      Init
    ∇
    ∇ Make3(t content attr)       ⍝ elements and attributes added here
      :Implements constructor
      :Access public
      :If 0∧.≡≡¨t content attr    ⍝ handle 3-character tag (e.g. 'pre')
          Tag←t,content,attr
      :Else
          Tag←t
          Add content
          :If ~0∊⍴attr
              SetAttr attr
          :EndIf
      :EndIf
      Init
    ∇

    ∇ Init
      (HTML _HTML _JQ _SF _JQM)←#.(HTML _HTML _JQ _SF _JQM)
    ∇

    :endsection

    :section Rendering

⍝ Elements with no End tag (<tag></tag>).

⍝ area base basefont br col frame hr img input isindex link meta param

    NoEndTagElements←'area'  'base'  'basefont'  'br'  'col'  'frame'  'hr'  'img'  'input'  'isindex'  'link'  'meta'  'param'

    fmtAttr←{' ',⍺,'=',Quote HtmlSafeText,⍕⍵}

    ∇ r←Render;av;t;vs;e
      :Access public
    ⍝ Render by first constructing the Tag, complete with attributes, if any
      av←Tag
      :For e :In CommonAttributes
          av,←{0::'' ⋄ UNDEF≡t←⍎⍵:'' ⋄ e fmtAttr t}e
      :EndFor
      :If 0<⍴vs←Attr[]
          av,←∊fmtAttr/¨vs
      :EndIf
      r←av Enclose Compose Content
    ∇

    ∇ r←Postrender r
      :Access overridable
    ∇

    ∇ r←Compose list;e
      :Access public
    ⍝ This is the fn that does the bulk of the rendering work
    ⍝ It lays down the look of each element
      r←''
      :For e :In Eis list
          r,←{326=⎕DR ⍵:⍵.Render ⋄ ⍕⍵⊣÷≡⍵}e ⍝ ** TEMP: ÷≡⍵ to detect simple scalars: there should be none
      :EndFor
    ∇

    ∇ r←HtmlSafeText txt;i;m;u;ucs
    ⍝ make text HTML "safe"
      r←,⎕FMT txt
      i←'&<>"#'⍳r
      i-←(i=1)∧1↓(i=5),0 ⍝ mark & that aren't &#
      m←i∊⍳4
      u←127<ucs←⎕UCS r
      (m/r)←('&amp;' '&lt;' '&gt;' '&quot;')[m/i]
      (u/r)←(~∘' ')¨↓'G<&#ZZZ9;>'⎕FMT u/ucs
      r←∊r
    ∇

    :endsection

    :section Utilities

    Bracket←{'<',⍵,'>'}

    ∇ r←tag Enclose txt;nl
      :Access public
      tag←,tag
      r←(tag{(0∊⍴⍵)∧NoEndTagElements∊⍨⊂t←⍺↑⍨¯1+⍺⍳' ':Bracket ⍺,'/' ⋄ (Bracket ⍺),⍵,Bracket'/',t}txt),NL
    ∇

    ∇ r←Eis w
      :Access public
      r←⊂⍣((326∊⎕DR w)<2>|≡w),w ⍝ enclose if simple and not mixed
    ∇

    ∇ r←Quote a;b
      :Access public
      b←1↓<⌿¯1 0⌽'\"'∘.=';',a   ⍝ keep \" as is
      (b/a)←⊂'&quot;'
      r←1⌽'""',∊a
    ∇

    ∇ {r}←Push args;c;cl;attr;elm
      :Access public
      :If ~0∊⍴r←args
          (cl attr)←{2↑⍵,(⍴⍵)↓'' ''}eIs args
          c←Content
          :If isClass cl
              elm←⎕NEW cl
              elm.Content←c
              :If ~0∊⍴attr
                  elm.SetAttr attr
              :EndIf
              Content←elm
          :ElseIf 0∊⍴attr
              Content,⍨←⊂cl
          :Else
              'Invalid Push arguments'⎕SIGNAL 11
          :EndIf
      :EndIf
      r←⎕THIS
    ∇

    ∇ {r}←Add args;cl
    ⍝ add "something" to the Content
    ⍝ args can be an instance, a class, or just html/text
      :Access public
      :If ~0∊⍴r←args
          :If isClass cl←⊃args
              Content,←r←⎕NEW∘{2<⍴,⍵:(⊃⍵)(1↓⍵) ⋄ ⍵}Eis args
          :Else
              Content,←r←Eis args
          :EndIf
      :EndIf
    ∇

    ∇ {r}←Last
      :Access public
      r←⊃⌽Content
    ∇

    ∇ r←isClass ao
      :Access public
      r←9.4∊⎕NC⊂'ao'
    ∇

    ∇ r←isInstance ao
      :Access public
      r←9.2∊⎕NC⊂'ao'
    ∇

    ∇ r←isHtmlElement ao
      :Access public
      :Trap r←0
          r←⊃∨/#.HtmlElement=⎕CLASS ao
      :EndTrap
    ∇

    ∇ r←Parse string;b;s
    ⍝ Separate each section of name="..."
      :Access public
      string←(b⍲1⌽b←' '=s)/s←' ',string
      b←(' '=string)>≠\'"'=string
      r←1↓¨b⊂string ⍝ each pair
      s←r⍳¨'='      ⍝ each is separated by =
      r←s{(¯1↓⍺↑⍵)(1↓¯1↓⍺↓⍵)}¨r
    ∇
    :endsection

:endclass  ⍝ HtmlElement