#!/usr/bin/env python3
# for i in `cat worker.txt`; do (docker pull $i &); done
import argparse
import asyncio
import docker
import json
import sys

d = docker.from_env()


def read_images(fname, filters):
    with open(fname) as f:
        images = f.read().splitlines()
    return [i for i in images if all(f(i) for f in filters)]


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


def push(image, local_image, max_width):
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
        "inputs",
        nargs="+",
        help="list of input files with list of remote images to pull, retag and push (default: images.txt)",
    )
    parser.add_argument(
        "--registry",
        "-r",
        default="ghcr.io/stackhpc",
        help="name of the local registry to retag and push images to (default: ghcr.io/stackhpc)",
    )
    parser.add_argument(
        "--filter",
        "-f",
        default="",
        required=False,
        help="filter images (default: '')",
    )
    args = parser.parse_args()

    if not args.inputs:
        print("Nothing to pull, retag and push.")
        parser.print_help()
        sys.exit(1)

    for fname in args.inputs:
        filters = [lambda x: x, lambda x: not x.startswith("#")]
        if args.filter:
            filters.append(lambda x: args.filter in x)
        images = read_images(fname, filters)
        max_width = max([len(i) for i in images])

        print("Pulling images in %s" % fname)
        tasks = [loop.run_in_executor(None, pull, image, max_width) for image in images]
        await asyncio.gather(*tasks)
        print("---")

        print("Pushing images in %s" % fname)
        local_images = ["{}/{}".format(args.registry, image.rsplit("/", maxsplit=1)[-1]) for image in images]
        max_width = max([len(i) for i in local_images])

        tasks = [
            loop.run_in_executor(None, push, image, local_image, max_width)
            for image, local_image in zip(images, local_images)
        ]
        await asyncio.gather(*tasks)
        print("---")


if __name__ == "__main__":
    loop = asyncio.get_event_loop()
    loop.run_until_complete(main())
