prawn_document() do |pdf|
  pdf.text @search.groups_to_sentence
end
