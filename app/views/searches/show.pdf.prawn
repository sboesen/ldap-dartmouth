prawn_document() do |pdf|
  pdf_width = pdf.bounds.right - pdf.bounds.left
  if @search.finished?
    @search.groups.each do |group|
      pdf.text group.name
      if group.search_result.value.present?
        people = group.search_result.value.split(',').map do |person|
          [person]
        end
        table = pdf.table people, :row_colors => ["FFFFFF","DDDDDD"]
        pdf.move_down table.height
      elsif group.search_error.value.present?
        pdf.text "Error: #{group.search_error.value}"
      end
    end
  else
    pdf.text "Search not finished."
  end
end
