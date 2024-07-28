#![allow(unused_imports)]
#![allow(non_snake_case)]

#[macro_use]
extern crate lazy_static;

mod image_processing;
mod utils;
use tracing::warn;
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
use std::sync::{Arc, Mutex, MutexGuard, Once};
use std::{fs::File, io::BufWriter};
use std::{thread::sleep, time::Duration};
use tap::prelude::*;
use tracing_subscriber::{fmt, prelude::*, registry::Registry};
use winit::platform::windows::EventLoopBuilderExtWindows;

use crate::image_processing::*;

const X_POS: u16 = 25;
const Y_POS: u16 = 1390;
const WIDTH: u16 = 91;
const HEIGHT: u16 = 50;

fn main() -> eframe::Result {
   
    tracing_subscriber::fmt()
        // enable everything
        .with_max_level(tracing::Level::WARN)
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
    
    update_screenshot(Some((X_POS, Y_POS, WIDTH, HEIGHT)));

    Numpad0Key.bind(|| {
        profile!("Full Search Process", execute_search_process());
        //fastrace::flush();
    });

    // Exit program
    Numpad1Key.bind(|| {
        //Numpad0Key.unbind();
        //Numpad1Key.unbind();
        inputbot::stop_handling_input_events();
        //optick::stop_capture("zen_base_capture");
        //fastrace::flush();
    });

    //std::thread::spawn(move || {
    //    let options = eframe::NativeOptions {
    //        viewport: egui::ViewportBuilder::default().with_inner_size([400.0, 800.0]),
    //        ..Default::default()
    //    };
    //     use winit::platform::windows::EventLoopBuilderExtWindows;
    //    EventLoopBuilder::new().with_any_thread(true).build();

    //    let _ = eframe::run_native(
    //        "Image Viewer",
    //        options,
    //        Box::new(|cc| {
    //            // This gives us image support:
    //            egui_extras::install_image_loaders(&cc.egui_ctx);
    //            Ok(Box::<MyApp>::default())
    //        }),
    //    ) ;

    //});

    let _handle = std::thread::spawn(|| {
        inputbot::handle_input_events(false);
    });

    let options = eframe::NativeOptions {
        viewport: egui::ViewportBuilder::default()
            .with_inner_size([400.0, 800.0])
            //.with_mouse_passthrough(true)
            .with_transparent(true)
            .with_decorations(true),
        ..Default::default()
    };
    eframe::run_native(
        "Image Viewer",
        options,
        Box::new(|_cc| {
            // This gives us image support:
            //egui_extras::install_image_loaders(&cc.egui_ctx);
            Ok(Box::<MyApp>::default())
        }),
    )
    .unwrap();
    //fastrace::flush();
    //optick::stop_capture("zen_base_capture.opt");
    println!("Exiting safely!");
    Ok(())
}


#[derive(Default)]
struct MyApp {}

