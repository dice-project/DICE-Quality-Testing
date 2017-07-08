package com.github.dice-project.qt.examples;

import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import com.github.dice-project.qt.QTLoadInjector;
import com.github.dice-project.qt.spout.RateSpout;
import com.github.dice-project.qt.spout.RateSpout.ArrivalMode;
import com.github.dice-project.qt.spout.RateSpout.DataMode;
import com.github.dice-project.qt.util.LoadConfigProperties;
import org.apache.storm.Config;
import org.apache.storm.StormSubmitter;
import org.apache.storm.topology.TopologyBuilder;
import org.apache.storm.topology.IRichSpout;

public class BasicExclamationTopology {
	public static void main(String[] args) throws Exception {

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
		conf.registerMetricsConsumer( org.apache.storm.metric.LoggingMetricsConsumer.class, 1);
		StormSubmitter.submitTopology("topology-qt", conf, builder.createTopology());

	}
}

