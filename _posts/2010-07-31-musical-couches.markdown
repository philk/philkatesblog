There's this idea I've been rolling around for the last couple weeks that seems like it would have a lot more potential if it wasn't just rolling around in my head.

CouchDB has interested me for awhile, primarily because of the "eventual consistency" replication.  What's something that people like to have synced?  Their music collection.  How cool would it be if you had your desktop at home (or your NAS, CouchDB is pretty light) running a couch that had all of your music stored in it with all the correct information that could sync automatically to your laptop or your phone (at least Android currently).  You could use Couch's filtered replication to only sync selected tracks to your different devices and it would all happen immediately when both devices are accessible on your LAN (you could even do it across the net if you had the bandwidth and the right ports open).

Because Couch has such a simple API (what programming language can't access HTTP?) there could be desktop clients written in any language on any platform:

* Slaving away at you locked down work computer?  Access a webapp in your browser.
* Macbook Pro in a coffee shop?  Use that snazzy Cocoa app that connects to your local couch.
* Driving around town?  Pop open the Android app that accesses either your local or remote couches.

This seems like a really cool idea.  Selectively synced music across multiple systems is kind of an unsolved problem.  I'm not sure how crazy it is though and there are still a lot of questions to be answered.

This idea is license under the "If you use this idea to make something awesome I'd totally be cool with that" license.