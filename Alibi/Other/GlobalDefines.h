//
//  GlobalDefines.h
//  Alibi
//
//  Created by Matias Willand on 20/11/13.
//  Copyright (c) 2013 Planet 1107. All rights reserved.
//

#ifndef Alibi_GlobalDefines_h
#define Alibi_GlobalDefines_h

#define kDefaultPageSize 20

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define ALERT(_title,_text)		[[[UIAlertView alloc] initWithTitle:_title message:_text delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show]

#define GET_VALIDATED_STRING(_obj, _def_str) _obj == (id)[NSNull null] || _obj == nil ? _def_str : [NSString stringWithFormat:@"%@", _obj]

#define GET_VALIDATED_DOUBLE(_obj, _def_val) _obj == (id)[NSNull null] || _obj == nil ? _def_val : [_obj doubleValue]

#define VALIDATE_STRING(_obj, _def_str) _obj = _obj == (id)[NSNull null] || _obj == nil ? _def_str : [NSString stringWithFormat:@"%@", _obj];

#define UNIQUE_ID [[NSUserDefaults standardUserDefaults] objectForKey:@"uniqueID"]

#define MAIN_FONT_NAME @"SegoeUI"
#define MAIN_LIGHTFONT_NAME @"SegoeUI-Light"
#define MAIN_BOLDFONT_NAME @"SegoeUI-Bold"
#define MAIN_SEMIBOLDFONT_NAME @"SegoeUI-Semibold"

#define NAVBAR_BACK_COLOR RGB(56, 198, 237)

#define MAIN_BACK_COLOR RGB(229, 227, 218)

#define MAIN_GRAY_BACK_COLOR RGB(230, 231, 232)

#define MAIN_GRAY_FONT_COLOR RGB(88, 89, 91)

#define BUTTON_GRAY_BACK_COLOR RGB(214, 214, 214)

#endif