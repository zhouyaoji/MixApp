package com.appdynamics.e2e.mixapp_android;

import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.View;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.Button;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.appdynamics.eumagent.runtime.Instrumentation;

public class MainActivity extends AppCompatActivity {
    final String TAG = MainActivity.class.getName();
    private Button[] btns = new Button[5];

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        Instrumentation.start(PreferenceConstants.EUM_APP_KEY, getApplicationContext(), PreferenceConstants.EUM_COLLECTOR_URL, true);

        Button button = (Button) findViewById(R.id.test_button);
        button.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                new TestHttpRequest("GET").execute("https://www.appdynamics.com");
            }
        });

        // You have to have MixApp containers running for below links to work
        Button java_button = (Button) findViewById(R.id.test_java_button);
        java_button.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                new TestHttpRequest("GET").execute(PreferenceConstants.END_POINT_URL + ":3003/");
            }
        });

        Button php_button = (Button) findViewById(R.id.test_php_button);
        php_button.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                new TestHttpRequest("GET").execute(PreferenceConstants.END_POINT_URL + ":3002/");
            }
        });

        Button python_button = (Button) findViewById(R.id.test_python_button);
        python_button.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                new TestHttpRequest("GET").execute(PreferenceConstants.END_POINT_URL + ":3001/");
            }
        });

        Button nodejs_button = (Button) findViewById(R.id.test_nodejs_button);
        nodejs_button.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                new TestHttpRequest("GET").execute(PreferenceConstants.END_POINT_URL + ":3000/");
            }
        });

    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    private void logRequestHeaders(HttpURLConnection connection) {
        Map<String, List<String>> requestHeaders = connection.getRequestProperties();
        Set<String> requestKeys = requestHeaders.keySet();

        for (String k : requestKeys)
            Log.d(TAG, "Request Key: " + k + "  Value: " + requestHeaders.get(k));
    }

    private void logResponseHeaders(HttpURLConnection connection) {
        Map<String, List<String>> responseHeaders = connection.getHeaderFields();
        Set<String> responseKeys = responseHeaders.keySet();

        for (String k : responseKeys)
            Log.d(TAG, "Response Key: " + k + "  Value: " + responseHeaders.get(k));
    }

    private class TestHttpRequest extends AsyncTask<String, Void, String> {
        private String m_Method = "";
        private String m_Body = "";

        private int m_ConnectTimeout = 10000;
        private int m_ReadTimeout = 15000;

        TestHttpRequest(String method) {
            m_Method = method;
            List<String> supportedMethods  = Arrays.asList("GET", "POST");
            if (! supportedMethods.contains(m_Method)) {
                throw new IllegalArgumentException("Method not supported: " + m_Method);
            }
        }

        public void setM_Body(String m_Body) {
            this.m_Body = m_Body;
        }

        @Override
        protected String doInBackground(String... params) {
            URL url = null;
            HttpURLConnection connection = null;
            String responseBody = null;
            StringBuffer sb = new StringBuffer();

            try {
                url = new URL(params[0]);

                connection = (HttpURLConnection) url.openConnection();

                connection.setRequestMethod(m_Method);
                connection.setConnectTimeout(m_ConnectTimeout);
                connection.setReadTimeout(m_ReadTimeout);
                connection.setDoInput(true);

                Log.d(TAG, m_Method + " " + url);
                logRequestHeaders(connection);

                connection.connect();
                int response = connection.getResponseCode();
                Log.d(TAG, "Status Code: " + response);

                logResponseHeaders(connection);

                InputStream in = new BufferedInputStream(connection.getInputStream());
                BufferedReader br = new BufferedReader(new InputStreamReader(in));
                String inputLine = "";
                while ((inputLine = br.readLine()) != null) {
                    sb.append(inputLine);
                }
                responseBody = sb.toString();
            }
            catch (MalformedURLException ex) {
                Log.d(TAG, ex.getMessage());
            }
            catch (Exception e) {
                Log.d(TAG, e.getMessage());
            }
            finally {
                connection.disconnect();
            }

            return responseBody;
        }

        @Override
        protected void onPostExecute(String s) {
            super.onPostExecute(s);
            //Log.d(TAG, "Response: " + s );
        }
    }

    private class TestHttpPost extends AsyncTask<String, Void, String> {
        @Override
        protected String doInBackground(String... params) {
            return null;
        }
    }
}
