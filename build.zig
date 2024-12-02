const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    buildAll(b, target, optimize);
}

pub fn buildAll(b: *std.Build, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) void {
    const dir = std.fs.cwd().openDir("src", .{ .iterate = true }) catch unreachable;

    var buffer: [32]u8 = undefined;

    var iter = dir.iterate();
    while (iter.next() catch unreachable) |task_source| {
        const exe = b.addExecutable(.{
            .name = task_source.name[0 .. task_source.name.len - 4],
            .root_source_file = b.path(std.fmt.bufPrint(&buffer, "src/{s}", .{task_source.name}) catch unreachable),
            .target = target,
            .optimize = optimize,
        });

        b.installArtifact(exe);

        const run_cmd = b.addRunArtifact(exe);

        run_cmd.step.dependOn(b.getInstallStep());

        // if (b.args) |args| {
        //     run_cmd.addArgs(args);
        // }

        const run_step = b.step(task_source.name[0 .. task_source.name.len - 4], "run the task");
        run_step.dependOn(&run_cmd.step);
    }
}
