module ControllerMacros
  def login_admin
    before(:each) do
      sign_in FactoryBot.create(:user)
    end
  end

  def login_no_role
    before(:each) do
      sign_in FactoryBot.create(:user, role: nil)
    end
  end

  def self.attributes_with_foreign_keys(*args)
    FactoryBot.build(*args).attributes.delete_if { |k, v| %w(id type created_at updated_at lft rgt depth).member?(k) }
  end
end
