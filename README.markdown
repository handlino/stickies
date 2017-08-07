handlino-stickies

This is a modified version from http://software.pmade.com/stickies
We use jquery to let it be unobtrusive.
 
# Stickies

Stickies is a plugin for Ruby on Rails that provides some easy to use yet
powerful features for displaying status messages.  It's a replacement for the
traditional use of placing such messages in the flash.

## Examples

The following line goes in your layout, where you normally render messages
that are in the flash:

 <%= render_stickies %>

Once that is place, you can use the helper methods from your controllers or
views for adding messages to the message collection:

 error_stickie("Your account has been disabled")
 warning_stickie("Your account will expire in 3 days")
 notice_stickie("Account activated")
 debug_stickie("This only works when RAILS_ENV is development")

## Features

* Displayed messages have a close link to remove them from the web page
* Messages default to only being displayed once (they disappear on the next page load)
* Messages can stick around until a user closes them
* You can choose to have a specific message display every so often

To display a warning that a user's browser sucks, no more than once every 24
hours:

 warning_stickie("Your browser sucks", {
   :remember => true,
   :name     => :browser_warning,
   :seen_in  => 24.hours,
 })

## Installation

**Rails >= 3.1.0**

Gemfile

    gem "stickies", :git => "git://github.com/techbang/stickies.git"

assets/stylesheets/application.css
    
    //= require stickies

assets/javascripts/application.js

    //= require stickies

**Rails < 3.1.0**

Gemfile

    gem "stickies", :git => "git://github.com/techbang/stickies.git"

$ rails g stickies

This will create:

     public/stylesheets/stickies.css
     public/javascripts/stickies.js
