jQuery, Ruby, and Multidimensional Forms
========================================

I just had to open my big mouth and suggest that I do a RSVP system for my wedding website.  Oh, I'll do the form with the jQuery and the ruby and it'll be dynamic and it'll be easy!

I wanted a simple table style layout with headers above the fields and any arbitrary number of duplicate fields below.  Essentially it would show up on the page like this:
	
	First Name:	Last Name:	Email:		Attending:
	John		Smith		john@smith.com	Yes
	---------------------------------------------------------------
				Add Row		Submit
						
and could potentially grow (as you hit the Add Row button) to end up like this:

	First Name:	Last Name:	Email:		Attending:
	John		Smith		john@smith.com	Yes
	Mary		Smith		mary@smith.com	Yes
	Susie		Smith		sue@smith.com	Yes
	---------------------------------------------------------------
				Add Row		Submit

This should be easy, right?  I'm sure if you know what you're doing it probably is, but Googling multidimensional forms or array of forms or any number of other combination of search terms didn't seem to be getting me anywhere.  I thought maybe I could do an array of forms (so imagine each row as a separate `<form>`).  That would've been extremely complicated with the jQuery forms plugin I was using.  Getting multiple forms to submit from one button apparently isn't too hard but you have to chain them and I couldn't think of a way to do that when I'm dealing with an arbitrary number of forms.  I tried naming the form inputs in sequence (like: 

{% highlight html %}
<input name="first_name1">
{% endhighlight %}

but when I serialized them I just got 

{% highlight javascript %}
{"first_name1": "John", "first_name2": "Mary", "first_name3": "Susie"}...
{% endhighlight %}

and I really didn't feel like writing a parser to pull that out (and couldn't find one via Google).  
	
No there had to be a way to get an array of arrays out of that where I could get a JSON array for each row.  I eventually stumbled across a few posts where people mentioned PHP getting an array from $_POST when the values are named like: 

{% highlight html %}
<input name="data[0][first_name]">
<input name="data[1][first_name]">
{% endhighlight %}
	
That's great for PHP but if you feed that into Ruby's CGI you get something similar to the flat JSON array.  Lucky for me I'd been using Sinatra lately as my local test server and realized that it seemed to be getting a nice nested hash when I posted that value through.  Apparently "multidimensional form inputs" are really called "nested parameters".  Once I posted that data into Sinatra I got a nice hash like this:

{% highlight ruby %}
{"0"=>{"first_name" => "John", "last_name" => "Smith"}, "1" => {"first_name" => "Mary", "last_name" => "Smith"}}...
{% endhighlight %}

Perfect.  But these are all static files with no real need for something like Sinatra.  I did some more digging and couldn't find anything about handling nested parameters with just CGI so I gave up and just set up [Sinatra on Dreamhost](http://railstips.org/2008/12/15/deploying-sinatra-on-dreamhost-with-passenger).  I was going to need to send the data to a DB anyway and I had an email signup that was running through CGI that I can now just make a simple post to a DB.  It's not like this is going to be an incredibly popular site getting millions of hits a second.  Sinatra seems to be working fine for what I need and I'm a big fan of using not necessarily the _right_ tool but the tool that gets the job done.