import cloudinary
import cloudinary.uploader
from flask import current_app


def upload_image(file, folder):
    cloudinary.config(
        cloud_name=current_app.config["CLOUDINARY_CLOUD_NAME"],
        api_key=current_app.config["CLOUDINARY_API_KEY"],
        api_secret=current_app.config["CLOUDINARY_API_SECRET"],
        secure=True,
    )

    result = cloudinary.uploader.upload(
        file,
        folder=folder,
        resource_type="image"
    )

    return result["secure_url"]