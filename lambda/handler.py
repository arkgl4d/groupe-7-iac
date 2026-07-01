import io
import json
import os
import urllib.parse
import logging
import boto3
import img2pdf

logger = logging.getLogger()
logger.setLevel(logging.INFO)

DEST_BUCKET = os.environ.get("DEST_BUCKET")
SUPPORTED_EXTENSIONS = {".jpg", ".jpeg", ".png", ".gif", ".tiff", ".bmp"}

s3 = boto3.client("s3")


def lambda_handler(event, context):
    if not DEST_BUCKET:
        raise ValueError("DEST_BUCKET environment variable must be set")

    records = event.get("Records", [])
    processed = 0

    for record in records:
        bucket = record["s3"]["bucket"]["name"]
        key = urllib.parse.unquote_plus(record["s3"]["object"]["key"])
        _, extension = os.path.splitext(key.lower())

        if extension not in SUPPORTED_EXTENSIONS:
            logger.info("Skipping unsupported file %s", key)
            continue

        base_name = os.path.splitext(key)[0]
        target_key = f"{base_name}.pdf"
        logger.info("Converting %s to %s", key, target_key)

        response = s3.get_object(Bucket=bucket, Key=key)
        image_data = response["Body"].read()

        try:
            pdf_bytes = img2pdf.convert(io.BytesIO(image_data))
        except Exception as exc:
            logger.error("Conversion failed for %s: %s", key, exc)
            raise

        s3.put_object(
            Bucket=DEST_BUCKET,
            Key=target_key,
            Body=pdf_bytes,
            ContentType="application/pdf",
        )

        logger.info("Upload completed to %s/%s", DEST_BUCKET, target_key)
        processed += 1

    return {
        "statusCode": 200,
        "body": json.dumps({"processed": processed}),
    }
