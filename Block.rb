# require_relative 'Structure'
# require 'pry'

#INCLUDES BLOCK AND ATTACHEDBLOCK

class Block
  @@autoId = 0

  def initialize (length, width, level, color)
    @id = @@autoId
    @length = length
    @width = width
    @level = level
    @color = color
    @height = 1 #Height can be changed in getType method in AttachedBlock
    incrementId
  end

#---------------------------------------------------
  def getId
    return @id
  end

#---------------------------------------------------
  def getLength
    return @length
  end

#---------------------------------------------------
  def getWidth
    return @width
  end

#---------------------------------------------------
  def getlevel
    return @level
  end

#---------------------------------------------------
  def getColor
    return @color
  end

#---------------------------------------------------
  def getHeight
    return @height
  end

#---------------------------------------------------
  def incrementId
    @@autoId += 1
  end

end

#---------------------------------------------------

class AttachedBlock < Block

  #ATTR ACCESSOR FOR EASE OF USE ESPECIALLY IN XML/TESTS, MOSTLY EVERYTHING USES GETTERS/SETTERS
  attr_accessor :id, :visited, :type, :length, :width, :level, :color, :fromPoint, :toPoint, :orientation, :attachToID, :uplinks, :downlinks

  def initialize(length, width, level, color, orientation, fromPoint, attachTo, attachToID, downlinks = [])
  super(length, width, level, color)
  @orientation = orientation
  @fromPoint = findFromPoint(fromPoint)
  @attachTo = attachTo #BLOCK
  @attachToID = attachToID #STRUCTURE
  @toPoint = findToPoint(length, width, orientation, fromPoint)
  @uplinks = []
  @downlinks = downlinks
  @type = getType(color, length, width)
  @visited = false
  end

#---------------------------------------------------
  def getOrientation
    return @orientation
  end

#---------------------------------------------------
  def getFromPoint
    return @fromPoint
  end

#---------------------------------------------------
  def setFromPoint(x, y)
    @fromPoint = {
      "xCord" => x.to_i,
      "yCord" => y.to_i
    }
    return @fromPoint
  end

#---------------------------------------------------
  def getToPoint
    return @toPoint
  end

#---------------------------------------------------
  def setToPoint(x, y)
    @toPoint = {
      "xCord" => x.to_i,
      "yCord" => y.to_i,
      "rangeX" => (@fromPoint["xCord"].to_i..x).to_a,
      "rangeY" => (@fromPoint["yCord"].to_i..y).to_a
    }
    return @toPoint
  end

#----STRUCTURE--------------------------------------
  def getAttachToID
    return @attachToID
  end

#----BLOCK------------------------------------------
  def getAttachTo
    return @attachTo
  end

#----BLOCK------------------------------------------
  def setAttachTo (id)
    @attachTo = id
  end

#---------------------------------------------------
  def getUplinks
    return @uplinks
  end

#---------------------------------------------------
  def getDownlinks
    return @downlinks
  end

#---------------------------------------------------
  def getVisited
    return @visited
  end

#---------------------------------------------------
  def getType(color, length, width)
    if length == 4 #Changes height for this block
      @height = 0.5
    end
    return color + length.to_s + "x" + width.to_s
  end

#---------------------------------------------------
  def setVisited
    @visited = true
  end
#---------------------------------------------------
  def unVisit
    @visited = false
  end

#---------------------------------------------------
  def findFromPoint(fromPoint)

    case fromPoint.size
    when 3
      setFromPoint(fromPoint[0], fromPoint[2])
      # fromPoint = {
      #   "xCord" => fromPoint[0].to_i,
      #   "yCord" => fromPoint[2].to_i
      # }
    when 4
      if fromPoint[1] == ","
        setFromPoint(fromPoint[0], "#{fromPoint[2]}#{fromPoint[3]}")
        # fromPoint = {
        #   "xCord" => fromPoint[0].to_i,
        #   "yCord" => "#{fromPoint[2]}#{fromPoint[3]}".to_i
        # }
      else
        setFromPoint("#{fromPoint[0]}#{fromPoint[1]}", fromPoint[3])
        # fromPoint = {
        #   "xCord" => "#{fromPoint[0]}#{fromPoint[1]}".to_i,
        #   "yCord" => fromPoint[3].to_i
        # }
      end
    when 5
      setFromPoint("#{fromPoint[0]}#{fromPoint[1]}", "#{fromPoint[3]}#{fromPoint[4]}")
      # fromPoint = {
      #   "xCord" => "#{fromPoint[0]}#{fromPoint[1]}".to_i,
      #   "yCord" => "#{fromPoint[3]}#{fromPoint[4]}".to_i
      # }
    end
    # return fromPoint

  end

