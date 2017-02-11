package uk.ic.dice.qt.examples;


import java.util.Map;

import backtype.storm.topology.OutputFieldsDeclarer;
import backtype.storm.tuple.Fields;
import backtype.storm.tuple.Tuple;
import backtype.storm.tuple.Values;

import backtype.storm.task.OutputCollector;
import backtype.storm.task.TopologyContext;
import backtype.storm.topology.base.BaseRichBolt;


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
	  

