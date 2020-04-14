/*
*    Daniel de Beer
*    Intro to IM
*    Processing Project 
*    14 April 2020
*/

// Draws a graph with coronavirus case data from around the world

import org.gicentre.geomap.*;

GeoMap geoMap;              // This draws the map of the world from the GeoMap processing library (https://www.gicentre.net/geomap)
Table coronaTable;          // Table that I use to store the maximum values of coronavirus cases around the world
Table graphTable;           // Temporary table that stores all the graphs at the start
color minColour, maxColour; // Colors for the world map, to show the distribution of cases around the world
float dataMax;              // The maximum value for data

ArrayList<Table> myTables = new ArrayList<Table>();    // This arrayList stores all the tables of cumulative cases for the different countries

void setup()
{
  size(1400, 700);

  // Read map data.
  geoMap = new GeoMap(this);
  geoMap.readFile("world");
  
  coronaTable = loadTable("corona2.csv");  // Read coronavirus country data

  graphTable = loadTable("corona3.csv");   // Read coronavirus countries and cases data 

  // Find largest data value so we can scale colours.
  dataMax = 0;  
  for (TableRow row : coronaTable.rows())  
  {
    dataMax = max(dataMax, row.getFloat(0));
  }

  minColour = color(207, 232, 255);   // Light blue
  maxColour = color(0, 75, 145);    // Dark blue.

  String myCode = "";    // Temporary string to store the country code of the current country table we are making
  
  int myCounter = 0;     // Counter for which value we are at in the table we're making, so that we can add the cases to make them cumulative
  
  TableRow newRow;       // Temporary table row that we use to make the new table

  for (int i = graphTable.getRowCount()-1; i > 0; i--)                // We go through the whole stored table and save everything
  {
    if (!graphTable.getRow(i).getString(2).equals(myCode))
    {
      myCode = graphTable.getString(i, 2);
      myCounter = 0;
      myTables.add(new Table());
      myTables.get(myTables.size()-1).addColumn("date");
      myTables.get(myTables.size()-1).addColumn("cases");
      myTables.get(myTables.size()-1).addColumn("code");
      
      
      newRow = myTables.get(myTables.size()-1).addRow();
      newRow.setInt("date", graphTable.getRow(i).getInt(0));
      newRow.setInt("cases", graphTable.getRow(i).getInt(1));
      newRow.setString("code", graphTable.getRow(i).getString(2));
      
      continue;
    }
    
    newRow = myTables.get(myTables.size()-1).addRow();
    newRow.setInt("date", graphTable.getRow(i).getInt(0));
    newRow.setInt("cases", myTables.get(myTables.size()-1).getInt(myCounter, "cases") + graphTable.getRow(i).getInt(1));
    newRow.setString("code", graphTable.getRow(i).getString(2));
    
    
    myCounter++;
  }
  
  saveTable(myTables.get(0), "datanew2.csv");
  
}

void draw()
{
  background(255);
  stroke(150);
  strokeWeight(0.5);

  // Draw countries
  for (int id : geoMap.getFeatures().keySet())
  {
    String countryCode = geoMap.getAttributeTable().findRow(str(id), 0).getString("ISO_A3");    


    TableRow dataRow = coronaTable.findRow(countryCode, 1);

    if (dataRow != null)       // Table row matches country code
    {
      float normBadTeeth = dataRow.getFloat(0)/dataMax;
      fill(lerpColor(minColour, maxColour, normBadTeeth));
    } else  // No data found in table.
    {
      fill(250);
    }
    geoMap.draw(id); // Draw country
  }

  // Query the country at the mouse position.
  int id = geoMap.getID(mouseX, mouseY);
  if (id != -1)
  {
    fill(180, 120, 120);
    geoMap.draw(id);
    String name = geoMap.getAttributeTable().findRow(str(id), 0).getString("NAME");    
    String countryCode = geoMap.getAttributeTable().findRow(str(id), 0).getString("ISO_A3"); 
    TableRow dataRow = coronaTable.findRow(countryCode, 1);
    if (dataRow!=null) name += ": " + dataRow.getInt(0) + " cases";
    else name += ": 0";
    fill(0);

    if (mouseX + 160 > width)
    {
    textAlign(RIGHT);
    text(name, mouseX+5, mouseY-5);
    drawGraph(mouseX - 160, mouseY, countryCode);
    }
    else{
      textAlign(LEFT);
      text(name, mouseX+5, mouseY-5);
      drawGraph(mouseX, mouseY, countryCode);
    }
    
    
    
    
    
    
    
    
  }
}

void drawGraph(float x, float y, String code)
{
  Table tempTable = null;
  for (Table t : myTables)
  {
     if(t.getString(0, "code").equals(code))
     {
       tempTable = t;
       break;
     }
  }
  if(tempTable == null) 
  {
    return;
  }
  fill(1, 49, 94);
  strokeWeight(4);
  stroke(255);
  rect(x+10,y+10,150,150);
  
  for(int i = 0; i < tempTable.getRowCount(); i++)
  {
    strokeWeight(0);
    stroke(102, 181, 255);
    fill(102, 181, 255);
    rect(map(i,0,tempTable.getRowCount(),x+10,x+160), y+160-map(tempTable.getInt(i, "cases"), 0, tempTable.getInt(tempTable.getRowCount()-1, "cases"), 0, 150),150/tempTable.getRowCount(), map(tempTable.getInt(i, "cases"), 0, tempTable.getInt(tempTable.getRowCount()-1, "cases"), 0, 150));
  }
}
