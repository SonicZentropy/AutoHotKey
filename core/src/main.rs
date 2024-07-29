#![allow(unused_imports)]
#![allow(non_snake_case)]

#[macro_use]
extern crate lazy_static;

mod image_processing;
mod utils;
use tracing::{info, trace, warn};
use utils::*;

use eframe::{
    egui::{self, ColorImage},
    EventLoopBuilderHook,
};
use image::{DynamicImage, GenericImageView, Pixel, Rgba};
use inputbot::{
    KeySequence,
    KeybdKey::{self, *},
    MouseButton::*,
};
use rayon::prelude::*;
use derive_more::Display;
use std::ffi::OsString;
use std::os::windows::ffi::OsStrExt;
use std::os::windows::ffi::OsStringExt;
use std::sync::{Arc, Mutex, MutexGuard, Once};
use std::{fs::File, io::BufWriter};
use std::{thread::sleep, time::Duration};
use tap::prelude::*;
use tracing_subscriber::{fmt, prelude::*, registry::Registry};
use windows::{core::HSTRING, Win32::Foundation::{BOOL, HWND, LPARAM, RECT}};
use windows::Win32::UI::WindowsAndMessaging::{FindWindowW, GetWindowRect};
use winit::platform::windows::EventLoopBuilderExtWindows;

use crate::image_processing::*;

static mut X_POS: u16 = 0;
static mut Y_POS: u16 = 0;
static mut X_POS_OFFSET: u16 = 10;
static mut Y_POS_OFFSET: u16 = 15;
static mut WIDTH: u16 = 5;
static mut HEIGHT: u16 = 5;

fn main() -> eframe::Result {
   
    tracing_subscriber::fmt()
        // enable everything
        .with_max_level(tracing::Level::INFO)
        .compact()
        // Display source code file paths
        .with_file(true)
        // Display source code line numbers
        .with_line_number(true)
        // Display the thread ID an event was recorded on
        .with_thread_ids(false)
        // Don't display the event's target (module path)
        .with_target(false)
        // sets this to be the default, global collector for this application.
        .init();
    
    let win = find_window_by_title("World of Warcraft").unwrap();
    let rect = get_window_rect(win).unwrap();
    let width = rect.right - rect.left;
    let height = rect.bottom - rect.top;
    warn!("Window Size: {:?}", (width, height));
    unsafe {X_POS = X_POS_OFFSET + rect.left as u16 ; Y_POS =  (rect.bottom as u16 - HEIGHT - Y_POS_OFFSET) as u16; }
    
    unsafe {update_screenshot(Some((X_POS, Y_POS, WIDTH, HEIGHT)))};

    Numpad0Key.bind(|| {
        profile!("Full Search Process", execute_search_process());
        //fastrace::flush();
    });

    // Exit program
    Numpad1Key.bind(|| {
        inputbot::stop_handling_input_events();
    });

    let _handle = std::thread::spawn(|| {
        inputbot::handle_input_events(false);
    });

    let options = eframe::NativeOptions {
        viewport: egui::ViewportBuilder::default()
            .with_inner_size([200.0, 200.0])
            //.with_mouse_passthrough(true)
            //.with_transparent(true)
            .with_decorations(true),
        ..Default::default()
    };
    eframe::run_native(
        "Dev Tools",
        options,
        Box::new(|_cc| {
            Ok(Box::<MyApp>::default())
        }),
    )
    .unwrap();
    
    info!("Exiting safely!");
    Ok(())
}


#[derive(Default)]
struct MyApp {}

