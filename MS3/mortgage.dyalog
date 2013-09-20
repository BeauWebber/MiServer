:Class mortgage : MiPage

    :Include #.HTMLInput

    ⍝ define fields used by JQ.On to return event information
    :Field Public event         ⍝ the triggered event
    :Field Public what          ⍝ the id, if any, of the element that triggered the event - JQ.On supplies this

    ⍝ define the fields that MiServer will keep up-to-date using form data
    :Field Public prin←'100000' ⍝ principal field
    :Field Public rate←'4.5'    ⍝ rate
    :Field Public term←'30'     ⍝ term (years)
    :Field Public pmt←''        ⍝ payment

    tonum←{{(,1)≡1⊃⍵:2⊃⍵ ⋄ ''}⎕VFI ⍵} ⍝ very simple check for a single number
    calcpmt←{0::'Error' ⋄ p r n←⍵÷1 1200 (÷12) ⋄ .01×⌈100×p×r÷1-(1+r)*-n}
    ⍝ ↑ calculate payment based on principal, rate, and term
    calcprin←{0::'Error' ⋄ r n m←⍵÷1200 (÷12) 1 ⋄ .01×⌈100×m÷r÷1-(1+r)*-n}
    ⍝ ↑ calculate how much you can borrow based on rate, term, and payment

    ∇ html←Render req;inputs;event;selector;returndata ⍝ render the initial page
      :Access Public
     
      :If 0=⍴pmt ⋄ pmt←calcpmt tonum¨prin rate term ⋄ :EndIf ⍝ First calculation
      html←'h2'Enclose'Mortgage Calculator'
      html,←'Modify principal, rate or term to recalculate payment.<br>'
      html,←'Change payment to recalculate the principal.<br><br>'
     
     ⍝ Define a form with input fields
      inputs←1 2⍴'Principal'('prin'Edit prin) ⍝ A label, and an edit field called "prin" containing prin
      inputs⍪←'Interest Rate'('rate'Edit rate)
      inputs⍪←'Term (years)'('term'Edit term)
      inputs⍪←'<b>Payment</b>'('pmt'Edit pmt)
      html,←'id="mortgage"'('POST'Form)Table inputs
     
      selector←'#mortgage input'
      event←'change'
      returndata←'formdata' '#mortgage' 'serialize'
      ⍝ ↑ Return serialized data for form #mortgage as "formdata"
      ⍝ ↑ MiServer maps named data in serialized form data to public fields in the page object
      html,←req #.JQ.On selector event returndata
    ∇

    ∇ resp←APLJax req;p;r;m;n ⍝ respond to AJAX calls
      :Access public
      p r n m←tonum¨prin rate term pmt ⍝ convert input fields to numbers
      resp←''
     
      :Select what ⍝ what field changed?
     
      :CaseList 'prin' 'rate' 'term' ⍝ one of prin rate or term changed, calculate payment
          :If ~∨/{0∊⍴⍵}¨p r n ⍝ if we have values for all inputs...
          ⍝ ... calculate the payment and replace the value attribute in the input element
              resp←('execute'('$("#pmt").val("',(⍕calcpmt p r n),'")'))
          :EndIf
     
      :Case 'pmt' ⍝ payment changed, calculate principal
          :If ~∨/{0∊⍴⍵}¨r n m ⍝ if we have values for all inputs...
          ⍝ ... calculate the principal and replace the value attribute in the input element
              resp←('execute'('$("#prin").val("',(⍕calcprin r n m),'")'))
          :EndIf
     
      :EndSelect
      resp←#.JSON.fromNVP resp
    ∇

:EndClass