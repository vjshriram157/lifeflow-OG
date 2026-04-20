<%@ page import="java.io.*, java.net.*, org.json.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>AI Connectivity Diagnostic</title>
    <style>
        body { font-family: sans-serif; background: #0f172a; color: #f1f5f9; padding: 20px; }
        .card { background: #1e293b; padding: 20px; border-radius: 8px; border: 1px solid #334155; }
        .success { color: #22c55e; }
        .error { color: #ef4444; }
        pre { background: #000; padding: 10px; border-radius: 4px; overflow-x: auto; }
    </style>
</head>
<body>
    <div class="card">
        <h2>🤖 AI Connectivity Diagnostic</h2>
        <hr style="border-color: #334155;">
        
        <%
            String key = "AIzaSyBcXsRdHozNeQi3o62zUyvvzTwB0UISQpU"; // User provided key
            String urlStr = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=" + key;
            
            out.println("<p>Testing Key: <code>" + key.substring(0, 8) + "...</code></p>");
            
            try {
                URL url = new URL(urlStr);
                HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                conn.setRequestMethod("POST");
                conn.setRequestProperty("Content-Type", "application/json");
                conn.setDoOutput(true);
                
                JSONObject part = new JSONObject();
                part.put("text", "hi");
                JSONObject content = new JSONObject();
                content.put("parts", new JSONArray().put(part));
                JSONObject payload = new JSONObject();
                payload.put("contents", new JSONArray().put(content));
                
                OutputStream os = conn.getOutputStream();
                os.write(payload.toString().getBytes("utf-8"));
                os.flush();
                
                int code = conn.getResponseCode();
                out.println("<p>Response Code: <strong class='" + (code == 200 ? "success" : "error") + "'>" + code + "</strong></p>");
                
                InputStream is = (code == 200) ? conn.getInputStream() : conn.getErrorStream();
                BufferedReader br = new BufferedReader(new InputStreamReader(is, "utf-8"));
                StringBuilder res = new StringBuilder();
                String line;
                while ((line = br.readLine()) != null) res.append(line);
                
                out.println("<h4>Raw Response:</h4>");
                out.println("<pre>" + res.toString() + "</pre>");
                
                if (code == 200) {
                    out.println("<h3 class='success'>✅ Connectivity Test PASSED!</h3>");
                    out.println("<p>The Gemini API is reachable and the key is valid.</p>");
                } else {
                    out.println("<h3 class='error'>❌ Connectivity Test FAILED.</h3>");
                    out.println("<p>Check the error message above for details.</p>");
                }
                
            } catch (Exception e) {
                out.println("<h3 class='error'>❌ Exception occurred:</h3>");
                out.println("<pre>" + e.toString() + "</pre>");
            }
        %>
        
        <hr style="border-color: #334155;">
        <p><strong>Next Steps:</strong> If this test passes but the chatbot is still offline, please <strong>restart your Tomcat/Jetty server</strong> to ensure the new <code>ChatServlet</code> logic is loaded.</p>
    </div>
</body>
</html>