impl eframe::App for MyApp {
    fn update(&mut self, ctx: &egui::Context, _frame: &mut eframe::Frame) {
        ctx.set_visuals(egui::Visuals {
            //panel_fill: egui::Color32::TRANSPARENT,
            ..Default::default()
        });

        egui::CentralPanel::default().show(ctx, |ui| {
            egui::ScrollArea::both().show(ui, |ui| {
                unsafe {
                    let mut x_pos = X_POS as f64;
                    let mut y_pos = Y_POS as f64;
                    let mut width = WIDTH as f64;
                    let mut height = HEIGHT as f64;
                
                    ui.label("X Position");
                    if ui.add(egui::Slider::new(&mut x_pos, 0.0..=3440.0)).changed() {
                        X_POS = x_pos as u16;
                    }
                
                    ui.label("Y Position");
                    if ui.add(egui::Slider::new(&mut y_pos, 0.0..=1440.0)).changed() {
                        Y_POS = y_pos as u16;
                    }
                
                    ui.label("Width");
                    if ui.add(egui::Slider::new(&mut width, 0.0..=200.0)).changed() {
                        WIDTH = width as u16;
                    }
                    
                    ui.label("Height");
                    if ui.add(egui::Slider::new(&mut height, 0.0..=200.0)).changed() {
                        HEIGHT = height as u16;
                    }
                }
                               
                let screenshot = SCREEN.lock().unwrap().as_ref().unwrap().clone();
                let color_image = dynamic_image_to_color_image(screenshot);
                
                let texture = ui.ctx().load_texture(
                    "logo",
                    egui::ImageData::Color(Arc::new(color_image)),
                    Default::default(),
                );
                
                 ui.image(&texture);
                 
                 let img_clone = IMG_0.clone();
                 let inner_image = &*img_clone; // Dereference the Arc to get &DynamicImage
                 let comparison_img = dynamic_image_to_color_image(inner_image.clone());
                
                let texture = ui.ctx().load_texture(
                    "comparison",
                    egui::ImageData::Color(Arc::new(comparison_img)),
                    Default::default(),
                );
                
                 ui.image(&texture);
                 
                 let img_clone = IMG_7.clone();
                 let inner_image = &*img_clone; // Dereference the Arc to get &DynamicImage
                 let comparison_img = dynamic_image_to_color_image(inner_image.clone());
                
                let texture = ui.ctx().load_texture(
                    "comparison",
                    egui::ImageData::Color(Arc::new(comparison_img)),
                    Default::default(),
                );
                
                 ui.image(&texture);
                
            });
        });
    }

    fn clear_color(&self, visuals: &egui::Visuals) -> [f32; 4] {
        let u8_array = visuals.panel_fill.to_array();
        // Convert each u8 value to f32
        let f32_array: [f32; 4] = [
            u8_array[0] as f32,
            u8_array[1] as f32,
            u8_array[2] as f32,
            u8_array[3] as f32,
        ];
        f32_array
    }
}

fn dynamic_image_to_color_image(dynamic_image: DynamicImage) -> ColorImage {
    let image_buffer = dynamic_image.to_rgba8();
    let (width, height) = image_buffer.dimensions();
    let pixels = image_buffer.into_raw();
    ColorImage::from_rgba_unmultiplied([width as usize, height as usize], &pixels)
}

fn find_keybinds_parallel(
    images: Vec<(&Arc<DynamicImage>, KeybindTypes)>,
    region: Option<(u16, u16, u16, u16)>,
    min_confidence: Option<f32>,
    tolerance: Option<u8>,
) -> Option<KeybindTypes> {
    images
        .into_par_iter()
        .filter_map(|(img, keybind)| {
            trace!("Testing keybind: {:?}", keybind);
            match locate_image(&**img, region, min_confidence, tolerance) {
                Some((_x, _y, _img_width, _img_height, confidence)) => {
                    trace!("Found match for keybind: {:?} with confidence: {:?}", keybind, confidence);
                    Some((keybind, confidence))},
                None => {
                    trace!("No match found for keybind: {:?}", keybind);
                    None},
            }
        })
        .max_by(|(_, confidence1), (_, confidence2)| confidence1.partial_cmp(confidence2).unwrap())
        .tap(|conf| tracing::warn!("Max found confidence: {:?}", conf))
        .map(|(keybind, _)| keybind)
}

#[derive(Debug, Copy, Clone, Display)]
#[display(fmt = "r: {:.2}, g: {:.2}, b: {:.2}, a: {:.2}", r, g, b, a)]
pub struct PixelColor {
    pub r: f32,
    pub g: f32,
    pub b: f32,
    pub a: f32,
}

impl PixelColor {
    fn new(r: u8, g: u8, b: u8, a: u8) -> Self {
        PixelColor {
            r: r as f32 / 255.0,
            g: g as f32 / 255.0,
            b: b as f32 / 255.0,
            a: a as f32 / 255.0,
        }
    }
    
