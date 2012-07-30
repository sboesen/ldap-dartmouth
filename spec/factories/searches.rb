FactoryGirl.define do
  factory :search do
    after(:build) do |search|
      search.groups << FactoryGirl.build(:group, search: search)
      search.groups << FactoryGirl.build(:group, name: 'SISMAT', search: search)
    end
  end
end
