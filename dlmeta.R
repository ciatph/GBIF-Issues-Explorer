
# Metadata of Download ----
dl_meta_file <- XML::xmlToList("data/metadata.xml")
output$download_doi <- renderText({
  this_doi <- dl_meta_file$additionalMetadata$metadata$`gbif`$citation$.attrs
  gbif_key <- dl_meta_file$dataset$alternateIdentifier
  
  metadata_json <- paste0("http://api.gbif.org/v1/occurrence/download/", gbif_key)
  
  gbif_metadata <- unlist(jsonlite::fromJSON(metadata_json))
  
  html_to_print <- paste0("<div class=\"panel panel-primary\"> <div class=\"panel-heading\"> <h3 class=\"panel-title\">GBIF Occurrence Download Metadata</h3></div><div class=\"panel-body\"><div style = \"overflow-y: auto; overflow-x: auto;\"><dl class=\"dl-horizontal\">")
  
  for (i in 1:length(gbif_metadata)){
    html_to_print <- paste0(html_to_print, "<dt>", names(gbif_metadata[i]), "</dt>")
    if (names(gbif_metadata[i]) == "doi"){
      html_to_print <- paste0(html_to_print, "<dd><a href=\"https://doi.org/", gbif_metadata[i], "\" target = _blank>", gbif_metadata[i], "</a></dd>")
    }else if(names(gbif_metadata[i]) == "downloadLink" || names(gbif_metadata[i]) == "license"){
      html_to_print <- paste0(html_to_print, "<dd><a href=\"", gbif_metadata[i], "\" target = _blank>", gbif_metadata[i], "</a></dd>")
    }else{
      html_to_print <- paste0(html_to_print, "<dd>", gbif_metadata[i], "</dd>")
    }
    
  }
  
  html_to_print <- paste0(html_to_print, "</dl>")
  html_to_print <- paste0(html_to_print, "<p><a href=\"", metadata_json, "\" target = _blank>Metadata JSON</a>")
  html_to_print <- paste0(html_to_print, "</div></div></div>")

  #Messages ----
  output$messages <- renderUI({
    metadata_json <- jsonlite::fromJSON(metadata_json)
    no_datasets <- prettyNum(metadata_json$numberDatasets, big.mark = ",", scientific=FALSE)
    
    if (metadata_json$numberDatasets > 1){
      datasets_text <- "datasets"
    }else{
      datasets_text <- "dataset"
    }
    
    HTML(paste0("<p class=\"alert alert-success\" role=\"alert\">Loaded download ", metadata_json$key, " (doi: ", metadata_json$doi, ") with ", no_datasets," ", datasets_text, " and ", prettyNum(metadata_json$totalRecords, big.mark = ",", scientific=FALSE), " occurrence records.</p>"))
  })
  
  HTML(html_to_print)
})