    fn white() -> PixelColor {
        PixelColor {
            r: 1.0,
            g: 1.0,
            b: 1.0,
            a: 1.0,
        }
    }
}

impl From<&Rgba<u8>> for PixelColor {
    fn from(rgba: &Rgba<u8>) -> Self {
        PixelColor {
            r: rgba[0] as f32 / 255.0,
            g: rgba[1] as f32 / 255.0,
            b: rgba[2] as f32 / 255.0,
            a: rgba[3] as f32 / 255.0,
        }
    }
}

pub fn check_pixel_colors_match(
    pixel_color: PixelColor,
    white_pixel_color: PixelColor,
    tolerance: f32,
) -> bool {
    (pixel_color.r - white_pixel_color.r).abs() <= tolerance
        && (pixel_color.g - white_pixel_color.g).abs() <= tolerance
        && (pixel_color.b - white_pixel_color.b).abs() <= tolerance
        && (pixel_color.a - white_pixel_color.a).abs() <= tolerance
}


pub(crate) fn get_next_keybind_from_screen() -> Option<KeybindTypes> {
    let screenshot = unsafe{ screenshot(X_POS, Y_POS, WIDTH, HEIGHT)};
    let width = screenshot.width();
    let height = screenshot.height();
    let screen_pixels: Vec<_> = screenshot.pixels().map(|p| p.2.to_rgba()).collect();
    let screen_idx = unsafe { screen_pixels.get_unchecked( (width /2) as usize + (height /2) as usize) };
    let screen_pixel = *screen_idx;
    
    let screen_pixel_color = PixelColor::from(&screen_pixel);
    let white_pixel_color = PixelColor::white();
   
    
    warn!("Screen pixel color: {:?}", screen_pixel_color);
    warn!("White pixel color: {:?}", white_pixel_color);
    let res = check_pixel_colors_match(screen_pixel_color, white_pixel_color, 0.05);
    warn!("Check pixel colors match: {:?}", res);
    
    None
    
    // OLD CODE matching font images instead of color squares
    //let images_with_keybinds: Vec<(&Arc<DynamicImage>, KeybindTypes)> = vec![
    //    (&IMG_Q, KeybindTypes::KeyQ),
    //    (&IMG_E, KeybindTypes::KeyE),
    //    (&IMG_R, KeybindTypes::KeyR),
    //    (&IMG_F, KeybindTypes::KeyF),
    //    (&IMG_Z, KeybindTypes::KeyZ),
    //    (&IMG_X, KeybindTypes::KeyX),
    //    (&IMG_C, KeybindTypes::KeyC),
    //    (&IMG_V, KeybindTypes::KeyV),
    //    (&IMG_1, KeybindTypes::Key1),
    //    (&IMG_2, KeybindTypes::Key2),
    //    (&IMG_3, KeybindTypes::Key3),
    //    (&IMG_4, KeybindTypes::Key4),
    //    (&IMG_5, KeybindTypes::Key5),
    //    (&IMG_6, KeybindTypes::Key6),
    //    (&IMG_7, KeybindTypes::Key7),
    //    (&IMG_8, KeybindTypes::Key8),
    //    (&IMG_9, KeybindTypes::Key9),
    //    (&IMG_0, KeybindTypes::Key0),
    //    (&IMG_DASH, KeybindTypes::KeyDash),
    //    (&IMG_EQUALS, KeybindTypes::KeyEquals),
    //    (&IMG_S1, KeybindTypes::KeyS1),
    //    (&IMG_S2, KeybindTypes::KeyS2),
    //    (&IMG_S3, KeybindTypes::KeyS3),
    //    (&IMG_S4, KeybindTypes::KeyS4),
    //    (&IMG_S5, KeybindTypes::KeyS5),
    //    (&IMG_S6, KeybindTypes::KeyS6),
    //    (&IMG_S7, KeybindTypes::KeyS7),
    //    (&IMG_S8, KeybindTypes::KeyS8),
    //    (&IMG_S9, KeybindTypes::KeyS9),
    //    (&IMG_S0, KeybindTypes::KeyS0),
    //    //(&IMG_SDASH, KeybindTypes::KeySDash),
    //    //(&IMG_SEQUALS, KeybindTypes::KeySEquals),
    //];

    //let region = unsafe {Some((X_POS, Y_POS, WIDTH, HEIGHT))};
    //let min_confidence = Some(0.95);
    //let tolerance = Some(0);
    
    //let found_keybind =
    //    find_keybinds_parallel(images_with_keybinds, region, min_confidence, tolerance);

    //found_keybind
}

