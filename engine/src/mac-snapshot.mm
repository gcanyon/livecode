/* Copyright (C) 2003-2013 Runtime Revolution Ltd.
 
 This file is part of LiveCode.
 
 LiveCode is free software; you can redistribute it and/or modify it under
 the terms of the GNU General Public License v3 as published by the Free
 Software Foundation.
 
 LiveCode is distributed in the hope that it will be useful, but WITHOUT ANY
 WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
 for more details.
 
 You should have received a copy of the GNU General Public License
 along with LiveCode.  If not see <http://www.gnu.org/licenses/>.  */

#include <Cocoa/Cocoa.h>

#include "core.h"
#include "globdefs.h"

#include "imagebitmap.h"

#include "platform.h"
#include "platform-internal.h"

#include "mac-internal.h"

////////////////////////////////////////////////////////////////////////////////

static void MCMacPlatformCGImageToMCImageBitmap(CGImageRef p_image, MCImageBitmap*& r_bitmap)
{
	if (p_image != nil)
	{
		MCImageBitmap *t_bitmap;
		/* UNCHECKED */ MCImageBitmapCreate(CGImageGetWidth(p_image), CGImageGetHeight(p_image), t_bitmap);
		
		CFDataRef t_data;
		t_data = CGDataProviderCopyData(CGImageGetDataProvider(p_image));
		
		uint8_t *t_bytes;
		t_bytes = (uint8_t *)CFDataGetBytePtr(t_data);
		
		for(int32_t y = 0; y < CGImageGetHeight(p_image); y++)
			memcpy((uint8_t*)t_bitmap -> data + y * t_bitmap -> stride, t_bytes + y * CGImageGetBytesPerRow(p_image), CGImageGetWidth(p_image) * 4);
		
		CFRelease(t_data);
		
		r_bitmap = t_bitmap;
	}
	else
		r_bitmap = nil;
}

void MCPlatformScreenSnapshotOfUserArea(MCImageBitmap*& r_bitmap)
{
	// COCOA-TODO: Screen snapshot of area.
	r_bitmap = nil;
}

void MCPlatformScreenSnapshotOfWindow(uint32_t p_window_id, MCImageBitmap*& r_bitmap)
{
	CGImageRef t_image;
	t_image = CGWindowListCreateImage(CGRectNull, kCGWindowListOptionIncludingWindow, p_window_id, kCGWindowImageBoundsIgnoreFraming);
	MCMacPlatformCGImageToMCImageBitmap(t_image, r_bitmap);
	CGImageRelease(t_image);
}

void MCPlatformScreenSnapshot(MCRectangle p_screen_rect, MCImageBitmap*& r_bitmap)
{
	CGRect t_area;
	t_area = CGRectMake(p_screen_rect . x, p_screen_rect . y, p_screen_rect . width, p_screen_rect . height);
	
	CGImageRef t_image;
	t_image = CGWindowListCreateImage(t_area, kCGWindowListOptionOnScreenOnly, kCGNullWindowID, kCGWindowImageDefault);
	MCMacPlatformCGImageToMCImageBitmap(t_image, r_bitmap);
	CGImageRelease(t_image);
}

////////////////////////////////////////////////////////////////////////////////
