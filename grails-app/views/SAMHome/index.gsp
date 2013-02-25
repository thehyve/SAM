<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="sammain"/>
        <title>Home</title>
        <script>
            $(function() {
                $( "#faq" ).accordion({ autoHeight: false, collapsible: true, active: false, header: 'h3' });
            });
        </script>
    </head>

    <body>
        <div id="data" style="position: relative;">
            <div style="width: 65%; ">
                <h1>Introduction ${platform}</h1>
                <p>The Simple Assay Module (SAM) is a module of the Generic Study Capture Framework that can store simple assay data. The Generic Study Capture Framework (GSCF) is an application that can store any biological study.</p>
            </div>
            <div id="faq" style="position: absolute; right: 0px; top: 0px; width: 30%;">
                <h1>Frequently Asked Questions</h1>
                <g:render template="faq" />
            </div>
        </div>
    </body>
</html>
