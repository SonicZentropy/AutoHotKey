#![allow(unused_imports)]
#![allow(non_snake_case)]

#[macro_use]
extern crate lazy_static;

use image::DynamicImage;
use inputbot::{
    KeySequence,
    KeybdKey::{self, *},
    MouseButton::*,
};
use rayon::prelude::*;
use spectrust::*;
use std::sync::{Mutex, MutexGuard, Arc};
use std::{thread::sleep, time::Duration};

#[derive(Debug, Copy, Clone)]
pub enum KeybindTypes {
    KeyQ,
    KeyE,
    KeyR,
    KeyF,
    KeyZ,
    KeyX,
    KeyC,
    KeyV,
    Key1,
    Key2,
    Key3,
    Key4,
    Key5,
    Key6,
    Key7,
    Key8,
    Key9,
    Key0,
    KeyDash,
    KeyEquals,
    KeyS1,
    KeyS2,
    KeyS3,
    KeyS4,
    KeyS5,
    KeyS6,
    KeyS7,
    KeyS8,
    KeyS9,
    KeyS0,
    KeySDash,
    KeySEquals,
}

//lazy_static! {
//    static ref IMG_Q: Mutex<DynamicImage> = Mutex::new(image::open("images/Q.png").expect("Unable to locate file."));
//    static ref IMG_E: Mutex<DynamicImage> = Mutex::new(image::open("images/E.png").expect("Unable to locate file."));

//    static ref IMG_1: Mutex<DynamicImage> = Mutex::new(image::open("images/1.png").expect("Unable to locate file."));
//    static ref IMG_2: Mutex<DynamicImage> = Mutex::new(image::open("images/2.png").expect("Unable to locate file."));
//    static ref IMG_3: Mutex<DynamicImage> = Mutex::new(image::open("images/3.png").expect("Unable to locate file."));
//    static ref IMG_4: Mutex<DynamicImage> = Mutex::new(image::open("images/4.png").expect("Unable to locate file."));
//    static ref IMG_5: Mutex<DynamicImage> = Mutex::new(image::open("images/5.png").expect("Unable to locate file."));
//    static ref IMG_6: Mutex<DynamicImage> = Mutex::new(image::open("images/6.png").expect("Unable to locate file."));
//    static ref IMG_7: Mutex<DynamicImage> = Mutex::new(image::open("images/7.png").expect("Unable to locate file."));
//    static ref IMG_8: Mutex<DynamicImage> = Mutex::new(image::open("images/8.png").expect("Unable to locate file."));
//    static ref IMG_9: Mutex<DynamicImage> = Mutex::new(image::open("images/9.png").expect("Unable to locate file."));
//    static ref IMG_0: Mutex<DynamicImage> = Mutex::new(image::open("images/0.png").expect("Unable to locate file."));
//    static ref IMG_DASH: Mutex<DynamicImage> = Mutex::new(image::open("images/dash.png").expect("Unable to locate file."));
//    static ref IMG_EQUALS: Mutex<DynamicImage> = Mutex::new(image::open("images/equals.png").expect("Unable to locate file."));
//}

macro_rules! create_image_refs {
    ( $( $name:ident => $file_stem:expr ),+ ) => {
        lazy_static! {
            $(
                static ref $name: Arc<DynamicImage> = Arc::new(
                    image::open(format!("images/{}.png", $file_stem))
                        .expect("Unable to locate file.")
                );
            )+
        }
    };
}

create_image_refs! {
    IMG_Q => "Q",
    IMG_E => "E",
    IMG_R => "R",
    IMG_F => "F",
    IMG_Z => "Z",
    IMG_X => "X",
    IMG_C => "C",
    IMG_V => "V",

    IMG_1 => "1",
    IMG_2 => "2",
    IMG_3 => "3",
    IMG_4 => "4",
    IMG_5 => "5",
    IMG_6 => "6",
    IMG_7 => "7",
    IMG_8 => "8",
    IMG_9 => "9",
    IMG_0 => "0",
    IMG_DASH => "dash",
    IMG_EQUALS => "equals",

    IMG_S1 => "S1",
    IMG_S2 => "S2",
    IMG_S3 => "S3",
    IMG_S4 => "S4",
    IMG_S5 => "S5",
    IMG_S6 => "S6",
    IMG_S7 => "S7",
    IMG_S8 => "S8",
    IMG_S9 => "S9",
    IMG_S0 => "S0",
    IMG_SDASH => "SDASH",
    IMG_SEQUALS => "SEQUALS"
}

pub(crate) fn press_key(key: KeybdKey) {
    key.press();
    sleep(Duration::from_millis(20));
    key.release();
}

