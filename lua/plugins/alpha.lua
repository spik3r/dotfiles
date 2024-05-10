-- Count support for [count]gcc and [count]gbc
-- Left-right (gcw gc$) and Up-Down (gc2j gc4k) motions
-- Use with text-objects (gci{ gbat)
return {
  "goolord/alpha-nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },

  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.startify")

    dashboard.section.header.val = {
       [[                                                       ]],
       [[                                     ==+=  =           ]],
       [[          ***==++             .-+=*   --=+#**.         ]],
       [[    =.--   *+**+**+:      =##**++.:=****+*#**=.        ]],
       [[                :++==+****++===+*%%#=   ..*-*          ]],
       [[        -=#%#-=    ** +#%#**+++***==%= .    -=#%#-=    ]],
       [[    -**   ===+%* .  :##%%%  -**#%*:-.    -**   ==+%* . ]],
       [[   +**   :.:   -*=          ***+** -    ***  :.:   -*= ]],
       [[   +##*.      *#=                       -#+       -**  ]],
       [[      -#****+                              -#****+     ]],
       [[         ...                                  ...      ]],
    }

    alpha.setup(dashboard.opts)
  end,
}
