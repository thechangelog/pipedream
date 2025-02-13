// A generated module for Pipely functions
//
// This module has been generated via dagger init and serves as a reference to
// basic module structure as you get started with Dagger.
//
// Two functions have been pre-created. You can modify, delete, or add to them,
// as needed. They demonstrate usage of arguments and return types using simple
// echo and grep commands. The functions can be called from the dagger CLI or
// from one of the SDKs.
//
// The first line in this comment block is a short description line and the
// rest is a long description with more detail on the module's purpose or usage,
// if appropriate. All modules should have a short description.

package main

import (
	"context"
	"dagger/pipely/internal/dagger"
)

type Pipely struct{}

func (m *Pipely) BuildContainer(ctx context.Context, source *dagger.Directory) *dagger.Container {
	build := dag.Container().From("golang:1.23").
		WithExec([]string{"go", "install", "github.com/nabsul/tls-exterminator@latest"}).
		WithExec([]string{"go", "install", "github.com/mattn/goreman@latest"})

	binDir := build.Directory("/go/bin")
	certsDir := build.Directory("/etc/ssl/certs")

	procFile := source.File("Procfile")
	vclFile := source.File("default.vcl")

	return dag.Container().From("varnish:7.4.3").
		WithDirectory("/apps", binDir).
		WithDirectory("/etc/ssl/certs", certsDir).
		WithEnvVariable("VARNISH_HTTP_PORT", "9000").
		WithFile("/Procfile", procFile).
		WithFile("/default.vcl", vclFile).
		WithExposedPort(9000).
		WithWorkdir("/").
		WithEntrypoint([]string{"/apps/goreman", "start"})
}
