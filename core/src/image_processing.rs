use std::sync::Mutex;

// Importing necessary image processing and screenshot capturing modules.
use image::{DynamicImage, GenericImageView, Pixel, Rgba};
use screenshots::{DisplayInfo, Screen};
use tracing::{info, warn};

use crate::{HEIGHT, WIDTH, X_POS, Y_POS};

lazy_static! {
    pub static ref SCREEN: Mutex<Option<DynamicImage>> = Mutex::new(None);
}

// Function that takes a screenshot of a specified area.
// It takes as parameters the x, y coordinates and the width, height of the desired area.
pub fn screenshot(x: u16, y: u16, width: u16, height: u16) -> DynamicImage {
    // Determine current display size
    let display = size();
    // Ensure the capture area is within the screen size
    if !(x + width <= display.0 && y + height <= display.1) {
        panic!("One or more specified parameter is not within the screen size. Use screen::size() to check.")
    }

    // Retrieve screen based on specified coordinates
    let screen =
        Screen::from_point(x.into(), y.into()).expect("Cannot get screen from specified x and y");

    // Capture specified area of the screen
    let capture = screen
        .capture_area(x.into(), y.into(), width.into(), height.into())
        .expect("Unable to screen capture.");

    // Convert capture to image buffer
    let buffer = capture.buffer();

    // Load the image from memory buffer
    let dynamic_image = image::load_from_memory(buffer).unwrap();

    return dynamic_image;
}

// Function to get the size of the primary display.
fn size() -> (u16, u16) {
    // Retrieve all display info
    let displays: Vec<DisplayInfo> = DisplayInfo::all().expect("Unable to get displays");
    // Find primary display
    let primary = displays
        .iter()
        .find(|display| display.is_primary == true)
        .expect("Unable to find primary display");
    // Return width and height of primary display
    return (primary.width as u16, primary.height as u16);
}

// Function to locate an image on the screen with optional region, minimum confidence, and tolerance.
// Returns coordinates, width, height and confidence if image is found, otherwise None.
fn locate_on_screen(
    screen: &[Rgba<u8>],
    img: &[Rgba<u8>],
    screen_width: u32,
    screen_height: u32,
    img_width: u32,
    img_height: u32,
    min_confidence: f32,
    tolerance: u8,
) -> Option<(u32, u32, u32, u32, f32)> {
    let step_size = 1;
    warn!("Screen height: {:?} img_height: {:?}", screen_height, img_height);
    for y in (0..screen_height - img_height).step_by(step_size) {
        for x in (0..screen_width - img_width).step_by(step_size) {
            let mut matching_pixels = 0;
            let mut total_pixels = 0;

            'outer: for dy in 0..img_height {
                let base_screen_idx = (y + dy) * screen_width + x;
                let base_img_idx = dy * img_width;

                for dx in 0..img_width {

                    let screen_idx =
                        unsafe { screen.get_unchecked((base_screen_idx + dx) as usize) };
                    let img_idx = unsafe { img.get_unchecked((base_img_idx + dx) as usize) };
                    
                    let screen_pixel = *screen_idx;
                    let img_pixel = *img_idx;
                    
                    // Skip transparent pixels
                    if img_pixel[3] < 128 {
                        continue;
                    }
                    
                    total_pixels += 1;

                    if within_tolerance(screen_pixel[0], img_pixel[0], tolerance)
                        && within_tolerance(screen_pixel[1], img_pixel[1], tolerance)
                        && within_tolerance(screen_pixel[2], img_pixel[2], tolerance)
                    {
                        matching_pixels += 1;
                    } else {
                        break 'outer;
                    }
                }
            }

            let confidence = if total_pixels == 0 {
                0.0
            } else {
                matching_pixels as f32 / total_pixels as f32
            };

            //warn!("Confidence: {:?}", confidence);

            if confidence >= min_confidence {
                return Some((x, y, img_width, img_height, confidence));
            }
        }
    }

    None
}

// Helper function to check if a color value is within a tolerance range
#[inline]
fn within_tolerance(value1: u8, value2: u8, tolerance: u8) -> bool {
    let min_value = value2.saturating_sub(tolerance);
    let max_value = value2.saturating_add(tolerance);
    value1 >= min_value && value1 <= max_value
}

// Function to locate an image on the screen with optional region, minimum confidence, and tolerance.
// Returns coordinates, width, height and confidence if image is found, otherwise None.
pub fn locate_image(
    img: &DynamicImage,
    _region: Option<(u16, u16, u16, u16)>,
    min_confidence: Option<f32>,
    tolerance: Option<u8>,
) -> Option<(u32, u32, u32, u32, f32)> {
    // Default values
    //let (x, y, width, height) = region.unwrap_or((0, 0, size().0, size().1));
    let min_confidence = min_confidence.unwrap_or(0.75);
    let tolerance = tolerance.unwrap_or(25);

    let img_pixels: Vec<_> = img.pixels().map(|p| p.2.to_rgba()).collect();
    let img_width = img.width();
    let img_height = img.height();

    //let screenshot = screenshot(x, y, width, height);
    //unsafe {update_screenshot(Some((X_POS, Y_POS, WIDTH, HEIGHT)))};
    let screenshot = SCREEN.lock().unwrap().as_ref().unwrap().clone();
    let screen_pixels: Vec<_> = screenshot.pixels().map(|p| p.2.to_rgba()).collect();
    let screen_width = screenshot.width();
    let screen_height = screenshot.height();
    std::mem::drop(screenshot);

    locate_on_screen(
        &screen_pixels,
        &img_pixels,
        screen_width,
        screen_height,
        img_width,
        img_height,
        min_confidence,
        tolerance,
    )
}

pub fn update_screenshot(region: Option<(u16, u16, u16, u16)>) {
    let (x, y, width, height) = region.unwrap_or((0, 0, size().0, size().1));
    let screenshot = screenshot(x, y, width, height);
    let mut screen = SCREEN.lock().unwrap();
    *screen = Some(screenshot);
}
