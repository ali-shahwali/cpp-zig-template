const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "cpp-zig-template",
        .target = target,
        .optimize = optimize,
    });

    const libs = [_][]const u8{ "glad", "glfw", "assimp", "imgui" };

    inline for (libs) |lib| {
        const dep = b.dependency(lib, .{
            .target = target,
            .optimize = optimize,
        });

        exe.linkLibrary(dep.artifact(lib));
    }

    const dep = b.dependency("cglm", .{
        .target = target,
        .optimize = optimize,
        .cglm_static = true,
    });
    exe.linkLibrary(dep.artifact("cglm"));

    exe.addCSourceFiles(.{
        .files = &.{"src/main.cc"},
        .flags = &.{"-std=c++23"},
    });
    exe.linkLibCpp();

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
