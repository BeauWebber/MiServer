:Namespace Mortgage
    ⎕IO ⎕ML←1 1

    ∇ pay←CalcPMT prt;n;p;r
      :Trap 0
          (p r n)←prt÷1 1200(÷12)       ⍝ Convert from annual to monthly
          pay←0.01×⌈100×p×r÷1-(1+r)*-n  ⍝ Compute Payment
      :Else ⋄ pay←0
      :EndTrap
    ∇

    ∇ prin←CalcPrin rnm;n;p;m;r
      :Trap 0
          (r n m)←rnm÷1200(÷12)1        ⍝ Convert annual to monthly (m=payMent)
          prin←0.01×⌈100×m÷r÷1-(1+r)*-n ⍝ Compute Principle
      :Else ⋄ prin←0
      :EndTrap
    ∇

:EndNamespace 