package utils;

import java.io.StringReader;
import java.io.StringWriter;
import java.nio.file.Files;
import java.nio.file.Path;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.xml.sax.InputSource;

public class XmlTemplateProcessor {

	 private static final XPath XPATH = XPathFactory.newInstance().newXPath();

	    public static String processTemplate(String templateFilePath, String xmlFragment) throws Exception {
	        String templateContent = Files.readString(Path.of(templateFilePath));
	        return replacePlaceholder(templateContent, xmlFragment);
	    }

	    public static String replacePlaceholder(String templateContent, String xmlFragment) throws Exception {
	        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
	        factory.setNamespaceAware(true);
	        DocumentBuilder builder = factory.newDocumentBuilder();

	        Document templateDoc = builder.parse(new InputSource(new StringReader(templateContent)));
	        Document fragmentDoc = builder.parse(new InputSource(new StringReader(xmlFragment)));

	        Node placeholder = (Node) XPATH.evaluate("//*[local-name()='PLACEHOLDER']",
	                                                 templateDoc, XPathConstants.NODE);
	        if (placeholder == null) {
	            throw new IllegalStateException("Template does not contain <PLACEHOLDER/>");
	        }

	        Node imported = templateDoc.importNode(fragmentDoc.getDocumentElement(), true);
	        placeholder.getParentNode().replaceChild(imported, placeholder);

	        StringWriter output = new StringWriter();
	        Transformer transformer = TransformerFactory.newInstance().newTransformer();
	        transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");
	        transformer.transform(new DOMSource(templateDoc), new StreamResult(output));
	        
	        return output.toString();
	    }
	}

