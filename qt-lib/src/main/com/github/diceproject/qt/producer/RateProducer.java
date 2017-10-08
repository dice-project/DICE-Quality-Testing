package com.github.diceproject.qt.producer;

import com.ameliant.tools.kafka.perftool.config.*;
import com.ameliant.tools.kafka.perftool.drivers.ConsumerDriver;
import com.ameliant.tools.kafka.perftool.drivers.ProducerDriver;
import com.ameliant.tools.kafka.perftool.drivers.TestProfileRunner;
import com.ameliant.tools.kafka.testdsl.config.ConsumerConfigsBuilder;
import com.ameliant.tools.kafka.testdsl.config.ProducerConfigsBuilder;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import org.apache.kafka.common.serialization.ByteArrayDeserializer;
import org.apache.kafka.common.serialization.ByteArraySerializer;

public class RateProducer {

	private static final long serialVersionUID = 1L;

	TestProfileDefinition testProfileDefinition;
	int numWorkers;
	int messageCount;
	int messageSize;
	ProducerDefinition prodDef;

	/* initialize kafka producer for manual configuration */
	public RateProducer() {
		numWorkers = 1;
		messageCount = 1;
		messageSize = 1024;
		//		testProfileDefinition = new TestProfileDefinition();
		prodDef = new ProducerDefinition();
	}

	/* max duration in seconds */
	public void setMaxDuration(int maxDuration) {
		//		testProfileDefinition.setMaxDuration(maxDuration);
	}

	public void setWorkers(int workers) {
		numWorkers = workers;
	}

	public void setMessageCount(int msgCount) {
		messageCount = msgCount;
	}

	public void setMessageSize(int msgSize) {
		messageSize = msgSize;
	}

	public void setAutogenerateTopic(boolean autogenerateTopic) {
		testProfileDefinition.setAutogenerateTopic(autogenerateTopic);
	}


	public void run(String url, String topic) {
		this.run(url, topic, null);			
	}

	public void run(String url, String topic, String messageLocation) {		

		CountDownLatch latch;

		if (numWorkers>1) {
			latch = new CountDownLatch(numWorkers);
		} else {
			latch = new CountDownLatch(2);
		}
		// fill up the topic
		Map<String, Object> producerConfigs = new ProducerConfigsBuilder()
		.bootstrapServers(url)
		.keySerializer(ByteArraySerializer.class)
		.valueSerializer(ByteArraySerializer.class)
		.batchSize(0)
		.build();

		ProducerDefinition producerDefinition = new ProducerDefinition();
		producerDefinition.setConfig(producerConfigs);
		producerDefinition.setTopic(topic);
		producerDefinition.setMessageSize(messageSize);
		producerDefinition.setMessagesToSend(messageCount);
		producerDefinition.setSendBlocking(true);
		producerDefinition.setMessageLocation(messageLocation);

		ProducerDriver producerDriver = new ProducerDriver(producerDefinition, latch);

		try {
			if (numWorkers>1) {
				ExecutorService executorService = Executors.newFixedThreadPool(numWorkers);
				executorService.submit(producerDriver);
			} else {
				producerDriver.run();
			}
		} catch (ArrayIndexOutOfBoundsException e) {
			System.out.println("QT-LIB Error: Input JSON file exhausted. Try decreasing the message count.");
		}

	}
}
