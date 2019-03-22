module Pig
  module NavigationHelper
    def navigation_items
      nav_items = []
      nav_items << {
        visible: proc { can?(:manage, Pig::ContentPackage) && can?(:manage, Pig::ActivityItem) },
        is_active: proc { !@content_packages && !@activity_items.nil? },
        url: pig.admin_content_path,
        title: 'My Content',
        icon: 'home'
      }
      nav_items << {
        visible: proc { can? :manage, Pig::ContentPackage },
        is_active: proc { @content_packages && !@archived_content_packages },
        url: pig.admin_content_packages_path,
        title: 'Page list',
        icon: 'list'
      }
      nav_items << {
        visible: proc { can? :manage, Pig::ActivityItem },
        is_active: proc { @content_types && @activity_items.nil? },
        url: pig.admin_content_types_path,
        title: 'Templates',
        icon: 'file-text-o'
      }
      nav_items << {
        visible: proc { can? :manage, Pig::TagCategory },
        is_active: proc { @tag_categories },
        url: pig.admin_tag_categories_path,
        title: 'Tag Management',
        icon: 'tags'
      }
      nav_items << {
        visible: proc { can? :manage, Pig::MetaDatum },
        is_active: proc { @meta_data },
        url: pig.admin_meta_data_path,
        title: 'Non CMS meta
        data', icon: 'code'
      }
      nav_items << {
        visible: proc { can? :manage, Pig::User },
        is_active: proc { @users || @user },
        url: pig.admin_manage_users_path,
        title: 'User Management',
        icon: 'user'
      }
      nav_items << {
        visible: proc { can? :manage, Pig::AppSettings },
        is_active: proc { @app_settings },
        url: pig.admin_manage_settings_path,
        title: 'CMS Settings',
        icon: 'gear'
      }
      nav_items << {
        visible: proc { can? :manage, Pig::Persona },
        is_active: proc { @persona || @persona },
        url: pig.admin_personas_path,
        title: 'Personas',
        icon: 'group'
      }
      nav_items << {
        visible: proc { can? :manage, Pig::ContentPackage },
        is_active: proc { @archived_content_packages },
        url: pig.archived_admin_content_packages_path,
        title: t('actions.archived_content'),
        icon: 'trash-o'
      }

      ::Pig::Core::Plugins.registered.each do |plugin|
        nav_items.insert(plugin.preferred_position,
          is_active: plugin.active,
          visible: plugin.visible.call(self),
          url: plugin.url.call,
          title: plugin.title,
          icon: plugin.icon
        )
      end

      nav_items
    end
  end
end
