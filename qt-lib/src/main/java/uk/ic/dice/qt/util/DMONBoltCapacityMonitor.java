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
public class DMONBoltCapacityMonitor {
	public static List<String> DMONkeys = Arrays.asList("bolts_0_capacity", "bolts_1_capacity");

	public static double recurJSON(JSONObject jsonObj) {
		Double maxcapacity = new Double(0.0);
		Iterator<?> keys = jsonObj.keys();
		while( keys.hasNext() ) {
			String key = (String)keys.next();		    
			if ( jsonObj.get(key) instanceof JSONObject ) {
				JSONObject o = (JSONObject) jsonObj.get(key);

				for (String pattern : DMONkeys) {				
					if (o.has(pattern)) {
						//System.out.println(pattern + ":"+ o.get(pattern).toString());
						maxcapacity = Double.max(maxcapacity,Double.parseDouble(o.get(pattern).toString()));
					}
				}				
				maxcapacity = Double.max(maxcapacity, recurJSON(o));
			}
			else if ( jsonObj.get(key) instanceof JSONArray ) {
				JSONArray a = (JSONArray) jsonObj.get(key);
				List<String> list = new ArrayList<>();		    	
				for (int i=0; i<a.length(); i++) {
					//System.out.println("\nA: " + a.get(i).toString());
					if (a.get(i) instanceof JSONObject) {
						maxcapacity = Double.max(maxcapacity,recurJSON((JSONObject)a.getJSONObject(i)));
					}
				}

			}
		}
		return maxcapacity;		
	}

	public static double getMaxCapacity(String url , String t0, String t1, int maxDMONRecords) throws Exception {
		double maxcapacity = 0;
		URL object = new URL(url + "/dmon/v1/observer/query/json");

		String myJSON = "{\"DMON\":{\"fname\":\"output\",\"ordering\":\"desc\",\"queryString\":\"NOT _type=collectd\",\"size\": "+maxDMONRecords+",\"tstart\":\""+t0+"\",\"tstop\":\""+t1+"\"}}";

		HttpURLConnection con = (HttpURLConnection) object.openConnection();
		con.setDoOutput(true);
		con.setDoInput(true);
		con.setRequestProperty("Content-Type", "application/json");
		con.setRequestProperty("Accept", "application/json");
		con.setRequestMethod("POST");

		OutputStreamWriter wr = new OutputStreamWriter(con.getOutputStream());
		wr.write(myJSON);
		wr.flush();

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
			String t0 = "2017-03-04T12:19:30.000Z";
			String timeStampDate = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
			String timeStampTime = new SimpleDateFormat("HH:mm:ss.000").format(new Date());
			String t1 = timeStampDate + "T"+ timeStampTime + "Z";
			System.out.println(t1);
			t1 = "2017-03-04T12:20:00.000Z";
			int maxDMONRecords = 100;			
			double maxcapacity = getMaxCapacity("http://109.231.122.229:5001", t0, t1, maxDMONRecords);
			System.out.println("Max Bolt Capacity: "+maxcapacity);
		}
		catch (Exception e) {
			e.printStackTrace();
		}
	}
}