pub(crate) fn press_shift_key_sequence(key: KeybdKey) {
    LShiftKey.press();
    sleep(Duration::from_millis(20));
    key.press();
    sleep(Duration::from_millis(20));
    LShiftKey.release();
    sleep(Duration::from_millis(20));
    key.release();
}

fn main() {
    //let img_Q = image::open("images/Q.png").expect("Unable to locate file.");
    //let img_1 = image::open("images/1.png").expect("Unable to locate file.");
    // Bind the number 1 key your keyboard to a function that types
    // "Hello, world!" when pressed.
    Numpad0Key.bind(|| {
        println!("In bind");
        let pre = std::time::Instant::now();

        let thingmod = 5.0;
        let thing = if thingmod % 2.0 > 0.5 { QKey } else { RKey };
        thing.press();

        match get_next_keybind_from_screen() {
            Some(KeybindTypes::KeyQ) => {
                press_key(QKey);
            }
            Some(KeybindTypes::KeyE) => {
                press_key(EKey);
            }
            Some(KeybindTypes::KeyR) => {
                press_key(QKey);
            }
            Some(KeybindTypes::KeyF) => {
                press_key(EKey);
            }
            Some(KeybindTypes::KeyZ) => {
                press_key(QKey);
            }
            Some(KeybindTypes::KeyX) => {
                press_key(EKey);
            }
            Some(KeybindTypes::KeyC) => {
                press_key(QKey);
            }
            Some(KeybindTypes::KeyV) => {
                press_key(EKey);
            }
            Some(KeybindTypes::Key1) => {
                press_key(Numrow1Key);
            }
            Some(KeybindTypes::Key2) => {
                press_key(Numrow2Key);
            }
            Some(KeybindTypes::Key3) => {
                press_key(Numrow3Key);
            }
            Some(KeybindTypes::Key4) => {
                press_key(Numrow4Key);
            }
            Some(KeybindTypes::Key5) => {
                press_key(Numrow5Key);
            }
            Some(KeybindTypes::Key6) => {
                press_key(Numrow6Key);
            }
            Some(KeybindTypes::Key7) => {
                press_key(Numrow7Key);
            }
            Some(KeybindTypes::Key8) => {
                press_key(Numrow8Key);
            }
            Some(KeybindTypes::Key9) => {
                press_key(Numrow9Key);
            }
            Some(KeybindTypes::Key0) => {
                press_key(Numrow0Key);
            }
            Some(KeybindTypes::KeyDash) => {
                press_key(MinusKey);
            }
            Some(KeybindTypes::KeyEquals) => {
                press_key(EqualKey);
            }

            Some(KeybindTypes::KeyS1) => {
                press_shift_key_sequence(Numrow1Key);
            }
            Some(KeybindTypes::KeyS2) => {
                press_shift_key_sequence(Numrow2Key);
            }
            Some(KeybindTypes::KeyS3) => {
                press_shift_key_sequence(Numrow3Key);
            }
            Some(KeybindTypes::KeyS4) => {
                press_shift_key_sequence(Numrow4Key);
            }
            Some(KeybindTypes::KeyS5) => {
                press_shift_key_sequence(Numrow5Key);
            }
            Some(KeybindTypes::KeyS6) => {
                press_shift_key_sequence(Numrow6Key);
            }
            Some(KeybindTypes::KeyS7) => {
                press_shift_key_sequence(Numrow7Key);
            }
            Some(KeybindTypes::KeyS8) => {
                press_shift_key_sequence(Numrow8Key);
            }
            Some(KeybindTypes::KeyS9) => {
                press_shift_key_sequence(Numrow9Key);
            }
            Some(KeybindTypes::KeyS0) => {
                press_shift_key_sequence(Numrow0Key);
            }
            Some(KeybindTypes::KeySDash) => {
                press_shift_key_sequence(MinusKey);
            }
            Some(KeybindTypes::KeySEquals) => {
                press_shift_key_sequence(EqualKey);
            }

            None => {}
        }

        let post = std::time::Instant::now();
        let dur = post - pre;
        println!("Time taken: {:?}ms", dur.as_millis());
    });

    // Call this to start listening for bound inputs.
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

    let x_pos = 800;
    let y_pos = 1300;
    let width = 150;
    let height = 140;
    let region = Some((x_pos, y_pos, width, height));
    let min_confidence = Some(0.9999);
    let tolerance = Some(0);

    let found_keybind =
        find_keybinds_parallel(images_with_keybinds, region, min_confidence, tolerance);

    println!("Selected Key: {:?}", found_keybind);
    found_keybind
}
