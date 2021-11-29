<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- Define how our output should look -->
	<xsl:output method="xml"
		    encoding="iso-8859-1"
		    indent="yes"
		    omit-xml-declaration="no"
		    doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
		    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>

	<!-- Strip extraneous whitespace -->
	<xsl:strip-space elements="*"/>

	<!-- Partial identity transform - leave processing instructions alone -->
	<xsl:template match="@*|*|comment()|text()">
		<xsl:copy>
			<xsl:apply-templates select="@*|*|comment()|text()"/>
		</xsl:copy>
	</xsl:template>

	<!-- Drop the header and footer -->
	<xsl:template match="//div[@id='header' or @id='footer']"/>

	<!-- Drop section headers -->
	<xsl:template match="//div[@id='section-header']"/>

	<!-- Remove unused anchors whose name starts with 'UID-' -->
	<xsl:template match="//a[starts-with(@name, 'UID-')]"/>

</xsl:stylesheet>
