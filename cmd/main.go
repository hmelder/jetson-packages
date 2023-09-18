package main

import (
	"flag"
	"fmt"
	"os"
)

const (
	L4TVersion     = "32.7.4"
	BSPDownloadURL = "https://developer.nvidia.com/downloads/embedded/l4t/r32_release_v7.4/t210/jetson-210_linux_r32.7.4_aarch64.tbz2"
)

type Config struct {
	L4tDir       string
	ExtractDir   string
	Tarball      string
	RepoDir      string
	SkipDownload bool
}

func main() {
	config := &Config{}

	cwd, err := os.Getwd()
	if err != nil {
		panic("Failed to get current working directory: " + err.Error())
	}

	flag.StringVar(&config.L4tDir, "l4t-dir", cwd+"/nvidia-bin-release", "L4T Directory for binary package extraction")
	flag.StringVar(&config.Tarball, "tarball", cwd+"/nvidia-bin-release/l4t.tbz2", "L4T Tarball to extract")
	flag.StringVar(&config.RepoDir, "repo-dir", cwd, "The repository directory")

	flag.Parse()

	config.ExtractDir = config.L4tDir + "/bsp"

	info, err := os.Stat(config.Tarball)
	if err == nil {
		if info.IsDir() {
			fmt.Fprintf(os.Stderr, "ERROR: %s is a directory, not a file\n", config.Tarball)
			os.Exit(1)
		}
		config.SkipDownload = true
	}

	if !config.SkipDownload {
		if err = config.DownloadL4t(); err != nil {
			os.Exit(1)
		}
	}

	info, err = os.Stat(config.ExtractDir)
	if err == nil {
		if !info.IsDir() {
			fmt.Fprintf(os.Stderr, "ERROR: %s is not a directory\n", config.ExtractDir)
			os.Exit(1)
		}
		fmt.Printf("INFO: %s already exists, skipping extraction\n", config.ExtractDir)
	} else {
		if err = config.ExtractL4t(); err != nil {
			os.Exit(1)
		}
	}

	if err = config.PrepareRepositories(); err != nil {
		os.Exit(1)
	}

	fmt.Println("INFO: Done. You can now build the debian packages with 'dpkg-deb --build <package>'")
}

func (config *Config) DownloadL4t() error {
	fmt.Println("INFO: Downloading L4T Version " + L4TVersion)

	if err := downloadFile(config.Tarball, BSPDownloadURL); err != nil {
		fmt.Fprintf(os.Stderr, "ERROR: Failed to download L4T: %s\n", err.Error())
		return err
	}

	return nil
}

func (config *Config) ExtractL4t() error {
	fmt.Println("INFO: Extracting L4T Version " + L4TVersion)

	if err := os.MkdirAll(config.ExtractDir, 0755); err != nil {
		fmt.Fprintf(os.Stderr, "ERROR: Failed to create L4T directory: %s\n", err.Error())
		os.Exit(1)
	}

	if err := extractTarball(config.Tarball, config.ExtractDir, CompressionBzip2, 1); err != nil {
		fmt.Fprintf(os.Stderr, "ERROR: Failed to extract L4T: %s\n", err.Error())
		return err
	}

	return nil
}

func (config *Config) PrepareRepositories() error {
	fmt.Println("INFO: Preparing Repositories for L4T Version " + L4TVersion)

	binaryDir := config.RepoDir + "/Binary/t210"

	// Prepare the driver package
	l4tDriverDist := binaryDir + "/nv-l4t-drivers"
	l4tDriverSource := config.ExtractDir + "/nv_tegra/nvidia_drivers.tbz2"
	fmt.Println("INFO: Extracting drivers to " + l4tDriverDist)
	if err := extractTarball(l4tDriverSource, l4tDriverDist, CompressionBzip2, 0); err != nil {
		fmt.Fprintf(os.Stderr, "ERROR: Failed to extract drivers: %s\n", err.Error())
		return err
	}

	// We need to move the lib directory to usr/lib, otherwise debootstrap will fail
	if err := moveDirectory(l4tDriverDist+"/lib/firmware", l4tDriverDist+"/usr/lib"); err != nil {
		fmt.Fprintf(os.Stderr, "ERROR: Failed to move lib/firmware directory: %s\n", err.Error())
		return err
	}
	if err := os.Remove(l4tDriverDist + "/lib"); err != nil {
		fmt.Fprintf(os.Stderr, "ERROR: Failed to remove lib directory: %s\n", err.Error())
		return err
	}

	return nil
}
