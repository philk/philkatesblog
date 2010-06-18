Hatta take a ride with Dreamhost
--------------------------------

I've been looking for a personal wiki off and on for a little while now and finally began searching in earnest in the last few days.  I've heard great things about maintaining your own personal wiki but never really found much use for one.  I've mainly survived using [Evernote](http://www.evernote.com) as my external brain but it doesn't really have a good way to handle code.  There are various snippets that I need to refer to from time to time and Evernote just doesn't love the formatting and doesn't support syntax highlighting.  One of the premium features is being able to attach any file types to the notes but that just seems...inelegant?  There's also the issue of Linux.  Recently I've been using [ArchLinux](http://www.archlinux.org) at home and while Evernote has clients for Windows, Mac, and iPhone it's still missing a Linux client (and running it via Wine is a terrible experience).  So a personal wiki seemed like it might be what I was looking for.  At worst I just might learn something!

[GitWiki](http://atonie.org/2008/02/git-wiki) is actually what started me along this path so I gave it the first shot.  Ultra minimalist, uses git as the backend, markdown or textile.  No syntax highlighting, extremely limited web interface, Ok...maybe some things are a bit too minimalist even for me.  [Daniel Mendler (minad)](http://github.com/minad) has an [amazing fork](http://github.com/minad/git-wiki) that it looks like some serious time went into.  I actually used it for a couple days and almost went with it but as near as I could tell there was no way I was getting it to run on Dreamhost's Rack configuration.  It also felt like a little _too_ much of a good thing.

Then I got the silly idea that maybe I could rewrite GitWiki from scratch (since I really only wanted a basic feature set) so I spent a couple days writing my own custom git-wiki from bits and pieces collected from other forks.  I managed to get it basically functional (syntax highlighting mostly working and weird issues with RDiscount and Maruku) but I started to feel like I was reinventing the wheel so I shelved it and started looking for a pre-built wiki.  I'm not asking for much, just a nice simple personal wiki for my code:

### Requirements 

* **Support syntax highlighting**  
Since syntax highlighting is one of my main reasons for even setting up this wiki this is the most important point.  There's a ton of different ways to do syntax highlighting as I found out. 

* **Support Markdown or something similarly easy**  
  I like [Markdown](http://daringfireball.net/projects/markdown/).  It's simple.  It's easy.  All the cool kids are doing it.  And it's highly functional.  I write this blog with Jekyll and Markdown.  Learning a special wiki syntax doesn't really appeal to me that much.  (Though [Creole](http://www.wikicreole.org/) isn't bad) 

* **Provide a web interface**   
  Being able to view it when I'm away from any of my computers or my phone seems like it might be advantageous.  The editing from a webpage thing might be nice but it's not important to me, so even a static site generator like Jekyll (but for wikis) wouldn't be too bad.

* **Ability to sync to a local copy**  
  I'm online 90% of the time and probably more like 100% of the time when I'm coding but I'd still like to be able to make local copies of my wiki with ease.  I'm also a pretty big git fan.  Something about DVCS and git in particular really spoke to me.  It's such a great way to manage file version history.  It's super fast and reliable (and I'm afraid [Linus will make fun of me](http://www.youtube.com/watch?v=4XpnKHJAok8) if I use anything else).

* **Be accessible from any platform I use**  
  I move around a lot (Windows and Mac at work, Linux at home, iPhone out and about) and after fighting with VIM for a few weeks have finally gotten a setup where I can code from anywhere (previously I was tied to my Macbook Pro and TextMate).  I want a wiki I can access from anywhere.

I took these requirements and proceeded to repeatedly bash my head into [wikimatrix](http://www.wikimatrix.org) for the next few hours.  I bounced from one wiki to another but there was always at least one major problem with every single one I tried.

* [Pimki](http://pimki.rubyforge.org/): Rails 1.0?  Last updated in 2004?  Dead project.  
* [Gitit](http://gitit.net/): Haskell is cool (well XMonad is cool, Haskell hurts my weak brain).  It also uses something called [highlighting-kate](http://johnmacfarlane.net/highlighting-kate/) <strike>which sounds cool but doesn't support Bash or Ruby syntax.  Deal breaker.</strike> (<em>Update:</em> I was apparently mistaken, kate does support Ruby and Bash.  See this [comment](http://philkates.com/2009/11/hatta-with-passenger-on-dreamhost/#comment-57040582).)
* [ikiwiki](http://ikiwiki.info/): This actually looks like a wiki that was made in Perl.  It looks, sounds, and feels too much like Perl.  Everything on that wiki just seems needlessly complicated to me.
* [Wagn](http://www.wagn.org/): I think I'd appreciate their completely off the wall fresh take on wikis if I understood wikis better in the first place.  This one felt like I'd have to learn a new religion before I could properly use it.
* [MoinMoin](http://moinmo.in/): If I was going to set up a semi-major group wiki I might use this.  It feels like MediaWiki but with less pain.  There's a Ruby syntax parser available but I couldn't get it to work and didn't feel like fighting anymore.  It also still felt like more than I wanted.
* [OddMuse](http://www.oddmuse.org/): Have I mentioned I don't like Perl?  This one actually looked OK but I couldn't find anything about syntax highlighting and I wasn't really in the mood to dig much at this point.
* [Instiki](http://instiki.org/show/HomePage): I like the layout.  I like that it's in Rails.  I liked how easy it was to get set up.  But no syntax highlighting (yet).  This one was way up on my list and I'm definitely going to keep my eye on it since it seems actively developed.  If I knew Rails better I'd work on hacking decent syntax highlighting in to it myself.

I eventually got so fed up that I'd pretty much given up and done Dreamhost's one-click install of MediaWiki and was starting through the configuration but my elitism reared it's head and forced me to stop (I can't justify my hatred of MediaWiki but I'm pretty sure it's not just because it's popular).

I decided to do just a few more google searches and this time I found a little Python based wiki called [Hatta](http://hatta-wiki.org/).  It grabbed me right off the bat by being minimalist but not ugly.  I quickly checked to see that it was using a decent syntax highlighter and was delighted to find it uses pygments (which as near as I can tell might just be inventing languages to highlight at this point).  It uses Mercurial which I've never used before but it's a DVCS and I've heard good things about it and was willing to try.  I went to install it and found that it has straight-forward [docs](http://hatta-wiki.org/Usage) and even better, a pre-built Mac app for easy testing and local operation.  Its markup is a hybrid of Creole and Markdown which I can deal with.  At this point I was wary as I'd been let down by other wikis but this looked like it could be the one.  I spent the next 30 minutes creating a wiki and everything just seemed to work exactly like I wanted it to.

Then I decided to get it set up on Dreamhost...

Now I've been a long time Dreamhost user.  I understand that I'm going to run into problems whenever I try to do anything that isn't raw HTML or a simple PHP page, but I think I was feeling brave coming off my [recent success](2009/10/jquery-ruby-form-arrays/) getting Sinatra working with Passenger.  Let's just say it was a bit of a rabbit hole.

Hatta requires Python 2.5 or greater, Dreamhost is on Python 2.4.  Hatta also requires [Werkzeug](http://werkzeug.pocoo.org/) and [Mercurial](http://www.selenic.com/mercurial/) which means getting setuptools installed.  I found out after running around in circles for a bit that it also requires python-bz2 which doesn't compile by default on Dreamhost's servers because they're missing lib-bz2 (why?).  Anyways, here's the basic setup that seems to be working for me:

### Disclaimer:  I really don't know what I'm doing and generally rely on luck.  If this breaks something or if Dreamhost gets mad at you it's not my fault.  You're the one listening to the crazy person's blog.

Set your PATH up so that $HOME/bin is the first directory in your path, like this:

**.bashrc**

    export PATH=$HOME/bin:$PATH

**Install lib-bz2**
{% highlight bash %}
mkdir $HOME/Source
cd $HOME/Source
wget http://www.bzip.org/1.0.5/bzip2-1.0.5.tar.gz
tar zxvf bzip2-1.0.5.tar.gz
cd bzip2-1.0.5
make
make install PREFIX=$HOME
{% endhighlight %}

I had to log out of my Dreamhost session and back in before compiling Python or I would get an error about missing the bits for the bz2 module.  So go ahead and do that now. (I know there's a command for refreshing the libs but I can never remember it).

**Install Python 2.6**
{% highlight bash %}
cd $HOME/Source
wget http://www.python.org/ftp/python/2.6.4/Python-2.6.4.tgz
tar zxvf Python-2.6.4.tgz
cd Python-2.6.4
./configure --prefix=$HOME
make
make install
{% endhighlight %}

If you see a bit about:

    Failed to find the necessary bits to build these modules:
    bz2

Then something went wrong with lib-bz2 that I don't understand and maybe I just got lucky.

Log out of your session again and back in.

**Install setuptools**
{% highlight bash %}
cd $HOME/Source
wget http://peak.telecommunity.com/dist/ez_setup.py
python ez_setup.py
{% endhighlight %}

**Setup Werkzeug, Mercurial, and Pygments**
{% highlight bash %}
easy_install Werkzeug
easy_install Mercurial
easy_install pygments
{% endhighlight %}

**Install hatta to your site-packages**
{% highlight bash %}
cd $HOME/Source
wget http://hg.hatta-wiki.org/hatta/archive/1.3.3.zip
unzip 1.3.3.zip
cd 1.3.3
python setup.py install
{% endhighlight %}

Go into your Dreamhost management panel and go to Manage Domains.  Add a new domain or subdomain and make sure to check Passenger under Web Options.  Give that five to ten minutes and check to see that the directory now exists.

We'll use hatta.philkates.com for this example, but since that's my domain and you can't have it, change it when you actually do this.  Go ahead and create the pages and cache directories and I'll try to explain what that passenger\_wsgi.py file is in a second.

    hatta.philkates.com
    |-public/
    |-pages/
    |-cache/
    |-passenger_wsgi.py

passenger\_wsgi.py is the file you create to tell Dreamhost's server that you're serving a Passenger site and how to actually do that.  This is what's working for me.  It's based on the [example](http://hatta-wiki.org/WSGI%20setup) from the Hatta site and the tip at the bottom of [this Dreamhost Wiki article](http://wiki.dreamhost.com/Passenger_WSGI#Passenger_WSGI_and_virtualenv).  Change where it says USERNAME to your user name and change the domain to your actual domain.

**passenger\_wsgi.py**

{% highlight python %}
# This sets the python interpreter to use your local Python 2.6
import sys, os
INTERP = "/home/USERNAME/bin/python"
if sys.executable != INTERP: os.execl(INTERP, INTERP, *sys.argv)

# XXX Uncomment and edit this if hatta.py is not installed in site-packages
# sys.path.insert(0, "/path/to/hatta/")
import hatta

config = hatta.WikiConfig(
        pages_path='/home/USERNAME/hatta.philkates.com/pages/', # XXX Edit this!
        cache_path='/home/USERNAME/hatta.philkates.com/cache/', # XXX Edit this!
)
config.parse_args()
config.parse_files()
config.sanitize()
wiki = hatta.Wiki(config)
application = wiki.application
{% endhighlight %}

Assuming I'm not crazy or just lucky this should work and you should now have a nice friendly Hatta interface to work from.

You can also sync back and forth with Mercurial.  I could have these commands wrong since I'm more git than Mercurial but they seem to work.

{% highlight bash %}
hg clone ssh://USERNAME@yourdomain.com/~/hatta.yourdomain.com/pages/
{% endhighlight %}

Now in that pages directory you can do `hg pull` or `hg push` to pull the latest changes or push your local changes up.  Then you run `hg update` in the directory that just received the changes to update the file system (Hatta won't show the new pages until you do this).  I'm assuming that Mercurial has something like git's post-receive hooks but I haven't investigated that part too much yet.

Any problems, questions, or suggestions please let me know.