package uk.ic.dice.qt.util;
import java.text.SimpleDateFormat;
import java.util.*;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;

import org.json.JSONArray;
import org.json.JSONObject;

/*
curl -H "Content-Type: application/json" -XPOST http://109.231.122.229:5001/dmon/v1/observer/query/json -d '{"DMON":{"fname":"output","ordering":"desc","queryString":"NOT _type=collectd","size": 100,"tstart":"2017-03-04T12:19:30.000Z","tstop":"2017-03-04T12:20:00.000Z"}}'
 */
public class StormUICapacityMonitor {
	public static List<String> DMONkeys = Arrays.asList("capacity");

	public static double recurJSON(JSONObject jsonObj) {
		Double maxcapacity = new Double(0.0);
		Iterator<?> keys = jsonObj.keys();
		while( keys.hasNext() ) {
			String key = (String)keys.next();		    
			if ( jsonObj.get(key) instanceof JSONArray ) {
				JSONArray a = (JSONArray) jsonObj.get(key);

				List<String> list = new ArrayList<>();		    	
				for (int i=0; i<a.length(); i++) {
					if (a.get(i) instanceof JSONObject) {
						JSONObject y = (JSONObject)a.getJSONObject(i);
						if (y.has("capacity")){
							maxcapacity = Double.max(maxcapacity, new Double(y.getString("capacity")));
						}
					}
				}

			}
		}
		return maxcapacity;		
	}

	public static String getId(String url, String topologyName) throws Exception {
		// obtained the Id of a topology given its name using the Storm UI
		String encodedId = new String("");
		URL object = new URL(url + "/api/v1/topology/summary");

		HttpURLConnection con = (HttpURLConnection) object.openConnection();
		con.setDoOutput(true);
		con.setDoInput(true);
		con.setRequestProperty("Content-Type", "application/json");
		con.setRequestProperty("Accept", "application/json");
		con.setRequestMethod("GET");

		StringBuilder sb = new StringBuilder();  
		int HttpResult = con.getResponseCode(); 
		if (HttpResult == HttpURLConnection.HTTP_OK) {
			BufferedReader br = new BufferedReader(
					new InputStreamReader(con.getInputStream(), "utf-8"));
			String line = null;  
			while ((line = br.readLine()) != null) {  
				sb.append(line + "\n");  
			}
			br.close();			
			JSONObject jsonObj = new JSONObject("" + sb.toString());		
			JSONArray a = (JSONArray) jsonObj.get("topologies");
			List<String> list = new ArrayList<>();		    	
			for (int i=0; i<a.length(); i++) {
				if (a.get(i) instanceof JSONObject) {
					JSONObject jsonTopology = (JSONObject) a.get(i);
					if (jsonTopology.get("name").equals(topologyName)) {
						encodedId = jsonTopology.get("encodedId").toString();
					}
				}
			}

		} else {
			System.out.println(con.getResponseMessage());  
		}
		return encodedId;
	}

	public static double getMaxCapacity(String url, String encodedId) throws Exception {
		double maxcapacity = 0;
		URL object = new URL(url + "/api/v1/topology/" + encodedId);
		
		HttpURLConnection con = (HttpURLConnection) object.openConnection();
		con.setDoOutput(true);
		con.setDoInput(true);
		con.setRequestProperty("Content-Type", "application/json");
		con.setRequestProperty("Accept", "application/json");
		con.setRequestMethod("GET");

		//display what returns the POST request

		StringBuilder sb = new StringBuilder();  
		int HttpResult = con.getResponseCode(); 
		if (HttpResult == HttpURLConnection.HTTP_OK) {
			BufferedReader br = new BufferedReader(
					new InputStreamReader(con.getInputStream(), "utf-8"));
			String line = null;  
			while ((line = br.readLine()) != null) {  
				sb.append(line + "\n");  
			}
			br.close();
			
			JSONObject jsonObj = new JSONObject("" + sb.toString());
			maxcapacity = recurJSON(jsonObj);
		} else {
			System.out.println(con.getResponseMessage());  
		}
		return maxcapacity;
	}

	// http://localhost:8080/RESTfulExample/json/product/get
	public static void main(String[] args) {
		try {						
			String encodedId = getId("http://localhost:8080", "topology-qt1");
			double maxcapacity = getMaxCapacity("http://localhost:8080", encodedId);
			System.out.println("Max Bolt Capacity (StormUI, topology="+encodedId+"): "+maxcapacity);
		}
		catch (Exception e) {
			e.printStackTrace();
		}
	}
}
