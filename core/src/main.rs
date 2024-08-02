#![allow(unused_imports)]
#![allow(non_snake_case)]

#[macro_use]
extern crate lazy_static;

mod image_processing;
mod utils;
use tracing::{info, trace, warn};
use utils::*;

use derive_more::Display;
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
use std::ffi::OsString;
use std::os::windows::ffi::OsStrExt;
use std::os::windows::ffi::OsStringExt;
use std::sync::{Arc, Mutex, MutexGuard, Once};
use std::{fs::File, io::BufWriter};
use std::{thread::sleep, time::Duration};
use tap::prelude::*;
use tracing_subscriber::{fmt, prelude::*, registry::Registry};
use windows::Win32::UI::WindowsAndMessaging::{FindWindowW, GetWindowRect};
use windows::{
    core::HSTRING,
    Win32::Foundation::{BOOL, HWND, LPARAM, RECT},
};
use winit::platform::windows::EventLoopBuilderExtWindows;

use crate::image_processing::*;

static mut X_POS: u16 = 0;
static mut Y_POS: u16 = 0;
static mut X_POS_OFFSET: u16 = 10;
static mut Y_POS_OFFSET: u16 = 15;
static mut WIDTH: u16 = 5;
static mut HEIGHT: u16 = 5;

static mut CURRENT_KEYBIND: Option<KeybindTypes> = None;

