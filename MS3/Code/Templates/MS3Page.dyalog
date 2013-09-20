:Class MS3Page : #.MiPage

    ∇ Wrap;lang
      :Access Public
      Use'Everything'
      Add HTML.title _Request.Server.Config.Name
      (Add HTML.link).SetAttr(('href' '/Styles/style.css')('rel' 'stylesheet')('type' 'text/css'))
      (Add HTML.meta).SetAttr'http-equiv="content-type" content="text/html;charset=UTF-8"'
      Body.Push HTML.div'id="contentblock"'
      (Add HTML.div(#.HTMLInput.APLToHTML ⎕SRC⊃⊃⎕CLASS ⎕THIS)).SetAttr'id="codeblock" style="display: none;"'
      Add _HTML.Script'$(function(){$("#bannerimage").on("click", function(evt){$("#contentblock,#codeblock").toggle();});});'
      Add #.Files.GetText _Request.Server.Root,'Styles\footer.txt'
      (Body.Push #.Files.GetText _Request.Server.Root,'Styles\banner.txt').Push HTML.div'id="wrapper"'
      lang←_Request.Server.Config.Lang ⍝ use the language specified in Server.xml
      Content.SetAttr'lang="',lang,'" xml:lang="',lang,'" xmlns="http://www.w3.org/1999/xhtml"'
      _Request.Response.HTML←⎕BASE.Render
    ∇

:EndClass