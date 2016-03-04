import java.io.InputStream;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.BufferedReader;
import java.util.List;
import java.util.ArrayList;
import java.net.URL;
import java.net.HttpURLConnection;

public class MixAppLoadGenerator {
    public static void main(String[] args) {
    	List<String> urls = new ArrayList<String>(); 
        String file ="MixAppLoadGenURLs.txt";
        try{
        	//Reading the text file
        	InputStream ips=new FileInputStream(file); 
            InputStreamReader ipsr=new InputStreamReader(ips);
            BufferedReader br=new BufferedReader(ipsr);
            String line;
            while ((line=br.readLine())!=null){
                urls.add(line);
            }
            br.close();
        	for(int j=1;;j++){
        		for(String url : urls) {
        			callHttpClient(url);
        		}
        	}
        } catch(Exception e){
            e.printStackTrace();
        }
    }
    
    public static void callHttpClient(String address) {
        try{
			
		URL serverAddress = new URL(address);
		System.out.println(address);
                HttpURLConnection connection = null;
                connection = (HttpURLConnection) serverAddress.openConnection();
                connection.setRequestMethod("GET");
			//	connection.setRequestProperty("ApicaGUID", "835adskn789534c");
			//	connection.setRequestProperty("appdynamicssnapshotenabled", "false");
                connection.setDoOutput(true);
                connection.setReadTimeout(100000);
                //connection.setReadTimeout(1000);

                connection.connect();


                BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
				//System.out.println(">>>>>>>>>>>>>REQUEST COUNT <<<<<<<<<<<<<<<<<<< "+ (++count));
				connection.disconnect();			
				Thread.sleep(2000);
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
