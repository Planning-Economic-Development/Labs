##################################################
#   URP-5493: Planning & Econ Development
#   Prof: Esteban Lopez Ochoa, PhD
#   Lab 3: IO Industry network Analysis
#################################################
require(data.table)
require(shiny)
require(visNetwork)
require(igraph)
require(readxl)

#source("03_Lab/03_a_leonfief_matrix.R")

L<-readRDS(file = "03_Lab/Leontief.rds")
A<-readRDS(file = "03_Lab/technical_coeff.rds")

ind_labels<-data.table(read_excel("03_Lab/IO_labels.xlsx",col_names = T,col_types = 'text'),stringsAsFactors = F)# Industry(435) x Product(510)
ind_labels<-ind_labels[entry_type=="industry",.(code,label)]
names(ind_labels)[1]<-"id"

ind_index<-colnames(L)
row.names(L)<-ind_index
colnames(A)<-ind_index

g_L<-graph.adjacency(L,weighted = T,mode = "undirected")
gg_L<-get.data.frame(g_L)
names(gg_L)[3]<-"value"

g_A<-graph.adjacency(A,weighted = T,mode = "undirected")
gg_A<-get.data.frame(g_A)
names(gg_A)[3]<-"value"

matrices<-list(A=gg_A,L=gg_L)

ui <- fluidPage(
  # Application title
  titlePanel("San Antonio MSA's Inter-Industry linkages"),
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      radioButtons(inputId = "matrix",
                   label = "Matrix", 
                   choices = c("Technical Coefficients" = "A", "Leontief" = "L"),
                   selected = "A"),
    
      sliderInput("weight",
                  "Value:",
                  min = 0,
                  max = 3,
                  value = 0.05,step = 0.01)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      visNetworkOutput("netPlot")
    )
  )
)

server <- function(input, output) {
  
  query_edges<-eventReactive(list(input$weight,input$matrix),{
    mat<-matrices[[input$matrix]]
    mat[mat$value>=input$weight,]
    
  })
  
  query_nodes<-eventReactive(list(input$weight,input$matrix),{
    mat<-matrices[[input$matrix]]
    ids_edges<-unique(mat[mat$value>=input$weight,]$from,mat[mat$value>=input$weight,]$to)
    ind_labels[id%in%ids_edges]
  })
  
  
  output$netPlot <-renderVisNetwork({
    visNetwork(nodes=query_nodes(),edges=query_edges(),main=paste(input$matrix,"matrix"))%>%
      visIgraphLayout(layout = "layout_in_circle") %>%
      visNodes(size=10,physics=T) %>%
      visEdges(physics=T,arrows=list(label=list(enabled=F)),selfReferenceSize = FALSE) %>%
      visOptions(highlightNearest=list(enabled=T,hover=T),height='150%',collapse = T,nodesIdSelection=T)
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)
# 


# visNetwork(nodes=ind_labels[id%in%unique(gg_A[gg_A$value>=0.005,]$from,gg_A[gg_A$value>=0.005,]$to),],edges=gg_A[gg_A$value>=0.005,],main="Technical Coefficients")%>%
#   visNodes(size=10,physics=T) %>%
#   visEdges(physics=T,arrows=list(label=list(enabled=F)),selfReferenceSize = FALSE) %>%
#   visOptions(highlightNearest=list(enabled=T,hover=T,algorithm="hierarchical"),height='150%',collapse = T,nodesIdSelection=T)
#  
