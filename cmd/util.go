package main

import (
	"fmt"
	"io"
	"net/http"
	"os"
	"os/exec"
)

type CompressionType int

const (
	CompressionBzip2 CompressionType = iota
)

func downloadFile(filepath string, url string) (err error) {
	out, err := os.Create(filepath)
	if err != nil {
		return err
	}
	defer out.Close()

	resp, err := http.Get(url)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return fmt.Errorf("bad status: %s", resp.Status)
	}

	_, err = io.Copy(out, resp.Body)
	if err != nil {
		return err
	}

	return nil
}

func extractTarball(filepath string, dest string, compressionType CompressionType, stripComponents int) (err error) {
	args := []string{}

	if stripComponents > 0 {
		args = append(args, "--strip-components", fmt.Sprintf("%d", stripComponents))
	}

	switch compressionType {
	case CompressionBzip2:
		args = append(args, "-xjpf")
	default:
		return fmt.Errorf("unsupported compression type")
	}

	args = append(args, filepath, "-C", dest)

	cmd := exec.Command("tar", args...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	if err := cmd.Run(); err != nil {
		return err
	}

	return nil
}

func moveDirectory(src string, dest string) (err error) {
	cmd := exec.Command("mv", src, dest)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	if err := cmd.Run(); err != nil {
		return err
	}

	return nil
}
