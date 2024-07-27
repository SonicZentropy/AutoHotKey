#![allow(unused_imports)]
#![allow(non_snake_case)]

#[macro_use]
extern crate lazy_static;

mod image_processing;
mod utils;
use utils::*;

use image::DynamicImage;
use inputbot::{
    KeySequence,
    KeybdKey::{self, *},
    MouseButton::*,
};
use rayon::prelude::*;

use std::sync::{Arc, Mutex, MutexGuard};
use std::{thread::sleep, time::Duration};

use image_processing::*;

const X_POS: u16 = 800;
const Y_POS: u16 = 1300;

fn main() {
    Numpad0Key.bind(|| {        
        profile!("Full Search Process", execute_search_process());
    });

    inputbot::handle_input_events(false);
}

fn find_keybinds_parallel(
    images: Vec<(&Arc<DynamicImage>, KeybindTypes)>,
    region: Option<(u16, u16, u16, u16)>,
    min_confidence: Option<f32>,
    tolerance: Option<u8>,
) -> Option<KeybindTypes> {
    images
        .into_par_iter() // Convert to a parallel iterator
        .filter_map(|(img, keybind)| {
            match locate_image(&**img, region, min_confidence, tolerance) {
                Some((_x, _y, _img_width, _img_height, confidence)) => Some((keybind, confidence)),
                None => None,
            }
        })
        .max_by(|(_, confidence1), (_, confidence2)| confidence1.partial_cmp(confidence2).unwrap())
        .map(|(keybind, _)| keybind)
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

    let width = 150;
    let height = 140;
    let region = Some((X_POS, Y_POS, width, height));
    let min_confidence = Some(0.9999);
    let tolerance = Some(0);

    let found_keybind =
        find_keybinds_parallel(images_with_keybinds, region, min_confidence, tolerance);

    println!("Selected Key: {:?}", found_keybind);
    found_keybind
}

fn execute_search_process() {
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
