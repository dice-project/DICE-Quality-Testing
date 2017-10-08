package com.github.diceproject.qt.spout;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.Scanner;

import org.bson.Document;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.RandomStringUtils;

import static org.apache.storm.utils.Utils.tuple;
import org.apache.storm.spout.SpoutOutputCollector;
import org.apache.storm.task.TopologyContext;
import org.apache.storm.topology.OutputFieldsDeclarer;
import org.apache.storm.topology.base.BaseRichSpout;
import org.apache.storm.tuple.Fields;
import org.apache.storm.tuple.Values;
import org.apache.storm.utils.Utils;

public class RateSpout extends BaseRichSpout{

	private static final long serialVersionUID = 1L;

	public static enum DataMode {
		RandText, RandAscii, RandBytes, RandBSON, RandJSON, ParseJSON, ParseTimedJSON, Null,
	};

	public static enum ArrivalMode {
		ParseIat, RandIat, RandIatExp, ParseRate, ParseCount, Null,
	};

	SpoutOutputCollector collector;
	InputStream inputRates;
	transient Scanner scanner;
	List<Integer> iatList; // list of interarrival times
	List<Integer> volList; // list of volumes
	List<String> payloadList; // list of payloads
	int arvCursor;
	int dataCursor;
	int cntCursor;
	long lastEmit;
	long lastTimestamp;
	boolean binaryBDoc;
	ArrivalMode arvMode;
	DataMode dataMode;
	String arvFile;
	String dataFile;
	String timeField;
	int dataVol;
	double rateScaler;
	
	private static final Logger LOG = LoggerFactory.getLogger(RateSpout.class);

	/* initialize spout for manual configuration */
	public RateSpout() {
		setBinaryBDoc(false);
		setRateScaler(1.0);
	}

	/* send 1k of random text at inter-arrival times specified in the given file */
	public RateSpout(String _arvfname) {
		setBinaryBDoc(false);
		setArrivalMode(ArrivalMode.RandIat);
		setArrivalFile( _arvfname);
		setDataMode(DataMode.ParseJSON);
		setDataVolume(1024); //1kB
		setRateScaler(1.0);
	}

	/* send specified amount of random text at inter-arrival times specified in the given file */
	public RateSpout(String _arvfname, int _datavol) {
		setBinaryBDoc(false);
		setArrivalMode(ArrivalMode.RandIat);
		setArrivalFile( _arvfname);
		setDataMode(DataMode.RandText);
		setRateScaler(1.0);
	}

	public void setRateScaler(double _scale) {
		this.rateScaler = _scale;
	}
	
	public void setTimeField(String _field) {
		this.timeField = _field;
	}
	
	public void setBinaryBDoc(boolean val) {
		binaryBDoc = val;
	}
	
	public String getTimeField() {
		return this.timeField;
	}

	public void setArrivalMode(ArrivalMode _arvmode) {
		this.arvMode = _arvmode;
	}

	public void setArrivalFile(String _arvfname) {
		this.arvFile = _arvfname;
	}

	public void setDataMode(DataMode _DataMode) {
		this.dataMode = _DataMode;
	}

	public void setDataFile(String _datafname) {
		this.dataFile = _datafname;
	}

	public void setDataVolume(int _datavol) {
		this.dataVol = _datavol;
	}

	public ArrivalMode getArrivalMode() {
		return this.arvMode;
	}

	public String getArrivalFile() {
		return this.arvFile;
	}

	public DataMode getDataMode() {
		return this.dataMode;
	}

	public String getDataFile() {
		return this.dataFile;
	}

	public int getDataVolume() {
		return this.dataVol;
	}


