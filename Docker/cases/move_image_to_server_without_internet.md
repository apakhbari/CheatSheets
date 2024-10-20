### 1. Save the Docker images on the server with internet access:
On the server that has internet access and contains the Docker images you want to transfer, use the following command to save each Docker image to a `.tar` file.

```bash
docker save -o <image-name>.tar <image-name>:<tag>
```

For example, to save the image `nginx:latest`:

```bash
docker save -o nginx-latest.tar nginx:latest
```

This will create a `.tar` file of the Docker image.

### 2. Transfer the `.tar` file to the Ubuntu server without internet:
You can use various methods to transfer the `.tar` files to the offline server, such as:
- **USB drive**: Physically transfer the file using a USB stick.
- **SCP**: If there's a local network connection between the servers, you can use SCP to transfer the file:

```bash
scp <image-name>.tar user@offline-server-ip:/path/to/destination
```

- **FTP or other network file transfer tools**: Use appropriate tools for your environment.

### 3. Load the Docker image on the offline Ubuntu server:
Once the `.tar` file is transferred to the Ubuntu server without internet access, load the image using the following command:

```bash
docker load -i <image-name>.tar
```

For example:

```bash
docker load -i nginx-latest.tar
```

This will load the Docker image into your local Docker registry on the offline server.

### 4. Verify the loaded image:
After loading, you can check if the image was successfully loaded by listing the images:

```bash
docker images
```

You should now see the transferred image in the list, and you can run it as usual.

Let me know if you need further assistance!