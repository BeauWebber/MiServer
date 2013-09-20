:Class OldIndex : MS3Page

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

    ∇ Render;inp;fields;t;tabs;terms;rates;prins;pmts;pmttables;charts;tabcontent
      :Access Public
     
      Init ⍝ clear out any pre-existing content
     
      Add #.OOH.h2'Welcome to MiServer 3.0!'
     
      ⍝ create all input fields and set their names to match the public fields above
      (inp←⎕NEW¨3 3⍴#.OOH.input).SetAttr(⊂⊂'name'),∘⊂¨fields←'prin' 'rate' 'term'∘.,'base' 'incr' 'steps'
      inp.SetAttr⊂('type' 'text')('required' '')
      inp.SetAttr(⊂⊂'value'),∘⊂∘⍕¨3 3⍴prinbase prinincr prinsteps ratebase rateincr ratesteps termbase termincr termsteps
     
      t←⎕NEW #.AAH.Table
      t.Data←'Parameter' 'Base Value' 'Increment' 'Steps'⍪'Principal' 'Interest Rate' 'Term in Years',inp
      t.HeaderRows←1
     
      (Add #.AAH.Form _Request.Page).(Add #.AAH.Table).Data←1 2⍴t(⎕NEW #.AAH.Submit('submit' ' Submit '))
     
      :If {6::0 ⋄ 1⊣submit}⍬ ⍝ did we get a form submission?
          (prins rates terms)←genseries¨↓3 3⍴#.Strings.tonum¨prinbase prinincr prinsteps ratebase rateincr ratesteps termbase termincr termsteps
          pmts←↓prins,[1.1]↓[1]¨1⊂[1]#.Mortgage.CalcPMT¨⊃(∘.,)/prins rates terms  ⍝ pmts is prins x terms for each rate
          pmttables←(rates terms)∘FormatPayments¨pmts
          charts←(rates terms)∘MakeChart¨pmts
          tabs←⎕NEW #.AAH.JQTabs
          tabs.Titles←'$',¨#.Strings.commaFmt prins
          tabs.Tabs←(⎕NEW¨(⍴prins)⍴#.OOH.div).Add↓pmttables,[1.1]charts
          Add tabs
      :EndIf
    ∇

    ∇ r←larg FormatPayments(prin pmts);prins;tab;terms;rates
      :Access public
      (rates terms)←larg
      tab←2 #.Strings.commaFmt pmts
      tab⍪⍨←(⍕¨terms),¨⊂' Years'
      tab,⍨←(⊂'Monthly Payments'),'APR '∘,¨fmtPct¨rates
      r←⎕NEW #.OOH.div(⎕NEW #.AAH.Table(tab 1 'border=1 cellpadding=3 class=centered' 'class=rjust' 'class=rjust'))
      r←r.Render
    ∇

    ∇ r←larg MakeChart(prin pmts);rates;prins;total_interest;terms
      :Access public
      (rates terms)←larg
      total_interest←prin-⍨pmts×[2]12×terms
      r←⎕NEW #.AAH.sfChart
      r.Title←'Total interest for a ',('$',∊#.Strings.commaFmt prin),' loan'
      r.(XTitle YTitle Id)←'Years' 'Total Interest'('chart','.'~⍨⍕prin)
      r.Data←(fmtPct¨rates),[1.1](⊂terms),[1.1]¨↓[2]total_interest
      r←⎕NEW #.OOH.div r
      r←r.Render
    ∇

    genseries←{⍵[1],⍵[1]+⍵[2]×⍳⍵[3]}
    fmtPct←{' '~⍨,'F7.3,<%>' ⎕FMT,⍵}
:EndClass