	private void initData() {
		LOG.info("QTLib started: am = " + getArrivalMode() + ", dm = " + getDataMode());
		arvCursor = 0;
		dataCursor = 0;
		cntCursor = 0;
		lastEmit = System.currentTimeMillis(); // bogus timestamp before first emission
		lastTimestamp = 0;

		switch (getArrivalMode()) {
		case ParseIat: {
			InputStream is = (InputStream) getClass().getResourceAsStream("/" + this.arvFile);
			scanner = new Scanner(is);		
			iatList = new ArrayList<Integer>();
			while (scanner.hasNext()) {
				if (scanner.hasNextInt()) {
					iatList.add(scanner.nextInt());
				} else {
					scanner.next();
				}
			}
		}
		break;
		case ParseRate:{
			iatList = new ArrayList<Integer>();
			volList = new ArrayList<Integer>();
			InputStream is = (InputStream) getClass().getResourceAsStream("/" + this.arvFile);
			scanner = new Scanner(is);		

			while (scanner.hasNext()) {
				int holdTime = scanner.nextInt();
				int rateBytes = scanner.nextInt();
				for (int i=1;i<=holdTime;i++) {
					iatList.add(1000);
					volList.add(rateBytes);
					System.out.println(rateBytes);
				}
			}
			scanner.close();
		}
		break;
		case ParseCount:{
			iatList = new ArrayList<Integer>();
			volList = new ArrayList<Integer>();
			InputStream is = (InputStream) getClass().getResourceAsStream("/" + this.arvFile);
			scanner = new Scanner(is);		

			while (scanner.hasNext()) {
				int holdTime = scanner.nextInt();
				int count = scanner.nextInt();
				for (int i=1;i<=holdTime;i++) {
					iatList.add(1000);
					volList.add(count);
				}
			}
			scanner.close();
		}
		break;
		case RandIat:
			break;
		default:
			break;
		}

		switch (getDataMode()) {
		case ParseJSON:
		case ParseTimedJSON:
			InputStream in = (InputStream) getClass().getResourceAsStream("/"+dataFile);
			payloadList = new ArrayList<String>();
			try {
				payloadList = IOUtils.readLines(in,"UTF-8");
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		case RandBSON:
			break;
		case RandBytes:
			break;
		case RandJSON:
			break;
		case RandText:
			break;
		default:
			break;
		}

	}

	public  void open(@SuppressWarnings("rawtypes") Map arg0, TopologyContext arg1, SpoutOutputCollector arg2) {
		// TODO Auto-generated method stub
		this.collector = arg2;
		initData();		
	}

	public String setMsgId() {
		return "##";
	}

	public void nextTuple() {
		Object msgId= setMsgId();
		@SuppressWarnings("unused")
		long curTime = System.currentTimeMillis();

		switch (getArrivalMode()) {
		case ParseIat: {
			Utils.sleep((long)((double)iatList.get(arvCursor++)/rateScaler));		
			if (arvCursor == iatList.size()) { arvCursor = 0;} // read the iat list cyclically
		} break;
		case RandIat: {
			Random r = new Random();
			Utils.sleep((long)((double)(r.nextDouble()*1000)/rateScaler));
		} break;
		case RandIatExp: {
			Random r = new Random();
			long t = (long)(-(1/1000) * Math.log(r.nextDouble()));
			if (t>1000) { t=1000;}
			Utils.sleep((long)((double)t/rateScaler));
		} break;
		case ParseRate: {
			Utils.sleep((long)((double)iatList.get(arvCursor++)/rateScaler));		
			if (arvCursor == iatList.size()) { arvCursor = 0;} // read the iat list cyclically
			String sentence = RandomStringUtils.randomAlphanumeric(volList.get(dataCursor++));
			if (dataCursor == volList.size()) { dataCursor = 0;} // read the vol list cyclically
			emitOne(msgId, sentence);
			return;
		}
		case ParseCount: {
			Utils.sleep((long)((double)iatList.get(arvCursor++)/rateScaler));
			if (arvCursor == iatList.size()) { arvCursor = 0;} // read the iat list cyclically
			int count = volList.get(cntCursor++);
			if (cntCursor == volList.size()) { cntCursor = 0;} // read the vol list cyclically
			for (int i=0; i<count; i++) {
				emitOne(msgId, null);				
			}
			return;
		}
		default:
			break;
		}

		emitOne(msgId);

	}

	public void emitOne(Object msgId) {
		emitOne(msgId, null);
	}

	public void emitOne(Object msgId, String sentence) {
		switch (getDataMode()) {
		case RandText: {
			if (sentence == null) {	sentence = RandomStringUtils.randomAlphanumeric(dataVol); } 
			LOG.info("random sentence " + sentence);
			collector.emit(new Values(sentence),msgId);
		}
		break;
		case RandAscii: {
			if (sentence == null) {	sentence = RandomStringUtils.randomAscii(dataVol); } 
			LOG.info("random sentence " + sentence);
			collector.emit(new Values(sentence),msgId);
		}
		break;
		case RandBytes: {
			Random r = new Random();
			byte[] bytes = new byte[dataVol];
			r.nextBytes(bytes); 
			LOG.info("" + dataVol + " random bytes: " + bytes);
			collector.emit(tuple(bytes.toString()),msgId);
		}
		break;
		case RandBSON: {
			if (sentence == null) {	sentence = RandomStringUtils.randomAlphanumeric(dataVol); } 
			Document bDoc = new Document("key",sentence);
			LOG.info("random BSON sentence " + bDoc.getString("key"));
			collector.emit(tuple(bDoc.toString()),msgId);
		}
		break;
		case RandJSON: {			
			if (sentence == null) {	sentence = RandomStringUtils.randomAlphanumeric(dataVol); }
			String string_json = "{ 'msg': '" + sentence + "'}";
			Document bDoc = new Document();
			bDoc = Document.parse(string_json);
			LOG.info("BSON document parsed from JSON: " + bDoc.toString());
			collector.emit(tuple(bDoc.toString()),msgId);
		}
		break;
		case ParseJSON: {			
			String string_json = payloadList.get(dataCursor++); 
			if (dataCursor == payloadList.size()) { dataCursor = 0;} // read the data list cyclically
			Document bDoc = new Document();
			bDoc = Document.parse(string_json);
			LOG.info("BSON document parsed from JSON: " + bDoc.toString());
			if (binaryBDoc) {
				collector.emit(tuple(bDoc),msgId);
			} else {
				collector.emit(tuple(bDoc.toString()),msgId);
			}
		}
		break;
		case ParseTimedJSON: {			
			String string_json = payloadList.get(dataCursor++); 
			if (dataCursor == payloadList.size()) { dataCursor = 0;} // read the data list cyclically
			Document bDoc = new Document();
			bDoc = Document.parse(string_json);
			LOG.info("BSON document parsed from JSON: " + bDoc.toString());
			long targetIat;
			if (lastTimestamp >0 ) {
				targetIat = bDoc.getLong(getTimeField()) - lastTimestamp;
				if (targetIat < 0) {
					targetIat = 0;
				}
			}
			else {
				targetIat = 0;
			}
			LOG.debug("new timestamp: " + bDoc.getLong(getTimeField()) + " last timestamp: " + lastTimestamp + " target iat: " + targetIat);
			Utils.sleep((long)((double) targetIat/rateScaler));
			lastTimestamp = bDoc.getLong(getTimeField());
			if (binaryBDoc) {
				collector.emit(tuple(bDoc),msgId);				
			} else {
				collector.emit(tuple(bDoc.toString()),msgId);
			}
		}
		break;
		}
		lastEmit = System.currentTimeMillis();
		LOG.debug("emitted at time " + lastEmit);
	}

	public void declareOutputFields(OutputFieldsDeclarer arg0) {
		// TODO Auto-generated method stub
		arg0.declare(new Fields("str"));	
	}

	public void ack(Object msgId) {
		//	 LOG.info("[ratespout] ack on msgId " + msgId);
	}
}