fn execute_search_process() {

    let region = unsafe {Some((X_POS, Y_POS, WIDTH, HEIGHT))} ;
    update_screenshot(region);

    if let Some(keybind) = get_next_keybind_from_screen() {
        match keybind {
            KeybindTypes::KeyQ => press_key(QKey),
            KeybindTypes::KeyE => press_key(EKey),
            KeybindTypes::KeyR => press_key(RKey),
            KeybindTypes::KeyF => press_key(FKey),
            KeybindTypes::KeyZ => press_key(ZKey),
            KeybindTypes::KeyX => press_key(XKey),
            KeybindTypes::KeyC => press_key(CKey),
            KeybindTypes::KeyV => press_key(VKey),
            KeybindTypes::Key1 => press_key(Numrow1Key),
            KeybindTypes::Key2 => press_key(Numrow2Key),
            KeybindTypes::Key3 => press_key(Numrow3Key),
            KeybindTypes::Key4 => press_key(Numrow4Key),
            KeybindTypes::Key5 => press_key(Numrow5Key),
            KeybindTypes::Key6 => press_key(Numrow6Key),
            KeybindTypes::Key7 => press_key(Numrow7Key),
            KeybindTypes::Key8 => press_key(Numrow8Key),
            KeybindTypes::Key9 => press_key(Numrow9Key),
            KeybindTypes::Key0 => press_key(Numrow0Key),
            KeybindTypes::KeyDash => press_key(MinusKey),
            KeybindTypes::KeyEquals => press_key(EqualKey),
            KeybindTypes::KeyS1 => press_shift_key_sequence(Numrow1Key),
            KeybindTypes::KeyS2 => press_shift_key_sequence(Numrow2Key),
            KeybindTypes::KeyS3 => press_shift_key_sequence(Numrow3Key),
            KeybindTypes::KeyS4 => press_shift_key_sequence(Numrow4Key),
            KeybindTypes::KeyS5 => press_shift_key_sequence(Numrow5Key),
            KeybindTypes::KeyS6 => press_shift_key_sequence(Numrow6Key),
            KeybindTypes::KeyS7 => press_shift_key_sequence(Numrow7Key),
            KeybindTypes::KeyS8 => press_shift_key_sequence(Numrow8Key),
            KeybindTypes::KeyS9 => press_shift_key_sequence(Numrow9Key),
            KeybindTypes::KeyS0 => press_shift_key_sequence(Numrow0Key),
            KeybindTypes::KeySDash => press_shift_key_sequence(MinusKey),
            KeybindTypes::KeySEquals => press_shift_key_sequence(EqualKey),
        }
    }
}

fn find_window_by_title(title: &str) -> anyhow::Result<HWND> {
    //let title_wide: Vec<u16> = OsString::from(title.clone())
    //    .encode_wide()
    //    .chain(std::iter::once(0))
    //    .collect();
    //let _hwnd = unsafe { FindWindowW(None, title_wide.as_ptr()) };
    //unsafe { desktop.SetWallpaper(None, &HSTRING::from(&path)) };
     unsafe { FindWindowW(None, &HSTRING::from(title)) }
        .map_err(|e| anyhow::anyhow!(e.message()))
    
    //if hwnd.0 == 0 {
    //    None
    //} else {
    //    Some(hwnd)
    //}
    //hwnd
}

fn get_window_rect(hwnd: HWND) -> Option<RECT> {
    let mut rect = RECT::default();
    let success = unsafe { GetWindowRect(hwnd, &mut rect) };
    dbg!(rect);
    if success.is_ok() {
        Some(rect)
    } else {
        None
    }
}
