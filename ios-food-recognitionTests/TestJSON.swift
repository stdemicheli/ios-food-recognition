//
//  TestJSON.swift
//  ios-food-recognitionTests
//
//  Created by De MicheliStefano on 27.09.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation

let validNutritionixJSON = """
{
"branded": [
{
"food_name": "Grilled Cheese",
"image": null,
"serving_unit": "serving",
"nix_brand_id": "513fbc1283aa2dc80c000358",
"brand_name_item_name": "Claim Jumper Grilled Cheese",
"serving_qty": 1,
"nf_calories": 560,
"brand_name": "Claim Jumper",
"brand_type": 1,
"nix_item_id": "529e800af9655f6d3500c710"
},
{
"food_name": "Grilled Cheesewich",
"image": null,
"serving_unit": "serving",
"nix_brand_id": "521b95434a56d006cae29678",
"brand_name_item_name": "Red Robin Grilled Cheesewich",
"serving_qty": 1,
"nf_calories": 550,
"brand_name": "Red Robin",
"brand_type": 1,
"nix_item_id": "52cdccf0051cb9eb320054c6"
},
{
"food_name": "Grilled Cheese Melts",
"image": "https://d1r9wva3zcpswd.cloudfront.net/54ca49ac6f1a024b0f919764.jpeg",
"serving_unit": "slice",
"nix_brand_id": "51db37b5176fe9790a8988dd",
"brand_name_item_name": "Borden Grilled Cheese Melts",
"serving_qty": 1,
"nf_calories": 50,
"brand_name": "Borden",
"brand_type": 2,
"nix_item_id": "54ca48fc064e3a791d6737b0"
},
{
"food_name": "Kid's Grilled Cheese",
"image": null,
"serving_unit": "serving",
"nix_brand_id": "521b95494a56d006cae2a612",
"brand_name_item_name": "Larkburger Kid's Grilled Cheese",
"serving_qty": 1,
"nf_calories": 500,
"brand_name": "Larkburger",
"brand_type": 1,
"nix_item_id": "529e80ceea63d4933500fc87"
}

],
"self": [
{
"food_name": "grilled cheese",
"serving_unit": "sandwich",
"nix_brand_id": null,
"serving_qty": 1,
"nf_calories": 348.4,
"brand_name": null,
"uuid": "7e79cdfa-bb3f-4f3b-a292-3357aa35d31f",
"nix_item_id": null
},
{
"food_name": "cheeseburgers",
"serving_unit": "item",
"nix_brand_id": null,
"serving_qty": 1.5,
"nf_calories": 802.97,
"brand_name": null,
"uuid": "5a63f2af-34b2-4137-bf14-5d95eabcf12d",
"nix_item_id": null
}
],
"common": [
{
"food_name": "grilled cheese",
"image": "https://d2xdmhkmkbyw75.cloudfront.net/1763_thumb.jpg",
"tag_id": "1763"
},
{
"food_name": "grilled cheeses",
"image": "https://d2xdmhkmkbyw75.cloudfront.net/1763_thumb.jpg",
"tag_id": "1763"
},
{
"food_name": "grilled cheese cheeseburger melt",
"image": null,
"tag_id": "5901"
},
{
"food_name": "grilled cheese cheeseburger",
"image": null,
"tag_id": "5901"
},
{
"food_name": "grilled cheese burger",
"image": null,
"tag_id": "5901"
}
]
}
""".data(using: .utf8)