lazy_static! {
    static ref COLORS: Vec<(PixelColor, PixelColors)> = vec![
        (PixelColor::white(), PixelColors::White),
        (PixelColor::green(), PixelColors::Green),
        (PixelColor::dark_gray(), PixelColors::DarkGray),
        (PixelColor::blue(), PixelColors::Blue),
        (PixelColor::black(), PixelColors::Black),
        (PixelColor::cyan(), PixelColors::Cyan),
        (PixelColor::yellow(), PixelColors::Yellow),
        (PixelColor::something(), PixelColors::Something),
        (PixelColor::gray(), PixelColors::Gray),
        (PixelColor::pinkish(), PixelColors::Pinkish),
        (PixelColor::mint(), PixelColors::Mint),
        (PixelColor::dark_red(), PixelColors::DarkRed),
        (PixelColor::dark_green(), PixelColors::DarkGreen),
        (PixelColor::dark_blue(), PixelColors::DarkBlue),
        (PixelColor::olive(), PixelColors::Olive),
        (PixelColor::purple(), PixelColors::Purple),
        (PixelColor::teal(), PixelColors::Teal),
        (PixelColor::light_purple(), PixelColors::LightPurple),
        (PixelColor::orange_brownish(), PixelColors::OrangeBrownish),
        (PixelColor::dark_purple(), PixelColors::DarkPurple),
        (PixelColor::light_green(), PixelColors::LightGreen),
        (PixelColor::light_yellow(), PixelColors::LightYellow),
        (PixelColor::bright_orange(), PixelColors::BrightOrange),
        (PixelColor::light_green2(), PixelColors::LightGreen2),
        (PixelColor::light_blue(), PixelColors::LightBlue),
        (PixelColor::reddish_purple(), PixelColors::ReddishPurple),
        (PixelColor::olive_drab(), PixelColors::OliveDrab),
        (PixelColor::burnt_orange(), PixelColors::BurntOrange),
        (PixelColor::dark_blue_violet(), PixelColors::DarkBlueViolet),
        (PixelColor::very_dark_blue(), PixelColors::VeryDarkBlue),
        (PixelColor::dark_magenta(), PixelColors::DarkMagenta),
        (PixelColor::mustard_yellow(), PixelColors::MustardYellow),
        (PixelColor::sea_green(), PixelColors::SeaGreen),
    ];
}
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
    unsafe {
        X_POS = X_POS_OFFSET + rect.left as u16;
        Y_POS = (rect.bottom as u16 - HEIGHT - Y_POS_OFFSET) as u16;
    }

    unsafe { update_screenshot(Some((X_POS, Y_POS, WIDTH, HEIGHT))) };

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
        Box::new(|_cc| Ok(Box::<MyApp>::default())),
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
                    if ui
                        .add(egui::Slider::new(&mut x_pos, 0.0..=3440.0))
                        .changed()
                    {
                        X_POS = x_pos as u16;
                    }

                    ui.label("Y Position");
                    if ui
                        .add(egui::Slider::new(&mut y_pos, 0.0..=1440.0))
                        .changed()
                    {
                        Y_POS = y_pos as u16;
                    }

                    ui.label("Width");
                    if ui.add(egui::Slider::new(&mut width, 0.0..=200.0)).changed() {
                        WIDTH = width as u16;
                    }

                    ui.label("Height");
                    if ui
                        .add(egui::Slider::new(&mut height, 0.0..=200.0))
                        .changed()
                    {
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

                // Add spacing between the image and the text
                ui.add_space(10.0);

                // Safely access and display the CURRENT_KEYBIND
                unsafe {
                    if let Some(ref current_keybind) = CURRENT_KEYBIND {
                        ui.label(format!("CURRENT_KEYBIND: {:?}", current_keybind));
                    } else {
                        ui.label("CURRENT_KEYBIND: None");
                    }
                }
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

fn closest_color(pixel: PixelColor) -> (&'static (PixelColor, PixelColors), f32) {
    let closest = COLORS
        .iter()
        .min_by(|a, b| {
            pixel
                .distance(&a.0)
                .partial_cmp(&pixel.distance(&b.0))
                .unwrap()
        })
        .unwrap();
    let min_distance = pixel.distance(&closest.0);
    (closest, min_distance)
}

use windows::Win32::Graphics::Gdi::GetDC;
use windows::Win32::Graphics::Gdi::GetPixel;

pub(crate) fn get_next_keybind_from_screen() -> Option<KeybindTypes> {
    let screenshot = unsafe { screenshot(X_POS, Y_POS, WIDTH, HEIGHT) };
    let width = screenshot.width();
    let height = screenshot.height();
    let screen_pixels: Vec<_> = screenshot.pixels().map(|p| p.2.to_rgba()).collect();
    let screen_idx =
        unsafe { screen_pixels.get_unchecked((width / 2) as usize + (height / 2) as usize) };
    let screen_pixel = *screen_idx;
    dbg!(screen_pixel);
    
    let screen_pixel_color = PixelColor::from(&screen_pixel);
    //warn!("Screen pixel color: {:?}", screen_pixel_color);

    let closest = closest_color(screen_pixel_color);
    //warn!(
    //    "Closest color: {:?} with distance: {:?}",
    //    closest.0, closest.1
    //);
    use KeybindTypes::*;

    let found_keybind = match closest.0 .1 {
        PixelColors::Black => NOKEY,
        PixelColors::DarkGray => Key1,
        PixelColors::Blue => Key2,
        PixelColors::Green => Key3,
        PixelColors::White => KeybindTypes::Key4,        
        PixelColors::Cyan => Key5,
        PixelColors::Yellow => Key6,
        PixelColors::Something => Key7,
        PixelColors::Gray => Key8,
        PixelColors::Pinkish => Key9,
        PixelColors::Mint => Key0,
        PixelColors::DarkRed => KeyDash,
        PixelColors::DarkGreen => KeyEquals,
        PixelColors::DarkBlue => KeyQ,
        PixelColors::Olive => KeyE,
        PixelColors::Purple => KeyR,
        PixelColors::Teal => KeyF,
        PixelColors::OrangeBrownish => KeyZ,
        PixelColors::DarkPurple => KeyX,
        PixelColors::LightGreen => KeyC,
        PixelColors::LightYellow => KeyV,
        PixelColors::BrightOrange => KeyS1,
        PixelColors::LightGreen2 => KeyS2,
        PixelColors::LightBlue => KeyS3,
        PixelColors::LightPurple => KeyS4,
        PixelColors::ReddishPurple => KeyS5,
        PixelColors::OliveDrab => KeyS6,
        PixelColors::BurntOrange => KeyS7,
        PixelColors::DarkBlueViolet => KeyS8,
        PixelColors::VeryDarkBlue => KeyS9,
        PixelColors::DarkMagenta => KeyS0,
        PixelColors::MustardYellow => KeySDash,
        PixelColors::SeaGreen => KeySEquals,
    };

    info!("Found keybind: {:?}", found_keybind);
    unsafe { CURRENT_KEYBIND = Some(found_keybind) };
    Some(found_keybind)
}

fn execute_search_process() {
    let region = unsafe { Some((X_POS, Y_POS, WIDTH, HEIGHT)) };
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
            KeybindTypes::NOKEY => {}
        }
    }
}

fn find_window_by_title(title: &str) -> anyhow::Result<HWND> {
    unsafe { FindWindowW(None, &HSTRING::from(title)) }.map_err(|e| anyhow::anyhow!(e.message()))
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
