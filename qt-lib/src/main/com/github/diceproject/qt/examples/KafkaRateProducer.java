package com.github.dice_project.qt.examples;

import com.github.dice_project.qt.QTLoadInjector;
import com.github.dice_project.qt.producer.RateProducer;

public class KafkaRateProducer {
	
	public static void main(String[] args) {
		QTLoadInjector QT = new QTLoadInjector();
		String input_file = "test.json"; // this is assumed to be a resource of the project jar file
		
		RateProducer RP;
		RP=QT.getRateProducer();
		String topic = "dice3"; // topic get created automatically
		String bootstrap_server = "localhost:9092";
		
		// random message data - default is to send a single message
		RP.run(bootstrap_server, topic);
		
		// random message data
		RP.run(bootstrap_server, topic);
		
		RP.setMessageCount(1);
		// data from jsonfile
		RP.run(bootstrap_server, topic, input_file);

		// data from jsonfile -- this is going to read more data than available in the json file, looping
		RP.setMessageCount(101);
		RP.run(bootstrap_server, topic, input_file);
		

	}

}
