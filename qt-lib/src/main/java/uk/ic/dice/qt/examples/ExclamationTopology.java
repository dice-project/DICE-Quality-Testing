package uk.ic.dice.qt.examples;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import uk.ic.dice.qt.QTLoadInjector;
import uk.ic.dice.qt.spout.RateSpout;
import uk.ic.dice.qt.spout.RateSpout.ArrivalMode;
import uk.ic.dice.qt.spout.RateSpout.DataMode;
import org.apache.storm.Config;
import org.apache.storm.StormSubmitter;
import org.apache.storm.topology.TopologyBuilder;
import org.apache.storm.topology.IRichSpout;
import org.apache.storm.generated.KillOptions;
import org.apache.storm.generated.Nimbus.Client;
import org.apache.storm.utils.NimbusClient;
import org.apache.storm.utils.Utils;
import uk.ic.dice.qt.util.DMONBoltCapacityMonitor;

public class ExclamationTopology {

	public static void main(String[] args) throws Exception {
		String timeStampDate = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
		String timeStampTime = new SimpleDateFormat("HH:mm:ss.000").format(new Date());
		String tStart = timeStampDate + "T"+ timeStampTime + "Z";
		double maxBoltCapacity = 1.0;
		double curMaxBoltCapacity = 0.0;

		int numExperiments = 4;
		for (int topologyId=1; topologyId<=numExperiments; topologyId++) {

			/* Storm topology builder */
			TopologyBuilder builder = new TopologyBuilder();  

			/* Load custom property file */
			Integer qtSpoutParallelism = 1;
			Integer qtSpoutNumTasks = 1;  
			String  qtSpoutName = "word-spout";
			Map<String, Object> confSpout = new HashMap<String, Object>();
			confSpout.put("spout", "spout");

			/* Create QT-LIB's Spout factory */
			QTLoadInjector qt = new QTLoadInjector();

			/* Obtain a spout to inject at prescribed rates specified in a CSV file */
			RateSpout qtSpout = (RateSpout) qt.getRateSpout(); 

			ArrivalMode am = ArrivalMode.ParseCount;
			qtSpout.setArrivalMode(am);
			qtSpout.setRateScaler(topologyId*1.0);
			switch (am) {
			case ParseIat : {
				qtSpout.setArrivalFile("iats.txt");	
			} break;
			case ParseRate : {
				qtSpout.setArrivalFile("rates.txt");	
			} break;
			case ParseCount : {
				qtSpout.setArrivalFile("counts.txt");	
			} break;
			default:
				break;
			}

			DataMode dm = DataMode.ParseJSON;
			qtSpout.setDataMode(dm);
			switch (dm) {
			case ParseJSON :{
				qtSpout.setDataFile("test.json");
			}break;
			case ParseTimedJSON :{
				qtSpout.setDataFile("test.json");
				qtSpout.setTimeField("publicationTime");
			}break;
			default: // for all Rand modes
				qtSpout.setDataVolume(1024);
				break;
			}

			/* Install spout */
			builder.setSpout(qtSpoutName, (IRichSpout) qtSpout, qtSpoutParallelism).addConfigurations(confSpout).setNumTasks(qtSpoutNumTasks);

			/* Install bolts */	
			builder.setBolt("exclaim1", new ExclamationBolt(), 1).shuffleGrouping(qtSpoutName).setNumTasks(1);
			builder.setBolt("exclaim2", new ExclamationBolt(),2).shuffleGrouping("exclaim1").setNumTasks(2);

			/* Configure and start topology */
			Config conf = new Config();
			conf.setDebug(true); // this is to get debugging information in logs
			conf.setNumWorkers(1);    
			//conf.registerMetricsConsumer( org.apache.storm.metric.LoggingMetricsConsumer.class, 1);
			StormSubmitter.submitTopology("topology-qt"+topologyId, conf, builder.createTopology());

			/* Let the topology run for the specified time then kill it*/
			int topologyDuration = 600;
			/*try{
				Thread.sleep(topologyDuration*1000);
			}catch(InterruptedException e){
				System.out.println("got interrupted!");
			}

			/* Kill the last topology 
			Map stormConf = Utils.readStormConfig();
			Client client = NimbusClient.getConfiguredClient(stormConf).getClient();
			KillOptions killOpts = new KillOptions();
			client.killTopologyWithOpts("topology-qt", killOpts); //provide topology name
			*/

			/* time before running the next topology 
			int topologySleep = 30;
			try{
				Thread.sleep(topologySleep*1000);
			}catch(InterruptedException e){
				System.out.println("got interrupted!");
			}
			*/

			/* determine maximal bolt capacity */
			timeStampDate = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
			timeStampTime = new SimpleDateFormat("HH:mm:ss.000").format(new Date());
			String tEnd = timeStampDate + "T"+ timeStampTime + "Z";		
			int maxDMONRecords = 100;
			String DMONurl = "http://109.231.122.229:5001";
			//curMaxBoltCapacity = DMONBoltCapacityMonitor.getDMONkey(DMONurl, tStart, tEnd, maxDMONRecords);
			System.out.println("Topology: " + topologyId + " Start: " + tStart + " End: " + tEnd + " Current Bolt Capacity: "+curMaxBoltCapacity);
			if (curMaxBoltCapacity>=maxBoltCapacity) {
				System.out.println("Current bolt capacity is "+ curMaxBoltCapacity + " and exceeds the maximum bolt capacity: " + maxBoltCapacity + " STOPPING experiment.");
				return;
			}
		}
	}
}

