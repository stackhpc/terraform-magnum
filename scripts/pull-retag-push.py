#!/usr/bin/env python3
# for i in `cat worker.txt`; do (docker pull $i &); done
import argparse
import asyncio
import docker
import json
import sys

d = docker.from_env()


def read_images(fname):
    with open(fname) as f:
        images = f.read().splitlines()
    return images


def pull(image, max_width):
    try:
        d.images.get(image)
        result = "exists locally"
    except docker.errors.ImageNotFound:
        try:
            d.images.pull(image)
            result = "pulled"
        except Exception:
            result = "error"
    cols = image.ljust(max_width), result
    print(" | ".join(cols))


def push(local_registry, image, max_width):
    _, name = image.rsplit("/", maxsplit=1)
    local_image = "/".join([local_registry, name])
    try:
        d.api.tag(image, local_image)
        error = json.loads(d.images.push(local_image).splitlines()[-1]).get("error")
        result = error if error else "pushed"
    except docker.errors.ImageNotFound:
        result = "not found"
    cols = local_image.ljust(max_width), result
    print(" | ".join(cols))


async def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--inputs",
        "-i",
        default=["images.txt"],
        nargs="+",
        help="list of input files with list of remote images to pull, retag and push (default: images.txt)",
    )
    parser.add_argument(
        "--registry",
        "-r",
        default="10.60.253.37/magnum",
        help="name of the local registry to retag and push images to (default: 10.60.253.37/magnum)",
    )
    args = parser.parse_args()

    if not args.inputs:
        print("Nothing to pull, retag and push.")
        parser.print_help()
        sys.exit(1)

    for fname in args.inputs:
        images = read_images(fname)
        max_width = max([len(i) for i in images])

        print("Pulling images in %s" % fname)
        tasks = [loop.run_in_executor(None, pull, image, max_width) for image in images]
        await asyncio.gather(*tasks)
        print("---")

        print("Pushing images in %s" % fname)
        tasks = [
            loop.run_in_executor(None, push, args.registry, image, max_width)
            for image in images
        ]
        await asyncio.gather(*tasks)
        print("---")


if __name__ == "__main__":
    loop = asyncio.get_event_loop()
    loop.run_until_complete(main())
