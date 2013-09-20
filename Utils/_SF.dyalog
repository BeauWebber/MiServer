:Namespace _SF

    :class sfChart
        :field public Title←''
        :field public Data
        :field public XTitle←''
        :field public YTitle←''
        :field public Size
        :field public Id
        :field public JQpars←''

        ∇ r←Render
          :Access public
          r←('div id="',Id,'"')#.HTMLInput.Enclose''
          JQpars←'size:{width:800}'
         
          r,←#.JQO.sfChart Id(Title XTitle YTitle)Data JQpars
        ∇

    :endclass

:EndNamespace 