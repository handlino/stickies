################################################################################
#
# Copyright (C) 2007 pmade inc. (Peter Jones pjones@pmade.com)
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
################################################################################
module Stickies
  module RenderHelpers

    ################################################################################
    # Render the stickie messages, returning the resulting HTML.  Options are:
    #
    # +:close+: Close link HTML, or nil to not include a close link
    # +:effect+: A visual effect to use when closing a message
    # +:effect_options+: Options passed to the visual effect
    # +:id+: The HTML ID to use on the outer div
    # +:key+: The session key to use to access the messages object
    # +:link_html+: HTML options passed to the link generation functions
    #
    # The defaults are pretty decent.
    def render_stickies (options={})
      configuration = {
        :close          => 'Close',
        :close_position => :before,
        :unified        => false,
        :effect         => nil,
        :effect_options => {},
        :id             => 'stickies',
        :key            => :stickies,
        :link_html      => {},
      }.update(options)

      html = %Q(<div id="#{configuration[:id]}">)
      
      Stickies::Messages.fetch(session, configuration[:key]) do |messages|
        if configuration[:unified]
          html << render_stickies_unified(messages, configuration)
        else
          html << render_stickies_separate(messages, configuration)
        end

        messages.flash
      end

      html << %Q(</div>)
      html
    end

    ################################################################################
    # Helper method to generate the close button for a message.
    def render_stickie_close_area (message, options)
      return "" unless options[:close]
      html = %Q(<div class="stickies_close_area">)
      html << link_to_function(options[:close], javascript_to_close_stickie(message, options), options[:link_html])
      html << %Q(</div>)
      html
    end

    ################################################################################
    # Helper method to render each stickie message as a separate div.
    def render_stickies_separate (messages, options)
      html = ''

      messages.each do |m|
        html << %Q(<div class="#{m.level}_stickie" id="stickie_#{m.options[:name]}">)
        html << render_stickie_close_area(m, options) if options[:close_position] == :before
        html << m.message
        html << render_stickie_close_area(m, options) if options[:close_position] != :before
        html << %Q(<br style="clear:all;"/>)
        html << %Q(</div>)
      end

      html
    end

    ################################################################################
    # Render all stickies in a unified block
    def render_stickies_unified (messages, options)
      return "" if messages.empty?
      
      html         = %Q(<div id="unified_stickies"><div>)
      message_html = %Q(<ol>)
      close_js     = ''

      messages.each do |m|
        message_html << %Q(<li class="#{m.level}_stickie" id="stickie_#{m.options[:name]}">)
        message_html << m.message
        message_html << %Q(</li>)
        close_js     << javascript_to_close_stickie(m, options)
      end

      message_html << %Q(</ol>)

      close_html  = %Q(<div class="stickies_close_area">)
      close_html << link_to_function(options[:close], javascript_to_remove_stickie_html('unified_stickies', options), options[:link_html])
      close_html << %Q(</div>)

      if options[:close_position] == :before
        html << close_html << message_html
      else 
        html << message_html << close_html
      end

      html << %Q(</div></div>)
      html
    end

    ################################################################################
    # Returns the JavaScript that is necessary to close a stickie on
    # the server and in the browser.
    def javascript_to_close_stickie (message, options)
      div_id = "stickie_#{message.options[:name]}"

      if message.options[:flash]
        options[:unified] ? '' : javascript_to_remove_stickie_html(div_id, options)
      else
        remote_options = {}
        remote_options[:url] = {:action => 'destroy_stickie', :id => message.options[:name]}
        remote_options[:before] = javascript_to_remove_stickie_html(div_id, options) unless options[:unified]
        remote_function(remote_options)
      end
    end

    ################################################################################
    # Render the JavaScript that is necessary to close the stickie div.
    def javascript_to_remove_stickie_html (div_id, options)
      if options[:effect]
        update_page {|p| p.visual_effect(options[:effect], div_id, options[:effect_options])}
      else
        update_page {|p| p.hide(div_id)}
      end
    end

  end
end
################################################################################
