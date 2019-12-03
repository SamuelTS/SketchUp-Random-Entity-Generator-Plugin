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

# REG plugin namespace.
module REG

  # Materials.
  module Materials

    # Generates a random material.
    #
    # @return [Sketchup::Material]
    def self.generate_random

      material = Sketchup.active_model.materials.add(rand.to_s)

      material.color = Sketchup::Color.new(
        rand(0..255), # Red
        rand(0..255), # Green
        rand(0..255) # Blue
      )

      material.alpha = [0.5, 1, 1, 1, 1, 1, 1, 1, 1, 1].sample

      material

    end

  end

end
