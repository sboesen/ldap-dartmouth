module SearchesHelper
  def search_link_paths(search)

    output = ""
    output += link_to 'Show', search
    output += " | "
    output += link_to 'Edit', edit_search_path(search)
    output += " | "
    output += link_to 'Destroy', search, :confirm => 'Are you sure?', :method => :delete
  end
end
