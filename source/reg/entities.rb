# Random Entity Generator extension for SketchUp 2017 or newer.
# Copyright: © 2019 Samuel Tallet <samuel.tallet arobase gmail.com>
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3.0 of the License, or
# (at your option) any later version.
# 
# If you release a modified version of this program TO THE PUBLIC,
# the GPL requires you to MAKE THE MODIFIED SOURCE CODE AVAILABLE
# to the program's users, UNDER THE GPL.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
# 
# Get a copy of the GPL here: https://www.gnu.org/licenses/gpl.html

raise 'The REG plugin requires at least Ruby 2.2.0 or SketchUp 2017.'\
  unless RUBY_VERSION.to_f >= 2.2 # SketchUp 2017 includes Ruby 2.2.4.

require 'sketchup'
require 'reg/transform'
require 'reg/shapes'
require 'reg/materials'

# REG plugin namespace.
module REG

  # Entities.
  module Entities

    # Clones a group or component.
    #
    # @param [Sketchup::Group|Sketchup::ComponentInstance]
    # @raise [ArgumentError]
    #
    # @return [Sketchup::Group|Sketchup::ComponentInstance]
    def self.clone_grouponent(original_grouponent)

      raise ArgumentError, 'Grouponent parameter is invalid.'\
        unless original_grouponent.is_a?(Sketchup::Group)\
          || original_grouponent.is_a?(Sketchup::ComponentInstance)

      if original_grouponent.is_a?(Sketchup::Group)

        cloned_grouponent = original_grouponent.copy
        cloned_grouponent.material = original_grouponent.material
      
      else # if original_grouponent.is_a?(Sketchup::ComponentInstance)

        cloned_grouponent = Sketchup.active_model.entities.add_instance(
          original_grouponent.definition,
          Geom::Transformation.new
        )

        material_name = cloned_grouponent.definition.get_attribute(
          Proxies::ATTR_DICT_NAME, :MaterialName
        )

        if !material_name.nil?

          cloned_grouponent.material = Sketchup.active_model.materials[
            material_name
          ]

        end

      end

      cloned_grouponent

    end

    # Randomizes an entity's position and size.
    #
    # @param [Sketchup::Entity] entity
    # @raise [ArgumentError]
    #
    # @return [Sketchup::Entity]
    def self.randomize_position_and_size(entity)

      raise ArgumentError, 'Entity parameter must be a Sketchup::Entity.'\
        unless entity.is_a?(Sketchup::Entity)

      entity.transform!(Transformations.generate_random_rotation)

      entity.transform!(Transformations.generate_random_scaling)

      entity.transform!(Transformations.generate_random_translation)

      entity

    end

    # Generates a random entity.
    #
    # @return [Sketchup::Group]
    def self.generate_random

      group = Shapes.generate_random

      group.material = Materials.generate_random

      randomize_position_and_size(group)

    end

    # Detects collided entities.
    #
    # @param [Array<Sketchup::Entity>] entities Entities.
    #
    # @return [Array<Sketchup::Entity>] Collided entities.
    def self.collision_detect(entities)

      ent_bounding_boxes = []
      collided_entities = []

      entities.each { |entity|

        ent_bounding_boxes.push([entity, entity.bounds])

      }

      ent_bounding_boxes.each { |entity_1, bounding_box_1|

        ent_bounding_boxes.each { |entity_2, bounding_box_2|

          if entity_1.object_id == entity_2.object_id

            next

          end

          if bounding_box_1.intersect(bounding_box_2).valid?

            collided_entities.push(entity_1)
            collided_entities.push(entity_2)

          end

        }

      }

      collided_entities

    end

  end

end
