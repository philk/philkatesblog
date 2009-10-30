jQuery, Ruby, and Multidimensional Forms
---------------------------------------------------------------

I just had to open my big mouth and suggest that I do a RSVP system for my wedding website.  Oh, I'll do the form with the jQuery and the Ruby and it'll be dynamic and buzzwordy and it'll be easy!

I wanted a simple table style layout with headers above the fields and the ability to have any arbitrary number of duplicate fields below.  Essentially it would show up on the page like this:
	
	First Name:	Last Name:	Email:			Attending:
	John		Smith		john@smith.com		Yes
	-----------------------------------------------------------------------
			Add Row		Submit
						
and could potentially grow (as you hit the Add Row button) to end up like this:

	First Name:	Last Name:	Email:			Attending:
	John		Smith		john@smith.com		Yes
	Mary		Smith		mary@smith.com		Yes
	Susie		Smith		sue@smith.com		No
	-----------------------------------------------------------------------
			Add Row		Submit

This should be easy, right?  I'm sure if you know what you're doing it probably is, but Googling multidimensional forms or form post array or html form array hash any number of other combination of search terms didn't seem to be getting me anywhere.  All I want is an easy to parse data structure like a multidimensional array or an array of hashes.  I tried doing an array of forms (imagine each row as a separate `<form>`).  Until I realized how incredibly complicated that seemed especially with the [jQuery forms plugin](http://jquery.malsup.com/form/) I was using.  Getting multiple forms to submit from one button apparently isn't too hard but to do that you have to chain them and I couldn't think of a way to do that while dealing with an arbitrary number of forms.  
	
Next I tried naming the form inputs in sequence, like:

{% highlight html %}
<input name="first_name0">
<input name="first_name1">
<input name="first_name2">
{% endhighlight %}

but when I serialized them I just got:

{% highlight javascript %}
{"first_name1": "John", "first_name2": "Mary", "first_name3": "Susie"}...
{% endhighlight %}

and I really didn't feel like writing a parser to turn that into easy to use data (and couldn't find one pre-written via Google).
	
No there had to be a way to get an array of arrays out of that where I could get a JSON array for each row.  I eventually stumbled across a few posts where people mentioned PHP getting a nice multidimensional array from $_POST when the values are named like:

{% highlight html %}
<input name="data[0][first_name]">
<input name="data[1][first_name]">
{% endhighlight %}
	
That's great for PHP (which I know just enough of to not like) but if you feed that into Ruby's CGI you get something similar to the flat JSON array.  Lucky for me I'd been using Sinatra lately as my local test server and realized that it seemed to be getting a nice nested hash (exactly what I want) when I posted that value through.  Apparently "multidimensional form inputs" are really called "nested parameters".  Once I posted that data into Sinatra I got a nice hash like this:

{% highlight ruby %}
{"0"=>{"first_name" => "John", "last_name" => "Smith"}, "1" => {"first_name" => "Mary", "last_name" => "Smith"}}...
{% endhighlight %}

Perfect.  But these are all static files with no real need for something like Sinatra.  I did some more digging and couldn't find anything about handling nested parameters with just CGI so I gave up and just set up [Sinatra on Dreamhost](http://railstips.org/2008/12/15/deploying-sinatra-on-dreamhost-with-passenger).  I was going to need to send the data to a DB anyway and I had an email signup that was running through CGI that I can now just make a simple post to a DB.  It's not like this is going to be an incredibly popular site getting millions of hits a second.  Sinatra seems to be working fine for what I need and I'm a big fan of using not necessarily the _right_ tool but the tool that gets the job done.  I'm not proud of most of this code...but it works.

Here's the final code if anyone's interested (formatting is a little off here but I linked to some gists):

