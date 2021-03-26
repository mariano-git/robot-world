#
# Bom Payload
#
class BomPayload
  def initialize(type, models)
    @models = models
    @type = type
  end

  def as_payload
    @items = []
    @models.each do |model|
      @item = {
        'id' => model.id,
        'serial' => SecureRandom.uuid,
        'name' => model.name,
        'components' => []
      }

      model.model_specifications.each do |spec|
        i = 1
        until i > spec.qty
          @component = {
            'id' => spec.component.id,
            'category' => spec.component.category,
            'name' => spec.component.name,
            'serial' => SecureRandom.uuid
          }
          i += 1
          @item['components'].push(@component)
        end
      end
      @items.push(@item)
    end

    return { 'type' => @type, 'items' => @items }

  end
end


