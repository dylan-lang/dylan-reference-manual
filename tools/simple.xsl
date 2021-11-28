<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output omit-xml-declaration="yes" indent="no"/>

	<xsl:template match="node()|@*">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="meta"/>

	<!-- Drop the header and footer -->
	<xsl:template match="//div[@id='header' or @id='footer']"/>

	<!-- Drop section headers -->
	<xsl:template match="//div[@id='section-header']"/>

	<!-- Remove unused anchors whose name starts with 'UID-' -->
	<xsl:template match="//a[starts-with(@name, 'UID-')]"/>

</xsl:stylesheet>
