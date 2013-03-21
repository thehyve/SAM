<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="sammain"/>
        <title>${module} Home</title>
        <script>
            $(function() {
                $( "#faq" ).accordion({ autoHeight: false, collapsible: true, active: false, header: 'h3' });
            });
        </script>
    </head>

    <body>
        <div id="data" style="position: relative;">
            <div style="width: 65%; ">
                <h1>Introduction ${module}</h1>
                <p>${platformtext}</p>
            </div>
            <div id="faq" style="position: absolute; right: 0px; top: 0px; width: 30%;">
                <h1>Frequently Asked Questions</h1>
                <g:render template="faq" />
            </div>
        </div>
    </body>
</html>