#---------------------------------------------------
  def findToPoint(length, width, orientation, fromPoint)

    length = length.to_i
    width = width.to_i

    pegLSpaces = 0; #Length increment
    pegWSpaces = 0; #Width increment

    direction = 0
    if orientation == "East"
      direction = 1
    else
      direction = 2
    end

    if direction == 1
      if length == 2 && width == 2 #2X2
        pegLSpaces = 1
        pegWSpaces = 1
      elsif length == 1 #1X4
        pegLSpaces = 0
        pegWSpaces = 3
      elsif length == 2 && width == 4 #2X4
        pegLSpaces = 1
        pegWSpaces = 3
      else #2x8
        pegLSpaces = 1
        pegWSpaces = 7
      end
    else
      if length == 2 && width == 2 #2X2
        pegLSpaces = 1
        pegWSpaces = 1
      elsif length == 1 #1X4
        pegLSpaces = 3
        pegWSpaces = 0
      elsif length == 2 && width == 4 #2X4
        pegLSpaces = 3
        pegWSpaces = 1
      else #2x8
        pegLSpaces = 7
        pegWSpaces = 1
      end
    end

    # puts length
    # puts width
    # puts pegLSpaces
    # puts pegWSpaces
    # puts fromPoint["xCord"]
    # puts fromPoint["yCord"]
    newRangeX = @fromPoint["xCord"].to_i + pegWSpaces
    newRangeY = @fromPoint["yCord"].to_i + pegLSpaces

    setToPoint(newRangeX, newRangeY)
    #Old code below
    # toPoint = {
    #   "xCord" => newRangeX,
    #   "yCord" => newRangeY,
    #   "rangeX" => (@fromPoint["xCord"].to_i..newRangeX).to_a, #.. is a range operator to include everything in between the two variables in the array
    #   "rangeY" => (@fromPoint["yCord"].to_i..newRangeY).to_a
    # }
    # return toPoint

  end

#---------------------------------------------------
  def moveBlock(deltaX, deltaY)
    deltaX = deltaX.to_i
    deltaY = deltaY.to_i

    puts "Moves from: "
    puts "ID:  #{getId}"
    puts getFromPoint
    puts getToPoint

    getFromPoint["xCord"] += deltaX
    getFromPoint["yCord"] += deltaY

    newX = getToPoint["xCord"] + deltaX
    newY = getToPoint["yCord"] + deltaY

    #OLD CODE BELOW
    # newRangeX = getToPoint["xCord"].to_i + deltaX
    # newRangeY = getToPoint["yCord"].to_i + deltaY
    # getToPoint["rangeX"] = (getFromPoint["xCord"].to_i..getToPoint["xCord"]).to_a
    # getToPoint["rangeY"] = (getFromPoint["yCord"].to_i..getToPoint["yCord"]).to_a

    setToPoint(newX, newY)

    puts "Moves to: "
    puts "ID:  #{getId}"
    puts getFromPoint
    puts getToPoint

  end
#---------------------------------------------------
  def disconnect(deleteBlock)

    if deleteBlock.getUplinks == [] && deleteBlock.getDownlinks == []
      return
    end

    puts "Deleted ID #{getId}: #{self}"
    if getUplinks != []
      getUplinks.each do |block|
            block.getDownlinks.delete(deleteBlock)
            if block.getDownlinks.empty?
              #In this case, block is deleted
            else
              block.setAttachTo(block.getDownlinks[0].getId) #If there is another downlink to support it switches the block ID it is attached to
            end
      end
    end
    getDownlinks.each do |block|
      if block.class.name != "Baseplate"
        if block.getUplinks.include?(deleteBlock)
          block.getUplinks.delete(deleteBlock)
        end
      end
    end
    getUplinks.clear
    getDownlinks.clear
  end

#---------------------------------------------------
end
