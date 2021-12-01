<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:str="http://exslt.org/strings"
		xmlns:xi="http://www.w3.org/2001/XInclude"
		extension-element-prefixes="str">


	<!--========== Global configuration ==========-->

	<!-- Define how our output should look -->
	<xsl:output method="xml"
		    encoding="utf-8"
		    indent="yes"
		    omit-xml-declaration="no"
		    doctype-public="-//OASIS//DTD DocBook XML V5.0//EN"
		    doctype-system="http://www.oasis-open.org/docbook/xml/5.0/dtd/docbook.dtd"/>

	<!-- Strip extraneous whitespace -->
	<xsl:strip-space elements="*"/>

	<!-- Element name of toplevel node -->
	<xsl:param name="toplevel" select="'section'"/>

	<!-- Space-separated list of child section files to include -->
	<xsl:param name="children"/>


	<!--========== Match the toplevel and process the content ==========-->

	<xsl:template match="/html">
		<xsl:apply-templates select="./body/div[@id='content']"/>
	</xsl:template>


	<!--========== DIV elements ==========-->

	<!-- Turn normal divs into sections -->
	<xsl:template match="//div">
		<section>
			<xsl:apply-templates select="*|comment()|text()"/>
		</section>
	</xsl:template>

	<!-- Handle the main content element -->
	<xsl:template match="//div[@id='content']">
		<xsl:element name="{$toplevel}">
			<!-- Expand child nodes before section includes -->
			<xsl:apply-templates select="*|comment()|text()"/>
			<!-- Include child sections -->
			<xsl:for-each select="str:split($children, ' ')">
				<xsl:message>Including <xsl:value-of select="."/></xsl:message>
				<xsl:element name="xi:include">
					<xsl:attribute name="href">
						<xsl:value-of select="text()"/>
					</xsl:attribute>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>

	<!-- Drop section headers -->
	<xsl:template match="//div[@id='section-header']"/>

	<!-- Drop the ISBN section on the Copyrights page -->
	<xsl:template match="//div[@id='ISBN-LOC']"/>

	<!-- TODO annotated figures -->
	<xsl:template match="//div[@class='figure wide']"/>


	<!--========== H1 headings are our section titles ==========-->

	<xsl:template match="//h1">
		<xsl:message terminate="yes">There should be only one H1 per input file.</xsl:message>
	</xsl:template>
	<xsl:template match="//h1[1]">
		<title>
			<xsl:apply-templates select="*|comment()|text()"/>
		</title>
	</xsl:template>


	<!--========== H2 headings are ignored or sectionized ==========-->

	<!-- Err when encountering unknown H2 classes. -->
	<xsl:template match="//h2">
		<xsl:message terminate="yes">Unknown type of H2.</xsl:message>
	</xsl:template>
	<!--  Drop TOC titles ("Contents") -->
	<xsl:template match="//h2[@class='chapter-title']"/>
	<!-- Subsume elements after section titles into a new section -->
	<xsl:template match="//h2[@class='subsection-title']">
		<!-- Set the global header id -->
		<xsl:variable name="header2-id" select="generate-id(.)"/>
		<xsl:variable name="header3-id" select="generate-id(.)"/>
		<!-- Construct a new section -->
		<section>
			<!-- Use our contents as the title-->
			<title>
				<xsl:apply-templates select="*|comment()|text()"/>
			</title>
			<!-- Iterate all following siblings as long as their preceding H2 has the same header id -->
			<xsl:for-each select="following-sibling::*[generate-id(preceding-sibling::h2[1]) = $header2-id]">
				<xsl:apply-templates select="."/>
			</xsl:for-each>
		</section>
	</xsl:template>


	<!--========== H3 headings form subsections (TODO incomplete) ==========-->

	<!-- Err when encountering unknown H3 classes. -->
	<xsl:template match="//h3">
		<xsl:message terminate="yes">Unknown type of H3.</xsl:message>
	</xsl:template>
	<!-- Handle subsection titles -->
	<xsl:template match="//h3[@class='sub-subsection-title']">
		<xsl:variable name="header3-id" select="generate-id(.)"/>
		<bridgehead>
			<xsl:apply-templates select="*|comment()|text()"/>
		</bridgehead>
	</xsl:template>


	<!--========== H4 headings (TODO incomplete) ==========-->

	<xsl:template match="//h4">
		<xsl:apply-templates select="*|comment()|text()"/>
	</xsl:template>


	<!--========== H5 headings (TODO incomplete) ==========-->

	<xsl:template match="//h5">
		<xsl:apply-templates select="*|comment()|text()"/>
	</xsl:template>


	<!--========== Link handling (TODO completely incorrect) ==========-->

	<!-- Ignore non-link anchors for now -->
	<xsl:template match="//a">
		<xsl:apply-templates select="*|comment()|text()"/>
	</xsl:template>
	<!-- Translate links incorrectly -->
	<xsl:template match="//a[@href]">
		<link>
			<xsl:apply-templates select="*|comment()|text()"/>
		</link>
	</xsl:template>
	<!-- Skip heading anchors -->
	<xsl:template match="//a[starts-with(@name, 'HEADING-')]"/>
	<!-- UID anchores are not used by anything -->
	<xsl:template match="//a[starts-with(@name, 'UID-')]"/>


	<!--========== Index terms ==========-->

	<xsl:template match="//dfn">
		<indexterm>
			<primary>
				<xsl:apply-templates select="*|comment()|text()"/>
			</primary>
		</indexterm>
	</xsl:template>

	<xsl:template match="//term">
		<glossterm>
			<xsl:apply-templates select="*|comment()|text()"/>
		</glossterm>
	</xsl:template>


	<!--========== Formatting instructions ==========-->

	<!-- Ignore BR -->
	<xsl:template match="//br"/>

	<!-- Ignore HR -->
	<xsl:template match="//hr"/>


	<!--========== Commonplace elements ==========-->

	<xsl:template match="//i">
		<emphasis>
			<xsl:apply-templates select="*|comment()|text()"/>
		</emphasis>
	</xsl:template>

	<xsl:template match="//p">
		<para>
			<xsl:apply-templates select="*|comment()|text()"/>
		</para>
	</xsl:template>

	<xsl:template match="//q">
		<quote>
			<xsl:apply-templates select="*|comment()|text()"/>
		</quote>
	</xsl:template>

	<xsl:template match="//dl">
		<variablelist>
			<xsl:apply-templates select="*|comment()|text()"/>
		</variablelist>
	</xsl:template>

	<xsl:template match="//dt">
		<term>
			<xsl:apply-templates select="*|comment()|text()"/>
		</term>
	</xsl:template>

	<xsl:template match="//dd">
		<listitem>
			<xsl:apply-templates select="*|comment()|text()"/>
		</listitem>
	</xsl:template>

	<!--
	<xsl:template match="//ol">
		<orderedlist>
			<xsl:apply-templates select="*|comment()|text()"/>
		</orderedlist>
	</xsl:template>
	-->

	<xsl:template match="//ul">
		<itemizedlist>
			<xsl:apply-templates select="*|comment()|text()"/>
		</itemizedlist>
	</xsl:template>
	<!-- Drop the original chapter TOC -->
	<xsl:template match="//ul[@class='TOC']"/>

	<xsl:template match="//li">
		<listitem>
			<para>
				<xsl:apply-templates select="*|comment()|text()"/>
			</para>
		</listitem>
	</xsl:template>

	<xsl:template match="//pre">
		<literallayout>
			<xsl:apply-templates select="*|comment()|text()"/>
		</literallayout>
	</xsl:template>

	<xsl:template match="//code">
		<code>
			<xsl:apply-templates select="*|comment()|text()"/>
		</code>
	</xsl:template>

	<xsl:template match="//em">
		<emphasis>
			<xsl:apply-templates select="*|comment()|text()"/>
		</emphasis>
	</xsl:template>

	<xsl:template match="//strong">
		<emphasis role="strong">
			<xsl:apply-templates select="*|comment()|text()"/>
		</emphasis>
	</xsl:template>

	<xsl:template match="//span">
		<code>
			<xsl:apply-templates select="*|comment()|text()"/>
		</code>
	</xsl:template>

	<xsl:template match="//sub">
		<subscript>
			<xsl:apply-templates select="*|comment()|text()"/>
		</subscript>
	</xsl:template>

	<xsl:template match="//sup">
		<superscript>
			<xsl:apply-templates select="*|comment()|text()"/>
		</superscript>
	</xsl:template>

	<xsl:template match="//var">
		<varname>
			<xsl:apply-templates select="comment()|text()"/>
		</varname>
	</xsl:template>


	<!--========== Copy everything else except processing instructions ==========-->

	<xsl:template match="*|@*|comment()|text()">
		<xsl:copy>
			<xsl:apply-templates select="*|@*|comment()|text()"/>
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>
