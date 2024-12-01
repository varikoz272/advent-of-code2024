const std = @import("std");

pub fn main() void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    var file = std.fs.cwd().openFile("input.txt", .{}) catch unreachable;

    var buffer: [1024]u8 = undefined;
    const size = file.readAll(&buffer) catch unreachable;
    const input = buffer[0..size];

    std.debug.print("{s}", .{input});
}
