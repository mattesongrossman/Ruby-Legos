require 'nokogiri'
# require_relative 'Baseplate'

def traverseBaseplateForXML(baseplate)

builder = Nokogiri::XML::Builder.new do |xml|
  xml.BasePlate do
    xml.send("type", baseplate.type)
    xml.send("color", baseplate.getColor)
    xml.send("length", baseplate.getLength.to_s)
    xml.send("width", baseplate.getWidth.to_s)
    xml.send("height", baseplate.getHeight.to_s)
    xml.send("Id", baseplate.getId)
    xml.send("structures"){
    baseplate.structures.each do |struct|
        xml.send(struct.class.name){
        xml.send("blocks"){
          # traverseStructureList(struct, xml)
          getAllBlocks.each do |block|
            if block.getAttachToID == struct.getId
              # traverseStructureList(struct, xml)
              xml.send(block.class.name){
              xml.send("type", block.getType(block.getColor, block.getLength, block.getWidth))
              changeColorName(block, xml) #outputs color "R" => "Red"
              xml.send("length", block.getLength)
              xml.send("width", block.getWidth)
              xml.send("height", block.getHeight)
              xml.send("Id", block.getId)
              xml.send("orientation", block.getOrientation)
              xml.send("fromPoint"){
                xml.send("X", block.fromPoint["xCord"])
                xml.send("Y", block.fromPoint["yCord"])}
              xml.send("attachedToID", block.getAttachTo)
              xml.send("toPoint") {
                xml.send("X", block.toPoint["xCord"])
                xml.send("Y", block.toPoint["yCord"])}}
            end
          end
      }
        xml.send("ID", struct.getId)
      }
    end
  }
  end
end

output = File.open( "output.xml","w" )
output << builder.to_xml
output.close

end

def traverseStructureList(array, xml)

  if array.class.name == "Structure"
    array.blocks.each do |block|
        block.setVisited
        xml.send(block.class.name){
        xml.send("type", block.getType(block.getColor, block.getLength, block.getWidth))
        changeColorName(block, xml) #outputs color "R" => "Red"
        xml.send("length", block.getLength)
        xml.send("width", block.getWidth)
        xml.send("height", block.getHeight)
        xml.send("Id", block.getId)
        xml.send("orientation", block.getOrientation)
        xml.send("fromPoint"){
          xml.send("X", block.fromPoint["xCord"])
          xml.send("Y", block.fromPoint["yCord"])}
        xml.send("attachedToID", block.getAttachTo)
        xml.send("toPoint") {
          xml.send("X", block.toPoint["xCord"])
          xml.send("Y", block.toPoint["yCord"])}}
       if block.getUplinks.size > 0
         traverseStructureList(block.getUplinks, xml)
       end
    end
  else
    array.each do |block|
      if block.getVisited == false
        block.setVisited
        xml.send(block.class.name){
        xml.send("type", block.getType(block.getColor, block.getLength, block.getWidth))
        changeColorName(block, xml) #outputs color "R" => "Red"
        xml.send("length", block.getLength)
        xml.send("width", block.getWidth)
        xml.send("height", block.getHeight)
        xml.send("Id", block.getId)
        xml.send("orientation", block.getOrientation)
        xml.send("fromPoint"){
          xml.send("X", block.fromPoint["xCord"])
          xml.send("Y", block.fromPoint["yCord"])}
        xml.send("attachedToID", block.getAttachTo)
        xml.send("toPoint") {
          xml.send("X", block.toPoint["xCord"])
          xml.send("Y", block.toPoint["yCord"])}}
         if block.getUplinks.size > 0
           traverseStructureList(block.getUplinks, xml)
         end
       end
     end
    end

      getBaseplate.getAllBlocks.each do |block|
        block.unVisit
      end

  end

  def changeColorName(block, xml)
    case block.getColor
    when "B"
      return xml.send("color", "Blue")
    when "R"
      return xml.send("color", "Red")
    when "G"
      return xml.send("color", "Green")
    when "Y"
      return xml.send("color", "Yellow")
    end

  end
