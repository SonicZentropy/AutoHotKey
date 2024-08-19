# Readme

## WoW Changes

- Install Prat addon for access to Bazooka font
- Use bazooka font in hekili @ 26 size, #EF00FF color, thick outline
- hekili style - Hekili:TR5x3jkoua8prTNqae4XQRDhpBhSBH9m7SpWSbjwZPiWgI268W(zFVjGOG0P2rBhDho90kjesU3BU)5hXgOf4h4fre0axmcBGSWwxI0r9qobEIvz0aVCXQy4JmYQ4usKC4FCrSGjV4(40hLFstiHX0OGWaVjPXPCwY9WKsNsGbw2fmmxTax0LoMWkT(cD5f6qtd5DHXopncwlYcr6eso0(FwqxumXZy3plg(ve0xoqwseBcrKYZ3wa6h49emLWmKmzgSOE3n6x)GF10a3EL82WZNXzZj8vFIfjMf4AcpY0ys(SD0M5HerLEvQeAsn4AlthdDKj2u3XXshzfm9ct9cvAJ(KVilJtZZLtryml5b5ftzprJ8yFLkBKNrH1cmdgWi4sfmroExneQCK930RC8YNZf2PKtFYI5JMKMKlxqpbHFpvOShkT0BAAIqTmUA4A2O1wN(J99h)XsB0oAO8V6Q)UwButyH7W4)W)MrUdl6lW7koJe)V)TlHZbxIInbH0hiMSsjrf(sF5lUx99VsKiLfBJY1(66rJxUGninnok9XeLrBTc7p(2BgET)oMMNe0KOchRTmtFnnDoiyWm(aLMDfStnrChrWsL3CglIoEEcBWaL7bjd6pjVH)t9LHa(VjbEdg66p8U21XcDRUpCXU0Ez22eU0M5rQDZZsFKYNtH7wpUrfl3)BjK(Fy0GFBBjvBTKURKHU0wZPhYYPzartLAlluVTJtFg5FkNmN6j4ebjW7MXFQ8rujXyCy)b2eQI6FCtWDzsSYBuZbr5FivALrPsXZZitK5XCn3jBs60P5uXNvQ(mQkNKArk6)pLpIq6ZSkuMLk5ELxrDxH9yVSn3JT8JlLLCAgbSg0FxAgkgoOpXYnzidQQrHr9MD7AWlleWU8fARh)1TfYn52uUy8skNdbeLjG1k7(VubqOl7T9m0AgPTUDdv(fDj2zZKtsUN2W7Ui9djKfZeR2k))h2A7BAk4abvDULYzPqkznZs)TBOlPXqBymlz5SYjbwGSLzb(vvjKQTmRWhtxKikIcjXpkZ)PmiQb5RYrR6GeNnJOUsu156kGYnwWXjwzqJwqILFYPeW)EPQpsAXhqHY5qgPjf5UYwsp6YdjAj41PECOvykpIYByCNYe1l9pzroixnQ8xKxOz(aXm2KhkR4bTHEgbclNViROswteJ(VFig1ZWhUGflgLifGcBGmXWBT541cLSBa8BmachcmQszUlt1zy9)tqkQdL1DdLOMChngIVKtAvywRz(ALdQz6WNcU(clldKzpSUtpdnDhabE6fgwNperRKQGJwpdBdSzpBtBnnLky2bB0bB8YWgjGlsTAwTrw0YRpCUdI)Zoi0(azkdWRQcDAZYOFcYYaUU435ZtPdN5CfNzsL95aPzm1XMoAgoieYcPBlrb6DMrZOBJDSmX6itKdY0Suf6Oz6Oz2pAMn5A6GzuYZHdp8)cyMBlCgkQLC9fMylKMoYWr3Yud70tMNr)h1xku4ZxzjCVRSSlxKwlbj7J161d700LUjQs)wbE6)8apO60sfCoOnrl3MYKbdRdzo(Sn9FdzBuB31b0W2N)jIa(tImzGFAGN3G7go0TbUJerbWtKL3TTTWitBBfIIr75L3hQND5(vEyhpU)Zf2PiwEgedugxa(FnyM8hp(g)r3UpCtyZAinVAQP1OrBMNp3wgSAOzIVb3eUxnt012ggyKbgJnbmxdd7YV76QDZ2dVRhHSwwQK)toCQI95(eW3)bYXNRkSeyt0(RCuWsTUMztskz2Q98DZcFhF3SAVaCDSOkKH(VnijhgI0rhzt04qtG2)cDknjheKt9tZX4K60CqxAIXL6Toc39nu99J98t1r6eTjC7GothBSMTo2W2XWYWW06S8iDWwoqHASf2gJWy9UJ0P7iDA3B5zosNTkD1DMok55GbeoqGLJpa131z6C14HQbDMVB)ser4tlIOTsV8(CKp1OGo(mp9FdzEcFfmpVNVQ0USKBOy0p8ZICVjEAj3TQoLf68HXPyM7Wz6Wz2pCgzvR24y(b(o5F7)tH)57Wt2p(d5pb)3p

## Hekili Changes

- Set a global for the upcoming next recommendation.  This lets my own addon display a pixel square with a specific color for each keybind

- Each b.Keybinding:SetText(keybind) call in UI.lua has a global set after it, similarly the SetText(nil) gets KeybindUpNext set to "" EXCEPT the ones in d:UpdateKeybindings()

```lua
  local ZenBridge = _G["ZenBridge"]
  
  
  if conf.keybindings.enabled and ( i == 1 or conf.keybindings.queued ) then
                                b.Keybinding:SetText(keybind)
                                if i == 1 then --- NOTE THIS CHECK IS NECESSARY
                                    Zekili.KeybindUpNext = b.Keybind
                                end
                            else
                                b.Keybinding:SetText(nil)
                                Zekili.KeybindUpNext = ""
                            end```


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