HTML [(gist)](http://gist.github.com/222548):

{% highlight html %}
<form action="/rsvp" method="post" accept-charset="utf-8" id="rsvp_form" class="rsvps">
<fieldset id="rsvp_fields">
	<table border="2" cellspacing="5" cellpadding="5" id="rsvp_table">
		<tr>
			<th>First Name:</th>
			<th>Last Name:</th>
			<th>Email:</th>
			<th>Attending</th>
			<th></th>
		</tr>
		<tr id="row0">
			<td><input type="text" name="data[0][first_name]" value="" id="first_name0" /></td>
			<td><input type="text" name="data[0][last_name]" value="" id="last_name0" /></td>
			<td><input type="text" name="data[0][email]" value="" id="email0" /></td>
			<td>
				<select name="data[0][attending]" id="attending1">
					<option value="1" class="attendingyes">Yes</option>
					<option value="0" class="attendingno">No</option>
				</select>
			</td>
			<td id="removetd"></td>
		</tr>
	</table>
</fieldset>
<div id="formbuttons">
	<input type="button" name="Add Row" value="Add Row" id="addrow" class="buttons" />
	<input type="submit" value="RSVP &rarr;" id="rsvpadd" class="buttons"/>
</div>
</form>
{% endhighlight %}

Javascript [(gist)](http://gist.github.com/222546):

{% highlight javascript %}
// Add another row function.  I'm not proud of this at all.
$("#addrow").click(function(){
	var fn = '<input type="text" name="data['+row+'][first_name]" value="" id="first_name'+row+'"/>';
	var ln = '<input type="text" name="data['+row+'][last_name]" value="" id="last_name'+row+'"/>';
	var em = '<input type="text" name="data['+row+'][email]" value="" id="email'+row+'"/>';
	var att = '<select name="data['+row+'][attending]" value="" id="attending'+row+'"><option class="attendingyes" value="1">Yes</option><option class="attendingno" value="0">No</option></select>';
	var rem = '<a class="removebutton" name="row'+row+'" href="#"><img src="/images/remove.png"/></a>'
	var tr = '<tr class="extratrs" id="row'+row+'"><td>'+fn+'</td><td>'+ln+'</td><td>'+em+'</td><td>'+att+'</td><td id="removetd">'+rem+'</td></tr>';
	$(tr).hide().appendTo($('#rsvp_table > tbody:last')).fadeIn('slow');
	$('.removebutton').click(function(){
		$('#' + $(this).attr('name')).fadeOut(function(){$(this).remove();});
	});
row = row + 1;
return false;
});
// Setup ajaxForm
$('#rsvp_form').ajaxForm({
	dataType: 'json',
	beforeSubmit: submitted,
	success: completed
});
// Loading plugin from here: http://code.google.com/p/jquery-loading-plugin/
$('#rsvp_form').loading({ onAjax: true, align: 'center', pulse: 'fade', text: 'Submitting'});

// This happens before the form is submitted.  Removes error boxes from the form.
function submitted(formData) {
	$('.formerror').removeClass();
	return true;
};
// Stuff to do after the server returns a 200 message.  jsonData is the json formatted return info from Sinatra.
function completed(jsonData) {
	var errors = 0;
	jQuery.each(jsonData, function(maini, mainval){
		if (mainval["response"] == "success") {
		} else {
			errors += 1
			jQuery.each(mainval, function(secondi, secondval){
				$('#' + secondval + mainval["index"]).addClass("formerror");
			});
		};
	});
	if (errors == 0) {
		$('#rsvp_form').fadeOut("fast", function(){
			$('#rsvp_form').after("<div id='success'><h4>Thanks! Your RSVP has been received.</h4><a href='#' onClick='resetForm(true);'>Forget Someone?</a></div>");	
		});
	} else {
		resetForm(false);
		$("<h4 class='errors'><center>Please fill in the marked fields</center></h4>").hide().insertBefore($('#rsvp_table')).slideDown('slow');
	};
	return false;
};
// Reset form back to original look
function resetForm(cleardata) {
	$('#success').remove();
	$('.errors').remove();
	if (cleardata) {
		$('#rsvp_form').clearForm();
		$('.attendingyes').attr({
			selected: "selected"
		});
		$('.extratrs').remove();
	};
	$('#rsvp_form').show();
};

{% endhighlight %}

Ruby [(gist)](http://gist.github.com/222563):

{% highlight ruby %}
require "sinatra"
require "dm-core"
require "dm-validations"
require "json"

class RSVP
  include DataMapper::Resource
  property :id, Serial
  property :first_name, String, :nullable => false, :message => "first_name"
  property :last_name, String, :nullable => false, :message => "last_name"
  property :email, String
  property :attending, Boolean
  property :created_at, DateTime
end

RSVP.auto_migrate! unless RSVP.storage_exists?

post '/rsvp' do
  form = params["data"]
  @res = []
  @values = {}
  form.each_pair do |i, person|
    rsvp = RSVP.new
    rsvp.attributes = {
      :first_name => person["first_name"],
      :last_name => person["last_name"],
      :email => person["email"],
      :attending => person["attending"],
      :created_at => Time.now
    }
    @values.merge!({i => rsvp})
  end
  invalid = @values.select {|k, rsvp| !rsvp.valid?}
  if invalid == []
    @values.each_pair do |i, rsvp|
      rsvp.save
      @res.push({:index => i, :response => "success"})
    end
  else
    @values.each_pair do |i, rsvp|
      if rsvp.valid? 
      else
        @res.push({
          :index => i,
          :fn => rsvp.errors[:first_name].to_s,
          :ln => rsvp.errors[:last_name].to_s,
          :email => rsvp.errors[:email].to_s
        })
      end
    end
  end
  content_type :json    
  @res.to_json
end
{% endhighlight %}