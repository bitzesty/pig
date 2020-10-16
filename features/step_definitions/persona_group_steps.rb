Given(/^there (is|are) (\d+) persona groups?$/) do |ia,n|
  if n.to_i.zero?
    PersonaGroup.destroy_all
  end
  @persona_groups = [].tap do |arr|
    n.to_i.times do
      arr << FactoryBot.create(:persona_group)
    end
  end
  @persona_group = @persona_groups.first
end

Then(/^I see the persona groups$/) do
  @persona_groups.each do |persona_group|
    expect(page).to have_content(persona_group.to_s)
  end
end