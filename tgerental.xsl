<?xml version="1.0" encoding="UTF-8" ?>



<xsl:stylesheet version="2.0"
     xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

   <xsl:output method="html"
      doctype-system="about:legacy-compat"
      encoding="UTF-8"
      indent="yes" />
      
      
      
   <xsl:variable name="tgecustomersDoc" select="document('tgecustomers.xml')" />
   <xsl:variable name="tgetoolsDoc" select="document('tgetools.xml')" />
   
   
   <xsl:key name="date" match="rental" use="Start_Date" />
   <xsl:key name="tKey" match="tool" use="@id" />
   <xsl:key name="fKey" match="customer" use="@id" />
   
   <xsl:output method="html"
   doctype-system="about:legacy-compat"
   encoding="UTF-8"
   indent="yes" />

   <xsl:template match="/">
      <html>
         <head>
            <title>Rental Listings</title>
            <link href="tgestyles.css" rel="stylesheet" type="text/css" />
         </head>

         <body>
            <div id="wrap">
               <header>
                  <img src="tgelogo.png" alt="The Good Earth" />
               </header>

               <h1>Current Rentals</h1>
               <section id="date_list">
               |
                 <xsl:apply-templates
                  select="rentals/rental[not(Start_Date=preceding::rental/Start_Date)]"
                  mode="dateList">

                    <xsl:sort select="Start_Date" />
                 </xsl:apply-templates>
                </section>

                <xsl:for-each 
                 select="//rental[generate-id()=generate-id(key('date', Start_Date)[1])]">
                 <xsl:sort select="Start_Date" />
                 <h2 id="{generate-id()}"><xsl:value-of select="Start_Date" /></h2>

                 <xsl:apply-templates select="key('date', Start_Date)">
                    <xsl:sort select="Days" order="descending" />
                 </xsl:apply-templates>

               </xsl:for-each>
             </div>
         </body>

      </html>
   </xsl:template>

    <xsl:template match="rental">
      <table class="head" cellpadding="2">
         <tr>
            <th>Customer</th>
            <td rowspan="2">
               <xsl:value-of select="Customer" /><br />
			   <xsl:value-of select="Weeks" /><br />
            </td>
         </tr>
         <tr>
            <th>Tool</th>
            <td><xsl:value-of select="Tool" /></td>
         </tr>
         <tr>	
            <th>Category</th>
            <td><xsl:value-of select="category" /></td>
            <th>Due back</th>
            <td><xsl:value-of select="Start_Date" /></td>
         </tr>
         <tr>
            <th>Charge</th>
            <td><xsl:value-of select="dailyRate" /></td>
         </tr>
         <tr>
            <td colspan="2">
               <xsl:variable name="custID" select="@customer" />
               <xsl:for-each select="$tgecustomersDoc">
                  <xsl:value-of select="key('fKey', $custID)/firstName" /> <br />
                  <xsl:value-of select="key('fKey', $custID)/lastName" /> <br />
                  <xsl:value-of select="key('fKey', $custID)/street" />, 
                  <xsl:value-of select="key('fKey', $custID)/city" /> &#160;
                  <xsl:value-of select="key('fKey', $custID)/state" /><br />
                  <xsl:value-of select="key('fKey', $custID)/zip" /><br />
               </xsl:for-each>
            </td>
            <td colspan="2">
               <xsl:variable name="tID" select="@tool" />
               <xsl:for-each select="$tgetoolsDoc">
                  <xsl:value-of select="key('tKey', $tID)/description" /> <br />
                  <xsl:value-of select="key('tKey', $tID)/category" /> <br />             
               </xsl:for-each>
            </td>
         </tr>
      </table>
   </xsl:template>

   <xsl:template match="rental" mode="dataList">
      <a href="#{generate-id()}">
      <xsl:value-of select="Start_Date" />
      </a>
      (<xsl:value-of select="count(key('data', Start_Date))" />) |
   </xsl:template>

</xsl:stylesheet>

