module Stickies
  class Railtie < ::Rails::Railtie
    initializer "stickies.controller_actions" do
      ActionController::Base.send(:include, Stickies::ControllerActions)
      ActionController::Base.send(:include, Stickies::AccessHelpers)
    end
    initializer "stickies.view_helpers" do
      ActionView::Base.send :include, Stickies::AccessHelpers
      ActionView::Base.send :include, Stickies::RenderHelpers
    end
  end
end