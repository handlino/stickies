# -*- encoding : utf-8 -*-
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
        :id             => 'stickies',
        :key            => :stickies,
        :link_html      => {},
      }.update(options)

      html = %Q(<div id="#{configuration[:id]}">)

      Stickies::Messages.fetch(session, configuration[:key]) do |messages|
        html << render_stickies_separate(messages, configuration)
        messages.flash
      end

      html << %Q(</div>)
      raw html
    end

    ################################################################################
    # Helper method to generate the close button for a message.
    def render_stickie_close_area (message, options)
      return "" unless options[:close]
      html = %Q(<div class="stickies_close_area">)
      html << link_to(options[:close], "#", options[:link_html])
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
        html << m.message.force_encoding("UTF-8")
        html << render_stickie_close_area(m, options) if options[:close_position] != :before
        html << %Q(<br style="clear:all;"/>)
        html << %Q(</div>)
      end

      html
    end

  end
end
