# Readme

## Zekili Changes

### Notes About Changes

- Set a global for the upcoming next recommendation.  This lets my own addon display a pixel square with a specific color for each keybind

- Each b.Keybinding:SetText(keybind) call in UI.lua has a global set after it, similarly the SetText(nil) gets KeybindUpNext set to "" EXCEPT the ones in d:UpdateKeybindings()

### Changes Themselves

1 - Rename Hekili.lua and Hekili.toc to Zekili file names
2 - Search & replace HEKILI Hekili hekili with Z replacements across whole folder
3 - Make the additions below to UI.lua

```lua
  -- UI.lua
  
  if conf.keybindings.enabled and ( i == 1 or conf.keybindings.queued ) then
                                b.Keybinding:SetText(keybind)
                                if i == 1 then --- NOTE THIS CHECK IS NECESSARY
                                    Zekili.KeybindUpNext = b.Keybind
                                end
                            else
                                b.Keybinding:SetText(nil)
                                Zekili.KeybindUpNext = ""
                            end```


4 - Make changes to Core.lua
Find This:
```  if self:IsActionActive( packName, listName, actID ) then
                -- Check for commands before checking actual actions.
                local scriptID = packName .. ":" .. listName .. ":" .. actID
                local action = entry.action

                state.this_action = action
                state.delay = nil
                
                local ability = class.abilities[ action ]
                
                local playerIsMoving = GetUnitSpeed("player") > 1
               
                
                --print(packName, listName, actID, " --- ", ability.id)
                
                if not ability then
                    if not invalidActionWarnings[scriptID] then
                        Zekili:Error(
                        "Priority '%s' uses action '%s' ( %s - %d ) that is not found in the abilities table.", packName,
                            action or "unknown", listName, actID)
                        invalidActionWarnings[scriptID] = true
                    end```
                    
Add This:






## InputBot Changes
- Block numpad 0 key from propagating to Windows in src/windows/mod.rs
```     let vkcode = unsafe { (*(l_param.0 as *const KBDLLHOOKSTRUCT)).vkCode };
    //println!("vkcode: {vkcode:?}, w_param: {w_param:?}, l_param: {l_param:?}");
    if vkcode == 96 {
        static DO_NOT_PROPAGATE: isize = 1;
        return windows::Win32::Foundation::LRESULT(DO_NOT_PROPAGATE);
    }
    return CallNextHookEx(None, code, w_param, l_param);
``` at the bottom of the keybd_proc function

## WEAKAURAS CHANGES
- set new defaults for text so its faster to make hotkeys: in WeakAuras/SubRegionTypes/SubText.lua