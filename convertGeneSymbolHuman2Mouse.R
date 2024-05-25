library(biomaRt)
convertGeneSymbolHuman2Mouse <- function(genes) {
  ##intro:
  #convert human gene symbol to mouse MGI_id
  #..............
  
  #debug:
  # genes=c("AQP8","CA7")
  #...............
  
  #demo
  
  # human_genes <- c("BRCA1", "TP53", "MYC")
  # mouse_symbols <- convertGeneSymbolHuman2Mouse(human_genes)
  #.......................
  
  
  # Use Ensembl to access human and mouse data
  
  human = useMart(biomart="ensembl", dataset = "hsapiens_gene_ensembl", 
                  verbose = TRUE, host = "https://dec2021.archive.ensembl.org")
  mouse <- useMart("ensembl", 
                   dataset = "mmusculus_gene_ensembl",host = "https://dec2021.archive.ensembl.org")
  
  # attributesHuman = listAttributes(human)
  # attributesMouse =listAttributes(mouse)
  # 
  
  
  out=getLDS(attributes = c("hgnc_symbol","chromosome_name", "start_position"), 
             filters = "hgnc_symbol", 
             # values = c("CA7","TP53"), 
             values = genes, 
             mart = human, 
             attributesL = c("mgi_id","mgi_symbol","chromosome_name","start_position"), 
             martL = mouse)
  
  
  # Handle genes not found in mouse
  not_found <- setdiff(genes, out$HGNC.symbol)
  if (length(not_found) > 0) {
    warning(paste("These human genes not found in mouse:", paste(not_found, collapse = ", ")))
  }
  
  # Return mouse symbols (MGI)
  return(out)
}


human_genes=c("AQP8","CA7")
mouse_symbols <- convertGeneSymbolHuman2Mouse(human_genes)
mouse_symbols
