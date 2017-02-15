# DICE Quality Testing Tools
==============

The DICE quality testing tool is a load generator for streaming workloads that can be used to validity the performance and scalability of stream-based applications.

The tool is composed of two modules: QT-GEN, provided under the *Gen* folder, and QT-LIB, under the *Lib* folder. 

QT-GEN is a tool for generation of traces that are statistically similar to a given JSON trace, but nevertheless non-identical. For example, it is possible to change the volumes of timestamped JSON message as desired and differently across types of messages (e.g., in Twitter data one may scale differently the volumes of tweets and the volumes of retweets). MATLAB sources are also included in the distribution of QT-GEN.

QT-LIB is instead a Java library for workload injection in Apache Storm. The library allows a programmer to install a custom spout that can be used to send random messages or replay a JSON or BSON trace according to user specified rates or time-varying counts.

Please check out the [wiki](https://github.com/dice-project/DICE-Quality-Testing/wiki) for installation and user manuals.

##License##

DICE-FG is licensed under the [BSD 3-clause license][1]

[1]: http://opensource.org/licenses/BSD-3-Clause
