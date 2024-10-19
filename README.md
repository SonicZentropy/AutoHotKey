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



## WORKING ICONS FOR PLATER SCRIPT
 1AvBpTnsq4)l8jJuBQxV76xq6(ahqB5knGQJ6DNAQXl2BsSQJ3O1Bkq)G)TFZS2Hy4IPePwfbEYSZm7ZZ8wCcjzssSALPqvvdIJTFFY9RKjJ9sI)O4o4PBs8PY6SK4XszEtQOj9nAzPsKdguuH(e)b59jX1Y5lLvM6JxQwxzsI)SOCTS1)XILYK42dAsvZAsJ7moj(8mvf8)kJuptKjNECE(Lv1tVQuaAMwSumxwpTfIxxTE5nsDs8B1ImurYnjgePpaAYM7kELq)TM0tuLk9gOy53y3rrC)qFVag3nk0LH(J6P2Jcd9OCVigHe4ZtgZWJmBiigZUiUpOoR1L2Kicy6oa87kv3oaEd59rLfVUJyucnWJZICjr(TWN8e8ohc5Va4cHZOY(UuxJz8XeIRRl0CiYZXy2gIKyITJXGKkUotxScCJ2rHa)aI98XmojmOfTEa6dAHmJZym3KXCulp0d4istUFepa8gmNgs5GpHGOxaHc2gHImViK3UOfSawiIoqM5cbeK9qB8DzqWiuR9by(JWSYr4tchLHWG(cNbrK4cXMa3kJX9CHNKqREodSLeH6JyCUTZg077fISbzcusOOClrDJaF9OOSBahjeR1gm(EyZfdkROmEVuwiKvb(BLdqE5H0fYsi28q(cqaphPpnK5J6PeRn28lf5RFa3f5k(xyyOp(e5BafChEI3l1pKH2J3l3NJyGA5BqKVp6Nf)EiEXZG0aej4PRvpnaLjTYWqcuOHk)5lxP0gboF)HISVv)gBZME9kCgN)KEp12EVpkZletZ0QBRU2NLeZGEgiIbWaIuNvOUjj2VZBmyqJgy0S1v25)MuNAz5Sx1KUUQWCEENaSEyPeKLvFFI4MsuSTL0(TdB(RM02pV(1LQmrztAMO28NcDt6F0lcJ2OTN9Bc5MZ(7ICZcRBDko6DsJvPZJUNUthz3lDuS08zP2iVZoE6CQ0ikkRTx6Tk48Re6AP9SANEiFemfpRy(OTlIoS3LS)sBzATrT6eaIfvZ)NJIxOUTp6hYmP54YvleoKDcIE5QtwR1WY(jY7mR1sB2I88idRQJq7XB5uT42le3l1ohi0gmbDaurdEu(16Wdj390J3xKlrclRYbl(FFGEo(J75gOzQOQgQQqRGkhy5cjW1EC7HONeddvW8ysmU0jaw(q58i4xcGLu)YAT3LuXSHkMnPMfYQbl1DjO0wk8IRwk4hnkf3J5E3xw1QNh0b94jTN7OUbPsVFhPY9BBXJT(9YI5lmpDvrRwNxqHZPszgQaDyx9BRRp7OBFqmYE8LT59JorlHTYDdQovfLqsPFrPvt)bPTLOHxtCLQOY4CqMe3IFWR2rsRT0Ix2wJCFsBZpFDu39CYzJNC2NWq0fDmUxC2BNGQi(de2NJaBsiF5ld9kulT)mwTrOVE26Ys4NY(6x3lSVRRaFRT6PhFtrzH5(RZvllQe2xrtVUss82ZBiU4hshQhoA5TxoUJT8)uF6ntF5Np7txC8)EWanop)kNhmFGvp7wcmgwbq(9Un9r7DGRZT9DVt(V