impl eframe::App for MyApp {
    fn update(&mut self, ctx: &egui::Context, _frame: &mut eframe::Frame) {
        ctx.set_visuals(egui::Visuals {
            //window_fill: egui::Color32::TRANSPARENT,
            panel_fill: egui::Color32::TRANSPARENT,
            ..Default::default()
        });

        egui::CentralPanel::default().show(ctx, |ui| {
            egui::ScrollArea::both().show(ui, |ui| {
                //unsafe {
                //    let mut x_pos = X_POS as f64;
                //    let mut y_pos = Y_POS as f64;
                //    let mut width = WIDTH as f64;
                //    let mut height = HEIGHT as f64;

                //    ui.label("X Position");
                //    if ui.add(egui::Slider::new(&mut x_pos, 0.0..=3440.0)).changed() {
                //        X_POS = x_pos as u16;
                //    }

                //    ui.label("Y Position");
                //    if ui.add(egui::Slider::new(&mut y_pos, 0.0..=1440.0)).changed() {
                //        Y_POS = y_pos as u16;
                //    }

                //    ui.label("Width");
                //    if ui.add(egui::Slider::new(&mut width, 0.0..=200.0)).changed() {
                //        WIDTH = width as u16;
                //    }
                    
                //    ui.label("Height");
                //    if ui.add(egui::Slider::new(&mut height, 0.0..=200.0)).changed() {
                //        HEIGHT = height as u16;
                //    }
                //}
                               
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
                
                
                //let screen_pixels: Vec<_> = screenshot.pixels().map(|p| p.2.to_rgba()).collect();
                //let screen_width = screenshot.width();
                //let screen_height = screenshot.height();
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
            warn!("Testing keybind: {:?}", keybind);
            match locate_image(&**img, region, min_confidence, tolerance) {
                Some((_x, _y, _img_width, _img_height, confidence)) => {
                    warn!("Found match for keybind: {:?} with confidence: {:?}", keybind, confidence);
                    Some((keybind, confidence))},
                None => {
                    warn!("No match found for keybind: {:?}", keybind);
                    None},
            }
        })
        .max_by(|(_, confidence1), (_, confidence2)| confidence1.partial_cmp(confidence2).unwrap())
        .tap(|conf| tracing::warn!("Max found confidence: {:?}", conf))
        .map(|(keybind, _)| keybind)

    //if let Some((keybind, confidence)) = &maybe_max {
    //    println!(
    //        "Max confidence found: {}, for keybind: {:?}",
    //        confidence, keybind
    //    );
    //} else {
    //    println!("No valid keybinding found.")
    //}

    //maybe_max.map(|(keybind, _)| keybind)
}

pub(crate) fn get_next_keybind_from_screen() -> Option<KeybindTypes> {
    let images_with_keybinds: Vec<(&Arc<DynamicImage>, KeybindTypes)> = vec![
        (&IMG_Q, KeybindTypes::KeyQ),
        (&IMG_E, KeybindTypes::KeyE),
        (&IMG_R, KeybindTypes::KeyR),
        (&IMG_F, KeybindTypes::KeyF),
        (&IMG_Z, KeybindTypes::KeyZ),
        (&IMG_X, KeybindTypes::KeyX),
        (&IMG_C, KeybindTypes::KeyC),
        (&IMG_V, KeybindTypes::KeyV),
        (&IMG_1, KeybindTypes::Key1),
        (&IMG_2, KeybindTypes::Key2),
        (&IMG_3, KeybindTypes::Key3),
        (&IMG_4, KeybindTypes::Key4),
        (&IMG_5, KeybindTypes::Key5),
        (&IMG_6, KeybindTypes::Key6),
        (&IMG_7, KeybindTypes::Key7),
        (&IMG_8, KeybindTypes::Key8),
        (&IMG_9, KeybindTypes::Key9),
        (&IMG_0, KeybindTypes::Key0),
        (&IMG_DASH, KeybindTypes::KeyDash),
        (&IMG_EQUALS, KeybindTypes::KeyEquals),
        (&IMG_S1, KeybindTypes::KeyS1),
        (&IMG_S2, KeybindTypes::KeyS2),
        (&IMG_S3, KeybindTypes::KeyS3),
        (&IMG_S4, KeybindTypes::KeyS4),
        (&IMG_S5, KeybindTypes::KeyS5),
        (&IMG_S6, KeybindTypes::KeyS6),
        (&IMG_S7, KeybindTypes::KeyS7),
        (&IMG_S8, KeybindTypes::KeyS8),
        (&IMG_S9, KeybindTypes::KeyS9),
        (&IMG_S0, KeybindTypes::KeyS0),
        (&IMG_SDASH, KeybindTypes::KeySDash),
        (&IMG_SEQUALS, KeybindTypes::KeySEquals),
    ];

    let region = Some((X_POS, Y_POS, WIDTH, HEIGHT));
    let min_confidence = Some(0.95);
    let tolerance = Some(0);

    let found_keybind =
        find_keybinds_parallel(images_with_keybinds, region, min_confidence, tolerance);

    //tracing::info!("Selected Key: {:?}", found_keybind);
    found_keybind
}

fn execute_search_process() {

    let region = Some((X_POS, Y_POS, WIDTH, HEIGHT)) ;
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
