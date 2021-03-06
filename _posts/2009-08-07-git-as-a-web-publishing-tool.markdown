---
title: Git for Web Publishing
---

I've been using [git](http://git-scm.com/) for awhile as my main version control system and was thinking of how you can push a repository to a remote site (usually for sharing that repository between developers) which made me think about how I could use that to push out the latest updates a website I'm working on.  I found out that some people don't recommend this but I couldn't find a reason that really mattered to me (it's an extremely low traffic static site).

Holy crap was it harder than it should be.  Here's how I did it (I'm assuming you already know a bit about git and honestly this is mostly notes for me to remember how I did it):

Setup git locally
-----------------

I'm not going through the local install because that's dependent on your OS but I'll point you in the right direction.  If you're on Windows I recommend [msysgit](http://code.google.com/p/msysgit/) on OSX use [MacPorts](http://www.macports.org/) and Linux use your package manager. Once it's installed open a terminal window and go to your development folder, then create a local git repo, add all the current files, commit the current state like this:

{% highlight bash %}
git init
git add .
git commit -m "Initial Commit"
{% endhighlight %}
	
Congratulations, you've now got git setup locally.


Setup git on your server
------------------------

I'm using Dreamhost and their version of git was quite out of date which caused me quite the headache as to why things weren't working the way they were supposed to.  So in case you've got a similar issue here's how I updated git on Dreamhost 
([Based on this setup](http://blog.marcoborromeo.com/how-to-install-gitosis-on-a-dreamhost-shared-account)).

{% highlight bash %}
wget http://kernel.org/pub/software/scm/git/git-1.6.4.tar.gz
tar zxvf git-1.6.4.tar.gz
cd git-1.6.4
./configure --prefix=$HOME NO_MMAP=1
make
make install
{%endhighlight%}
	
You've just installed git to your $HOME path so now you have to add that new bin folder to your PATH variable like this:

{% highlight bash %}
echo "export PATH=$HOME/bin:$PATH" >> ~/.bash_profile
{% endhighlight %}
	
You'll need to log out and back in for this to take effect.


Setup git repo on your server
-----------------------------

Thanks to [this tutorial](http://toroid.org/ams/git-website-howto) for the outline of how to do this.

Create a directory to host the git repo and create a directory to host the live site.  We'll create pretend folders here:

{% highlight bash %}
mkdir /home/phil/website.git && mkdir /home/phil/website
{% endhighlight %}
	
Change to the website.git directory and initialize the git repo.  We're also going to disable a warning message (we want everything to get overwritten whenever we push an update)

{% highlight bash %}
git --git-dir=. --work-tree=/home/phil/website init
git config receive.denycurrentbranch ignore
{% endhighlight %}	

Now create a post-receive hook to will checkout the files to the worktree after every push.  Edit the file "/home/phil/website.git/hooks/post-receive" so it has this line in it:

{% highlight bash %}
git checkout -f
{% endhighlight %}

Now make it executable:

{% highlight bash %}
chmod +x hooks/post-receive
{% endhighlight %}

Now here's the part that frustrated me for hours.  Every single time I did this then pushed to the repo it ended up putting all the files into the parent folder (/home/phil) instead of the folder I told it to.  Edit the git config file (/home/phil/website.git/config) and change the line that says:

{% highlight apacheconf %}
[core]
	worktree = /home/phil/website
{% endhighlight %}
		
instead it should be:

{% highlight apacheconf %}
[core]
	worktree = /home/phil/website/.
{% endhighlight %}
		
I don't know why since every tutorial I can find says it should just work, but this actually does work for me so I'll use it.


Add Remote and Push
-------------------

Back on your local workstation we need to set it up to push to the new server repo we set up.  That goes like this (from the git directory)

{% highlight bash %}
git remote add web ssh://username@servername.com/home/phil/website.git
git push web +master:refs/heads/master
{% endhighlight %}
	
Hopefully all went well and you can see your site in the /home/phil/website directory.  From now on to update all you've got to do is make your changes, then commit them, then push to the web repo.

{% highlight bash %}	
git commit -a -m "Commit message here"
git push web
{% endhighlight %}

	
Disclaimer:
-----------

I honestly have no idea what I'm doing so make sure you back up any data before you try to follow my instructions.  I'm not responsible if git decides to eat all your data and kick your puppies.