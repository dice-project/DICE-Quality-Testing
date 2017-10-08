package com.github.diceproject.qt.examples;


import java.util.Map;

import org.apache.storm.topology.OutputFieldsDeclarer;
import org.apache.storm.tuple.Fields;
import org.apache.storm.tuple.Tuple;
import org.apache.storm.tuple.Values;

import org.apache.storm.task.OutputCollector;
import org.apache.storm.task.TopologyContext;
import org.apache.storm.topology.base.BaseRichBolt;


//There are a variety of bolt types. In this case, we use BaseBasicBolt


	  public class ExclamationBolt extends BaseRichBolt {
	    /**
		 * 
		 */
		private static final long serialVersionUID = 1L;
		OutputCollector _collector;


	    public void prepare(Map conf, TopologyContext context, OutputCollector collector) {
	      _collector = collector;
	    }


	    public void execute(Tuple tuple) {
	      _collector.emit(tuple, new Values(tuple.getString(0) + "!!!"));
	      _collector.ack(tuple);
	    }

	
	    public void declareOutputFields(OutputFieldsDeclarer declarer) {
	      declarer.declare(new Fields("word"));
	    }


	  }
	  

