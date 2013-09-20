:Class Index : MS3Page

    :field public prinbase←100000
    :field public prinincr←25000
    :field public prinsteps←3
    :field public ratebase←2.5
    :field public rateincr←.25
    :field public ratesteps←5
    :field public termbase←10
    :field public termincr←5
    :field public termsteps←4
    :field public submit

    ∇ Render;fields;t;tabs;terms;rates;prins;pmts;pmttables;charts;tabcontent;inputs;button;values;data;form
      :Access Public
     
      Init ⍝ clear out any pre-existing content
     
      Add HTML.h2'Mortgage Calculator'
     
      ⍝ create all input fields and set their names to match the public fields above
      fields←'prin' 'rate' 'term'∘.,'base' 'incr' 'steps' ⍝ prinbase...termsteps
      inputs←⎕NEW¨3 3⍴HTML.input            ⍝ 3x3 array of HTML input fields
      inputs.name←fields
      inputs.SetAttr⊂('type' 'text')('required' '')
      inputs.value←3 3⍴prinbase prinincr prinsteps ratebase rateincr ratesteps termbase termincr termsteps
     
      (t←⎕NEW _HTML.Table).HeaderRows←1
      t.Data←'Parameter' 'Base Value' 'Increment' 'Steps'⍪'Principal' 'Interest Rate' 'Term in Years',inputs
     
      button←⎕NEW _HTML.Submit('submit' ' Submit ')
      form←Add _HTML.Form _Request.Page
      form.(Add _HTML.Table).Data←1 2⍴t button
     
      :If _Request.IsPost
          values←#.Strings.tonum¨prinbase prinincr prinsteps ratebase rateincr ratesteps termbase termincr termsteps
          (prins rates terms)←genseries¨↓3 3⍴values
          data←#.Mortgage.CalcPMT¨⊃(∘.,)/prins rates terms  ⍝ pmts is prins x terms for each rate
          pmts←↓prins,⍪⊂[2 3]data
          pmttables←(rates terms)∘FormatPayments¨pmts
          charts←(rates terms)∘MakeChart¨pmts
          tabs←⎕NEW _JQ.JQTabs                                     ⍝ Tab Control
          tabs.Titles←'$',¨#.Strings.commaFmt prins                ⍝ Tab titles
          tabs.Tabs←(⎕NEW¨(⍴prins)⍴HTML.div).Add↓pmttables,⍪charts ⍝ Tabs with contents
          Add tabs                                                 ⍝ Add tabs to page
      :EndIf
    ∇

    ∇ r←larg FormatPayments(prin pmts);prins;tab;terms;rates
      :Access public
      (rates terms)←larg
      tab←2 #.Strings.commaFmt pmts
      tab⍪⍨←(⍕¨terms),¨⊂' Years'
      tab,⍨←(⊂'Monthly Payments'),'APR '∘,¨fmtPct¨rates
      r←⎕NEW HTML.div(⎕NEW _HTML.Table(tab 1 'border=1 cellpadding=3 class=centered' 'class=rjust' 'class=rjust'))
    ∇

    ∇ r←larg MakeChart(prin pmts);rates;prins;total_interest;terms
      :Access public
      (rates terms)←larg
      total_interest←prin-⍨pmts×[2]12×terms
      r←⎕NEW _SF.sfChart
      r.Title←'Total interest for a ',('$',∊#.Strings.commaFmt prin),' loan'
      r.(XTitle YTitle Id)←'Years' 'Total Interest'('chart','.'~⍨⍕prin)
      r.Data←(fmtPct¨rates),⍪terms∘,¨1⊂⍉total_interest
      r←⎕NEW HTML.div r
    ∇

    genseries←{⍵[1],⍵[1]+⍵[2]×⍳⍵[3]}
    fmtPct←{' '~⍨,'F7.3,<%>' ⎕FMT,⍵}  
            
:EndClass
