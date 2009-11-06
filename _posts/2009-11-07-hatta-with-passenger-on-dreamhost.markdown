Hatta takes a ride on Dreamhost
-------------------------------

I've been looking for a personal wiki off and on for a little while now and finally began searching in earnest in the last few days.  I've heard great things about maintaining your own personal wiki but never really found much use for one (I mainly use [Evernote](http://www.evernote.com) as my external brain).  Evernote's main problem for me is that it doesn't have a good way to handle code.  I've got various snippets that I need to refer to from time to time and Evernote just doesn't love the formatting and doesn't support syntax highlighting.  I'm a Premium user so I can attach files to the notes but that just seems...inelegant.  Evernote also violates one of guiding principles of portability.  Sure it's available for Windows, Mac, and iPhone...but it's still missing a Linux client (and Wine is a terrible experience).  So a personal wiki seemed to be what I was looking for.

** Requirements ** 
* Support syntax highlighting (since that's the whole point of this exercise)
* Support Markdown or something equally easy as it's markup
* Provide a web interface (even if it's just static files from a generator like Jekyll)
* Ability to sync to a local copy (via version control or some other exotic sync method)
* Be accessible from any platform I use (Windows and Mac at work, Linux at home, iPhone out and about)

Setup a new domain with Passenger enabled.

We'll use wiki.philkates.com for this example, but since that's my domain and you can't have it, change it when you actually do this.

You should now see this directory in your home folder on Dreamhost.  Go ahead and create the pages and cache directories and I'll explain what that passenger_wsgi.py file is in a second.

  wiki.philkates.com
  |-public/
  |-pages/
  |-cache/
  |-passenger_wsgi.py

passenger_wsgi.py is the file you create to tell Dreamhost's server that you're serving a Passenger site and how to actually do that.  This is what's working for me.  It's based on the example from Hatta's site and the tip at the bottom of this [[http://wiki.dreamhost.com/Passenger_WSGI#Passenger_WSGI_and_virtualenv|Dreamhost Wiki article]].

{% highlight python %}
import sys, os
INTERP = "/home/USERNAME/bin/python"
if sys.executable != INTERP: os.execl(INTERP, INTERP, *sys.argv)
# XXX Uncomment and edit this if hatta.py is not installed in site-packages
# sys.path.insert(0, "/path/to/hatta/")
import hatta

config = hatta.WikiConfig(
        pages_path='/home/USERNAME/wiki.philkates.com/pages/', # XXX Edit this!
        cache_path='/home/USERNAME/wiki.philkates.com/cache/', # XXX Edit this!
)
config.parse_args()
config.parse_files()
config.sanitize()
wiki = hatta.Wiki(config)
application = wiki.application
{% endhighlight %}