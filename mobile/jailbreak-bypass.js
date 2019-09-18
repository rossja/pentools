if (ObjC.available) {
    var checkerfunc = ObjC.classes.SFJailBreakPolicy["- checker"];
checkerfunc.implementation = ObjC.implement(checkerfunc, function (handle, s elector) {
        console.log("Skipping SFJailBreakPolicy checker");
return; });
}
