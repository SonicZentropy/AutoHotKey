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
use spectrust::*;
use std::sync::Mutex;
use std::{thread::sleep, time::Duration};

#[derive(Debug)]
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
                static ref $name: Mutex<DynamicImage> = Mutex::new(
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

pub(crate) fn get_next_keybind_from_screen() -> Option<KeybindTypes> {
    let img_Q = IMG_Q.lock().unwrap();
    let img_E = IMG_E.lock().unwrap();
    let img_R = IMG_R.lock().unwrap();
    let img_F = IMG_F.lock().unwrap();
    let img_Z = IMG_Z.lock().unwrap();
    let img_X = IMG_X.lock().unwrap();
    let img_C = IMG_C.lock().unwrap();
    let img_V = IMG_V.lock().unwrap();
    
    let img_1 = IMG_1.lock().unwrap();
    let img_2 = IMG_2.lock().unwrap();
    let img_3 = IMG_3.lock().unwrap();
    let img_4 = IMG_4.lock().unwrap();
    let img_5 = IMG_5.lock().unwrap();
    let img_6 = IMG_6.lock().unwrap();
    let img_7 = IMG_7.lock().unwrap();
    let img_8 = IMG_8.lock().unwrap();
    let img_9 = IMG_9.lock().unwrap();
    let img_0 = IMG_0.lock().unwrap();
    let img_dash = IMG_DASH.lock().unwrap();
    let img_equals = IMG_EQUALS.lock().unwrap();

    let img_S1 = IMG_S1.lock().unwrap();
    let img_S2 = IMG_S2.lock().unwrap();
    let img_S3 = IMG_S3.lock().unwrap();
    let img_S4 = IMG_S4.lock().unwrap();
    let img_S5 = IMG_S5.lock().unwrap();
    let img_S6 = IMG_S6.lock().unwrap();
    let img_S7 = IMG_S7.lock().unwrap();
    let img_S8 = IMG_S8.lock().unwrap();
    let img_S9 = IMG_S9.lock().unwrap();
    let img_S0 = IMG_S0.lock().unwrap();
    let img_Sdash = IMG_SDASH.lock().unwrap();
    let img_Sequals = IMG_SEQUALS.lock().unwrap();

    let x_pos = 800;
    let y_pos = 1300;
    let width = 150;
    let height = 140;
    let region = Some((x_pos, y_pos, width, height));
    //let region = None;
    let min_confidence = Some(0.9999);
    let tolerance = Some(0);

    let mut found_keybind = None;
    let mut highest_confidence = 0.0;
    let find_image = |img: &DynamicImage, _keyname: &str| match locate_image(
        img,
        region,
        min_confidence,
        tolerance,
    ) {
        Some((_x, _y, _img_width, _img_height, confidence)) => {
            //println!(
            //    "{}: x: {}, y: {}, width: {}, height: {}, confidence: {}",
            //    keyname, x, y, img_width, img_height, confidence
            //);
            return Some(confidence);
        }
        None => None,
    };

    if let Some(confidence) = find_image(&img_Q, "Q") {
        if confidence > highest_confidence {
            highest_confidence = confidence;
            found_keybind = Some(KeybindTypes::KeyQ);
        }
    }

    if let Some(confidence) = find_image(&img_E, "E") {
        if confidence > highest_confidence {
            highest_confidence = confidence;
            found_keybind = Some(KeybindTypes::KeyE);
        }
    }

    if let Some(confidence) = find_image(&img_R, "R") {
        if confidence > highest_confidence {
            highest_confidence = confidence;
            found_keybind = Some(KeybindTypes::KeyR);
        }
    }

    if let Some(confidence) = find_image(&img_F, "F") {
        if confidence > highest_confidence {
            highest_confidence = confidence;
            found_keybind = Some(KeybindTypes::KeyF);
        }
    }

    if let Some(confidence) = find_image(&img_Z, "Z") {
        if confidence > highest_confidence {
            highest_confidence = confidence;
            found_keybind = Some(KeybindTypes::KeyZ);
        }
    }

    if let Some(confidence) = find_image(&img_X, "X") {
        if confidence > highest_confidence {
            highest_confidence = confidence;
            found_keybind = Some(KeybindTypes::KeyX);
        }
    }

    if let Some(confidence) = find_image(&img_C, "C") {
        if confidence > highest_confidence {
            highest_confidence = confidence;
            found_keybind = Some(KeybindTypes::KeyC);
        }
    }

    if let Some(confidence) = find_image(&img_V, "V") {
        if confidence > highest_confidence {
            highest_confidence = confidence;
            found_keybind = Some(KeybindTypes::KeyV);
        }
    }

    if let Some(confidence) = find_image(&img_1, "1") {
        if confidence > highest_confidence {
            highest_confidence = confidence;
            found_keybind = Some(KeybindTypes::Key1);
        }
    }

    if let Some(confidence) = find_image(&img_2, "2") {
        if confidence > highest_confidence {
            highest_confidence = confidence;
            found_keybind = Some(KeybindTypes::Key2);
        }
    }

    if let Some(confidence) = find_image(&img_3, "3") {
        if confidence > highest_confidence {
            highest_confidence = confidence;
            found_keybind = Some(KeybindTypes::Key3);
        }
    }

    if let Some(confidence) = find_image(&img_4, "4") {
        if confidence > highest_confidence {
            highest_confidence = confidence;
            found_keybind = Some(KeybindTypes::Key4);
        }
    }

    if let Some(confidence) = find_image(&img_5, "5") {
        if confidence > highest_confidence {
            highest_confidence = confidence;
            found_keybind = Some(KeybindTypes::Key5);
        }
    }

    if let Some(confidence) = find_image(&img_6, "6") {
        if confidence > highest_confidence {
            highest_confidence = confidence;
            found_keybind = Some(KeybindTypes::Key6);
        }
    }

    if let Some(confidence) = find_image(&img_7, "7") {
        if confidence > highest_confidence {
            highest_confidence = confidence;
            found_keybind = Some(KeybindTypes::Key7);
        }
    }

    if let Some(confidence) = find_image(&img_8, "8") {
        if confidence > highest_confidence {
            highest_confidence = confidence;
            found_keybind = Some(KeybindTypes::Key8);
        }
    }

    if let Some(confidence) = find_image(&img_9, "9") {
        if confidence > highest_confidence {
            highest_confidence = confidence;
            found_keybind = Some(KeybindTypes::Key9);
        }
    }

    if let Some(confidence) = find_image(&img_0, "0") {
        if confidence > highest_confidence {
            highest_confidence = confidence;
            found_keybind = Some(KeybindTypes::Key0);
        }
    }

    if let Some(confidence) = find_image(&img_dash, "-") {
        if confidence > highest_confidence {
            highest_confidence = confidence;
            found_keybind = Some(KeybindTypes::KeyDash);
        }
    }

    if let Some(confidence) = find_image(&img_equals, "=") {
        if confidence > highest_confidence {
            //highest_confidence = confidence;
            found_keybind = Some(KeybindTypes::KeyEquals);
        }
    }
    
    // Shift Keybinds
    if let Some(confidence) = find_image(&img_S1, "S1") {
        if confidence > highest_confidence {
            highest_confidence = confidence;
            found_keybind = Some(KeybindTypes::KeyS1);
        }
    }

    if let Some(confidence) = find_image(&img_S2, "S2") {
        if confidence > highest_confidence {
            highest_confidence = confidence;
            found_keybind = Some(KeybindTypes::KeyS2);
        }
    }

    if let Some(confidence) = find_image(&img_S3, "S3") {
        if confidence > highest_confidence {
            highest_confidence = confidence;
            found_keybind = Some(KeybindTypes::KeyS3);
        }
    }

    if let Some(confidence) = find_image(&img_S4, "S4") {
        if confidence > highest_confidence {
            highest_confidence = confidence;
            found_keybind = Some(KeybindTypes::KeyS4);
        }
    }

    if let Some(confidence) = find_image(&img_S5, "S5") {
        if confidence > highest_confidence {
            highest_confidence = confidence;
            found_keybind = Some(KeybindTypes::KeyS5);
        }
    }

    if let Some(confidence) = find_image(&img_S6, "S6") {
        if confidence > highest_confidence {
            highest_confidence = confidence;
            found_keybind = Some(KeybindTypes::KeyS6);
        }
    }

    if let Some(confidence) = find_image(&img_S7, "S7") {
        if confidence > highest_confidence {
            highest_confidence = confidence;
            found_keybind = Some(KeybindTypes::KeyS7);
        }
    }

    if let Some(confidence) = find_image(&img_S8, "S8") {
        if confidence > highest_confidence {
            highest_confidence = confidence;
            found_keybind = Some(KeybindTypes::KeyS8);
        }
    }

    if let Some(confidence) = find_image(&img_S9, "S9") {
        if confidence > highest_confidence {
            highest_confidence = confidence;
            found_keybind = Some(KeybindTypes::KeyS9);
        }
    }

    if let Some(confidence) = find_image(&img_S0, "S0") {
        if confidence > highest_confidence {
            highest_confidence = confidence;
            found_keybind = Some(KeybindTypes::KeyS0);
        }
    }

    if let Some(confidence) = find_image(&img_Sdash, "S-") {
        if confidence > highest_confidence {
            highest_confidence = confidence;
            found_keybind = Some(KeybindTypes::KeySDash);
        }
    }

    if let Some(confidence) = find_image(&img_Sequals, "S=") {
        if confidence > highest_confidence {
            //highest_confidence = confidence;
            found_keybind = Some(KeybindTypes::KeySEquals);
        }
    }
    
    
    println!("Selected Key: {:?}", found_keybind);
    return found_keybind;
}
