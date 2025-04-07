<pre>const bodyParser = require(&apos;body-parser&apos;)
const cors = require(&apos;cors&apos;)
const express = require(&apos;express&apos;)
const port = process.env.PORT||3000
const app = express()

app.use(bodyParser.json() , cors())

app.get(&apos;/&apos;, (req, res) =&gt; {
    res.send(&apos;Welcome to Nodejs Application Mr.Srikanth&apos;)
 })

app.get(&apos;/hello&apos;, (req, res) =&gt; {
  res.send(&apos;Hello Srikanth!|&apos;)
 })

app.listen(port, () =&gt; console.log(&apos;server is up and running ${port}&apos;))
</pre>
