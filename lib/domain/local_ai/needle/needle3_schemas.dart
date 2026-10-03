const Map<String, Object?> needle3RecipeIntentSchema =
    <String, Object?>{
  'name': 'find_recipes',
  'description':
      'Extract only recipe-search constraints explicitly stated by the user.',
  'parameters': <String, Object?>{
    'type': 'object',
    'properties': <String, Object?>{
      'ingredients': <String, Object?>{
        'type': 'array',
        'items': <String, Object?>{'type': 'string'},
        'description':
            'Ingredient names explicitly provided by the user. Do not invent.',
      },
      'max_minutes': <String, Object?>{
        'type': <String>['integer', 'null'],
        'minimum': 1,
        'maximum': 1440,
      },
      'category': <String, Object?>{
        'type': <String>['string', 'null'],
        'enum': <Object?>[
          'starter',
          'first_course',
          'main_course',
          'side',
          'dessert',
          null,
        ],
      },
      'diet': <String, Object?>{
        'type': 'array',
        'items': <String, Object?>{
          'type': 'string',
          'enum': <String>['vegan', 'vegetarian'],
        },
      },
      'exclude_allergens': <String, Object?>{
        'type': 'array',
        'items': <String, Object?>{
          'type': 'string',
          'enum': <String>[
            'gluten',
            'milk',
            'eggs',
            'fish',
            'crustaceans',
            'tree_nuts',
            'soy',
            'celery',
            'mustard',
            'sesame',
          ],
        },
      },
      'techniques': <String, Object?>{
        'type': 'array',
        'items': <String, Object?>{
          'type': 'string',
          'enum': <String>[
            'air_fryer',
            'baking',
            'sous_vide',
            'grilling',
            'steaming',
          ],
        },
      },
      'anti_waste': <String, Object?>{'type': 'boolean'},
    },
    'required': <String>[
      'ingredients',
      'diet',
      'exclude_allergens',
      'techniques',
      'anti_waste',
    ],
    'additionalProperties': false,
  },
};

const Map<String, Object?> needle3RerankSchema =
    <String, Object?>{
  'name': 'rerank_recipes',
  'description':
      'Return only recipe IDs from the supplied candidate list, best match first.',
  'parameters': <String, Object?>{
    'type': 'object',
    'properties': <String, Object?>{
      'ordered_recipe_ids': <String, Object?>{
        'type': 'array',
        'items': <String, Object?>{'type': 'string'},
      },
    },
    'required': <String>['ordered_recipe_ids'],
    'additionalProperties': false,
  },
};
